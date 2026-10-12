import 'dart:async';
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'package:kallopis/kallopis_theme.dart';

// 僅觀察公開手勢與 caller 保存結果；不以私有提交次序代替操作契約。
void main() {
	testWidgets('select 與同組 reorder 依 pure final index，no-op 不通知', (tester) async {
		final initial = _layout(left: [_group('left', ['a', 'b', 'c'], active: 'b')]);
		final changes = <KlpDockLayoutData>[];
		final before = _saved(initial);
		await _pump(tester, initial, changes);
		await tester.tap(find.text('b'));
		await tester.pumpAndSettle();
		expect(changes, isEmpty);
		final same = tester.getRect(find.text('b'));
		await _drop(tester, 'b', Offset(same.right - 1, same.center.dy));
		expect(changes, isEmpty, reason: '原 index 與 active 相同的 tab drop 不得通知');
		await tester.tap(find.text('c'));
		await tester.pumpAndSettle();
		_equal(changes.single, _apply(initial, const KlpDockAction.select(panelId: 'c')));
		changes.clear();
		await _pump(tester, initial, changes);
		final target = tester.getRect(find.text('c'));
		await _drop(tester, 'a', Offset(target.right - 1, target.center.dy));
		expect(changes, hasLength(1));
		_equal(changes.single, _apply(initial, const KlpDockAction.move(panelId: 'a',
			destination: KlpDockDestination.tab(area: KlpDockArea.left, groupId: 'left', index: 2))));
		_immutable(changes.single);
		expect(_saved(initial), before);
	});

	testWidgets('跨區 tab move 只有一次提交且 active source fallback 等於 pure action', (tester) async {
		final initial = _layout(left: [_group('left', ['a', 'b'])], right: [_group('right', ['c'])]);
		final changes = <KlpDockLayoutData>[];
		final before = _saved(initial);
		await _pump(tester, initial, changes);
		final target = tester.getRect(find.text('c'));
		await _drop(tester, 'a', Offset(target.right - 1, target.center.dy));
		expect(changes, hasLength(1));
		_equal(changes.single, _apply(initial, const KlpDockAction.move(panelId: 'a',
			destination: KlpDockDestination.tab(area: KlpDockArea.right, groupId: 'right', index: 1))));
		expect(changes.single.left.groups.single.activePanelId, 'b');
		_immutable(changes.single);
		expect(_saved(initial), before);
	});

	testWidgets('split 用 actual group 配額、兩個等偏好且 batch 一次提交', (tester) async {
		final initial = _layout(left: [_group('left', ['a', 'b'])], right: [_group('right', ['c'])]);
		final changes = <KlpDockLayoutData>[];
		final before = _saved(initial);
		await _pump(tester, initial, changes);
		final rect = tester.getRect(find.byKey(const ValueKey('content-c')));
		await _drop(tester, 'a', Offset(rect.center.dx, rect.bottom - 2));
		expect(changes, hasLength(1));
		final groups = changes.single.right.groups;
		expect(groups, hasLength(2));
		expect(groups.first.id, 'right');
		expect(groups.last.id, isNot('right'));
		final extent = (400 - _gutter()) / 2;
		expect(groups.first.mainAxisExtent, closeTo(extent, 1e-6));
		expect(groups.last.mainAxisExtent, closeTo(extent, 1e-6));
		final moved = _apply(initial, KlpDockAction.move(panelId: 'a',
			destination: KlpDockDestination.group(area: KlpDockArea.right,
				groupId: groups.last.id, index: 1, extent: extent)));
		_equal(changes.single, _apply(moved, KlpDockAction.resizeGroup(groupId: 'right', extent: extent)));
		_immutable(changes.single);
		expect(_saved(initial), before);
	});

	testWidgets('只有一 tab 的 source 不自拆，零 area Stage create 產生正 group 偏好', (tester) async {
		final initial = _layout(right: [_group('right', ['a'])], leftExtent: 0);
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, initial, changes);
		final own = tester.getRect(find.byKey(const ValueKey('content-a')));
		await _drop(tester, 'a', Offset(own.center.dx, own.bottom - 2));
		expect(changes, isEmpty, reason: 'single source 不得移除自己再建立 split');
		final stage = tester.getRect(find.byKey(const ValueKey('stage')));
		await _drop(tester, 'a', Offset(stage.left + 10, stage.top + 50));
		expect(changes, hasLength(1));
		final created = changes.single.left.groups.single;
		expect(changes.single.left.extent, 80);
		expect(created.mainAxisExtent, greaterThanOrEqualTo(32));
		final moved = _apply(initial, KlpDockAction.move(panelId: 'a',
			destination: KlpDockDestination.group(area: KlpDockArea.left,
				groupId: created.id, index: 0, extent: created.mainAxisExtent)));
		_equal(changes.single, _apply(moved, const KlpDockAction.resizeArea(area: KlpDockArea.left, extent: 80)));
		_immutable(changes.single);
		expect(initial.left.extent, 0);
	});

	testWidgets('group pair resize 轉兩個 pure actions，只一次通知且 caller immutable', (tester) async {
		final initial = _layout(left: [_group('one', ['a']), _group('two', ['b'])]);
		final changes = <KlpDockLayoutData>[];
		final before = _saved(initial);
		await _pump(tester, initial, changes);
		final pointer = await tester.startGesture(Offset(110, 137 + _gutter() / 2));
		await pointer.moveBy(const Offset(0, 20));
		await tester.pump();
		await pointer.up();
		await tester.pumpAndSettle();
		expect(changes, hasLength(1), reason: '相鄰兩組 resize 必須 atomic batch');
		final first = _apply(initial, const KlpDockAction.resizeGroup(groupId: 'one', extent: 157));
		_equal(changes.single, _apply(first, KlpDockAction.resizeGroup(groupId: 'two', extent: 400 - _gutter() - 157)));
		_immutable(changes.single);
		expect(_saved(initial), before);
	});

	testWidgets('optional metadata 保留舊 caller，pinned dirty 不進保存或阻擋 inactive close', (tester) async {
		const old = KlpDockPanel(id: 'a', header: Text('a'), content: SizedBox());
		expect(old.isPinned, isFalse);
		expect(old.isDirty, isFalse);
		expect(old.onCloseRequested, isNull);
		expect(old.closeLabel, isNull);
		final initial = _layout(left: [_group('left', ['a', 'b'])]);
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, initial, changes);
		expect(find.byWidgetPredicate((widget) => widget is KlpIcon && widget.icon == KlpIcons.bookmark), findsNothing);
		var calls = 0;
		await _pump(tester, initial, changes, overrides: {'b': _panel('b', pinned: true, dirty: true, close: () { calls++; return true; })});
		expect(find.byWidgetPredicate((widget) => widget is KlpIcon && widget.icon == KlpIcons.bookmark), findsOneWidget);
		expect(find.textContaining('•'), findsWidgets);
		await _close(tester, 'b');
		expect(calls, 1);
		expect(changes, hasLength(1));
		_equal(changes.single, _apply(initial, const KlpDockAction.close(panelId: 'b', approved: true)));
		expect(initial.left.groups.single.panelIds, ['a', 'b']);
		expect(_saved(changes.single), isNot(contains('isPinned')));
		expect(_saved(changes.single), isNot(contains('isDirty')));
	});

	testWidgets('single 無 header 可以 close，denied 無提交，approved 可從 registry 再 open', (tester) async {
		final initial = _layout(left: [_group('left', ['a'])]);
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, initial, changes, overrides: {'a': _panel('a', header: false, close: () => false)});
		await _close(tester, 'a');
		expect(changes, isEmpty);
		await _pump(tester, initial, changes, overrides: {'a': _panel('a', header: false, close: () => true)});
		await _close(tester, 'a');
		expect(changes, hasLength(1));
		_equal(changes.single, _apply(initial, const KlpDockAction.close(panelId: 'a', approved: true)));
		final reopened = _apply(changes.single, const KlpDockAction.open(panelId: 'a',
			destination: KlpDockDestination.group(area: KlpDockArea.left, groupId: 'reopened', index: 0, extent: 100)));
		await _pump(tester, reopened, changes);
		expect(find.byKey(const ValueKey('content-a')), findsOneWidget);
	});

	testWidgets('pending 不重入，其他 panel select 可用，批准從最新位置關閉', (tester) async {
		final initial = _layout(left: [_group('left', ['a', 'b'])], right: [_group('right', ['c'])]);
		final approval = Completer<bool>();
		var calls = 0;
		Future<bool> approve() { calls++; return approval.future; }
		final overrides = {'a': _panel('a', close: approve)};
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, initial, changes, overrides: overrides);
		await _close(tester, 'a');
		expect(tester.widget<KlpIconButton>(_closeButton('a')).onPressed, isNull);
		await _close(tester, 'a');
		expect(calls, 1);
		await tester.tap(find.text('b'));
		await tester.pumpAndSettle();
		expect(changes, hasLength(1), reason: 'pending 只停用該面板的 close');
		_equal(changes.single, _apply(initial, const KlpDockAction.select(panelId: 'b')));
		final moved = _apply(changes.single, const KlpDockAction.move(panelId: 'a',
			destination: KlpDockDestination.tab(area: KlpDockArea.right, groupId: 'right', index: 1)));
		changes.clear();
		await _pump(tester, moved, changes, overrides: overrides);
		approval.complete(true);
		await tester.pumpAndSettle();
		expect(changes, hasLength(1));
		_equal(changes.single, _apply(moved, const KlpDockAction.close(panelId: 'a', approved: true)));
		expect(changes.single.left.groups.single.panelIds, ['b']);
		expect(changes.single.right.groups.single.panelIds, ['c']);
	});

	for (final invalidation in ['layout 離開再開', 'registry 離開再回', 'callback 替換']) {
		testWidgets('$invalidation 忽略舊 approval，不能關掉後來的面板', (tester) async {
			final initial = _layout(left: [_group('left', ['a', 'b'])]);
			final approval = Completer<bool>();
			Future<bool> approve() => approval.future;
			final original = _panel('a', close: approve);
			final changes = <KlpDockLayoutData>[];
			await _pump(tester, initial, changes, overrides: {'a': original});
			await _close(tester, 'a');
			if (invalidation == 'layout 離開再開') {
				final closed = _apply(initial, const KlpDockAction.close(panelId: 'a', approved: true));
				await _pump(tester, closed, changes, overrides: {'a': original});
				await _pump(tester, initial, changes, overrides: {'a': original});
			} else if (invalidation == 'registry 離開再回') {
				final closed = _apply(initial, const KlpDockAction.close(panelId: 'a', approved: true));
				await _pump(tester, closed, changes, omit: {'a'});
				await _pump(tester, initial, changes, overrides: {'a': original});
			} else {
				await _pump(tester, initial, changes, overrides: {'a': _panel('a', close: () => false)});
			}
			approval.complete(true);
			await tester.pumpAndSettle();
			expect(changes, isEmpty, reason: '舊 token 不得跨過面板生命週期');
			expect(_closeButton('a'), findsOneWidget);
			expect(tester.widget<KlpIconButton>(_closeButton('a')).onPressed, isNotNull);
			expect(tester.takeException(), isNull);
		});
	}

	testWidgets('close callback error report 且解除 pending，caller 資料保留可重試', (tester) async {
		final initial = _layout(left: [_group('left', ['a'])]);
		final changes = <KlpDockLayoutData>[];
		final error = StateError('產品拒絕處理');
		var calls = 0;
		Future<bool> approve() async { calls++; if (calls == 1) throw error; return false; }
		await _pump(tester, initial, changes, overrides: {'a': _panel('a', close: approve)});
		await _close(tester, 'a');
		expect(tester.takeException(), same(error), reason: '錯誤必須送標準 Flutter error channel');
		expect(changes, isEmpty);
		expect(tester.widget<KlpIconButton>(_closeButton('a')).onPressed, isNotNull);
		await _close(tester, 'a');
		expect(calls, 2);
		expect(changes, isEmpty);
		expect(initial.left.groups.single.panelIds, ['a']);
		expect(tester.takeException(), isNull);
	});

	testWidgets('dispose 後完成 approval 不提交也不觸發 setState error', (tester) async {
		final approval = Completer<bool>();
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, _layout(left: [_group('left', ['a'])]), changes,
			overrides: {'a': _panel('a', close: () => approval.future)});
		await _close(tester, 'a');
		await tester.pumpWidget(const SizedBox());
		approval.complete(true);
		await tester.pumpAndSettle();
		expect(changes, isEmpty);
		expect(tester.takeException(), isNull);
	});
}

