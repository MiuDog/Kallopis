import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'package:kallopis/kallopis_theme.dart';

// 正文 probes 是 caller 擁有的空槽；不驗證私有樹、產品排版或感官品質。
void main() {
	testWidgets('正常 root 頂列跨中央及右區、左區全高、Bottom 只占中央', (tester) async {
		final layout = _layout(left: _area(['l1', 'l2'], 100), right: _area(['r'], 120),
			bottom: _area(['b1', 'b2'], 80, axis: Axis.horizontal));
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, _dock(layout, changes, header: 40), width: 600, height: 400);
		final g = _gutter();
		final center = 600 - 100 - 120 - g * 2;
		_expect(tester, 'l1', const Rect.fromLTWH(0, 0, 100, 100));
		_expect(tester, 'l2', Rect.fromLTWH(0, 100 + g, 100, 300 - g));
		_expect(tester, 'top', Rect.fromLTWH(100 + g, 0, 500 - g, 40));
		_expect(tester, 'r', const Rect.fromLTWH(480, 40, 120, 360));
		_expect(tester, 'stage', Rect.fromLTWH(100 + g, 40, center, 280 - g));
		_expect(tester, 'b1', Rect.fromLTWH(100 + g, 320, 120, 80));
		_expect(tester, 'b2', Rect.fromLTWH(220 + g * 2, 320, center - 120 - g, 80));
		expect(changes, isEmpty, reason: 'render 不得提交保存布局');
		expect(tester.takeException(), isNull);
	});

	testWidgets('左右 minimum 不足時同比例退化且不回寫偏好', (tester) async {
		final layout = _layout(left: _area(['l'], 180), right: _area(['r'], 240));
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, _dock(layout, changes, leftMin: 100, rightMin: 200), width: 160);
		final unit = (160 - _gutter() * 2) / 300;
		_expect(tester, 'l', Rect.fromLTWH(0, 0, 100 * unit, 400));
		_expect(tester, 'stage', Rect.fromLTWH(100 * unit + _gutter(), 0, 0, 400));
		_expect(tester, 'r', Rect.fromLTWH(100 * unit + _gutter() * 2, 0, 200 * unit, 400));
		expect(changes, isEmpty);
		expect(layout.left.extent, 180);
		expect(layout.right.extent, 240);
		expect(tester.takeException(), isNull);
	});

	testWidgets('Bottom 不足時退化、頂列 clamp 並保留零 Stage', (tester) async {
		final layout = _layout(bottom: _area(['b'], 200));
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, _dock(layout, changes, header: 20, bottomMin: 100), height: 60);
		_expect(tester, 'top', const Rect.fromLTWH(0, 0, 600, 20));
		_expect(tester, 'stage', const Rect.fromLTWH(0, 20, 600, 0));
		_expect(tester, 'b', Rect.fromLTWH(0, 20 + _gutter(), 600, 40 - _gutter()));
		await _pump(tester, _dock(layout, changes, header: 200, bottomMin: 100), height: 60);
		_expect(tester, 'top', const Rect.fromLTWH(0, 0, 600, 60));
		_expect(tester, 'stage', const Rect.fromLTWH(0, 60, 600, 0));
		_expect(tester, 'b', const Rect.fromLTWH(0, 60, 600, 0));
		expect(changes, isEmpty);
		expect(layout.bottom.extent, 200);
		expect(tester.takeException(), isNull);
	});

	testWidgets('groups preferred 及 minimum 不足沿兩軸比例分配', (tester) async {
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, _dock(_layout(left: _area(['a', 'b', 'c'], 200,
			extents: [100, 200, 999])), changes), height: 180);
		// 最後組 preferred 是 logical minimum，並非保存的 999。
		// 既有 resolver 先保留 minima，再比例縮小 preferred 超過 minima 的部分。
		final scale = (180 - _gutter() * 2 - 32 * 3) / (100 - 32 + 200 - 32);
		final first = 32 + (100 - 32) * scale;
		final second = 32 + (200 - 32) * scale;
		_expect(tester, 'a', Rect.fromLTWH(0, 0, 200, first));
		_expect(tester, 'b', Rect.fromLTWH(0, first + _gutter(), 200, second));
		_expect(tester, 'c', Rect.fromLTWH(0, first + second + _gutter() * 2, 200, 32));
		await _pump(tester, _dock(_layout(left: _area(['a', 'b'], 200)), changes), height: 40);
		final vertical = (40 - _gutter()) / 2;
		_expect(tester, 'a', Rect.fromLTWH(0, 0, 200, vertical));
		_expect(tester, 'b', Rect.fromLTWH(0, vertical + _gutter(), 200, vertical));
		await _pump(tester, _dock(_layout(bottom: _area(['a', 'b'], 80, axis: Axis.horizontal)), changes), width: 100);
		final horizontal = (100 - _gutter()) / 2;
		_expect(tester, 'a', Rect.fromLTWH(0, 320, horizontal, 80));
		_expect(tester, 'b', Rect.fromLTWH(horizontal + _gutter(), 320, horizontal, 80));
		expect(changes, isEmpty);
		expect(tester.takeException(), isNull);
	});

	testWidgets('巨大及零 semantic handle、零 viewport 的實際槽守恆且非負', (tester) async {
		final layout = _layout(left: _area(['l1', 'l2'], 100), right: _area(['r'], 100),
			bottom: _area(['b1', 'b2'], 80, axis: Axis.horizontal));
		final changes = <KlpDockLayoutData>[];
		for (final expression in ['p(radiusFull)', 'p(space0)']) {
			for (final size in [const Size(200, 120), Size.zero, const Size(0, 120), const Size(200, 0)]) {
				await _pump(tester, _dock(layout, changes), width: size.width, height: size.height,
					pack: _pack({'geometry.layout.resizeHandleExtent': expression}));
				for (final id in ['stage', 'l1', 'l2', 'r', 'b1', 'b2']) {
					_inside(_rect(tester, id), size);
				}
				if (expression == 'p(radiusFull)') {
					_expect(tester, 'stage', Rect.fromLTWH(size.width / 2, 0, 0, 0));
					_expect(tester, 'l1', const Rect.fromLTWH(0, 0, 0, 0));
					_expect(tester, 'l2', Rect.fromLTWH(0, size.height, 0, 0));
				} else if (size == const Size(200, 120)) {
					_expect(tester, 'l1', const Rect.fromLTWH(0, 0, 100, 88));
					_expect(tester, 'l2', const Rect.fromLTWH(0, 88, 100, 32));
					_expect(tester, 'stage', const Rect.fromLTWH(100, 0, 0, 40));
				}
				expect(tester.takeException(), isNull, reason: '$expression / $size 不得產生庫內 layout exception');
			}
		}
		expect(changes, isEmpty);
	});

	testWidgets('hidden 及 empty 不占配額，reopen handle 在零尺寸亦不越界', (tester) async {
		final changes = <KlpDockLayoutData>[];
		final layout = _layout(left: _area(['l'], 180).copyWith(isVisible: false),
			right: _area([], 240), bottom: _area(['b'], 200).copyWith(isVisible: false));
		for (final size in [const Size(200, 120), Size.zero, const Size(0, 120), const Size(200, 0)]) {
			await _pump(tester, _dock(layout, changes, header: 20), width: size.width, height: size.height,
				pack: _pack({'geometry.layout.resizeHandleExtent': 'p(radiusFull)'}));
			final header = size.height < 20 ? size.height : 20.0;
			_expect(tester, 'top', Rect.fromLTWH(0, 0, size.width, header));
			_expect(tester, 'stage', Rect.fromLTWH(0, header, size.width, size.height - header));
			expect(find.byKey(const ValueKey('l')), findsNothing);
			expect(find.byKey(const ValueKey('b')), findsNothing);
			expect(tester.takeException(), isNull);
		}
		expect(changes, isEmpty);
	});

	testWidgets('inverted 及巨大 indicator spacing 在有效把手內 hover 無 exception', (tester) async {
		for (final expressions in [
			{'spacing.loose': 'p(space0)', 'spacing.tight': 'p(radiusFull)'},
			{'spacing.loose': 'p(radiusFull)', 'spacing.tight': 'p(space0)'},
		]) {
			final changes = <KlpDockLayoutData>[];
			await _pump(tester, _dock(_layout(left: _area(['a', 'b'], 100)), changes),
				pack: _pack(expressions));
			final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
			await mouse.addPointer(location: Offset(100 + _gutter() / 2, 200));
			await mouse.moveTo(Offset(50, 100 + _gutter() / 2));
			await tester.pumpAndSettle();
			expect(tester.takeException(), isNull);
			expect(changes, isEmpty);
			await mouse.removePointer();
		}
	});

	testWidgets('DockHeader 零及巨大 icon slot 不除零且 more menu 保留全部 callbacks', (tester) async {
		var enabledCalls = 0;
		var disabledCalls = 0;
		final header = KlpDockHeader(leading: const Text('面板'), actions: [
			KlpDockHeaderAction(icon: KlpIcons.check, label: '可用動作', onPressed: () => enabledCalls++),
			KlpDockHeaderAction(icon: KlpIcons.check, label: '停用動作', enabled: false, onPressed: () => disabledCalls++),
		]);
		for (final expression in ['p(space0)', 'p(radiusFull)']) {
			await _pump(tester, header, width: 200, height: 32,
				pack: _pack({'spacing.chromeTab': 'p(space800)', 'spacing.iconButton': expression}));
			expect(tester.takeException(), isNull, reason: '合法 iconButton 不得導致 Infinity floor 或 overflow');
			final more = find.byWidgetPredicate((widget) => widget is KlpIcon && widget.icon == KlpIcons.more);
			expect(more, findsOneWidget);
			await tester.tap(more, warnIfMissed: false);
			await tester.pumpAndSettle();
			expect(find.text('可用動作'), findsOneWidget);
			expect(find.text('停用動作'), findsOneWidget);
			await tester.tap(find.text('停用動作'));
			await tester.pumpAndSettle();
			expect(disabledCalls, 0);
			await tester.tap(find.text('可用動作'));
			await tester.pumpAndSettle();
			expect(enabledCalls, expression == 'p(space0)' ? 1 : 2);
			expect(tester.takeException(), isNull);
		}
		expect(KlpDockHeader.extent, 32);
	});

	testWidgets('area pointer resize 扣除另一 side 與 effective handle 並限制 finite 上限', (tester) async {
		final changes = <KlpDockLayoutData>[];
		final layout = _layout(left: _area(['l'], 100), right: _area(['r'], 100));
		final pack = _pack({'geometry.layout.resizeHandleExtent': 'p(space100)'});
		final g = _gutter(pack);
		await _pump(tester, _dock(layout, changes), width: 400, pack: pack);
		await _drag(tester, Offset(100 + g / 2, 200), const Offset(500, 0));
		expect(changes, isNotEmpty);
		expect(changes.last.left.extent, closeTo(400 - 100 - g * 2, 1e-6));
		expect(changes.last.right.extent, 100);
		expect(layout.left.extent, 100, reason: 'callback 不得修改 caller');
		expect(tester.takeException(), isNull);
	});

	testWidgets('area 可用上限低於 minimum 時 pointer 不回寫，巨大 effective gutter 同樣 no-op', (tester) async {
		final changes = <KlpDockLayoutData>[];
		final layout = _layout(left: _area(['l'], 100), right: _area(['r'], 100));
		await _pump(tester, _dock(layout, changes), width: 80);
		final left = _rect(tester, 'l');
		await _drag(tester, Offset(left.right + _gutter() / 2, 200), const Offset(30, 0));
		expect(changes, isEmpty, reason: '上限低於 minimum 不提交 extent');
		await _pump(tester, _dock(layout, changes), width: 80,
			pack: _pack({'geometry.layout.resizeHandleExtent': 'p(radiusFull)'}));
		await _drag(tester, const Offset(20, 200), const Offset(100, 0));
		expect(changes, isEmpty, reason: 'effective handle 吃滿 root 時不得保存非法小尺寸');
		await _pump(tester, _dock(_layout(bottom: _area(['b'], 100)), changes, bottomMin: 100), height: 80);
		await _drag(tester, Offset(200, _gutter() / 2), const Offset(0, -30));
		expect(changes, isEmpty);
		expect(tester.takeException(), isNull);
	});

	testWidgets('group pointer resize 使用 actual pair 配額，只改相鄰兩組並守恆', (tester) async {
		final changes = <KlpDockLayoutData>[];
		final layout = _layout(left: _area(['a', 'b', 'c'], 200, extents: [100, 100, 77]));
		final pack = _pack({'geometry.layout.resizeHandleExtent': 'p(space100)'});
		final g = _gutter(pack);
		await _pump(tester, _dock(layout, changes), pack: pack);
		await _drag(tester, Offset(100, 100 + g / 2), const Offset(0, 30));
		expect(changes, isNotEmpty);
		final groups = changes.last.left.groups;
		expect(groups[0].mainAxisExtent, closeTo(130, 1e-6));
		expect(groups[1].mainAxisExtent, closeTo(70, 1e-6));
		expect(groups[2].mainAxisExtent, 77);
		expect(layout.left.groups.map((group) => group.mainAxisExtent), [100, 100, 77]);
		expect(tester.takeException(), isNull);
	});

	testWidgets('group pair 不足兩個 minima 時 resize 維持 no-op 包含 effective巨大gutter', (tester) async {
		final changes = <KlpDockLayoutData>[];
		final layout = _layout(left: _area(['a', 'b'], 200));
		await _pump(tester, _dock(layout, changes), height: 40);
		await _drag(tester, const Offset(100, 20), const Offset(0, 10));
		expect(changes, isEmpty);
		await _pump(tester, _dock(layout, changes), height: 40,
			pack: _pack({'geometry.layout.resizeHandleExtent': 'p(radiusFull)'}));
		await _drag(tester, const Offset(100, 20), const Offset(0, 10));
		expect(changes, isEmpty);
		expect(tester.takeException(), isNull);
	});

	testWidgets('render theme viewport resize 不改 caller 並保留正文 Element State', (tester) async {
		final key = GlobalKey<_ContentState>();
		final panelKey = GlobalKey<_ContentState>();
		final content = _Content(key: key);
		final panelContent = _Content(key: panelKey);
		final layout = _layout(left: _area(['l'], 100));
		final before = KlpDockLayoutCodec.encode(layout);
		final changes = <KlpDockLayoutData>[];
		final dock = _dock(layout, changes, stageContent: content, panelContents: {'l': panelContent});
		await _pump(tester, dock);
		final state = key.currentState!;
		final element = key.currentContext;
		final panelState = panelKey.currentState!;
		final panelElement = panelKey.currentContext;
		state.increment();
		panelState.increment();
		await tester.pump();
		for (final size in [const Size(120, 30), Size.zero, const Size(600, 400)]) {
			await _pump(tester, dock, width: size.width, height: size.height);
			expect(key.currentState, same(state));
			expect(key.currentContext, same(element));
			expect(state.value, 1);
			expect(panelKey.currentState, same(panelState));
			expect(panelKey.currentContext, same(panelElement));
			expect(panelState.value, 1);
			expect(tester.takeException(), isNull);
		}
		await _pump(tester, dock, pack: _pack({'geometry.layout.resizeHandleExtent': 'p(radiusFull)'}));
		expect(key.currentState, same(state));
		expect(key.currentContext, same(element));
		expect(state.value, 1);
		expect(panelKey.currentState, same(panelState));
		expect(panelKey.currentContext, same(panelElement));
		expect(changes, isEmpty);
		await _pump(tester, dock);
		await _drag(tester, Offset(100 + _gutter() / 2, 200), const Offset(30, 0));
		expect(changes, isNotEmpty);
		await _pump(tester, _dock(changes.last, changes, stageContent: content, panelContents: {'l': panelContent}));
		expect(key.currentState, same(state));
		expect(key.currentContext, same(element));
		expect(panelKey.currentState, same(panelState));
		expect(panelKey.currentContext, same(panelElement));
		expect(panelState.value, 1);
		expect(KlpDockLayoutCodec.encode(layout), before);
		expect(tester.takeException(), isNull);
	});
}

