import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart' as declarative;
import 'package:kallopis/kallopis_editing_provider.dart' as provider;
import 'package:kallopis/src/capabilities/editing/klp_editing_submission.dart';
import 'package:kallopis/src/features/editing/adapters/klp_block_note_editing_adapter.dart';
import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_block_note_editing.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:krepis_block_note/krepis_block_note.dart' as krepis;

// 清冊使用真正可編譯的型別；共享快照、保存、命令與手寫資料不是舊正文權威。
final _legacyBodyTypes = <String, Type>{
	'KlpEditableSource': provider.KlpEditableSource,
	'KlpEditingLayoutSource': provider.KlpEditingLayoutSource,
	'KlpBlockControlSource': provider.KlpBlockControlSource,
	'KlpEditingIntent': provider.KlpEditingIntent,
	'KlpReplaceTextIntent': provider.KlpReplaceTextIntent,
	'KlpSelectTextIntent': provider.KlpSelectTextIntent,
	'KlpBeginCompositionIntent': provider.KlpBeginCompositionIntent,
	'KlpUpdateCompositionIntent': provider.KlpUpdateCompositionIntent,
	'KlpCommitCompositionIntent': provider.KlpCommitCompositionIntent,
	'KlpCancelCompositionIntent': provider.KlpCancelCompositionIntent,
	'KlpEditingCommandIntent': provider.KlpEditingCommandIntent,
	'KlpEditingCommand': provider.KlpEditingCommand,
	'KlpEditingRequest': provider.KlpEditingRequest,
	'KlpEditingReply': provider.KlpEditingReply,
	'KlpBlockIntent': provider.KlpBlockIntent,
	'KlpBlockRequest': provider.KlpBlockRequest,
	'KlpBlockViewportRequest': provider.KlpBlockViewportRequest,
	'KlpCompositionAttribute': provider.KlpCompositionAttribute,
	'KlpCompositionSegment': provider.KlpCompositionSegment,
	'KlpCompositionText': provider.KlpCompositionText,
	'KlpTextOffsets': provider.KlpTextOffsets,
	'KlpEditingLayout': provider.KlpEditingLayout,
	'KlpEditingPointRequest': provider.KlpEditingPointRequest,
	'KlpEditingTextWindow': provider.KlpEditingTextWindow,
	'KlpEditingSubmission': KlpEditingSubmission,
};

const _legacyBodyOperations = {
	'submit', 'selectPoint', 'bindInteraction', 'submitBlock', 'layout',
	'submitBlockViewport', 'resynchronize',
};

const _borrowedOwnerTypes = {
	'KlpBlockNoteSessionController', 'KlpBlockNoteBridgeChannel',
	'KrepisBlockNoteSessionController', 'KrepisBlockNoteBridgeChannel',
};

const _blockNoteSources = [
	'lib/src/features/editing/contracts/klp_block_note_editing_content.dart',
	'lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart',
	'lib/src/features/editing/presentation/klp_bound_block_note_editing.dart',
	'lib/src/rendering/flutter/internal/klp_flutter_block_note_editing.dart',
];

