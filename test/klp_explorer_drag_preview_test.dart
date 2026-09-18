import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_selection_surface.dart';

import 'klp_explorer_test.dart' show ExplorerTestHarness, explorerData, explorerId, explorerNode;

const _feedbackKey = ValueKey<String>('explorer.drag-feedback');
const _indicatorKey = ValueKey<String>('explorer.drop-indicator');
const _collapsible = KlpExplorerCapabilities(collapsible: true);

Finder _row(String title) => find.ancestor(of: find.text(title), matching: find.byType(KlpFlutterSelectionSurface)).first;

KlpExplorerNodeModel _source() => KlpExplorerNodeModel(id: explorerId('Source'), row: KlpExplorerRowData(title: 'Source', icon: KlpExplorerGlyph.music), canHaveChildren: false, capabilities: const KlpExplorerCapabilities(draggable: true));

Future<TestGesture> _startDrag(WidgetTester tester) async {
	final gesture = await tester.startGesture(tester.getCenter(_row('Source')), kind: PointerDeviceKind.mouse);
	await gesture.moveBy(const Offset(24, 0));
	await tester.pump();
	return gesture;
}

Future<void> _move(WidgetTester tester, TestGesture gesture, Offset position) async {
	await gesture.moveTo(position);
	await tester.pump();
}

Rect _markerRect(WidgetTester tester) {
	expect(find.byKey(_indicatorKey), findsOneWidget);
	final marker = tester.getRect(find.byKey(_indicatorKey));
	expect(marker.width, greaterThan(0));
	expect(marker.height, greaterThan(0));
	final decoration = tester.widget<DecoratedBox>(find.byKey(_indicatorKey)).decoration as BoxDecoration;
	expect(decoration.borderRadius, BorderRadius.circular(marker.height / 2));
	return marker;
}

