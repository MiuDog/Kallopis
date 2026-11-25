import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart' show Severity;

const _rootModules = <String>[
	'application',
	'capabilities',
	'composition',
	'features',
	'foundation',
	'kernel',
	'rendering',
	'runtime',
	'styling',
];

const _publicSurfaces = <_SurfaceDefinition>[
	_SurfaceDefinition('theme', 'package:kallopis/kallopis_theme.dart', 'flutter/lib/kallopis_theme.dart', 'stable'),
	_SurfaceDefinition('foundation', 'package:kallopis/kallopis_foundation.dart', 'flutter/lib/kallopis_foundation.dart', 'stable'),
	_SurfaceDefinition('experimental', 'package:kallopis/kallopis_experimental.dart', 'flutter/lib/kallopis_experimental.dart', 'experimental'),
];

Future<void> main(List<String> arguments) async {
	final outputPath = _outputPath(arguments);
	final root = Directory.current.resolveSymbolicLinksSync();
	final output = File(_absolute(root, outputPath));
	final entries = <_SurfaceDefinition, File>{};
	for (final surface in _publicSurfaces) {
		final entry = File(_absolute(root, surface.path));
		if (!entry.existsSync()) {
			stderr.writeln('Public surface does not exist: ${entry.path}');
			exitCode = 1;
			return;
		}
		entries[surface] = entry;
	}

	// 步驟 1：以同一 analyzer collection 解析三個正式公開入口。
	final collection = AnalysisContextCollection(
		includedPaths: [root],
		sdkPath: File(Platform.resolvedExecutable).parent.parent.path,
	);
	try {
		final libraries = <_SurfaceDefinition, LibraryElement>{};
		for (final surface in _publicSurfaces) {
			final entry = entries[surface]!;
			final session = collection.contextFor(entry.path).currentSession;
			final result = await session.getResolvedLibrary(entry.path);
			if (result is! ResolvedLibraryResult) throw StateError('Unable to resolve ${surface.name}: $result');
			final errors = result.units
				.expand((unit) => unit.diagnostics)
				.where((diagnostic) => diagnostic.severity == Severity.error)
				.toList();
			if (errors.isNotEmpty) throw StateError('Analyzer errors in ${surface.name}:\n${errors.join('\n')}');
			libraries[surface] = result.element;
		}

		// 公開barrel以外的匯出來源也須通過診斷，才能進入可發布的清單。
		await _validatePublicLibraries(collection, libraries.values);

		// 步驟 2：全部入口成功後才原子寫入 canonical manifest。
		final manifest = _extractManifest(libraries);
		output.parent.createSync(recursive: true);
		final temporary = File('${output.path}.tmp');
		temporary.writeAsStringSync('${const JsonEncoder.withIndent('\t').convert(manifest)}\n', flush: true);
		if (output.existsSync()) output.deleteSync();
		temporary.renameSync(output.path);
		stdout.writeln('Extracted ${manifest.declarationCount} canonical declarations.');
	}
	catch (error, stackTrace) {
		stderr.writeln(error);
		stderr.writeln(stackTrace);
		exitCode = 1;
	}
	finally {
		await collection.dispose();
	}
}

String _outputPath(List<String> arguments) {
	var output = 'build/reference-api.json';
	for (var index = 0; index < arguments.length; index++) {
		if (arguments[index] != '--output') throw ArgumentError('Unknown argument: ${arguments[index]}');
		if (++index >= arguments.length) throw ArgumentError('Missing value for --output');
		output = arguments[index];
	}
	return output;
}

String _absolute(String root, String candidate) {
	if (File(candidate).isAbsolute) return File(candidate).absolute.path;
	return File.fromUri(Directory(root).uri.resolve(candidate)).absolute.path;
}

