import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 僅保護公開 Widget 的確定性幾何，不讀取私有布局或評估視覺品質。
void main() {
	testWidgets('巢狀 Row／Column 每層只扣自己的 gap 與一次 root inset', (tester) async {
		await _pump(tester, KlpAppLayout(child: LayoutRow(children: [
			LayoutColumn(children: [_pane('top'), _pane('bottom')]),
			_pane('right'),
		])));
		_expectRect(tester, 'top', const Rect.fromLTWH(8, 8, 188, 138));
		_expectRect(tester, 'bottom', const Rect.fromLTWH(8, 154, 188, 138));
		_expectRect(tester, 'right', const Rect.fromLTWH(204, 8, 188, 284));
		expect(tester.takeException(), isNull);
	});

	testWidgets('顯式與連續 divider 不重複加入相鄰普通 gutter', (tester) async {
		await _pump(tester, LayoutRow(children: [
			_pane('left'),
			const KlpLayoutDivider(key: ValueKey('divider-1')),
			const KlpLayoutDivider(key: ValueKey('divider-2')),
			_pane('right'),
		]));
		_expectRect(tester, 'left', const Rect.fromLTWH(0, 0, 192, 300));
		_expectRect(tester, 'right', const Rect.fromLTWH(208, 0, 192, 300));
		for (final id in ['divider-1', 'divider-2']) {
			expect(tester.getSize(find.byKey(ValueKey(id))).width, closeTo(8, 1e-6));
			expect(find.descendant(of: find.byKey(ValueKey(id)), matching: find.byType(GestureDetector)), findsNothing);
		}
		final before = tester.getRect(find.byKey(const ValueKey('left')));
		await tester.drag(find.byKey(const ValueKey('divider-1')), const Offset(40, 0), warnIfMissed: false);
		await tester.pump();
		expect(tester.getRect(find.byKey(const ValueKey('left'))), before);
		expect(tester.takeException(), isNull);
	});

	testWidgets('none 關閉普通 gap 但顯式 divider 仍占 semantic gutter', (tester) async {
		await _pump(tester, LayoutRow(spacing: KlpLayoutSpacing.none, children: [
			_pane('a'), _pane('b'), const KlpLayoutDivider(), _pane('c'),
		]));
		final a = _rect(tester, 'a');
		final b = _rect(tester, 'b');
		final c = _rect(tester, 'c');
		expect(b.left, closeTo(a.right, 1e-6));
		expect(c.left - b.right, closeTo(8, 1e-6));
		expect(a.width, closeTo(392 / 3, 1e-6));
	});

	testWidgets('minimum／preferred／maximum 及 flex 投影到真實內容槽', (tester) async {
		await _pump(tester, LayoutRow(spacing: KlpLayoutSpacing.none, children: [
			_pane('capped', bounds: const KlpLayoutBounds(minimum: 20, maximum: 60, preferred: 40)),
			_pane('weighted', flex: 2, bounds: const KlpLayoutBounds(minimum: 30, preferred: 50)),
			_pane('fixed', flex: 0, bounds: const KlpLayoutBounds(preferred: 40)),
		]), width: 200);
		_expectRect(tester, 'capped', const Rect.fromLTWH(0, 0, 60, 300));
		_expectRect(tester, 'weighted', const Rect.fromLTWH(60, 0, 100, 300));
		_expectRect(tester, 'fixed', const Rect.fromLTWH(160, 0, 40, 300));
	});

	testWidgets('巢狀容器、Spacer 與 Frame 公開 bounds 可直接組裝', (tester) async {
		await _pump(tester, LayoutRow(bounds: const KlpLayoutBounds(), children: [
			LayoutSpacer(key: const ValueKey('spacer'), bounds: const KlpLayoutBounds(maximum: 80, preferred: 80)),
			LayoutColumn(bounds: const KlpLayoutBounds(maximum: 120, preferred: 120), children: [_pane('column-content')]),
			KlpAppFrame(key: const ValueKey('frame'), bounds: const KlpLayoutBounds(minimum: 40), child: const SizedBox()),
		]), width: 300);
		expect(_rect(tester, 'spacer').width, closeTo(80, 1e-6));
		_expectRect(tester, 'column-content', const Rect.fromLTWH(88, 0, 120, 300));
		_expectRect(tester, 'frame', const Rect.fromLTWH(216, 0, 84, 300));
		expect(tester.takeException(), isNull);
	});

	testWidgets('超出內容槽的原生內容無法在槽外接受點擊', (tester) async {
		var taps = 0;
		await _pump(tester, LayoutRow(spacing: KlpLayoutSpacing.none, children: [
			_pane('small', flex: 0, bounds: const KlpLayoutBounds(preferred: 20), child: OverflowBox(
				alignment: Alignment.topLeft,
				minWidth: 200,
				maxWidth: 200,
				child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => taps++, child: const SizedBox.expand()),
			)),
			_pane('neighbor'),
		]));
		await tester.tapAt(const Offset(10, 100));
		expect(taps, 1);
		await tester.tapAt(const Offset(80, 100));
		expect(taps, 1, reason: '內容不能穿越尺寸槽的裁切邊界攔截相鄰 pane 點擊');
		expect(tester.takeException(), isNull);
	});

	testWidgets('preferred 超量只比例縮小 minimum 以上部分', (tester) async {
		await _pump(tester, LayoutRow(spacing: KlpLayoutSpacing.none, children: [
			_pane('a', flex: 0, bounds: const KlpLayoutBounds(minimum: 10, preferred: 90)),
			_pane('b', flex: 0, bounds: const KlpLayoutBounds(minimum: 20, preferred: 60)),
		]), width: 100);
		expect(_rect(tester, 'a').width, closeTo(170 / 3, 1e-6));
		expect(_rect(tester, 'b').width, closeTo(130 / 3, 1e-6));
		expect(_rect(tester, 'b').right, closeTo(100, 1e-6));
	});

	testWidgets('minimum 不足比例退化，內容 geometry 仍有限', (tester) async {
		await _pump(tester, LayoutRow(spacing: KlpLayoutSpacing.none, children: [
			_pane('a', bounds: const KlpLayoutBounds(minimum: 80)),
			_pane('b', bounds: const KlpLayoutBounds(minimum: 40)),
		]), width: 60);
		_expectRect(tester, 'a', const Rect.fromLTWH(0, 0, 40, 300));
		_expectRect(tester, 'b', const Rect.fromLTWH(40, 0, 20, 300));
		expect(tester.takeException(), isNull);
	});

	for (final alignment in KlpLayoutMainAlignment.values) {
		testWidgets('Column ${alignment.name} 依 maximum 留白而不強迫填滿', (tester) async {
			await _pump(tester, LayoutColumn(alignment: alignment, children: [
				_pane('a', bounds: const KlpLayoutBounds(maximum: 30)),
				_pane('b', bounds: const KlpLayoutBounds(maximum: 40)),
			]), height: 200);
			final start = alignment == KlpLayoutMainAlignment.start ? 0.0 : 122.0;
			_expectRect(tester, 'a', Rect.fromLTWH(0, start, 400, 30));
			_expectRect(tester, 'b', Rect.fromLTWH(0, start + 38, 400, 40));
		});
	}

	testWidgets('沒有 preferred 的正 flex 保持 Expanded，零 flex 量測自然值', (tester) async {
		await _pump(tester, LayoutRow(children: [
			_pane('natural', flex: 0, child: const SizedBox(width: 40, height: 20)),
			_pane('a', child: const SizedBox(width: 300, height: 20)),
			_pane('b', flex: 3, child: const SizedBox(width: 1, height: 20)),
		]), width: 200);
		expect(_rect(tester, 'natural').width, closeTo(40, 1e-6));
		expect(_rect(tester, 'a').width, closeTo(36, 1e-6));
		expect(_rect(tester, 'b').width, closeTo(108, 1e-6));
		expect(tester.takeException(), isNull);
	});

	testWidgets('既有 flex-only subclass 與 ResizeHandle callback 保持來源相容', (tester) async {
		final positions = <Offset>[];
		const legacy = _LegacyLayoutNode(key: ValueKey('legacy'));
		expect(legacy.bounds.minimum, 0);
		expect(legacy.bounds.maximum, isNull);
		expect(legacy.bounds.preferred, isNull);
		await _pump(tester, LayoutRow(children: [
			legacy,
			LayoutResizeHandle(key: const ValueKey('old-handle'), onResize: positions.add),
			_pane('right'),
		]));
		_expectRect(tester, 'legacy', const Rect.fromLTWH(0, 0, 196, 300));
		_expectRect(tester, 'right', const Rect.fromLTWH(204, 0, 196, 300));
		final target = tester.getCenter(find.byKey(const ValueKey('old-handle'))) + const Offset(40, 0);
		await tester.drag(find.byKey(const ValueKey('old-handle')), const Offset(40, 0), warnIfMissed: false);
		await tester.pump();
		expect(positions, isNotEmpty, reason: '既有非空 onResize 必須繼續回報水平拖曳');
		expect(positions.last.dx, closeTo(target.dx, 1e-6), reason: '回報全域游標位置，不能改成位移量');
		expect(positions.last.dy, closeTo(target.dy, 1e-6));
		_expectRect(tester, 'legacy', const Rect.fromLTWH(0, 0, 196, 300));
		_expectRect(tester, 'right', const Rect.fromLTWH(204, 0, 196, 300));
		expect(tester.takeException(), isNull);
	});

	testWidgets('既有 trailing pane 的零 flex 自然寬度保持 semantic role', (tester) async {
		final expected = KlpStylePack.defaults().resolve(KlpThemeVariant.light)['theme.geometry.layout.secondaryPaneWidth'] as num;
		await _pump(tester, LayoutRow(children: [
			KlpLayoutPane(key: const ValueKey('trailing'), child: const SizedBox(width: 10, height: 20)),
			_pane('rest'),
		]), width: 700);
		expect(_rect(tester, 'trailing').width, closeTo(expected.toDouble(), 1e-6));
		expect(_rect(tester, 'rest').width, closeTo(700 - 8 - expected, 1e-6));
		expect(tester.takeException(), isNull);
	});

	testWidgets('無上限 Row 主軸以自然尺寸及 preferred 回退，不填滿 Infinity', (tester) async {
		await _pump(tester, UnconstrainedBox(constrainedAxis: Axis.vertical, child: LayoutRow(
			key: const ValueKey('natural-row'),
			children: [
				_pane('a', child: const SizedBox(width: 40, height: 20)),
				_pane('b', flex: 3, bounds: const KlpLayoutBounds(preferred: 70), child: const SizedBox(width: 10, height: 30)),
			],
		)));
		expect(tester.getSize(find.byKey(const ValueKey('natural-row'))), const Size(118, 300));
		expect(_rect(tester, 'a').width, closeTo(40, 1e-6));
		expect(_rect(tester, 'b').width, closeTo(70, 1e-6));
		expect(tester.takeException(), isNull);
	});

	testWidgets('無上限 Column 主軸回退有限自然尺寸', (tester) async {
		await _pump(tester, UnconstrainedBox(constrainedAxis: Axis.horizontal, child: LayoutColumn(
			key: const ValueKey('natural-column'),
			children: [
				_pane('a', child: const SizedBox(width: 40, height: 20)),
				_pane('b', child: const SizedBox(width: 10, height: 30)),
			],
		)));
		expect(tester.getSize(find.byKey(const ValueKey('natural-column'))), const Size(400, 58));
		expect(tester.takeException(), isNull);
	});

	testWidgets('兩軸無上限取自然主軸總和及自然交叉軸最大值', (tester) async {
		await _pump(tester, UnconstrainedBox(child: LayoutRow(
			key: const ValueKey('natural-both'),
			children: [
				_pane('a', child: const SizedBox(width: 40, height: 20)),
				_pane('b', child: const SizedBox(width: 70, height: 30)),
			],
		)));
		expect(tester.getSize(find.byKey(const ValueKey('natural-both'))), const Size(118, 30));
		expect(tester.takeException(), isNull);
	});

	testWidgets('巨大 semantic space2 在 root inset 與 gutter 壓縮到有限可用尺寸', (tester) async {
		final pack = _spacingPack('p(radiusFull)');
		await _pump(tester, KlpAppLayout(child: LayoutRow(children: [_pane('a'), _pane('b')])), pack: pack);
		_expectRect(tester, 'a', const Rect.fromLTWH(200, 150, 0, 0));
		_expectRect(tester, 'b', const Rect.fromLTWH(200, 150, 0, 0));
		expect(tester.takeException(), isNull);
		await _pump(tester, LayoutRow(children: [_pane('a'), const KlpLayoutDivider(), _pane('b')]), pack: pack);
		_expectRect(tester, 'a', const Rect.fromLTWH(0, 0, 0, 300));
		_expectRect(tester, 'b', const Rect.fromLTWH(400, 0, 0, 300));
		expect(tester.takeException(), isNull);
	});

	testWidgets('保留同一 child 與 caller list 時 viewport 與 scope spacing 更新仍重新布局', (tester) async {
		final children = <KlpLayoutNode>[_pane('a'), _pane('b')];
		final original = List<KlpLayoutNode>.of(children);
		final layout = KlpAppLayout(child: LayoutRow(children: children));
		await _pump(tester, layout);
		expect(_rect(tester, 'a').width, closeTo(188, 1e-6));
		await _pump(tester, layout, width: 500);
		expect(_rect(tester, 'a').width, closeTo(238, 1e-6));
		await _pump(tester, layout, width: 500, pack: _spacingPack('p(space0)'));
		_expectRect(tester, 'a', const Rect.fromLTWH(0, 0, 250, 300));
		_expectRect(tester, 'b', const Rect.fromLTWH(250, 0, 250, 300));
		expect(children, orderedEquals(original), reason: '布局不得改寫 consumer 的 child list');
		expect(tester.takeException(), isNull);
	});
}

