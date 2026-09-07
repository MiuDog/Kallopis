// 由 Kallopis 元件原始碼產生 Catalog 風格語意追蹤資料。
//
// 掃描元件及其組成元件實際引用的 resolver、semantic enum 與明確風格建構式，
// 避免 Catalog 另外維護一份會與實作分岔的手寫說明。
import 'dart:io';

const _outputPath = 'example/lib/catalog/generated/catalog_style_semantics.g.dart';

final _widgetDeclaration = RegExp(
	r'^(?:(?:final|base|sealed)\s+)?class\s+(Klp[A-Za-z0-9]+)(?:<[^>]+>)?\s+extends\s+'
	r'(?:StatelessWidget|StatefulWidget|KlpPanelFrame)',
	multiLine: true,
);
final _construction = RegExp(r'\b(Klp[A-Za-z0-9]+)\s*\(');
final _directContextReference = RegExp(r'context\.klp(?:Colors)?(?:\.[A-Za-z_][A-Za-z0-9_]*)+');
final _contextAlias = RegExp(
	r'(?:final|var)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*'
	r'(context\.klp(?:Colors)?(?:\.[A-Za-z_][A-Za-z0-9_]*)*)\s*;',
);
final _semanticEnum = RegExp(
	r'\b(?:KlpSurfaceTone|KlpTextRole|KlpTextTone|KlpStrokeRole|KlpFeedbackTone)\.[A-Za-z_][A-Za-z0-9_]*',
);
final _styleConstruction = RegExp(
	r'\b(?:EdgeInsets(?:Directional)?\.(?:all|symmetric|only|fromLTRB)|'
	r'BorderRadius\.(?:all|circular|only)|BorderSide|Border\.all|Duration|TextStyle)\([^;\n]*\)',
);
final _literalColor = RegExp(r'\b(?:Color\([^;\n]*\)|Colors\.[A-Za-z_][A-Za-z0-9_]*)');

class _ComponentSource {

	const _ComponentSource({required this.name, required this.path, required this.body});

	final String name;
	final String path;
	final String body;
}

class _StyleReferences {

	final Set<String> colors = {};
	final Set<String> surfaces = {};
	final Set<String> borders = {};
	final Set<String> spacing = {};
	final Set<String> typography = {};
	final Set<String> geometry = {};
	final Set<String> motion = {};
	final Set<String> components = {};

	void add(String reference) {
		if (_matches(reference, ['klpColors', '.color.', '.primary', 'FeedbackTone'])) {
			colors.add(reference);
			return;
		}
		if (_matches(reference, ['.surface.', 'KlpSurfaceTone'])) {
			surfaces.add(reference);
			return;
		}
		if (_matches(reference, ['.shape.', 'KlpStrokeRole', 'Border', 'border'])) {
			borders.add(reference);
			return;
		}
		if (_matches(reference, ['.space.', 'EdgeInsets', 'padding', 'gap'])) {
			spacing.add(reference);
			return;
		}
		if (_matches(reference, ['.type.', 'KlpTextRole', 'KlpTextTone'])) {
			typography.add(reference);
			return;
		}
		if (reference.startsWith('TextStyle')) {
			typography.add(reference);
			return;
		}
		if (_matches(reference, ['.geometry.'])) {
			geometry.add(reference);
			return;
		}
		if (_matches(reference, ['.motion.', 'Duration'])) {
			motion.add(reference);
			return;
		}

		components.add(reference);
	}

	bool _matches(String value, List<String> fragments) {
		return fragments.any(value.contains);
	}
}

void main(List<String> arguments) {
	final generated = generateCatalogStyleSemantics(Directory('lib/src'));
	final output = File(_outputPath);
	final checkOnly = arguments.contains('--check');

	if (checkOnly) {
		final current = output.existsSync() ? output.readAsStringSync() : '';
		if (current.replaceAll('\r\n', '\n') != generated) {
			stderr.writeln('Catalog style semantics are stale. Run: dart run tool/generate_catalog_style_semantics.dart');
			exitCode = 1;
		}
		return;
	}

	output.parent.createSync(recursive: true);
	output.writeAsStringSync(generated);
	stdout.writeln('Generated $_outputPath');
}

/// 從指定來源根目錄產生追蹤表，供正式產生與隔離回歸測試共用。
String generateCatalogStyleSemantics(Directory sourceDirectory) => _generate(_readComponents(sourceDirectory));