_ApiManifest _extractManifest(Map<_SurfaceDefinition, LibraryElement> libraries) {
	final drafts = <String, _DeclarationDraft>{};
	for (final surface in _publicSurfaces) {
		final names = _exportedNames(libraries[surface]!).entries.toList()
			..sort((left, right) => left.key.compareTo(right.key));
		for (final entry in names) {
			if (entry.key.endsWith('=') || entry.key.startsWith('_')) continue;
			final element = _normalize(entry.value);
			if (!element.isPublic) continue;
			final library = element.library;
			if (library == null) throw StateError('Declaration has no source library: ${entry.key}');
			final id = '${library.uri}#${entry.key}';
			final existing = drafts[id];
			if (existing != null) {
				existing.addSurface(surface.name);
				continue;
			}
			drafts[id] = _draft(id, entry.key, element, surface.name);
		}
	}

	// 步驟 3：只在同 module 同名碰撞時追加可讀的 surface suffix。
	final collisionCounts = <String, int>{};
	for (final draft in drafts.values) {
		final key = '${draft.module}/${draft.baseSlug}';
		collisionCounts[key] = (collisionCounts[key] ?? 0) + 1;
	}
	final pageKeys = <String>{};
	final declarations = <_Declaration>[];
	for (final draft in drafts.values) {
		final collisionKey = '${draft.module}/${draft.baseSlug}';
		final slug = collisionCounts[collisionKey] == 1 ? draft.baseSlug : '${draft.baseSlug}--${draft.primarySurface}';
		if (!pageKeys.add('${draft.module}/$slug')) throw StateError('Unresolved API route collision: ${draft.id}');
		declarations.add(draft.finish(slug));
	}

	final moduleNames = <String>{..._rootModules, ...declarations.map((item) => item.module)}.toList()
		..sort(_compareModules);
	final modules = moduleNames.map((name) {
		final owned = declarations.where((item) => item.module == name).toList()
			..sort((left, right) {
				final byName = left.name.compareTo(right.name);
				return byName != 0 ? byName : left.id.compareTo(right.id);
			});
		return _Module(name, owned);
	}).toList();
	return _ApiManifest(_publicSurfaces, modules);
}

Future<void> _validatePublicLibraries(AnalysisContextCollection collection, Iterable<LibraryElement> roots) async {
	// 公開匯出樹的每個本庫來源都先診斷；barrel本身無錯不代表被匯出的宣告有效。
	final pending = <LibraryElement>[...roots];
	final visited = <String>{};
	while (pending.isNotEmpty) {
		final library = pending.removeLast();
		final sourcePath = library.firstFragment.source.fullName;
		if (!visited.add(sourcePath)) continue;

		final session = collection.contextFor(sourcePath).currentSession;
		final result = await session.getResolvedLibrary(sourcePath);
		if (result is! ResolvedLibraryResult) throw StateError('Unable to resolve public library: $sourcePath');

		final errors = result.units.expand((unit) => unit.diagnostics).where((diagnostic) => diagnostic.severity == Severity.error).toList();
		if (errors.isNotEmpty) throw StateError('Analyzer errors in $sourcePath:\n${errors.join('\n')}');

		pending.addAll(library.exportedLibraries.where((exported) => exported.uri.scheme == 'package' && exported.uri.path.startsWith('kallopis/')));
	}
}

// root namespace已套用整條匯出鏈的show/hide；不得再從子library追回被隱藏名稱。
Map<String, Element> _exportedNames(LibraryElement root) => {...root.exportNamespace.definedNames2};

bool _renderable(Element element) {
	if (element is! ClassElement || element.isAbstract) return false;

	// 真正Flutter identity包含間接繼承及implements；同名的產品Widget資料類別不算。
	return element.allSupertypes.any((type) => type.element.name == 'Widget' && type.element.library.uri.toString() == 'package:flutter/src/widgets/framework.dart');
}

Element _normalize(Element element) {
	if (element is GetterElement && element.isOriginVariable) return element.variable;
	return element;
}

_DeclarationDraft _draft(String id, String name, Element element, String surface) {
	final sourceUri = element.library!.uri;
	return _DeclarationDraft(
		id: id,
		name: name,
		baseSlug: _slug(name),
		kind: _kind(element),
		renderable: _renderable(element),
		module: _moduleFor(sourceUri),
		sourceUri: sourceUri.toString(),
		surfaces: [surface],
		signature: element.displayString(multiline: true, preferTypeAlias: true),
		documentation: _documentation(element.documentationComment),
		typeRelationships: _relationships(element),
		members: _members(element),
		parameters: _parameters(element),
	);
}

String _kind(Element element) {
	if (element is ClassElement) {
		if (element.isSealed) return 'sealedClass';
		if (element.isBase) return 'baseClass';
		if (element.isInterface) return 'interfaceClass';
		if (element.isFinal) return 'finalClass';
		if (element.isMixinClass) return 'mixinClass';
		return element.isAbstract ? 'abstractClass' : 'class';
	}
	if (element is EnumElement) return 'enum';
	if (element is MixinElement) return element.isBase ? 'baseMixin' : 'mixin';
	if (element is ExtensionElement) return 'extension';
	if (element is ExtensionTypeElement) return 'extensionType';
	if (element is TypeAliasElement) return 'typedef';
	if (element is TopLevelFunctionElement) return 'function';
	if (element is TopLevelVariableElement) return 'variable';
	if (element is GetterElement) return 'getter';
	throw StateError('Unsupported declaration ${element.displayName}: ${element.runtimeType}');
}

