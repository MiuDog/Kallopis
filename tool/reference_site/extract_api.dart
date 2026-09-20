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
	_SurfaceDefinition('theme', 'package:kallopis/kallopis_theme.dart', 'lib/kallopis_theme.dart', 'stable'),
	_SurfaceDefinition('foundation', 'package:kallopis/kallopis_foundation.dart', 'lib/kallopis_foundation.dart', 'stable'),
	_SurfaceDefinition('experimental', 'package:kallopis/kallopis_experimental.dart', 'lib/kallopis_experimental.dart', 'experimental'),
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

Map<String, Element> _exportedNames(LibraryElement root) {
	final names = <String, Element>{...root.exportNamespace.definedNames2};
	final pending = <LibraryElement>[...root.exportedLibraries];
	final visited = <String>{root.uri.toString()};
	while (pending.isNotEmpty) {
		final library = pending.removeLast();
		if (!visited.add(library.uri.toString())) continue;

		for (final entry in library.exportNamespace.definedNames2.entries) {
			final existing = names[entry.key];
			if (existing == null || existing.library?.uri == entry.value.library?.uri) {
				names[entry.key] = entry.value;
			}
		}
		pending.addAll(library.exportedLibraries);
	}
	return names;
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
		module: _moduleFor(sourceUri),
		sourceUri: sourceUri.toString(),
		surfaces: [surface],
		signature: element.displayString(multiline: true, preferTypeAlias: true),
		documentation: _documentation(element.documentationComment),
		typeRelationships: _relationships(element),
		members: _members(element),
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
	signature: element.displayString(multiline: true, preferTypeAlias: true),
	documentation: _documentation(element.documentationComment),
);

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
	final String id;
	final String name;
	final String baseSlug;
	final String kind;
	final String module;
	final String sourceUri;
	final List<String> surfaces;
	final String signature;
	final String documentation;
	final Map<String, Object?> typeRelationships;
	final List<_Member> members;

	_DeclarationDraft({
		required this.id,
		required this.name,
		required this.baseSlug,
		required this.kind,
		required this.module,
		required this.sourceUri,
		required this.surfaces,
		required this.signature,
		required this.documentation,
		required this.typeRelationships,
		required this.members,
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
	);
}

final class _Declaration {
	final String id;
	final String name;
	final String slug;
	final String kind;
	final String module;
	final String sourceUri;
	final String primarySurface;
	final List<String> surfaces;
	final String signature;
	final String documentation;
	final Map<String, Object?> typeRelationships;
	final List<_Member> members;

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
	);

	Map<String, Object?> toJson() => {
		'id': id,
		'name': name,
		'slug': slug,
		'kind': kind,
		'module': module,
		'sourceUri': sourceUri,
		'primarySurface': primarySurface,
		'surfaces': surfaces,
		'signature': signature,
		'documentation': documentation,
		'typeRelationships': typeRelationships,
		'members': members.map((member) => member.toJson()).toList(),
	};
}

final class _Member {
	final String name;
	final String kind;
	final String signature;
	final String documentation;

	const _Member({required this.name, required this.kind, required this.signature, required this.documentation});

	Map<String, Object?> toJson() => {'name': name, 'kind': kind, 'signature': signature, 'documentation': documentation};
}