void main() {

	testWidgets('拖曳回饋保留圖示與標題，圓角條填滿列間隙並在離開拒絕與提交後清除', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		var allowed = true;
		final drops = <KlpExplorerDropRequest>[];
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([explorerNode('First'), _source(), explorerNode('Target'), explorerNode('Following')]), canDrop: (_) => allowed, onDrop: drops.add));

		// 以來源列實際顯示的圖示為依據，不在測試重建 glyph 映射。
		final sourceIcon = tester.widget<KlpFlutterLucideIcon>(find.descendant(of: _row('Source'), matching: find.byType(KlpFlutterLucideIcon)));
		final firstRect = tester.getRect(_row('First'));
		final sourceRect = tester.getRect(_row('Source'));
		final sourceIconLeft = tester.getRect(find.descendant(of: _row('Source'), matching: find.byType(KlpFlutterLucideIcon))).left;
		final targetRect = tester.getRect(_row('Target'));
		final followingRect = tester.getRect(_row('Following'));
		final gap = targetRect.top - sourceRect.bottom;
		expect(gap, greaterThan(0));
		expect(find.byKey(_feedbackKey), findsNothing);
		expect(find.byKey(_indicatorKey), findsNothing);
		final gesture = await _startDrag(tester);
		final feedback = find.byKey(_feedbackKey);
		expect(feedback, findsOneWidget);
		expect(find.descendant(of: feedback, matching: find.text('Source')), findsOneWidget);
		final feedbackIcon = tester.widget<KlpFlutterLucideIcon>(find.descendant(of: feedback, matching: find.byType(KlpFlutterLucideIcon)));
		expect(feedbackIcon.name, sourceIcon.name);

		// 同一手勢穿越 before 與 after，圓角條恰好填滿原列間隙。
		await _move(tester, gesture, targetRect.topCenter + const Offset(0, 2));
		final before = _markerRect(tester);
		expect(before.left, closeTo(sourceIconLeft, 0.5));
		expect(before.top, closeTo(sourceRect.bottom, 0.5));
		expect(before.bottom, closeTo(targetRect.top, 0.5));
		expect(before.height, closeTo(gap, 0.5));
		expect(tester.getRect(_row('Target')), targetRect);
		await _move(tester, gesture, targetRect.bottomCenter - const Offset(0, 2));
		final after = _markerRect(tester);
		expect(after.left, closeTo(sourceIconLeft, 0.5));
		expect(after.top, closeTo(targetRect.bottom, 0.5));
		expect(after.bottom, closeTo(followingRect.top, 0.5));
		expect(after.height, closeTo(followingRect.top - targetRect.bottom, 0.5));
		expect(after.top, greaterThan(before.top));
		expect(tester.getRect(_row('Target')), targetRect);
		expect(tester.getRect(_row('Following')), followingRect);

		// 首尾沒有外側列間隙，以相同厚度貼在列的內側邊界。
		await _move(tester, gesture, firstRect.topCenter + const Offset(0, 2));
		final firstMarker = _markerRect(tester);
		expect(firstMarker.top, closeTo(firstRect.top, 0.5));
		expect(firstMarker.bottom, closeTo(firstRect.top + gap, 0.5));
		await _move(tester, gesture, followingRect.bottomCenter - const Offset(0, 2));
		final lastMarker = _markerRect(tester);
		expect(lastMarker.top, closeTo(followingRect.bottom - gap, 0.5));
		expect(lastMarker.bottom, closeTo(followingRect.bottom, 0.5));
		expect(tester.getRect(_row('First')), firstRect);
		expect(tester.getRect(_row('Following')), followingRect);

		// 離開與拒絕都清除圓角條；再次允許後可恢復，放手才提交。
		await _move(tester, gesture, const Offset(790, 590));
		expect(find.byKey(_indicatorKey), findsNothing);
		expect(find.byKey(_feedbackKey), findsOneWidget);
		allowed = false;
		await _move(tester, gesture, targetRect.center);
		expect(find.byKey(_indicatorKey), findsNothing);
		expect(drops, isEmpty);
		allowed = true;
		await _move(tester, gesture, targetRect.center + const Offset(1, 0));
		final inside = _markerRect(tester);
		expect(inside.top, closeTo(targetRect.bottom, 0.5));
		expect(inside.bottom, closeTo(followingRect.top, 0.5));
		expect(drops, isEmpty);
		await gesture.up();
		await tester.pumpAndSettle();
		expect(drops, hasLength(1));
		expect(drops.single.position, KlpExplorerDropPlacement.inside);
		expect(find.byKey(_indicatorKey), findsNothing);
		expect(find.byKey(_feedbackKey), findsNothing);
		expect(find.text('Source'), findsOneWidget);
	});

	testWidgets('展開節點的 after 與 inside 圓角條填滿可見子樹後方間隙，inside 多一層縮排', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final branch = explorerNode('Branch', capabilities: _collapsible, children: [explorerNode('Grandchild')]);
		final target = explorerNode('Target', capabilities: _collapsible, children: [branch, explorerNode('Last')]);
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([_source(), target, explorerNode('Following')], expanded: {target.id, branch.id}), canDrop: (_) => true, onDrop: (_) {}));
		final sourceRect = tester.getRect(_row('Source'));
		final sourceIconLeft = tester.getRect(find.descendant(of: _row('Source'), matching: find.byType(KlpFlutterLucideIcon))).left;
		final targetRect = tester.getRect(_row('Target'));
		final lastRect = tester.getRect(_row('Last'));
		final followingRect = tester.getRect(_row('Following'));
		final targetTextRect = tester.getRect(find.text('Target'));
		final branchTextRect = tester.getRect(find.text('Branch'));
		final indent = branchTextRect.left - targetTextRect.left;
		expect(indent, greaterThan(0));
		expect(find.text('Grandchild'), findsOneWidget);
		final gesture = await _startDrag(tester);

		// after 越過所有可見後代，不留在目標標題列底部。
		await _move(tester, gesture, targetRect.bottomCenter - const Offset(0, 2));
		final after = _markerRect(tester);
		expect(after.left, closeTo(sourceIconLeft, 0.5));
		expect(after.top, closeTo(lastRect.bottom, 0.5));
		expect(after.bottom, closeTo(followingRect.top, 0.5));
		expect(after.height, closeTo(followingRect.top - lastRect.bottom, 0.5));
		expect(after.top, greaterThan(targetRect.bottom));

		// inside 使用相同子樹末端，水平位置增加一層既有節點縮排。
		await _move(tester, gesture, targetRect.center);
		final inside = _markerRect(tester);
		expect(inside.top, closeTo(lastRect.bottom, 0.5));
		expect(inside.bottom, closeTo(followingRect.top, 0.5));
		expect(inside.height, closeTo(followingRect.top - lastRect.bottom, 0.5));
		expect(inside.left - after.left, closeTo(indent, 0.5));
		expect(inside.left, closeTo(sourceIconLeft + indent, 0.5));
		expect(tester.getRect(_row('Last')), lastRect);
		expect(tester.getRect(_row('Following')), followingRect);

		// 回到 before 立即填滿目標上方間隙；取消手勢清除全部預覽。
		await _move(tester, gesture, targetRect.topCenter + const Offset(0, 2));
		final before = _markerRect(tester);
		expect(before.left, closeTo(sourceIconLeft, 0.5));
		expect(before.top, closeTo(sourceRect.bottom, 0.5));
		expect(before.bottom, closeTo(targetRect.top, 0.5));
		await gesture.cancel();
		await tester.pumpAndSettle();
		expect(find.byKey(_indicatorKey), findsNothing);
		expect(find.byKey(_feedbackKey), findsNothing);
	});
}
