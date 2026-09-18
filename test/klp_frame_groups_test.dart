import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart';
import 'package:kallopis/src/features/workspace/layout/adapters/klp_app_layout_adapter.dart';
import 'package:kallopis/src/features/workspace/layout/adapters/klp_frame_groups_adapter.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';

import 'support/klp_component_test_definition.dart';
import 'support/klp_component_test_item.dart';

void main() {
	test('Frame groups resolve padding and divider choices through semantic tokens', () {
		final runtime = KlpTreeRuntime();
		final adapter = KlpComponentTestAdapter();
		final primitives = KlpWorkspacePreset.light();
		addTearDown(runtime.dispose);
		runtime.update(
			root: KlpAppLayout(
				id: KlpId.parse('layout'),
				child: KlpAppFrame(
					id: KlpId.parse('frame'),
					child: KlpFrameGroups(
						id: KlpId.parse('groups'),
						groups: [
							_group('standard'),
			_group('none', padding: KlpPaddingHorizontal.none, divider: KlpPaddingDivider.dashed),
			_group('solid', divider: KlpPaddingDivider.solid),
						],
					),
				),
			),
			adapters: [...KlpAppLayoutAdapter.createAll(), ...KlpFrameGroupsAdapter.createAll(), adapter],
			primitives: primitives,
		);

		final root = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundAppLayout;
		final frame = (root.children.single as KlpBoundPlacement).content as KlpBoundAppLayout;
		final groups = (frame.children.single as KlpBoundPlacement).content as KlpBoundFrameGroups;
		final resolved = [for (final child in groups.children) (child as KlpBoundPlacement).content as KlpBoundFrameGroup];
		expect(resolved.map((group) => group.horizontalInset.value), [8, 0, 8]);
		expect(resolved.map((group) => group.divider), [0, 1, 2]);
		expect(resolved.every((group) => group.dividerColor == primitives.colors[5]), isTrue);
		expect(resolved.every((group) => group.dividerStroke == primitives.strokeWidths[1]), isTrue);
	});

	test('section and workspace gaps share eight pixels while compact and content insets remain unchanged', () {
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final block = KlpWorkspaceBlock(id: KlpId.parse('block'), kind: KlpWorkspaceBlockKind.paper, title: '內容');
		const style = KlpFrameGroupStyle(divider: KlpFrameGroupDivider.sectionGap, contentSpacing: KlpFrameGroupContentSpacing.standard);
		final group = KlpFrameGroup(id: KlpId.parse('section'), content: [block], style: style);
		final groups = KlpFrameGroups(id: KlpId.parse('groups'), groups: [group]);
		for (final primitives in [KlpWorkspacePreset.light(), KlpWorkspacePreset.dark()]) {
			// 跨 module 語意由同一 primitive set 解析，不另外複製距離表。
			runtime.update(root: KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), child: groups)), adapters: [...KlpAppLayoutAdapter.createAll(), ...KlpFrameGroupsAdapter.createAll(), ...KlpWorkspaceBlockAdapter.createAll()], primitives: primitives);
			final root = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundAppLayout;
			final frame = (root.children.single as KlpBoundPlacement).content as KlpBoundAppLayout;
			final resolvedGroups = (frame.children.single as KlpBoundPlacement).content as KlpBoundFrameGroups;
			final resolvedGroup = (resolvedGroups.children.single as KlpBoundPlacement).content as KlpBoundFrameGroup;
			final resolvedBlock = (resolvedGroup.children.single as KlpBoundPlacement).content as KlpBoundWorkspaceBlock;
			expect(root.inset, same(primitives.distances[2]));
			expect(resolvedGroup.horizontalInset, same(primitives.distances[2]));
			expect(resolvedGroup.groupGap.value, 8);
			expect(resolvedGroup.contentGap.value, 20);
			expect(resolvedBlock.gap, same(primitives.distances[2]));
			expect(resolvedBlock.compactGap.value, 4);
			expect(resolvedBlock.inset.value, 20);
			expect(resolvedBlock.headerExtent.value, 32);
		}
	});

	testWidgets('Frame group renderer distinguishes invisible, dashed, and solid dividers', (tester) async {
		final color = KlpColor(40, 40, 40);
		final content = KlpBoundFrameGroups([
			_boundGroup(inset: 20, divider: 0, color: color),
			_boundGroup(inset: 0, divider: 1, color: color),
			_boundGroup(inset: 20, divider: 2, color: color),
		]);
		await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: SizedBox(width: 200, child: KlpFlutterRenderer(content: content))));

		expect(find.byType(Padding), findsNWidgets(3));
		expect(find.byType(CustomPaint), findsOneWidget);
		expect(find.byWidgetPredicate((widget) => widget is ColoredBox && widget.color == const Color(0xff282828)), findsOneWidget);
	});
}

KlpPadding _group(String id, {KlpPaddingHorizontal padding = KlpPaddingHorizontal.standard, KlpPaddingDivider divider = KlpPaddingDivider.invisible}) => KlpPadding(
	id: KlpId.parse('$id.group'),
	style: KlpPaddingStyle(padding: padding, divider: divider),
	content: [KlpComponentTestItem(id: KlpId.parse('$id.content'))],
);

KlpBoundFrameGroup _boundGroup({required double inset, required int divider, required KlpColor color}) => KlpBoundFrameGroup(
	children: const [],
	horizontalInset: KlpDistance(inset),
	divider: divider,
	dividerColor: color,
	dividerStroke: KlpStrokeWidth(1),
	groupGap: KlpDistance(4),
	contentGap: KlpDistance(0),
);
