import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

void main() {
	testWidgets('文件分頁只回報 consumer 擁有的選取與釘選意圖', (tester) async {
		String? selectedId;
		(String, bool)? pinnedChange;
		await tester.pumpWidget(
			_testApp(
				KlpDocumentTabs(
					tabs: [
						KlpDocumentTab(id: 'alpha', label: 'Alpha', dirty: true, closable: false),
						KlpDocumentTab(id: 'beta', label: 'Beta'),
					],
					selectedId: 'alpha',
					onSelected: (id) => selectedId = id,
					onPinnedChanged: (id, pinned) => pinnedChange = (id, pinned),
				),
			),
		);

		await tester.tap(find.text('Beta'));
		expect(selectedId, 'beta');

		await tester.tap(find.byType(KlpIconButton).first);
		expect(pinnedChange, ('alpha', true));
		expect(find.text('Alpha'), findsOneWidget, reason: 'callback 不得自行改寫 consumer tabs');
	});

	testWidgets('Frame Groups 捲動主內容但固定 footer', (tester) async {
		final controller = ScrollController();
		await tester.pumpWidget(
			_testApp(
				SizedBox(
					width: 320,
					height: 180,
					child: KlpFrameGroups(
						scrollController: controller,
						groups: [
							KlpFrameGroup(content: const [SizedBox(height: 480)]),
						],
						footer: KlpFrameGroup(
							content: const [SizedBox(key: ValueKey('footer'), width: 80, height: 24)],
						),
					),
				),
			),
		);

		final footerTop = tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy;
		await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -120));
		await tester.pump();

		expect(controller.offset, greaterThan(0));
		expect(tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy, footerTop);
	});

	testWidgets('錨定 popup 由 consumer 接受 open request', (tester) async {
		var open = false;
		KlpAnchoredPopupChangeReason? reason;
		await tester.pumpWidget(
			_testApp(
				StatefulBuilder(
					builder: (context, setState) => KlpAnchoredPopup(
						open: open,
						accessibilityLabel: '文件動作',
						triggerBuilder: (context, toggle, expanded) => KlpButton(
							label: expanded ? '關閉' : '開啟',
							onPressed: toggle,
						),
						items: [KlpAnchoredPopupItem(id: 'rename', label: '重新命名')],
						onOpenChanged: (next, nextReason) {
							reason = nextReason;
							setState(() => open = next);
						},
					),
				),
			),
		);

		await tester.tap(find.text('開啟'));
		await tester.pumpAndSettle();
		expect(reason, KlpAnchoredPopupChangeReason.trigger);
		expect(find.text('重新命名'), findsOneWidget);

		await tester.tapAt(const Offset(760, 560));
		await tester.pumpAndSettle();
		expect(reason, KlpAnchoredPopupChangeReason.outside);
		expect(find.text('重新命名'), findsNothing);
	});

	testWidgets('App Layout 使用 8px gap 並限制 floating action', (tester) async {
		await tester.pumpWidget(
			_testApp(
				SizedBox(
					key: const ValueKey('layout-bounds'),
					width: 400,
					height: 300,
					child: KlpAppLayout(
						floatingAction: const SizedBox(
							key: ValueKey('floating-action'),
							width: 48,
							height: 32,
						),
						child: LayoutRow(
							children: [
								KlpAppFrame(key: const ValueKey('left-frame'), child: const SizedBox()),
								KlpAppFrame(key: const ValueKey('right-frame'), child: const SizedBox()),
							],
						),
					),
				),
			),
		);

		final left = tester.getRect(find.byKey(const ValueKey('left-frame')));
		final right = tester.getRect(find.byKey(const ValueKey('right-frame')));
		expect(right.left - left.right, 8);

		final bounds = tester.getRect(find.byKey(const ValueKey('layout-bounds')));
		final before = tester.getRect(find.byKey(const ValueKey('floating-action')));
		expect(bounds.right - before.right, 16, reason: '8px 外距加上 floating surface 的 8px padding');

		final moveGesture = await tester.startGesture(before.center);
		await moveGesture.moveBy(const Offset(-100, -80));
		await moveGesture.up();
		await tester.pump();
		final moved = tester.getRect(find.byKey(const ValueKey('floating-action')));
		expect(moved.left, lessThan(before.left));
		expect(moved.top, lessThan(before.top));

		final clampGesture = await tester.startGesture(moved.center);
		await clampGesture.moveBy(const Offset(600, 600));
		await clampGesture.up();
		await tester.pump();
		final after = tester.getRect(find.byKey(const ValueKey('floating-action')));
		expect(after.right, lessThanOrEqualTo(bounds.right - 8));
		expect(after.bottom, lessThanOrEqualTo(bounds.bottom - 8));
	});
}

Widget _testApp(Widget child) => MaterialApp(
	theme: buildKlpTheme(Brightness.light),
	localizationsDelegates: const [KlpLocalizationsDelegate()],
	home: Scaffold(body: Center(child: child)),
);
