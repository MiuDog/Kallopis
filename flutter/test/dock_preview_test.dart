import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 僅以 caller 正文槽與原生 pointer 保護保存及暫時呈現的邊界。
void main() {
	for (final slot in ['left', 'right', 'bottom']) {
		testWidgets('$slot hover 展開，cancel 與 miss 恢復且不保存', (tester) async {
			final layout = _layout(slot);
			final saved = KlpDockLayoutCodec.encode(layout);
			final changes = <KlpDockLayoutData>[];
			for (final cancel in [true, false]) {
				await _pump(tester, layout, changes);
				expect(_target(), findsNothing);
				final pointer = await _begin(tester);
				await _hover(tester, pointer, slot);
				expect(changes, isEmpty, reason: 'hover 不得提交保存布局');
				_preview(tester, slot);
				await pointer.moveTo(const Offset(750, 500));
				await tester.pump();
				if (cancel) {
					await pointer.cancel();
				} else {
					await pointer.up();
				}
				await tester.pumpAndSettle();
				expect(_target(), findsNothing);
				expect(changes, isEmpty, reason: '取消或未命中放下不能保存預覽');
				expect(KlpDockLayoutCodec.encode(layout), saved);
				expect(tester.takeException(), isNull);
			}
		});
	}
	testWidgets('preview group 成功一次提交，保留 area 與 group 偏好', (tester) async {
		final layout = _layout('left');
		final saved = KlpDockLayoutCodec.encode(layout);
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, layout, changes);
		final pointer = await _begin(tester);
		await _hover(tester, pointer, 'left');
		expect(changes, isEmpty);
		_preview(tester, 'left');
		// 公開標頭是 tab 合併目的地，離開 Stage 不應收回預覽。
		await pointer.moveTo(tester.getCenter(find.text('target')));
		await tester.pump();
		expect(_target(), findsOneWidget);
		await pointer.up();
		await tester.pumpAndSettle();
		expect(changes, hasLength(1));
		final committed = changes.single;
		expect(committed.left.isVisible, isTrue);
		expect(committed.left.extent, layout.left.extent, reason: 'minimum 只能影響呈現');
		expect(committed.left.axis, layout.left.axis);
		expect(committed.left.groups.single.id, 'target-group');
		expect(committed.left.groups.single.mainAxisExtent, 137);
		expect(committed.left.groups.single.panelIds, containsAll(['target', 'source']));
		expect(committed.left.groups.single.activePanelId, 'source');
		expect(committed.right.groups, isEmpty);
		expect(committed.right.extent, layout.right.extent);
		expect(KlpDockLayoutCodec.encode(layout), saved);
		expect(_target(), findsNothing, reason: '成功後清 preview，等待 caller 採用保存資料');
		expect(tester.takeException(), isNull);
	});
	testWidgets('capability 拒絕與不可拖面板不開始 preview', (tester) async {
		for (final policy in [(false, true), (true, false)]) {
			final layout = _layout('left');
			final changes = <KlpDockLayoutData>[];
			await _pump(tester, layout, changes, allowSide: policy.$1, draggable: policy.$2);
			final pointer = await _begin(tester);
			await _hover(tester, pointer, 'left');
			expect(_target(), findsNothing);
			await pointer.up();
			await tester.pumpAndSettle();
			expect(changes, isEmpty);
			expect(layout.left.isVisible, isFalse);
			expect(layout.left.extent, 183);
			expect(tester.takeException(), isNull);
		}
	});
	testWidgets('同 layout 尺寸 theme 重建保留 preview，新 identity 清除', (tester) async {
		final layout = _layout('left');
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, layout, changes);
		final pointer = await _begin(tester);
		await _hover(tester, pointer, 'left');
		_preview(tester, 'left');
		await _pump(tester, layout, changes, width: 500, height: 300, variant: KlpThemeVariant.dark);
		_preview(tester, 'left');
		expect(changes, isEmpty);
		final replacement = layout.copyWith();
		expect(identical(layout, replacement), isFalse);
		await _pump(tester, replacement, changes, width: 500, height: 300, variant: KlpThemeVariant.dark);
		expect(_target(), findsNothing);
		await pointer.up();
		await tester.pumpAndSettle();
		expect(changes, isEmpty, reason: '新 caller 清提示後不可提交舊 target');
		expect(KlpDockLayoutCodec.encode(replacement), KlpDockLayoutCodec.encode(layout));
		expect(tester.takeException(), isNull);
	});
	testWidgets('空 area 沿 Stage create 一次提交', (tester) async {
		final layout = _layout('left', empty: true);
		final saved = KlpDockLayoutCodec.encode(layout);
		final changes = <KlpDockLayoutData>[];
		await _pump(tester, layout, changes);
		final pointer = await _begin(tester);
		await _hover(tester, pointer, 'left');
		expect(changes, isEmpty);
		expect(_target(), findsNothing);
		await pointer.up();
		await tester.pumpAndSettle();
		expect(changes, hasLength(1));
		expect(changes.single.left.isVisible, isTrue);
		expect(changes.single.left.groups.single.panelIds, ['source']);
		expect(changes.single.left.groups.single.activePanelId, 'source');
		expect(changes.single.right.groups, isEmpty);
		expect(KlpDockLayoutCodec.encode(layout), saved);
		expect(tester.takeException(), isNull);
	});
}

