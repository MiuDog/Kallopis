import 'package:flutter/widgets.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';

import 'klp_application_catalog_contract_test.dart' as catalog;
import 'klp_prepared_module_boundary_test.dart';

// 獨立列舉原有 26 個變體，加上 POP-V1-r1 popup 與 CM-01 Menu，共 28 個。
const _generic = {
	'KlpBoundText', 'KlpBoundLinear', 'KlpBoundSurface', 'KlpBoundChoice',
	'KlpBoundRegions', 'KlpBoundExtent', 'KlpBoundPlacement',
	'KlpBoundRetainedStack', 'KlpBoundScreen', 'KlpBoundAccessibility',
};
const _editing = {
	'KlpBoundEditing', 'KlpBoundBlockNoteEditing', 'KlpBoundCanvaEditing',
	'KlpBoundBlockControlsSlot', 'KlpBoundAnchoredCommandsSlot', 'KlpBoundModeToolbarSlot',
};
const _workspace = {
	'KlpBoundAppLayout', 'KlpBoundFrameGroups', 'KlpBoundFrameGroup',
	'KlpBoundExplorer', 'KlpBoundDocumentTabs', 'KlpBoundWindowControls',
	'KlpBoundWorkspaceData', 'KlpBoundWorkspaceContent',
	'KlpBoundWorkspaceContentBlock', 'KlpBoundWorkspaceBlock',
	'KlpBoundAnchoredPopup',
};
const _overlays = {
	'KlpBoundMenu',
};
const _nonvisual = {
	'KlpBoundBlockControlsSlot', 'KlpBoundAnchoredCommandsSlot', 'KlpBoundModeToolbarSlot',
	'KlpBoundWorkspaceData', 'KlpBoundWorkspaceContent', 'KlpBoundWorkspaceContentBlock',
};

void main() {
	testWidgets('unknown prepared protocol implementation throws explicit contract error on build', (tester) async {
		// 實際進入 Widget build，避免只查來源文字卻容許空白 fallback。
		await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: KlpFlutterRenderer(content: const _UnknownPrepared())));
		expect(tester.takeException(), isA<KlpContractError>().having((error) => error.code, 'error code', 'unsupported_prepared_template'));
	});
	// 沿用已存在的目錄測試，核對實際工廠、來源宣告及樹交易。
	catalog.main();
	test('real catalog retains all 30 accepted IDs in order', () {
		final actual = klpApplicationAdapters().map((adapter) => adapter.contract.id).toList();
		expect(_catalogIds.length, 30);
		expect(actual, _catalogIds);
		expect(actual.toSet().length, actual.length);
	});
	test('all concrete prepared source declarations match 10 generic 6 editing 11 workspace 1 overlay variants', () {
		expect([_generic.length, _editing.length, _workspace.length, _overlays.length], [10, 6, 11, 1]);
		final expected = {..._generic, ..._editing, ..._workspace, ..._overlays};
		final actual = <String>[];
		for (final path in preparedDartFiles('lib/src')) {
			for (final declaration in preparedUnit(path).declarations.whereType<ClassDeclaration>()) {
				final parents = [declaration.extendsClause?.superclass.toSource(), ...?declaration.implementsClause?.interfaces.map((type) => type.toSource())];
				if (parents.contains('KlpBoundTemplate') && declaration.abstractKeyword == null) {
					actual.add(declaration.namePart.typeName.lexeme);
				}
			}
		}
		expect(actual.toSet(), expected);
		expect(actual.length, 28, reason: '不可用重複宣告填補變體數量');
	});
	test('renderer handles every concrete variant once and labels six nonvisual variants', () {
		final visitor = _ContentDispatchVisitor();
		preparedUnit('lib/src/rendering/flutter/klp_flutter_renderer.dart').accept(visitor);
		expect(visitor.dispatches.length, 1, reason: 'build 必須保留唯一 content 分派');
		final branches = <String, List<String>>{};
		for (final branch in visitor.dispatches.single.cases) {
			final pattern = branch.guardedPattern.pattern.toSource();
			for (final match in RegExp(r'\bKlpBound\w+\b').allMatches(pattern)) {
				branches.putIfAbsent(match.group(0)!, () => []).add(branch.expression.toSource());
			}
		}
		expect(branches.keys.toSet(), {..._generic, ..._editing, ..._workspace, ..._overlays});
		for (final entry in branches.entries) {
			expect(entry.value.length, 1, reason: '每個變體恰好一個分支：${entry.key}');
			final empty = entry.value.single.replaceAll('const ', '') == 'SizedBox.shrink()';
			expect(empty, _nonvisual.contains(entry.key), reason: '非視覺標记必須明確：${entry.key}');
		}
	});
}

final class _ContentDispatchVisitor extends RecursiveAstVisitor<void> {

	final dispatches = <SwitchExpression>[];

	@override
	void visitSwitchExpression(SwitchExpression node) {
		if (node.expression.toSource() == 'content' && node.thisOrAncestorOfType<MethodDeclaration>()?.name.lexeme == 'build') {
			dispatches.add(node);
		}
		super.visitSwitchExpression(node);
	}
}

const _catalogIds = <String>[
	'kallopis.menu',
	'kallopis.scopeBoundary',
	'kallopis.retainedScreens',
	'kallopis.screen',
	'kallopis.adaptive',
	'kallopis.editing',
	'kallopis.blockNoteEditing',
	'kallopis.canvaEditing',
	'kallopis.block-controls',
	'kallopis.anchored-commands',
	'kallopis.editing.modeToolbar',
	'kallopis.rail',
	'kallopis.explorer',
	'kallopis.explorer.entry',
	'kallopis.document_tabs',
	'kallopis.document_tab',
	'kallopis.window_controls',
	'kallopis.workspace_block',
	'kallopis.workspace_content',
	'kallopis.workspace_content_block',
	'kallopis.anchored_popup',
	'kallopis.app_layout',
	'kallopis.layout_row',
	'kallopis.layout_column',
	'kallopis.layout_resize_handle',
	'kallopis.layout_spacer',
	'kallopis.layout_pane',
	'kallopis.app_frame',
	'kallopis.frame_groups',
	'kallopis.frame_group',
];

// 舊 sealed 基線無法編譯這個未知型別；其結果標記 integration-pending。
final class _UnknownPrepared extends KlpBoundTemplate {

	const _UnknownPrepared();
}