KlpDockAreaData _area(List<String> ids, double extent, {Axis axis = Axis.vertical, List<double>? extents}) => KlpDockAreaData(
	axis: axis,
	extent: extent,
	groups: [for (var i = 0; i < ids.length; i++) KlpDockGroupData(
		id: 'group-${ids[i]}', panelIds: [ids[i]], activePanelId: ids[i], mainAxisExtent: extents?[i] ?? 100,
	)],
);

KlpDockLayoutData _layout({KlpDockAreaData? left, KlpDockAreaData? right, KlpDockAreaData? bottom}) => KlpDockLayoutData(
	left: left ?? _area([], 100), right: right ?? _area([], 100), bottom: bottom ?? _area([], 80),
);

Widget _dock(KlpDockLayoutData layout, List<KlpDockLayoutData> changes, {double? header,
	double leftMin = 80, double rightMin = 80, double bottomMin = 40, Widget? stageContent,
	Map<String, Widget> panelContents = const {}}) => KlpDockLayout(
	stage: KlpPanelFrame(content: stageContent ?? _slot('stage')),
	contentHeader: header == null ? null : PreferredSize(preferredSize: Size.fromHeight(header), child: _slot('top')),
	panels: [for (final area in [layout.left, layout.right, layout.bottom])
		for (final group in area.groups) for (final id in group.panelIds)
			KlpDockPanel(id: id, content: panelContents[id] ?? _slot(id))],
	layout: layout,
	onLayoutChanged: changes.add,
	leftConstraints: KlpDockAreaConstraints(minExtent: leftMin, maxExtent: double.infinity),
	rightConstraints: KlpDockAreaConstraints(minExtent: rightMin, maxExtent: 500),
	bottomConstraints: KlpDockAreaConstraints(minExtent: bottomMin, maxExtent: 500),
);

