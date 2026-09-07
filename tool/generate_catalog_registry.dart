import 'dart:convert';
import 'dart:io';

const _manifestPath = 'spec/semantics/kallopis.semantic-manifest.json';
const _outputPath = 'example/lib/catalog/generated/catalog_registry.g.dart';
const _expectedLayers = ['primitive', 'foundation', 'component', 'pattern'];

void main(List<String> arguments) {
	final checkOnly = arguments.contains('--check');
	final manifestFile = File(_manifestPath);
	if (!manifestFile.existsSync()) {
		stderr.writeln('Missing semantic manifest: $_manifestPath');
		exitCode = 1;
		return;
	}

	final root = jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
	_validateManifest(root);
	final generated = _generateRegistry(root);
	final outputFile = File(_outputPath);

	if (checkOnly) {
		if (!outputFile.existsSync() || outputFile.readAsStringSync() != generated) {
			stderr.writeln(
				'Catalog registry is stale. Run: '
				'dart run tool/generate_catalog_registry.dart',
			);
			exitCode = 1;
		}
		return;
	}

	outputFile.parent.createSync(recursive: true);
	outputFile.writeAsStringSync(generated);
	stdout.writeln('Generated $_outputPath');
}

void _validateManifest(Map<String, dynamic> root) {
	if (root['schemaVersion'] != 1) {
		throw const FormatException('schemaVersion must be 1.');
	}
	if (root['id'] != 'kallopis.default') {
		throw const FormatException('Manifest id must be kallopis.default.');
	}

	final policy = _map(root['consumerPolicy'], 'consumerPolicy');
	_expectExactList(
		policy['overridable'],
		const ['color.identity.brand'],
		'consumerPolicy.overridable',
	);
	final derivations = _map(policy['derivations'], 'consumerPolicy.derivations');
	const expectedPrimary = {
		'from': 'color.identity.brand',
		'backgroundAlpha': 255,
		'brightnessMetric': 'srgb-luma-601',
		'brightnessScale': 255,
		'lightForegroundMax': 159,
		'darkForegroundMin': 160,
	};
	final primary = _map(derivations['color.action.primary'], 'consumerPolicy.derivations.color.action.primary');
	if (derivations.length != 1 || jsonEncode(primary) != jsonEncode(expectedPrimary)) {
		throw const FormatException(
			'color.action.primary must use the canonical opaque contrast rule.',
		);
	}
	_expectExactList(
		policy['locked'],
		_expectedLayers,
		'consumerPolicy.locked',
	);
	_expectExactList(
		policy['isolatedFrom'],
		const ['user-design-system.recipe'],
		'consumerPolicy.isolatedFrom',
	);

	final layers = _list(root['layers'], 'layers');
	if (layers.length != _expectedLayers.length) {
		throw FormatException(
			'layers must contain exactly ${_expectedLayers.length} entries.',
		);
	}

	final pageIds = <String>{};
	final symbols = <String>{};
	for (var index = 0; index < layers.length; index += 1) {
		final layer = _map(layers[index], 'layers[$index]');
		final layerId = _requiredString(layer, 'id', 'layers[$index]');
		if (layerId != _expectedLayers[index]) {
			throw FormatException(
				'layers[$index].id must be ${_expectedLayers[index]}.',
			);
		}
		_requiredString(layer, 'label', 'layers[$index]');
		_requiredString(layer, 'description', 'layers[$index]');

		final pages = _list(layer['pages'], 'layers[$index].pages');
		if (pages.isEmpty) {
			throw FormatException('layers[$index].pages must not be empty.');
		}
		for (var pageIndex = 0; pageIndex < pages.length; pageIndex += 1) {
			final path = 'layers[$index].pages[$pageIndex]';
			final page = _map(pages[pageIndex], path);
			final id = _requiredString(page, 'id', path);
			final source = _requiredString(page, 'source', path);
			final symbol = _requiredString(page, 'symbol', path);
			if (!id.startsWith('$layerId.')) {
				throw FormatException('$path.id must begin with $layerId.');
			}
			if (!source.endsWith('.dart')) {
				throw FormatException('$path.source must be a Dart source file.');
			}
			if (!pageIds.add(id)) {
				throw FormatException('Duplicate catalog page id: $id.');
			}
			if (!symbols.add(symbol)) {
				throw FormatException('Duplicate catalog page symbol: $symbol.');
			}
		}
	}
}

