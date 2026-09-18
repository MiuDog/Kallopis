import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
	late Map<String, List<({String kind, String target})>> directives;
	setUpAll(() {
		// 只保留來源指令，避免依賴尚未搬移的 runtime 型別或實作。
		directives = {
			for (final file in Directory('lib').listSync(recursive: true).whereType<File>())
				if (file.path.endsWith('.dart')) file.path.replaceAll('\\', '/'): _directives(file.path.replaceAll('\\', '/'), file.readAsStringSync()),
		};
	});

	test('other modules do not import or export runtime internal paths', () {
		final violations = _internalViolations(directives);
		expect(violations, isEmpty, reason: '跨模組必須使用具名 runtime 契約或入口：\n${violations.join('\n')}');
	});

	test('consumer libraries cannot export runtime contracts or entries transitively', () {
		final violations = _publicViolations(directives);
		expect(violations, isEmpty, reason: 'runtime 契約與入口只供套件內使用：\n${violations.join('\n')}');
	});

	test('boundary guard rejects package relative and conditional internal directives', () {
		const path = 'lib/src/application/example.dart';
		const source = '''
import 'package:kallopis/src/runtime/compilation/internal/klp_tree_runtime.dart';
export '../runtime/installation/internal/klp_installation.dart';
import 'allowed.dart' if (dart.library.io) '../runtime/compilation/internal/klp_prepare_context.dart';
// import '../runtime/compilation/internal/comment.dart';
import 'package:another/src/runtime/compilation/internal/external.dart';
import '../runtime/contracts/klp_prepared_node.dart';
import '../runtime/compilation/klp_tree_runtime.dart';
''';
		final violations = _internalViolations({path: _directives(path, source)});
		expect(violations, [
			'$path -> lib/src/runtime/compilation/internal/klp_tree_runtime.dart',
			'$path -> lib/src/runtime/installation/internal/klp_installation.dart',
			'$path -> lib/src/runtime/compilation/internal/klp_prepare_context.dart',
		]);

		const runtimePath = 'lib/src/runtime/compilation/example.dart';
		final ownDirectives = _directives(runtimePath, "import 'internal/klp_tree_runtime.dart';");
		expect(_internalViolations({runtimePath: ownDirectives}), isEmpty);
	});

	test('public guard follows indirect and conditional exports but not imports', () {
		const sources = {
			'lib/public.dart': "export 'bridge.dart'; import 'src/runtime/contracts/import_only.dart';",
			'lib/bridge.dart': "export 'public.dart'; export 'src/empty.dart' if (dart.library.io) 'src/runtime/contracts/klp_prepared_node.dart'; export 'src/runtime/compilation/klp_tree_runtime.dart';",
			'lib/src/empty.dart': '',
			'lib/src/runtime/contracts/klp_prepared_node.dart': '',
			'lib/src/runtime/compilation/klp_tree_runtime.dart': '',
		};
		final graph = {for (final entry in sources.entries) entry.key: _directives(entry.key, entry.value)};
		final violations = _publicViolations(graph);
		expect(violations.toSet(), {
			'lib/public.dart -> lib/src/runtime/contracts/klp_prepared_node.dart',
			'lib/public.dart -> lib/src/runtime/compilation/klp_tree_runtime.dart',
			'lib/bridge.dart -> lib/src/runtime/contracts/klp_prepared_node.dart',
			'lib/bridge.dart -> lib/src/runtime/compilation/klp_tree_runtime.dart',
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
		if (entry.key.startsWith('lib/src/runtime/')) continue;

		for (final directive in entry.value) {
			if (directive.kind != 'import' && directive.kind != 'export') continue;

			final target = directive.target;
			if (target.startsWith('lib/src/runtime/') && target.split('/').contains('internal')) {
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

			if (path.startsWith('lib/src/runtime/')) violations.add('$root -> $path');
			for (final directive in graph[path] ?? <({String kind, String target})>[]) {
				if (directive.kind == 'export' || directive.kind == 'part') pending.add(directive.target);
			}
		}
	}
	return violations;
}
