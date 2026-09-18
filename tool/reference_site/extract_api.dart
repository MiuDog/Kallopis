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

Future<void> main(List<String> arguments) async {
	final options = _parseArguments(arguments);
	final root = Directory.current.resolveSymbolicLinksSync();
	final entry = File(_absolute(root, options.entry));
	final output = File(_absolute(root, options.output));
	if (!entry.existsSync()) {
		stderr.writeln('Declarative entry does not exist: ${entry.path}');
		exitCode = 1;
		return;
	}

	final collection = AnalysisContextCollection(
		includedPaths: [root],
		sdkPath: File(Platform.resolvedExecutable).parent.parent.path,
	);
	try {
		final session = collection.contextFor(entry.path).currentSession;
		final result = await session.getResolvedLibrary(entry.path);
		if (result is! ResolvedLibraryResult) {
			throw StateError('Unable to resolve declarative entry: $result');
		}
		final errors = result.units
			.expand((unit) => unit.diagnostics)
			.where((diagnostic) => diagnostic.severity == Severity.error)
			.toList();
		if (errors.isNotEmpty) {
			throw StateError(
				'Analyzer errors in declarative entry:\n${errors.join('\n')}',
			);
		}

		final manifest = _extractManifest(result.element);
		output.parent.createSync(recursive: true);
		final temporary = File('${output.path}.tmp');
		temporary.writeAsStringSync(
			'${const JsonEncoder.withIndent('\t').convert(manifest)}\n',
			flush: true,
		);
		if (output.existsSync()) output.deleteSync();
		temporary.renameSync(output.path);
		stdout.writeln(
			'Extracted ${manifest.declarationCount} public declarations into ${output.path}.',
		);
	} catch (error, stackTrace) {
		stderr.writeln(error);
		stderr.writeln(stackTrace);
		exitCode = 1;
	} finally {
		await collection.dispose();
	}
}

_Options _parseArguments(List<String> arguments) {
	var entry = 'lib/kallopis_declarative.dart';
	var output = 'build/reference-api.json';
	for (var index = 0; index < arguments.length; index++) {
		final argument = arguments[index];
		if (argument != '--entry' && argument != '--output') {
			throw ArgumentError('Unknown argument: $argument');
		}
		if (++index >= arguments.length) {
			throw ArgumentError('Missing value for $argument');
		}
		if (argument == '--entry') entry = arguments[index];
		if (argument == '--output') output = arguments[index];
	}
	return _Options(entry, output);
}

String _absolute(String root, String candidate) {
	final path = File(candidate).isAbsolute
		? candidate
		: File.fromUri(Directory(root).uri.resolve(candidate)).path;
	return File(path).absolute.path;
}

_ApiManifest _extractManifest(LibraryElement library) {
	final declarations = <_Declaration>[];
	final publicNames = library.exportNamespace.definedNames2.entries.toList()
		..sort((left, right) => left.key.compareTo(right.key));
	final seen = <String>{};
	for (final entry in publicNames) {
		if (entry.key.endsWith('=') || entry.key.startsWith('_')) continue;
		final element = _normalizeExportedElement(entry.value);
		if (!element.isPublic) continue;
		if (!seen.add(entry.key)) {
			throw StateError('Duplicate exported declaration: ${entry.key}');
		}
		declarations.add(_declaration(entry.key, element));
	}

	final names = <String>{..._rootModules};
	for (final declaration in declarations) {
		names.add(declaration.module);
	}
	final modules = names.toList()..sort(_compareModules);
	return _ApiManifest(
		modules.map((name) {
			final owned = declarations
				.where((declaration) => declaration.module == name)
				.toList()
				..sort((left, right) => left.name.compareTo(right.name));
			return _Module(name, owned);
		}).toList(),
	);
}

Element _normalizeExportedElement(Element element) {
	if (element is GetterElement && element.isOriginVariable) {
		return element.variable;
	}
	return element;
}

_Declaration _declaration(String publicName, Element element) {
	final library = element.library;
	if (library == null) {
		throw StateError('Exported declaration has no source library: $publicName');
	}
	final kind = _declarationKind(element);
	final relationships = _typeRelationships(element);
	return _Declaration(
		name: publicName,
		slug: _slug(publicName),
		kind: kind,
		module: _moduleFor(library.uri),
		sourceUri: library.uri.toString(),
		signature: element.displayString(multiline: true, preferTypeAlias: true),
		documentation: _documentation(element.documentationComment),
		typeRelationships: relationships,
		members: _members(element),
	);
}

String _declarationKind(Element element) {
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
	throw StateError(
		'Unsupported exported declaration ${element.displayName}: ${element.runtimeType}',
	);
}