Map<String, Object?> _relationships(Element element) {
	if (element is ExtensionElement) {
		return {'extends': element.extendedType.getDisplayString(), 'mixins': <String>[], 'implements': <String>[]};
	}
	if (element is MixinElement) {
		return {
			'extends': null,
			'mixins': element.superclassConstraints.map((type) => type.getDisplayString()).toList(),
			'implements': element.interfaces.map((type) => type.getDisplayString()).toList(),
		};
	}
	if (element is InterfaceElement) {
		return {
			'extends': element.supertype?.getDisplayString(),
			'mixins': element.mixins.map((type) => type.getDisplayString()).toList(),
			'implements': element.interfaces.map((type) => type.getDisplayString()).toList(),
		};
	}
	return {'extends': null, 'mixins': <String>[], 'implements': <String>[]};
}

List<_Member> _members(Element element) {
	if (element is! InstanceElement) return const [];
	final members = <_Member>[];
	if (element is InterfaceElement) {
		for (final constructor in element.constructors) {
			if (constructor.isPublic) members.add(_member('constructor', constructor));
		}
	}
	for (final field in element.fields) {
		if (field.isPublic && field.isOriginDeclaration) members.add(_member(field.isEnumConstant ? 'enumValue' : 'field', field));
	}
	for (final getter in element.getters) {
		if (getter.isPublic && getter.isOriginDeclaration) members.add(_member('getter', getter));
	}
	for (final setter in element.setters) {
		if (setter.isPublic && setter.isOriginDeclaration) members.add(_member('setter', setter));
	}
	for (final method in element.methods) {
		if (method.isPublic && method.isOriginDeclaration) members.add(_member('method', method));
	}
	members.sort((left, right) {
		final byName = left.name.compareTo(right.name);
		return byName != 0 ? byName : left.kind.compareTo(right.kind);
	});
	return members;
}

_Member _member(String kind, Element element) => _Member(
	name: element.displayName,
	kind: kind,
	signature: _memberSignature(element),
	documentation: _documentation(element.documentationComment),
	parameters: _parameters(element),
);

String _memberSignature(Element element) {
	final signature = element.displayString(multiline: true, preferTypeAlias: true);
	if (element is ConstructorElement && element.isConst) return 'const $signature';
	if (element is FieldElement) {
		final storage = element.isStatic ? 'static ' : '';
		final mutability = element.isConst ? 'const ' : element.isFinal ? 'final ' : '';
		return '$storage$mutability$signature';
	}
	if ((element is MethodElement && element.isStatic) || (element is GetterElement && element.isStatic) || (element is SetterElement && element.isStatic)) return 'static $signature';
	return signature;
}

// 由 analyzer 保留 required nullable、位置參數及預設值，避免從顯示簽名猜測。
List<Map<String, Object?>> _parameters(Element element) {
	if (element is! ExecutableElement) return const [];
	return element.formalParameters.map((parameter) => <String, Object?>{
		'name': parameter.name,
		'type': parameter.type.getDisplayString(),
		'required': parameter.isRequired,
		'named': parameter.isNamed,
		'defaultValue': parameter.defaultValueCode,
		'documentation': _documentation(parameter.documentationComment),
	}).toList();
}

String _moduleFor(Uri uri) {
	final segments = uri.pathSegments;
	if (uri.scheme != 'package' || !uri.path.startsWith('kallopis/src/')) throw StateError('Public declaration is outside Kallopis: $uri');
	final root = segments.length > 2 ? segments[2] : '';
	if (!_rootModules.contains(root)) throw StateError('Unknown Kallopis module: $uri');
	if (root == 'features' && segments.length > 3) return 'features.${segments[3]}';
	return root;
}

int _compareModules(String left, String right) {
	final leftRoot = left.split('.').first;
	final rightRoot = right.split('.').first;
	final rootOrder = _rootModules.indexOf(leftRoot).compareTo(_rootModules.indexOf(rightRoot));
	return rootOrder != 0 ? rootOrder : left.compareTo(right);
}

int _surfaceOrder(String name) => _publicSurfaces.indexWhere((surface) => surface.name == name);

String _slug(String value) => value
	.replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (match) => '${match[1]}-${match[2]}')
	.replaceAll('_', '-')
	.toLowerCase();

String _documentation(String? comment) {
	if (comment == null) return '';
	return comment
		.split('\n')
		.map((line) => line
			.replaceFirst(RegExp(r'^\s*///\s?'), '')
			.replaceFirst(RegExp(r'^\s*/\*\*?\s?'), '')
			.replaceFirst(RegExp(r'^\s*\*\s?'), '')
			.replaceFirst(RegExp(r'\s*\*/\s*$'), ''))
		.join('\n')
		.trim();
}

final class _SurfaceDefinition {
	final String name;
	final String entrypoint;
	final String path;
	final String stability;