void main() {

	test('retained provider snapshot and save remain separate from legacy body operations', () {
		final source = _unit('lib/src/capabilities/editing/contracts/klp_editing_source.dart');
		final base = _class(source, 'KlpEditingSource');
		expect(_methods(base).keys.toSet(), {'drawing', 'drawings'});
		expect(_methods(base)['drawing']!.returnType!.toSource(), 'KlpEditingDrawing');
		expect(_methods(base)['drawings']!.returnType!.toSource(), 'Stream<KlpEditingDrawing>');
		final editable = _class(source, 'KlpEditableSource');
		expect(editable.implementsClause!.interfaces.single.name.lexeme, 'KlpEditingLayoutSource');
		final submit = _methods(editable)['submit']!;
		expect(submit.returnType!.toSource(), 'FutureOr<KlpEditingReply>');
		expect(submit.parameters!.parameters.first.toSource(), 'KlpEditingRequest request');
		final blockSubmit = _methods(_class(source, 'KlpBlockControlSource'))['submitBlock']!;
		expect(blockSubmit.parameters!.parameters.first.toSource(), 'KlpBlockRequest request');
		final save = _class(_unit('lib/src/capabilities/editing/contracts/klp_editing_save_source.dart'), 'KlpEditingSaveSource');
		expect(save.implementsClause!.interfaces.single.name.lexeme, 'KlpEditingSource');
		expect(_methods(save).keys, containsAll(['saveState', 'issueCommandSequence', 'submitSave']));
		expect(_methods(save)['submitSave']!.parameters!.parameters.single.toSource(), 'KlpEditingSaveRequest request');

		// 以公開 enum 真值保護舊 block/list/undo 請求用途，仍可供舊 caller 使用。
		expect(provider.KlpBlockIntent.values.map((intent) => intent.name), [
			'select', 'moveBefore', 'moveAfter', 'convert', 'convertToUnorderedList',
			'convertToOrderedList', 'convertListToParagraph', 'indentList', 'outdentList',
			'toggleTaskChecked', 'toggleCollapsed', 'undo', 'redo',
		]);
	});
	test('new body declarations and operations do not consume legacy transactions', () {
		for (final path in _blockNoteSources) {
			final unit = _unit(path);
			expect(unit.declarations.whereType<ClassDeclaration>(), isNotEmpty, reason: path);
			expect(_bodyViolations(unit), isEmpty, reason: path);
		}

		// root 的 DTO import 供其他 legacy parts 解析；仍檢查 root 的所有實際宣告。
		const root = 'lib/src/features/editing/presentation/klp_editing_presentation.dart';
		final unit = _unit(root);
		expect(unit.directives.whereType<PartDirective>().map((part) => part.uri.stringValue), contains('klp_bound_block_note_editing.dart'));
		expect(_bodyViolations(unit), isEmpty, reason: root);
	});
	test('body guard detects typed legacy use calls tearoffs and new upstream owners', () {
		for (final name in _legacyBodyTypes.keys) {
			for (final declaration in [
				'class Probe { final old.$name value; Probe(this.value); }',
				'void probe(Object value) { value as old.$name; }',
				'void probe() { final value = old.$name(); }',
			]) {
				expect(_bodyViolations(_parse(declaration)), isNotEmpty, reason: declaration);
			}
		}
		for (final operation in _legacyBodyOperations) {
			for (final body in ['old.$operation(request);', 'old..$operation(request);', 'final callback = old.$operation;', '$operation(request);']) {
				final declaration = 'void probe(dynamic old, dynamic request) { $body }';
				expect(_bodyViolations(_parse(declaration)), isNotEmpty, reason: declaration);
			}
		}
		for (final owner in _borrowedOwnerTypes) {
			for (final expression in ['upstream.$owner()', 'new upstream.$owner()', 'upstream.$owner.hosted()', 'upstream.$owner.new']) {
				final declaration = 'void probe() { final value = $expression; }';
				expect(_bodyViolations(_parse(declaration)), isNotEmpty, reason: expression);
			}
		}
		final sharedRootWithOperation = "import 'klp_editing_request.dart'; part 'legacy.dart'; void probe(dynamic old) { old.submit(null); }";
		expect(_bodyViolations(_parse(sharedRootWithOperation)), isNotEmpty);
	});
	test('body guard allows shared provider save geometry anchor handwriting and borrowed session', () {
		const allowed = '''
import 'klp_editing_request.dart';
part 'legacy.dart';
// KlpEditingRequest 與 submit 僅在註解中，不是即時正文操作。
class Shared {
	final KlpEditingSource source;
	final KlpEditingSaveSource save;
	final KlpEditingDrawing drawing;
	final KlpEditingProjection projection;
	final KlpEditingEndpoint endpoint;
	final KlpEditingStamp stamp;
	final KlpCommandAnchor anchor;
	final KlpCommandProjection commands;
	final KlpHandwritingState handwriting;
	final KlpEditorModeSource modes;
	final KlpBlockNoteSessionController controller;
	KlpBlockNoteBridgeChannel get channel => controller.bridge as KlpBlockNoteBridgeChannel;
	void send() { save.submitSave(null); channel.flush(); controller.accept({}); }
	String get explanation => 'old.submit(KlpEditingRequest())';
}
''';
		expect(_bodyViolations(_parse(allowed)), isEmpty);
	});
	test('public body and presentation borrow the original Krepis controller and channel', () {
		final channel = krepis.KlpBlockNoteBridgeChannel();
		final controller = _controller(channel);
		final content = declarative.KlpBlockNoteEditingContent(id: declarative.KlpId.root('compatibility-body'), controller: controller);
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);

		// 經由真正 adapter prepare/materialize，驗證中間層沒有另建或替換 controller。
		runtime.update(root: content, adapters: [KlpBlockNoteEditingAdapter()], primitives: declarative.KlpWorkspacePreset.light());
		final bound = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundBlockNoteEditing;
		final renderer = KlpFlutterBlockNoteEditing(content: bound);
		expect(content.controller, same(controller));
		expect(bound.controller, same(controller));
		expect(renderer.content.controller, same(controller));
		expect(renderer.content.controller.bridge, same(channel));
		expect(declarative.KlpBlockNoteSessionController, same(krepis.KlpBlockNoteSessionController));
		expect(declarative.KlpBlockNoteDocument, same(krepis.KlpBlockNoteDocument));
		expect(declarative.KlpBlockNoteSaveResult, same(krepis.KlpBlockNoteSaveResult));
		expect(() => declarative.KlpBlockNoteEditingContent(id: content.id, controller: _controller(_UnhostedPort())), throwsArgumentError);
	});
}