Map<String, Object?> _typeRelationships(Element element) {
	if (element is ExtensionElement) {
		return {
			'extends': element.extendedType.getDisplayString(),
			'mixins': <String>[],
			'implements': <String>[],
		};
	}
	if (element is MixinElement) {
		return {
			'extends': null,
			'mixins': element.superclassConstraints
				.map((type) => type.getDisplayString())
				.toList(),
			'implements': element.interfaces
				.map((type) => type.getDisplayString())
				.toList(),
		};
	}
	if (element is InterfaceElement) {
		return {
			'extends': element.supertype?.getDisplayString(),
			'mixins': element.mixins
				.map((type) => type.getDisplayString())
				.toList(),
			'implements': element.interfaces
				.map((type) => type.getDisplayString())
				.toList(),
		};
	}
	return {
		'extends': null,
		'mixins': <String>[],
		'implements': <String>[],
	};
}

List<_Member> _members(Element element) {
	if (element is! InstanceElement) return const [];
	final members = <_Member>[];
	if (element is InterfaceElement) {
		for (final constructor in element.constructors) {
			if (!constructor.isPublic) continue;
			members.add(_member('constructor', constructor));
		}
	}
	for (final field in element.fields) {
		if (!field.isPublic || !field.isOriginDeclaration) continue;
		members.add(_member(field.isEnumConstant ? 'enumValue' : 'field', field));
	}
	for (final getter in element.getters) {
		if (!getter.isPublic || !getter.isOriginDeclaration) continue;
		members.add(_member('getter', getter));
	}
	for (final setter in element.setters) {
		if (!setter.isPublic || !setter.isOriginDeclaration) continue;
		members.add(_member('setter', setter));
	}
	for (final method in element.methods) {
		if (!method.isPublic || !method.isOriginDeclaration) continue;
		members.add(_member('method', method));
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
	if (uri.scheme == 'package' && uri.path.startsWith('kallopis/src/')) {
		final root = segments.length > 2 ? segments[2] : '';
		if (!_rootModules.contains(root)) {
			throw StateError('Unknown Kallopis module for $uri');
		}
		if (root == 'features' && segments.length > 3) {
			return 'features.${segments[3]}';
		}
		return root;
	}
	if (uri.scheme == 'package' && uri.pathSegments.first.startsWith('krepis')) {
		return 'features.editing.providers';
	}
	throw StateError('Cannot classify public declaration source: $uri');
}

int _compareModules(String left, String right) {
	final leftRoot = left.split('.').first;
	final rightRoot = right.split('.').first;
	final byRoot = _rootModules.indexOf(leftRoot).compareTo(
		_rootModules.indexOf(rightRoot),
	);
	return byRoot != 0 ? byRoot : left.compareTo(right);
}

String _slug(String value) => value
	.replaceAllMapped(
		RegExp(r'([a-z0-9])([A-Z])'),
		(match) => '${match[1]}-${match[2]}',
	)
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

final class _Options {
	final String entry;
	final String output;

	const _Options(this.entry, this.output);
}

final class _ApiManifest {
	final List<_Module> modules;

	const _ApiManifest(this.modules);

	int get declarationCount => modules.fold(
		0,
		(count, module) => count + module.declarations.length,
	);

	Map<String, Object?> toJson() => {
		'schemaVersion': 1,
		'entrypoint': 'package:kallopis/kallopis_declarative.dart',
		'modules': modules.map((module) => module.toJson()).toList(),
	};
}

final class _Module {
	final String name;
	final List<_Declaration> declarations;

	const _Module(this.name, this.declarations);

	Map<String, Object?> toJson() => {
		'name': name,
		'declarations': declarations
			.map((declaration) => declaration.toJson())
			.toList(),
	};
}

final class _Declaration {
	final String name;
	final String slug;
	final String kind;
	final String module;
	final String sourceUri;
	final String signature;
	final String documentation;
	final Map<String, Object?> typeRelationships;
	final List<_Member> members;

	const _Declaration({
		required this.name,
		required this.slug,
		required this.kind,
		required this.module,
		required this.sourceUri,
		required this.signature,
		required this.documentation,
		required this.typeRelationships,
		required this.members,
	});

	Map<String, Object?> toJson() => {
		'name': name,
		'slug': slug,
		'kind': kind,
		'module': module,
		'sourceUri': sourceUri,
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

	const _Member({
		required this.name,
		required this.kind,
		required this.signature,
		required this.documentation,
	});

	Map<String, Object?> toJson() => {
		'name': name,
		'kind': kind,
		'signature': signature,
		'documentation': documentation,
	};
}