Widget _slot(String id) => SizedBox.expand(key: ValueKey(id));

// 排除 Panel 自己的 chrome 及外距，讓 probes 直接觀察 Dock 配額。
KlpStylePack _pack([Map<String, String> expressions = const {}]) => KlpStylePack.defaults().applyOverrides({
	'semantics': {for (final entry in {
		'spacing.dockMargin': 'p(space0)', 'spacing.chromeHeader': 'p(space0)', 'spacing.chromeTab': 'p(space0)',
		...expressions,
	}.entries) 'theme.${entry.key}': {'light': entry.value}},
});

double _gutter([KlpStylePack? pack]) => ((pack ?? _pack()).resolve(KlpThemeVariant.light)['theme.geometry.layout.resizeHandleExtent'] as num).toDouble();

Future<void> _pump(WidgetTester tester, Widget child, {double width = 600, double height = 400, KlpStylePack? pack}) async {
	await tester.pumpWidget(MaterialApp(
		theme: buildKlpThemeVariant(KlpThemeVariant.light, stylePack: pack ?? _pack()),
		localizationsDelegates: const [KlpLocalizationsDelegate()],
		home: Scaffold(body: Align(alignment: Alignment.topLeft, child: SizedBox(width: width, height: height, child: child))),
	));
	await tester.pumpAndSettle();
}