const _ids = ['a', 'b', 'c'];
final _policies = [for (final id in _ids) KlpDockPanelPolicy(id: id)];

KlpDockGroupData _group(String id, List<String> panels, {String? active}) => KlpDockGroupData(
	id: id, panelIds: panels, activePanelId: active ?? panels.first, mainAxisExtent: 137,
);

KlpDockLayoutData _layout({List<KlpDockGroupData> left = const [], List<KlpDockGroupData> right = const [],
	double leftExtent = 220}) => KlpDockLayoutData(
	left: KlpDockAreaData(axis: Axis.vertical, extent: leftExtent, groups: left),
	right: KlpDockAreaData(axis: Axis.vertical, extent: 220, groups: right),
	bottom: const KlpDockAreaData(axis: Axis.horizontal, extent: 100, groups: []),
);

KlpDockPanel _panel(String id, {bool header = true, bool pinned = false, bool dirty = false,
	FutureOr<bool> Function()? close}) => KlpDockPanel(
	id: id, header: header ? Text(id) : null, content: SizedBox.expand(key: ValueKey('content-$id')),
	isPinned: pinned, isDirty: dirty, onCloseRequested: close, closeLabel: '關閉 $id',
);

final _pack = KlpStylePack.defaults().applyOverrides({'semantics': {
	'theme.spacing.dockMargin': {'light': 'p(space0)'},
}});
double _gutter() => (_pack.resolve(KlpThemeVariant.light)['theme.geometry.layout.resizeHandleExtent'] as num).toDouble();

