import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'klp_lower_module_boundary_test.dart' show lowerRenderingViolations, lowerUnits;
import 'klp_prepared_module_boundary_test.dart' show preparedDartFiles, preparedDeclarations, preparedExportClosure, preparedUnit, preparedUris;

const _failurePath = 'lib/src/features/editing/contracts/klp_editing_host_failure.dart';

void main() {
	test('host failure stays pure data and private to every public export graph', () {
		final unit = preparedUnit(_failurePath);
		expect(preparedDeclarations(unit).toSet(), {'KlpEditingHostOrigin', 'KlpEditingHostPhase', 'KlpEditingHostFailure', 'KlpEditingHostFailureSink'});
		final uris = unit.directives.expand(preparedUris);
		expect(uris.where((uri) => !uri.startsWith('dart:')), isEmpty, reason: '失敗值不可持有 Flutter、引擎或另一份應用權威');
		expect(uris.where((uri) => uri == 'dart:ui' || uri == 'dart:ffi'), isEmpty);
		final failure = unit.declarations.whereType<ClassDeclaration>().single;
		final fields = (failure.body as BlockClassBody).members.whereType<FieldDeclaration>().toList();
		expect(fields.every((field) => field.fields.isFinal), isTrue);
		expect(fields.expand((field) => field.fields.variables).map((variable) => variable.name.lexeme).toSet(), {'origin', 'phase', 'error', 'stackTrace'});
		for (final root in preparedDartFiles('lib', recursive: false)) {
			expect(preparedExportClosure(root), isNot(contains(_failurePath)), reason: root);
		}
	});

	test('all seven public library roots retain the exact accepted HOST PORTS content', () {
		expect(preparedDartFiles('lib', recursive: false).toSet(), _publicRoots.keys.toSet());
		for (final entry in _publicRoots.entries) {
			// 忽略作業系統換行差異，仍凍結所有公開 library 的完整來源。
			final source = File(entry.key).readAsStringSync().replaceAll('\r\n', '\n');
			expect(sha256.convert(utf8.encode(source)).toString(), entry.value, reason: entry.key);
		}
	});

	test('renderer uses permitted contracts without new foreign internal edges', () {
		final violations = lowerRenderingViolations(lowerUnits());
		expect(violations, isEmpty, reason: violations.join('\n'));
	});

	test('editing hosts do not construct document authority or release borrowed controllers', () {
		for (final path in _hostPaths) {
			final visitor = _BorrowedAuthorityVisitor();
			preparedUnit(path).accept(visitor);
			expect(visitor.violations, isEmpty, reason: '$path: ${visitor.violations.join(', ')}');
		}
	});
}

/// 僅限制正文控制器與環境權威；本機 input、WebView environment 與 binding 可正常釋放。
final class _BorrowedAuthorityVisitor extends RecursiveAstVisitor<void> {

	final violations = <String>[];

	@override
	void visitInstanceCreationExpression(InstanceCreationExpression node) {
		final type = node.constructorName.type.toSource();
		if (RegExp(r'(SessionController|BridgeChannel|DocumentController|ThemeData|KlpTheme|KlpLocalizations)$').hasMatch(type)) violations.add(node.toSource());
		super.visitInstanceCreationExpression(node);
	}

	@override
	void visitMethodInvocation(MethodInvocation node) {
		final method = node.methodName.name;
		final target = node.realTarget?.toSource() ?? '';
		final borrowed = RegExp(r'(^|\.)(_session|session|_controller|widget\.content\.controller|widget\.content\.actions)$').hasMatch(target);
		if (borrowed && {'close', 'dispose', 'save', 'submitSave'}.contains(method)) violations.add(node.toSource());
		super.visitMethodInvocation(node);
	}
}

const _hostPaths = [
	'lib/src/rendering/flutter/internal/klp_flutter_editing.dart',
	'lib/src/rendering/flutter/internal/klp_flutter_block_note_editing.dart',
	'lib/src/rendering/flutter/internal/klp_flutter_canva_editing.dart',
];

const _publicRoots = {
	'lib/kallopis_declarative.dart': 'a14a418367347db743f609d775ab5de39e457f0cbdfe35b37222cc538607e751',
	'lib/kallopis_legacy_file_picker.dart': 'cf3e71523f7a213ab781d6bebed3a5354c87163b16ae9318b6d434a43c117e86',
	'lib/kallopis_editing_provider.dart': 'c8b627b2254a026e89f0ed6e89a6e0dde9724e39df4801a0c5467855b806a104',
	'lib/kallopis_experimental.dart': '9c6afe490cf6a3543108c843c997a103707caa1ec9b8711e95f647815de066e9',
	'lib/kallopis_foundation.dart': 'e81b7ee0936425de90cea7db32a00a139da87e743648bce7ac879e1b95815ad2',
	'lib/kallopis_theme.dart': 'ecac099286f46aeb15151c1556dcfc8976bc2cbe8178fb1cbd9795efefe9baef',
	'lib/kallopis.dart': 'f4cf639972101648dbc05c0ba45fc88d9742a8051272994a9e2c6b75da07d345',
};