CompilationUnit _unit(String path) {
	// 只讀取固定來源，避免用產品搜尋結果反推受保護的集合。
	return _parse(File(path).readAsStringSync());
}

CompilationUnit _parse(String source) {
	// AST 排除註解與字串，並觀察型別、建構與實際操作位置。
	return parseString(content: source, throwIfDiagnostics: true).unit;
}

ClassDeclaration _class(CompilationUnit unit, String name) => unit.declarations.whereType<ClassDeclaration>().singleWhere((node) => node.namePart.typeName.lexeme == name);

Map<String, MethodDeclaration> _methods(ClassDeclaration node) => {for (final method in (node.body as BlockClassBody).members.whereType<MethodDeclaration>()) method.name.lexeme: method};

List<String> _bodyViolations(CompilationUnit unit) {
	final visitor = _BodyAuthorityVisitor();
	for (final declaration in unit.declarations) {
		declaration.accept(visitor);
	}
	return visitor.violations;
}

final class _BodyAuthorityVisitor extends RecursiveAstVisitor<void> {

	final violations = <String>[];

	@override
	void visitNamedType(NamedType node) {
		if (_legacyBodyTypes.containsKey(node.name.lexeme)) violations.add('舊正文型別：${node.toSource()}');
		super.visitNamedType(node);
	}

	@override
	void visitSimpleIdentifier(SimpleIdentifier node) {
		// 同時拒絕呼叫與方法 tear-off，避免改寫成 callback 繞過舊提交邊界。
		if (_legacyBodyOperations.contains(node.name)) violations.add('舊正文操作：${node.name}');
		if (_legacyBodyTypes.containsKey(node.name)) violations.add('舊正文建構或 enum 操作：${node.name}');
		super.visitSimpleIdentifier(node);
	}

	@override
	void visitInstanceCreationExpression(InstanceCreationExpression node) {
		final name = node.constructorName.type.name.lexeme;
		if (_borrowedOwnerTypes.contains(name)) violations.add('應借用既有 upstream authority：$name');
		super.visitInstanceCreationExpression(node);
	}

	@override
	void visitMethodInvocation(MethodInvocation node) {
		// 未解析 AST 的隱式建構子屬於 method invocation，連同具名 factory 一起防守。
		if (_borrowedOwnerTypes.contains(node.methodName.name) || _borrowedOwnerTypes.contains(_terminalName(node.target))) violations.add('不可另建 upstream authority：${node.toSource()}');
		super.visitMethodInvocation(node);
	}

	@override
	void visitPropertyAccess(PropertyAccess node) {
		if (_borrowedOwnerTypes.contains(_terminalName(node.target)) && node.propertyName.name == 'new') violations.add('不可借建構 tear-off 另建 upstream authority');
		super.visitPropertyAccess(node);
	}
}

String? _terminalName(Expression? expression) => switch (expression) {
	SimpleIdentifier node => node.name,
	PrefixedIdentifier node => node.identifier.name,
	PropertyAccess node => node.propertyName.name,
	_ => null,
};

krepis.KlpBlockNoteSessionController _controller(krepis.KlpBlockNoteBridgePort bridge) => krepis.KlpBlockNoteSessionController(
	documentId: 'compatibility-document',
	sessionId: 'compatibility-session',
	initialDocument: krepis.KlpBlockNoteDocument(schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: []),
	bridge: bridge,
	persist: (_) async {},
);

final class _UnhostedPort implements krepis.KlpBlockNoteBridgePort {

	@override
	Future<void> send(Map<String, Object?> command) async {}
}