	const _SurfaceDefinition(this.name, this.entrypoint, this.path, this.stability);

	Map<String, Object?> toJson() => {'name': name, 'entrypoint': entrypoint, 'stability': stability};
}

final class _ApiManifest {
	final List<_SurfaceDefinition> surfaces;
	final List<_Module> modules;

	const _ApiManifest(this.surfaces, this.modules);

	int get declarationCount => modules.fold(0, (count, module) => count + module.declarations.length);

	Map<String, Object?> toJson() => {
		'schemaVersion': 1,
		'surfaces': surfaces.map((surface) => surface.toJson()).toList(),
		'modules': modules.map((module) => module.toJson()).toList(),
	};
}

final class _Module {
	final String name;
	final List<_Declaration> declarations;

	const _Module(this.name, this.declarations);

	Map<String, Object?> toJson() => {'name': name, 'declarations': declarations.map((item) => item.toJson()).toList()};
}

final class _DeclarationDraft {

	/* id／name是公開canonical識別及名稱；baseSlug等待碰撞處理；kind供reference分類；module／sourceUri保留本庫來源。
	 * surfaces按正式surface次序合併；signature／documentation保存原宣告及說明；typeRelationships記錄extends／mixins／implements；members保存公開成員。
	 * renderable由analyzer擁有，具體Widget才要求專屬展示，不依kind字串猜測。 */
	final String id;
	final String name;
	final String baseSlug;
	final String kind;
	final bool renderable;
	final String module;
	final String sourceUri;
	final List<String> surfaces;
	final String signature;
	final String documentation;
	final Map<String, Object?> typeRelationships;
	final List<_Member> members;
	// parameters：完整保留公開函式參數的結構資訊。
	final List<Map<String, Object?>> parameters;

	_DeclarationDraft({
		required this.id,
		required this.name,
		required this.baseSlug,
		required this.kind,
		required this.renderable,
		required this.module,
		required this.sourceUri,
		required this.surfaces,
		required this.signature,
		required this.documentation,
		required this.typeRelationships,
		required this.members,
		required this.parameters,
	});

	String get primarySurface => surfaces.first;

	void addSurface(String surface) {
		if (!surfaces.contains(surface)) surfaces.add(surface);
		surfaces.sort((left, right) => _surfaceOrder(left).compareTo(_surfaceOrder(right)));
	}

	_Declaration finish(String slug) => _Declaration(
		id,
		name,
		slug,
		kind,
		module,
		sourceUri,
		primarySurface,
		List.unmodifiable(surfaces),
		signature,
		documentation,
		typeRelationships,
		members,
		renderable,
		parameters,
	);
}

final class _Declaration {

	/* id／name為canonical識別及公開名稱；slug是處理碰撞後的路由；kind供reference分類；module／sourceUri保留來源責任。
	 * primarySurface是依正式次序選出的入口；surfaces是完成去重的唯讀集合；signature／documentation保留原宣告及說明。
	 * typeRelationships包含extends／mixins／implements，members投影公開成員；renderable保留analyzer判定供網站coverage分流。 */
	final String id;
	final String name;
	final String slug;
	final String kind;
	final bool renderable;
	final String module;
	final String sourceUri;
	final String primarySurface;
	final List<String> surfaces;
	final String signature;
	final String documentation;
	final Map<String, Object?> typeRelationships;
	final List<_Member> members;
	// parameters：完整保留公開函式參數的結構資訊。
	final List<Map<String, Object?>> parameters;

	const _Declaration(
		this.id,
		this.name,
		this.slug,
		this.kind,
		this.module,
		this.sourceUri,
		this.primarySurface,
		this.surfaces,
		this.signature,
		this.documentation,
		this.typeRelationships,
		this.members,
		this.renderable,
		this.parameters,
	);

	Map<String, Object?> toJson() => {
		'id': id,
		'name': name,
		'slug': slug,
		'kind': kind,
		'renderable': renderable,
		'module': module,
		'sourceUri': sourceUri,
		'primarySurface': primarySurface,
		'surfaces': surfaces,
		'signature': signature,
		'documentation': documentation,
		'typeRelationships': typeRelationships,
		'members': members.map((member) => member.toJson()).toList(),
		'parameters': parameters,
	};
}

final class _Member {
	// parameters：成員呼叫介面，不包含任何 private state。
	final List<Map<String, Object?>> parameters;
	final String name;
	final String kind;
	final String signature;
	final String documentation;

	const _Member({required this.name, required this.kind, required this.signature, required this.documentation, required this.parameters});

	Map<String, Object?> toJson() => {'name': name, 'kind': kind, 'signature': signature, 'documentation': documentation, 'parameters': parameters};
}