String _generateRegistry(Map<String, dynamic> root) {
	final layers = _list(root['layers'], 'layers');
	final sources = <String>{};
	for (final rawLayer in layers) {
		final layer = _map(rawLayer, 'layer');
		for (final rawPage in _list(layer['pages'], 'layer.pages')) {
			final page = _map(rawPage, 'page');
			sources.add(_requiredString(page, 'source', 'page'));
		}
	}

	final buffer = StringBuffer()
		..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
		..writeln('// Source: $_manifestPath')
		..writeln()
		..writeln("import '../../catalog_model.dart';");
	for (final source in sources.toList()..sort()) {
		buffer.writeln("import '../$source';");
	}
	buffer
		..writeln()
		..writeln("const String catalogSemanticManifestId = '${root['id']}';")
		..writeln(
			"const int catalogSemanticSchemaVersion = ${root['schemaVersion']};",
		)
		..writeln()
		..writeln('/// Catalog groups follow the semantic layer order in the manifest.')
		..writeln('final List<CatalogGroup> catalogGroups = [');

	for (final rawLayer in layers) {
		final layer = _map(rawLayer, 'layer');
		buffer
			..writeln('\tCatalogGroup(')
			..writeln("\t\tid: '${_escape(layer['id'] as String)}',")
			..writeln("\t\tlabel: '${_escape(layer['label'] as String)}',")
			..writeln(
				"\t\tdescription: '${_escape(layer['description'] as String)}',",
			)
			..writeln('\t\tpages: [');
		for (final rawPage in _list(layer['pages'], 'layer.pages')) {
			final page = _map(rawPage, 'page');
			buffer.writeln('\t\t\t${page['symbol']},');
		}
		buffer
			..writeln('\t\t],')
			..writeln('\t),');
	}

	buffer
		..writeln('];')
		..writeln()
		..writeln('/// Flattened page order shared by navigation and coverage checks.')
		..writeln('final List<CatalogPageData> catalogPages = [')
		..writeln('\tfor (final group in catalogGroups) ...group.pages,')
		..writeln('];')
		..writeln()
		..writeln('/// Public widget names represented by the Catalog.')
		..writeln('final Set<String> catalogedComponents = {')
		..writeln('\tfor (final page in catalogPages)')
		..writeln('\t\tfor (final specimen in page.specimens) specimen.name,')
		..writeln('};');

	return buffer.toString();
}

Map<String, dynamic> _map(Object? value, String path) {
	if (value is! Map<String, dynamic>) {
		throw FormatException('$path must be an object.');
	}
	return value;
}

List<dynamic> _list(Object? value, String path) {
	if (value is! List<dynamic>) {
		throw FormatException('$path must be an array.');
	}
	return value;
}

String _requiredString(
	Map<String, dynamic> object,
	String key,
	String path,
) {
	final value = object[key];
	if (value is! String || value.trim().isEmpty) {
		throw FormatException('$path.$key must be a non-empty string.');
	}
	return value;
}

void _expectExactList(Object? value, List<String> expected, String path) {
	final actual = _list(value, path);
	if (actual.length != expected.length) {
		throw FormatException('$path must equal $expected.');
	}
	for (var index = 0; index < expected.length; index += 1) {
		if (actual[index] != expected[index]) {
			throw FormatException('$path must equal $expected.');
		}
	}
}

String _escape(String value) {
	return value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
}
