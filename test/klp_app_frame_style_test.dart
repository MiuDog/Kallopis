import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/features/workspace/layout/adapters/klp_app_layout_adapter.dart';
import 'package:kallopis/src/features/workspace/layout/adapters/klp_frame_groups_adapter.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_app_layout.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';

import 'support/klp_component_test_definition.dart';
import 'support/klp_component_test_item.dart';

KlpBoundAppLayout _layout(int kind, List<KlpBoundTemplate> children) => KlpBoundAppLayout(
	kind: kind, inset: KlpDistance(12), background: KlpColor(50, 50, 50),
	radius: KlpRadius(12), flex: 1, laneExtent: null, bare: false, alignment: 0, gapless: false, children: children,
);

KlpBoundAppLayout _frame() => _layout(4, [KlpBoundLinear(KlpAxis.vertical, KlpDistance(0), const [])]);

void main() {
	test('frame roles resolve through the selected primitive set', () {
		final runtime = KlpTreeRuntime();
		final adapter = KlpComponentTestAdapter();
		addTearDown(runtime.dispose);
		for (final primitives in [KlpWorkspacePreset.dark(), KlpWorkspacePreset.light()]) {
			expect(primitives.distances.map((distance) => distance.value), [0, 4, 8, 12, 20, 32, 40, 48]);
			for (final role in KlpAppFrameRole.values) {
				// 經過實際編譯與語意解析，驗證角色沒有在 renderer 寫死色彩。
				runtime.update(
					root: KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), role: role, child: _groups())),
					adapters: [...KlpAppLayoutAdapter.createAll(), ...KlpFrameGroupsAdapter.createAll(), adapter],
					primitives: primitives,
				);
				final root = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundAppLayout;
				final frame = (root.children.single as KlpBoundPlacement).content as KlpBoundAppLayout;
				expect(root.inset.value, 8);
				expect(frame.radius.value, 12);
				expect(frame.reliefShadow, isNull);
				expect(frame.reliefHighlight, isNull);
				expect(frame.background, same(primitives.colors[role == KlpAppFrameRole.auxiliary || role == KlpAppFrameRole.sidebar ? 2 : 3]));
			}
		}
		final dark = KlpWorkspacePreset.dark();
		expect(dark.colors[0].red, 32);
		expect(dark.colors[2].red, 41);
		expect(dark.colors[3].red, 53);
	});

	for (final dark in [false, true]) {
		testWidgets('raised frame resolves ${dark ? "dark" : "light"} relief outside the clip without changing child bounds', (tester) async {
			final runtime = KlpTreeRuntime();
			addTearDown(runtime.dispose);
			final primitives = dark ? KlpWorkspacePreset.dark() : KlpWorkspacePreset.light();
			final frame = _resolveFrame(runtime, primitives, KlpAppFrameSurface.raised);
			expect(frame.reliefScale!.value, 4);
			expect(frame.reliefShadow!.alpha, dark ? 122 : 46);
			expect(frame.reliefHighlight!.alpha, dark ? 18 : 217);
			expect([frame.reliefHighlight!.red, frame.reliefHighlight!.green, frame.reliefHighlight!.blue], [255, 255, 255]);

			// 從解析後的呈現資料量測陰影方向與內容矩形，不以圖片評分。
			await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: KlpFlutterAppLayout(content: frame)));
			final frameFinder = find.byWidgetPredicate((widget) => widget is KlpFlutterAppLayout && identical(widget.content, frame));
			final childFinder = find.byWidgetPredicate((widget) => widget is KlpFlutterRenderer && identical(widget.content, frame.children.single));
			expect(tester.getRect(childFinder), tester.getRect(frameFinder));
			final reliefFinder = find.byWidgetPredicate((widget) => widget is DecoratedBox && widget.decoration is BoxDecoration && (widget.decoration as BoxDecoration).boxShadow?.isNotEmpty == true);
			expect(reliefFinder, findsOneWidget);
			final decoration = tester.widget<DecoratedBox>(reliefFinder).decoration as BoxDecoration;
			expect(decoration.borderRadius, BorderRadius.circular(12));
			final shadow = decoration.boxShadow!.singleWhere((shadow) => shadow.offset.dx > 0);
			final highlight = decoration.boxShadow!.singleWhere((shadow) => shadow.offset.dx < 0);
			expect(shadow.offset, const Offset(2, 3));
			expect(shadow.blurRadius, 5);
			expect(shadow.spreadRadius, -1);
			expect(shadow.color, _color(frame.reliefShadow!));
			expect(highlight.offset, const Offset(-1, -1));
			expect(highlight.blurRadius, 0);
			expect(highlight.color, _color(frame.reliefHighlight!));
			expect(find.descendant(of: reliefFinder, matching: find.byType(ClipRRect)), findsOneWidget);
			expect(find.ancestor(of: reliefFinder, matching: find.byType(ClipRRect)), findsNothing);
			expect(tester.takeException(), isNull);
		});
	}

	testWidgets('replacing a complete primitive set re-resolves raised relief and layout distances', (tester) async {
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final initial = _resolveFrame(runtime, KlpWorkspacePreset.light(), KlpAppFrameSurface.raised);
		expect(initial.reliefHighlight!.alpha, 217);
		final source = KlpWorkspacePreset.dark();
		final changed = KlpPrimitiveSet(
			colors: source.colors,
			distances: [KlpDistance(0), KlpDistance(6), KlpDistance(11), KlpDistance(17), ...source.distances.skip(4)],
			radii: source.radii,
			strokeWidths: source.strokeWidths,
			fontSizes: source.fontSizes,
			fontWeights: source.fontWeights,
			lineHeights: source.lineHeights,
			letterSpacings: source.letterSpacings,
			durations: source.durations,
			fontFamilies: source.fontFamilies,
			curves: source.curves,
		);
		final frame = _resolveFrame(runtime, changed, KlpAppFrameSurface.raised);
		expect(frame.inset, same(changed.distances[2]));
		expect(frame.reliefScale, same(changed.distances[1]));
		expect(frame.reliefHighlight!.alpha, 18);
		expect(frame.background, same(changed.colors[3]));

		// 完整 primitive 替換後，renderer 也必須按新的 compactGap 比例呈現。
		await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: KlpFlutterAppLayout(content: frame)));
		final relief = find.byWidgetPredicate((widget) => widget is DecoratedBox && widget.decoration is BoxDecoration && (widget.decoration as BoxDecoration).boxShadow?.isNotEmpty == true);
		final decoration = tester.widget<DecoratedBox>(relief).decoration as BoxDecoration;
		final shadow = decoration.boxShadow!.singleWhere((shadow) => shadow.offset.dx > 0);
		final highlight = decoration.boxShadow!.singleWhere((shadow) => shadow.offset.dx < 0);
		expect(shadow.offset, const Offset(3, 4.5));
		expect(shadow.blurRadius, 7.5);
		expect(shadow.spreadRadius, -1.5);
		expect(highlight.offset, const Offset(-1.5, -1.5));
		expect(tester.takeException(), isNull);
	});

	for (final role in [KlpAppFrameRole.toolbarControls, KlpAppFrameRole.rightSidebar]) {
		testWidgets('raised option preserves bare $role behavior', (tester) async {
			final runtime = KlpTreeRuntime();
			addTearDown(runtime.dispose);
			final frame = _resolveFrame(runtime, KlpWorkspacePreset.light(), KlpAppFrameSurface.raised, role: role);
			expect(frame.bare, isTrue);
			// bare 角色無表面裝飾，選 raised 也不產生可見陰影。
			await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: KlpFlutterAppLayout(content: frame)));
			expect(find.byWidgetPredicate((widget) => widget is DecoratedBox && widget.decoration is BoxDecoration && (widget.decoration as BoxDecoration).boxShadow?.isNotEmpty == true), findsNothing);
			expect(tester.takeException(), isNull);
		});
	}

	for (final axis in [Axis.horizontal, Axis.vertical]) {
		for (final arrangement in ['adjacent', 'middle', 'leading', 'trailing']) {
			testWidgets('$axis $arrangement preserves the supplied twelve pixel gutter', (tester) async {
				final first = _frame();
				final second = _frame();
				final handle = _layout(3, []);
				final items = switch (arrangement) {
					'middle' => [first, handle, second],
					'leading' => [handle, first, second],
					'trailing' => [first, second, handle],
					_ => [first, second],
				};
				final root = _layout(0, [_layout(axis == Axis.horizontal ? 1 : 2, items)]);
				// 在有界視窗中量測真實布局，首尾 handle 也不能產生額外間隔。
				await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: KlpFlutterAppLayout(content: root)));
				expect(tester.takeException(), isNull);
				final firstRect = tester.getRect(find.byWidgetPredicate((widget) => widget is KlpFlutterAppLayout && identical(widget.content, first)));
				final secondRect = tester.getRect(find.byWidgetPredicate((widget) => widget is KlpFlutterAppLayout && identical(widget.content, second)));
				expect(axis == Axis.horizontal ? secondRect.left - firstRect.right : secondRect.top - firstRect.bottom, 12);
				final start = axis == Axis.horizontal ? firstRect.left : firstRect.top;
				final end = axis == Axis.horizontal ? secondRect.right : secondRect.bottom;
				final viewport = axis == Axis.horizontal ? 800 : 600;
				expect(start, arrangement == 'leading' ? 24 : 12);
				expect(viewport - end, arrangement == 'trailing' ? 24 : 12);
				final childRect = tester.getRect(find.byWidgetPredicate((widget) => widget is KlpFlutterRenderer && identical(widget.content, first.children.single)));
				expect(childRect, firstRect);
				final decoration = tester.widget<DecoratedBox>(find.descendant(of: find.byWidgetPredicate((widget) => widget is KlpFlutterAppLayout && identical(widget.content, first)), matching: find.byType(DecoratedBox))).decoration as BoxDecoration;
				expect(decoration.borderRadius, BorderRadius.circular(12));
				expect(decoration.boxShadow, isNull);
			});
		}
	}
}

Color _color(KlpColor color) => Color.fromARGB(color.alpha, color.red, color.green, color.blue);

KlpBoundAppLayout _resolveFrame(KlpTreeRuntime runtime, KlpPrimitiveSet primitives, KlpAppFrameSurface surface, {KlpAppFrameRole role = KlpAppFrameRole.content}) {
	final frame = KlpAppFrame(id: KlpId.parse('frame'), child: _groups(), role: role, surface: surface);
	// 以正式 adapter 執行語意解析，測試不依賴私人配方實作。
	runtime.update(root: KlpAppLayout(id: KlpId.parse('layout'), child: frame), adapters: [...KlpAppLayoutAdapter.createAll(), ...KlpFrameGroupsAdapter.createAll(), KlpComponentTestAdapter()], primitives: primitives);
	final root = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundAppLayout;
	return (root.children.single as KlpBoundPlacement).content as KlpBoundAppLayout;
}

KlpFrameGroups _groups() => KlpFrameGroups(
	id: KlpId.parse('groups'),
	groups: [KlpFrameGroup(id: KlpId.parse('group'), content: [KlpComponentTestItem()])],
);
