import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// 檢查消費端是否只透過宣告式入口使用 Kallopis。
///
/// 這不是 Dart 語言層存取控制；產品 CI 必須執行此工具，才能把
/// `lib/src`、Flutter 與轉接匯入排除在受控組裝邊界之外。
List<String> verifyKlpDeclarativeConsumer(FileSystemEntity root) {
	if (!root.existsSync()) throw ArgumentError.value(root.path, 'root', 'Consumer source target does not exist.');
	final violations = <String>[];
	final files = switch (root) {
		File file when file.path.endsWith('.dart') => [file],
		File() => throw ArgumentError.value(root.path, 'root', 'Consumer source file must end with .dart.'),
		Directory directory => directory.listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart')).toList()..sort((a, b) => a.path.compareTo(b.path)),
		_ => throw ArgumentError.value(root.path, 'root', 'Consumer source target must be a file or directory.'),
	};
	for (final file in files) {
		final unit = parseString(content: file.readAsStringSync(), path: file.path, throwIfDiagnostics: false).unit;
		for (final directive in unit.directives) {
			final uri = switch (directive) {
				ImportDirective(:final uri) => uri.stringValue,
				ExportDirective(:final uri) => uri.stringValue,
				_ => null,
			};
			if (uri == null || !_isForbidden(uri)) continue;
			violations.add('${file.path}:${directive.offset} $uri');
		}
	}
	return violations;
}

bool _isForbidden(String uri) {
	if (uri == 'dart:ui' || uri.startsWith('dart:ui/')) return true;
	if (uri == 'package:flutter' || uri.startsWith('package:flutter/')) return true;
	if (!uri.startsWith('package:kallopis/')) return false;
	return uri != 'package:kallopis/kallopis_declarative.dart';
}

void main(List<String> arguments) {
	if (arguments.length != 1) {
		stderr.writeln('Usage: dart run tool/verify_declarative_consumer.dart <consumer-source-directory>');
		exitCode = 64;
		return;
	}
	final path = arguments.single;
	final target = FileSystemEntity.typeSync(path) == FileSystemEntityType.file ? File(path) : Directory(path);
	final violations = verifyKlpDeclarativeConsumer(target);
	if (violations.isEmpty) {
		stdout.writeln('Declarative consumer boundary passed.');
		return;
	}
	stderr.writeln('Declarative consumer boundary violations:');
	for (final violation in violations) {
		stderr.writeln('- $violation');
	}
	exitCode = 1;
}