KlpDockAreaData _area(String? id, double extent, {bool visible = true, Axis axis = Axis.vertical}) => KlpDockAreaData(
	axis: axis, extent: extent, isVisible: visible,
	groups: id == null ? [] : [KlpDockGroupData(id: '$id-group', panelIds: [id], activePanelId: id, mainAxisExtent: 137)],
);

KlpDockLayoutData _layout(String slot, {bool empty = false}) => KlpDockLayoutData(
	left: _area(slot == 'left' && !empty ? 'target' : slot == 'right' ? 'source' : null, 183, visible: slot != 'left'),
	right: _area(slot == 'right' && !empty ? 'target' : slot != 'right' ? 'source' : null, 197, visible: slot != 'right'),
	bottom: _area(slot == 'bottom' && !empty ? 'target' : null, 149, visible: slot != 'bottom', axis: Axis.horizontal),
);

Future<void> _pump(WidgetTester tester, KlpDockLayoutData layout, List<KlpDockLayoutData> changes, {
	double width = 600, double height = 400, bool allowSide = true, bool draggable = true,
	KlpThemeVariant variant = KlpThemeVariant.light,
}) async {
	final pack = KlpStylePack.defaults().applyOverrides({'semantics': {
		'theme.spacing.dockMargin': {'light': 'p(space0)', 'dark': 'p(space0)'},
	}});
	await tester.pumpWidget(MaterialApp(
		theme: buildKlpThemeVariant(variant, stylePack: pack),
		localizationsDelegates: const [KlpLocalizationsDelegate()],
		home: Scaffold(body: Align(alignment: Alignment.topLeft, child: SizedBox(width: width, height: height,
			child: KlpDockLayout(
				stage: const KlpPanelFrame(content: SizedBox.expand(key: ValueKey('stage-content'))),
				panels: [
					KlpDockPanel(id: 'source', header: const Text('source'), content: const SizedBox.expand(key: ValueKey('source-content')),
						allowSide: allowSide, isDraggable: draggable),
					const KlpDockPanel(id: 'target', header: Text('target'), content: SizedBox.expand(key: ValueKey('target-content'))),
				],
				layout: layout, onLayoutChanged: changes.add,
				leftConstraints: const KlpDockAreaConstraints(minExtent: 80, maxExtent: 500),
				rightConstraints: const KlpDockAreaConstraints(minExtent: 80, maxExtent: 500),
				bottomConstraints: const KlpDockAreaConstraints(minExtent: 60, maxExtent: 500),
			),
		))),
	));
	await tester.pumpAndSettle();
}

Future<TestGesture> _begin(WidgetTester tester) async {
	final pointer = await tester.startGesture(tester.getTopLeft(find.text('source')) + const Offset(2, 2), kind: PointerDeviceKind.mouse);
	await pointer.moveBy(const Offset(-25, 0));
	await tester.pump();
	return pointer;
}

Future<void> _hover(WidgetTester tester, TestGesture pointer, String slot) async {
	final stage = tester.getRect(find.byKey(const ValueKey('stage-content')));
	final edge = switch (slot) {
		'left' => Offset(stage.left + 10, stage.top + 50),
		'right' => Offset(stage.right - 10, stage.top + 50),
		_ => Offset(stage.center.dx, stage.bottom - 10),
	};
	await pointer.moveTo(stage.center);
	await tester.pump();
	await pointer.moveTo(edge);
	await tester.pumpAndSettle();
}

Finder _target() => find.byKey(const ValueKey('target-content'));

void _preview(WidgetTester tester, String slot) {
	expect(_target(), findsOneWidget, reason: '合法隱藏非空區必須暫時展開');
	final rect = tester.getRect(_target());
	if (slot == 'bottom') {
		// 正文加標頭必須位於 minimum 60 的有限配額內。
		expect(rect.bottom, closeTo(400, 1e-6));
		expect(rect.height, inInclusiveRange(0, 60));
	} else {
		expect(rect.width, closeTo(80, 1e-6), reason: 'preview 依 constraints.minimum 呈現');
	}
}