Future<void> _drag(WidgetTester tester, Offset start, Offset delta) async {
	final pointer = await tester.startGesture(start);
	await pointer.moveBy(delta);
	await tester.pump();
	await pointer.up();
	await tester.pumpAndSettle();
}

Rect _rect(WidgetTester tester, String id) => tester.getRect(find.byKey(ValueKey(id)));

void _inside(Rect rect, Size size) {
	for (final value in [rect.left, rect.top, rect.width, rect.height]) {
		expect(value.isFinite, isTrue, reason: '實際槽必須有限');
		expect(value, greaterThanOrEqualTo(-1e-6));
	}
	// 零槽可落在邊界；不能以裁切掩蓋超出 root 的实际 geometry。
	expect(rect.right, lessThanOrEqualTo(size.width + 1e-6));
	expect(rect.bottom, lessThanOrEqualTo(size.height + 1e-6));
}

void _expect(WidgetTester tester, String id, Rect expected) {
	final actual = _rect(tester, id);
	for (final pair in [(actual.left, expected.left), (actual.top, expected.top), (actual.width, expected.width), (actual.height, expected.height)]) {
		expect(pair.$1.isFinite, isTrue);
		expect(pair.$1, closeTo(pair.$2, 1e-6), reason: '$id 實際槽不符合共同配額');
	}
}

class _Content extends StatefulWidget {
	const _Content({super.key});
	@override
	State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
	int value = 0;
	void increment() => setState(() => value++);
	@override
	Widget build(BuildContext context) => const SizedBox.expand();
}