Map<String, _ComponentSource> _readComponents(Directory sourceDirectory) {
	final result = <String, _ComponentSource>{};
	final files = sourceDirectory
		.listSync(recursive: true)
		.whereType<File>()
		.where((file) => file.path.endsWith('.dart'))
		.where((file) => !file.path.replaceAll(r'\', '/').contains('/internal/'))
		.toList()
		..sort((left, right) => left.path.compareTo(right.path));

	for (final file in files) {
		final source = file.readAsStringSync();
		final matches = _widgetDeclaration.allMatches(source).toList();
		for (var index = 0; index < matches.length; index++) {
			final match = matches[index];
			final end = index + 1 < matches.length ? matches[index + 1].start : source.length;
			final name = match.group(1)!;
			result[name] = _ComponentSource(
				name: name,
				path: file.path.replaceAll(r'\', '/'),
				body: _withStyleDependencies(file, source.substring(match.start, end)),
			);
		}
	}

	return result;
}

String _withStyleDependencies(File owner, String body) {
	// 只追蹤元件明確呼叫且直接匯入的風格表，避免無關元件污染追蹤結果。
	final calls = RegExp(r'\b(Klp[A-Za-z0-9]+Style)\.resolve\s*\(').allMatches(body);
	final names = calls.map((match) => match.group(1)!).toSet();
	if (names.isEmpty) return body;
	final result = StringBuffer(body);
	final imports = RegExp(r'''^import\s+['"]([^'"]+)['"]''', multiLine: true);
	for (final directive in imports.allMatches(owner.readAsStringSync())) {
		final uri = owner.uri.resolve(directive.group(1)!);
		if (uri.scheme != 'file') continue;
		final dependency = File.fromUri(uri);
		if (!dependency.existsSync()) continue;
		final source = dependency.readAsStringSync();
		if (!names.any((name) => RegExp('\\bclass\\s+$name\\b').hasMatch(source))) continue;
		result.writeln(source);
		// 注入的 KlpTheme 是同一份已解析主題，以標準 context 路徑呈現。
		for (final parameter in RegExp(r'\bKlpTheme\s+(\w+)').allMatches(source)) {
			result.writeln('final ${parameter.group(1)} = context.klp;');
		}
	}
	return result.toString();
}

String _generate(Map<String, _ComponentSource> components) {
	final buffer = StringBuffer()
		..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
		..writeln('// Source: lib/src component implementations')
		..writeln()
		..writeln("import '../../catalog_model.dart';")
		..writeln()
		..writeln('const Map<String, CatalogStyleSemantics> catalogStyleSemantics = {');

	final names = components.keys.toList()..sort();
	for (final name in names) {
		final component = components[name]!;
		final references = _collectReferences(name, components);
		buffer
			..writeln("\t'$name': CatalogStyleSemantics(")
			..writeln("\t\tsource: '${_escape(component.path)}',")
			..writeln('\t\tcolors: ${_list(references.colors)},')
			..writeln('\t\tsurfaces: ${_list(references.surfaces)},')
			..writeln('\t\tborders: ${_list(references.borders)},')
			..writeln('\t\tspacing: ${_list(references.spacing)},')
			..writeln('\t\ttypography: ${_list(references.typography)},')
			..writeln('\t\tgeometry: ${_list(references.geometry)},')
			..writeln('\t\tmotion: ${_list(references.motion)},')
			..writeln('\t\tcomponents: ${_list(references.components)},')
			..writeln('\t),');
	}

	buffer.writeln('};');
	return buffer.toString();
}

_StyleReferences _collectReferences(String name, Map<String, _ComponentSource> components) {
	final references = _StyleReferences();
	final component = components[name];
	if (component == null) return references;

	for (final match in _directContextReference.allMatches(component.body)) {
		references.add(match.group(0)!);
	}
	for (final match in _semanticEnum.allMatches(component.body)) {
		references.add(match.group(0)!);
	}
	for (final match in _styleConstruction.allMatches(component.body)) {
		references.add(_normalize(match.group(0)!));
	}
	if (_literalColor.hasMatch(component.body)) references.colors.add('literal Color（非語意，請查看來源）');

	final aliases = <String, String>{};
	for (final match in _contextAlias.allMatches(component.body)) {
		aliases[match.group(1)!] = match.group(2)!;
	}
	for (final entry in aliases.entries) {
		final usage = RegExp('\\b${RegExp.escape(entry.key)}((?:\\.[A-Za-z_][A-Za-z0-9_]*)+)');
		for (final match in usage.allMatches(component.body)) {
			references.add('${entry.value}${match.group(1)!}');
		}
	}

	final dependencies = _construction.allMatches(component.body).map((match) => match.group(1)!).toSet();
	for (final dependency in dependencies) {
		if (dependency == name || !components.containsKey(dependency)) continue;
		references.components.add(dependency);
	}

	return references;
}

String _list(Set<String> values) {
	final sorted = values.toList()..sort();
	if (sorted.isEmpty) return '[]';
	return '[${sorted.map((value) => "'${_escape(value)}'").join(', ')}]';
}

String _normalize(String value) {
	return value.replaceAll(RegExp(r'\s+'), ' ').trim();
}

String _escape(String value) {
	return value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
}