// 既有 consumer 只實作 flex 與 build，不須為新 bounds 改寫 subclass。
class _LegacyLayoutNode extends KlpLayoutNode {
	const _LegacyLayoutNode({super.key});

	@override
	int get flex => 1;

	@override
	Widget build(BuildContext context) => const SizedBox(width: 90, height: 30);
}

KlpLayoutPane _pane(String id, {int flex = 1, KlpLayoutBounds bounds = const KlpLayoutBounds(), Widget child = const SizedBox()}) => KlpLayoutPane(
	key: ValueKey(id),
	size: KlpLayoutPaneSize.expand,
	flex: flex,
	bounds: bounds,
	child: child,
);

// 只覆寫 space2 的 semantic 解析，保留所有其他 primitive 與尺寸限制。
KlpStylePack _spacingPack(String expression) => KlpStylePack.defaults().applyOverrides({
	'semantics': {'theme.spacing.space2': {'light': expression}},
});

Future<void> _pump(WidgetTester tester, Widget child, {double width = 400, double height = 300, KlpStylePack? pack}) async {
	await tester.pumpWidget(MaterialApp(
		theme: buildKlpThemeVariant(KlpThemeVariant.light, stylePack: pack),
		localizationsDelegates: const [KlpLocalizationsDelegate()],
		home: Scaffold(body: Align(alignment: Alignment.topLeft, child: SizedBox(width: width, height: height, child: child))),
	));
	await tester.pumpAndSettle();
}

Rect _rect(WidgetTester tester, String id) => tester.getRect(find.byKey(ValueKey(id)));

void _expectRect(WidgetTester tester, String id, Rect expected) {
	final actual = _rect(tester, id);
	for (final pair in [(actual.left, expected.left), (actual.top, expected.top), (actual.width, expected.width), (actual.height, expected.height)]) {
		expect(pair.$1.isFinite, isTrue, reason: '$id 的 geometry 必須有限');
		expect(pair.$1, closeTo(pair.$2, 1e-6), reason: '$id 的位置或內容槽尺寸不符合公開契約');
	}
}
