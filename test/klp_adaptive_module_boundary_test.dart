import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
	test('composition does not import or export runtime or foundation', () {
		// 直接讀取正式來源指令，基線不需匯入尚未搬移的產品型別。
		final files = Directory('lib/src/composition').listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart')).toList();
		expect(files, isNotEmpty, reason: '邊界掃描必須實際涵蓋 composition 來源。');
		final violations = <String>[];
		for (final file in files) {
			// 將 Windows 路徑正規化，讓相對指令與套件指令使用相同邊界。
			violations.addAll(_violations(file.path.replaceAll('\\', '/'), file.readAsStringSync()));
		}
		violations.sort();
		expect(violations, isEmpty, reason: 'composition 只能使用下層契約，不能匯入或轉匯出 runtime／foundation：\n${violations.join('\n')}');
	});

	test('boundary guard recognizes package relative and conditional edges', () {
		const path = 'lib/src/composition/nodes/probe.dart';
		const source = '''
import 'package:kallopis/src/runtime/contracts/probe.dart';
export '../../foundation/platform/probe.dart';
import 'allowed.dart' if (dart.library.io) '../../runtime/compilation/probe.dart';
export 'allowed.dart' if (dart.library.html) 'package:kallopis/src/foundation/platform/conditional.dart';
import 'package:kallopis/src/capabilities/environment/probe.dart';
import 'package:another/src/runtime/probe.dart';
// import '../../foundation/comment.dart';
''';
		expect(_violations(path, source), [
			'$path -> lib/src/runtime/contracts/probe.dart',
			'$path -> lib/src/foundation/platform/probe.dart',
			'$path -> lib/src/runtime/compilation/probe.dart',
			'$path -> lib/src/foundation/platform/conditional.dart',
		]);
	});
}

List<String> _violations(String path, String source) {
	// 解析語法而非搜尋字串，同時涵蓋條件匯入與匯出且忽略註解。
	final unit = parseString(content: source, path: path, throwIfDiagnostics: true).unit;
	final violations = <String>[];
	for (final directive in unit.directives) {
		final List<String?> uris;
		if (directive is ImportDirective) {
			uris = [directive.uri.stringValue, ...directive.configurations.map((item) => item.uri.stringValue)];
		}
		else if (directive is ExportDirective) {
			uris = [directive.uri.stringValue, ...directive.configurations.map((item) => item.uri.stringValue)];
		}
		else {
			continue;
		}

		for (final uri in uris) {
			if (uri == null) continue;

			final target = _localPath(path, uri);
			if (target.startsWith('lib/src/runtime/') || target.startsWith('lib/src/foundation/')) {
				violations.add('$path -> $target');
			}
		}
	}
	return violations;
}

String _localPath(String source, String target) {
	const packageRoot = 'package:kallopis/';
	if (target.startsWith(packageRoot)) return Uri.parse('lib/${target.substring(packageRoot.length)}').normalizePath().path;
	if (Uri.parse(target).hasScheme) return target;

	return Uri.parse(source).resolve(target).normalizePath().path;
}