Future<void> _pump(WidgetTester tester, KlpDockLayoutData layout, List<KlpDockLayoutData> changes,
	{Map<String, KlpDockPanel> overrides = const {}, Set<String> omit = const {}}) async {
	await tester.pumpWidget(MaterialApp(
		theme: buildKlpThemeVariant(KlpThemeVariant.light, stylePack: _pack),
		localizationsDelegates: const [KlpLocalizationsDelegate()],
		home: Scaffold(body: Align(alignment: Alignment.topLeft, child: SizedBox(width: 800, height: 400,
			child: KlpDockLayout(
				stage: const KlpPanelFrame(content: SizedBox.expand(key: ValueKey('stage'))),
				panels: [for (final id in _ids) if (!omit.contains(id)) overrides[id] ??
					KlpDockPanel(id: id, header: Text(id), content: SizedBox.expand(key: ValueKey('content-$id')))],
				layout: layout, onLayoutChanged: changes.add,
				leftConstraints: const KlpDockAreaConstraints(minExtent: 80, maxExtent: 500),
				rightConstraints: const KlpDockAreaConstraints(minExtent: 80, maxExtent: 500),
				bottomConstraints: const KlpDockAreaConstraints(minExtent: 60, maxExtent: 500),
			),
		))),
	));
	await tester.pumpAndSettle();
}

