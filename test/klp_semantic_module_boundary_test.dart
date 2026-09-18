import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
	late Map<String, List<({String kind, String target})>> directives;
	setUpAll(() {
		// 只保留來源指令，避免依賴尚未搬移的語意型別或實作。
		directives = {
			for (final file in Directory('lib').listSync(recursive: true).whereType<File>())
				if (file.path.endsWith('.dart')) file.path.replaceAll('\\', '/'): _directives(file.path.replaceAll('\\', '/'), file.readAsStringSync()),
		};
	});

	test('other modules do not import or export styling resolution internal paths', () {
		expect(directives, isNotEmpty, reason: '邊界掃描必須涵蓋正式來源。');
		final violations = _internalViolations(directives);
		expect(violations, isEmpty, reason: '跨模組必須使用具名語意契約或入口：\n${violations.join('\n')}');
	});

	test('consumer libraries cannot export styling resolution entries transitively', () {
		final violations = _publicViolations(directives);
		expect(violations, isEmpty, reason: '語意解析與驗證入口只供套件內使用：\n${violations.join('\n')}');
	});

	test('boundary guard rejects package relative and conditional internal directives', () {
		const path = 'lib/src/application/example.dart';
		const source = '''
import 'package:kallopis/src/styling/resolution/internal/klp_semantic_resolver.dart';
export '../styling/resolution/internal/klp_semantic_resolution.dart';
import 'allowed.dart' if (dart.library.io) '../styling/resolution/internal/conditional.dart';
// import '../styling/resolution/internal/comment.dart';
import 'package:another/src/styling/resolution/internal/external.dart';
import '../styling/resolution/klp_semantic_graph.dart';
import '../styling/resolution/klp_semantic_resolver.dart';
''';
		final violations = _internalViolations({path: _directives(path, source)});
		expect(violations, [
			'$path -> lib/src/styling/resolution/internal/klp_semantic_resolver.dart',
			'$path -> lib/src/styling/resolution/internal/klp_semantic_resolution.dart',
			'$path -> lib/src/styling/resolution/internal/conditional.dart',
		]);

		const stylingPath = 'lib/src/styling/resolution/example.dart';
		final ownDirectives = _directives(stylingPath, "import 'internal/klp_semantic_resolver.dart';");
		expect(_internalViolations({stylingPath: ownDirectives}), isEmpty);
	});

	test('public guard follows indirect and conditional exports but not imports', () {
		const sources = {
			'lib/public.dart': "export 'bridge.dart'; import 'src/styling/resolution/import_only.dart';",
			'lib/bridge.dart': "export 'public.dart'; export 'src/empty.dart' if (dart.library.io) 'src/styling/resolution/klp_semantic_graph.dart'; export 'src/styling/resolution/klp_semantic_resolver.dart';",
			'lib/src/empty.dart': '',
			'lib/src/styling/resolution/klp_semantic_graph.dart': '',
			'lib/src/styling/resolution/klp_semantic_resolver.dart': '',
		};
		final graph = {for (final entry in sources.entries) entry.key: _directives(entry.key, entry.value)};
		final violations = _publicViolations(graph);
		expect(violations.toSet(), {
			'lib/public.dart -> lib/src/styling/resolution/klp_semantic_graph.dart',
			'lib/public.dart -> lib/src/styling/resolution/klp_semantic_resolver.dart',
			'lib/bridge.dart -> lib/src/styling/resolution/klp_semantic_graph.dart',
			'lib/bridge.dart -> lib/src/styling/resolution/klp_semantic_resolver.dart',
		});
	});
}

List<({String kind, String target})> _directives(String path, String source) {
	// Dart 語法解析涵蓋註解、換行及條件 URI，不以文字中出現路徑作判定。
	final parsed = parseString(content: source, path: path, throwIfDiagnostics: false);
	final result = <({String kind, String target})>[];
	for (final directive in parsed.unit.directives) {
		final String kind;
		final List<String?> uris;
		if (directive is ImportDirective) {
			kind = 'import';
			uris = [directive.uri.stringValue, ...directive.configurations.map((item) => item.uri.stringValue)];
		}
		else if (directive is ExportDirective) {
			kind = 'export';
			uris = [directive.uri.stringValue, ...directive.configurations.map((item) => item.uri.stringValue)];
		}
		else if (directive is PartDirective) {
			kind = 'part';
			uris = [directive.uri.stringValue];
		}
		else {
			continue;
		}

		for (final uri in uris) {
			if (uri == null) continue;

			final target = _localPath(path, uri);
			if (target != null) result.add((kind: kind, target: target));
		}
	}
	return result;
}

String? _localPath(String source, String target) {
	// 套件 URI 與相對 URI 正規化為同一個 lib 路徑，外部套件不屬於本契約。
	const packageRoot = 'package:kallopis/';
	if (target.startsWith(packageRoot)) return Uri.parse('lib/${target.substring(packageRoot.length)}').normalizePath().path;
	if (Uri.parse(target).hasScheme) return null;

	return Uri.parse(source).resolve(target).normalizePath().path;
}

List<String> _internalViolations(Map<String, List<({String kind, String target})>> graph) {
	final violations = <String>[];
	for (final entry in graph.entries) {
		if (entry.key.startsWith('lib/src/styling/')) continue;

		for (final directive in entry.value) {
			if (directive.kind != 'import' && directive.kind != 'export') continue;

			final target = directive.target;
			if (target.startsWith('lib/src/styling/resolution/internal/')) {
				violations.add('${entry.key} -> $target');
			}
		}
	}
	return violations;
}

List<String> _publicViolations(Map<String, List<({String kind, String target})>> graph) {
	final violations = <String>[];
	for (final root in graph.keys.where((path) => path.split('/').length == 2)) {
		// 從每個公開 library 追蹤 export 與 part，循環匯出只走訪一次。
		final visited = <String>{};
		final pending = <String>[root];
		while (pending.isNotEmpty) {
			final path = pending.removeLast();
			if (!visited.add(path)) continue;

			if (path.startsWith('lib/src/styling/resolution/')) violations.add('$root -> $path');
			for (final directive in graph[path] ?? <({String kind, String target})>[]) {
				if (directive.kind == 'export' || directive.kind == 'part') pending.add(directive.target);
			}
		}
	}
	return violations;
}