Future<void> _drop(WidgetTester tester, String source, Offset target) async {
	final pointer = await tester.startGesture(tester.getTopLeft(find.text(source)) + const Offset(2, 2),
		kind: PointerDeviceKind.mouse);
	await pointer.moveBy(const Offset(-25, 0));
	await tester.pump();
	await pointer.moveTo(target);
	await tester.pump();
	await pointer.up();
	await tester.pumpAndSettle();
}

Finder _closeButton(String id) => find.byWidgetPredicate((widget) => widget is KlpIconButton && widget.label == '關閉 $id');
Future<void> _close(WidgetTester tester, String id) async {
	expect(_closeButton(id), findsOneWidget);
	await tester.tap(_closeButton(id));
	await tester.pumpAndSettle();
}

String _saved(KlpDockLayoutData layout) => KlpDockLayoutCodec.encode(layout);
KlpDockLayoutData _apply(KlpDockLayoutData layout, KlpDockAction action) =>
	applyKlpDockAction(layout: layout, panels: _policies, action: action).layout;
void _equal(KlpDockLayoutData actual, KlpDockLayoutData expected) => expect(_saved(actual), _saved(expected));

void _immutable(KlpDockLayoutData layout) {
	expect(() => layout.left.groups.clear(), throwsUnsupportedError);
	for (final area in [layout.left, layout.right, layout.bottom]) {
		for (final group in area.groups) {
			expect(() => group.panelIds.clear(), throwsUnsupportedError);
		}
	}
}
