import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';

const _anchorKey = ValueKey('popup-test-anchor');
const _captureKey = ValueKey('popup-test-capture');

void main() {
	TestWidgetsFlutterBinding.ensureInitialized();

	testWidgets('開啟內容跟隨同一 trigger 移動，不另發開關事件', (tester) async {
		final semantics = tester.ensureSemantics();
		try {
			final harness = _PopupLayoutHarness();
			addTearDown(harness.runtime.dispose);
			await harness.show(tester, const Offset(120, 90));
			final beforeAnchor = tester.getRect(find.byKey(_anchorKey));
			final beforePanel = tester.getRect(find.bySemanticsLabel('Geometry popup'));
			expect(beforePanel.top, greaterThanOrEqualTo(beforeAnchor.bottom));
			await harness.show(tester, const Offset(180, 140));
			final afterPanel = tester.getRect(find.bySemanticsLabel('Geometry popup'));
			expect(afterPanel.left - beforePanel.left, closeTo(60, 1));
			expect(afterPanel.top - beforePanel.top, closeTo(50, 1));
			expect(harness.changes, isEmpty);
		}
		finally {
			semantics.dispose();
		}
	});

	testWidgets('方向決定起始側，底邊翻轉且左右邊界保留在 viewport', (tester) async {
		final semantics = tester.ensureSemantics();
		try {
			final harness = _PopupLayoutHarness();
			addTearDown(harness.runtime.dispose);
			for (final direction in TextDirection.values) {
				final x = direction == TextDirection.ltr ? 200.0 : 460.0;
				await harness.show(tester, Offset(x, 80), direction: direction);
				final anchor = tester.getRect(find.byKey(_anchorKey));
				final panel = tester.getRect(find.bySemanticsLabel('Geometry popup'));
				if (direction == TextDirection.ltr) {
					expect(panel.left, closeTo(anchor.left, 1));
				}
				else {
					expect(panel.right, closeTo(anchor.right, 1));
				}

				// 以宿主位置觸發翻轉與裁界，不把像素參數交給 consumer 宣告。
				final edgeX = direction == TextDirection.ltr ? 640.0 : 0.0;
				await harness.show(tester, Offset(edgeX, 540), direction: direction);
				final edgeAnchor = tester.getRect(find.byKey(_anchorKey));
				final edgePanel = tester.getRect(find.bySemanticsLabel('Geometry popup'));
				expect(edgePanel.bottom, lessThanOrEqualTo(edgeAnchor.top));
				expect(edgePanel.left, greaterThanOrEqualTo(0));
				expect(edgePanel.top, greaterThanOrEqualTo(0));
				expect(edgePanel.right, lessThanOrEqualTo(800));
				expect(edgePanel.bottom, lessThanOrEqualTo(600));
			}
			expect(harness.changes, isEmpty);
		}
		finally {
			semantics.dispose();
		}
	});

	testWidgets('trigger 宿主消失時移除互動內容且只請求一次關閉', (tester) async {
		final harness = _PopupLayoutHarness();
		addTearDown(harness.runtime.dispose);
		await harness.show(tester, const Offset(120, 90));
		final previousItemPosition = tester.getCenter(find.text('Active project'));
		await tester.tap(find.text('Active project'));
		expect(harness.activations, 1);
		await harness.show(tester, const Offset(120, 90), visible: false);
		expect(find.text('Active project'), findsNothing);
		expect(harness.changes, [(false, KlpAnchoredPopupChangeReason.anchorUnavailable)]);
		await tester.tapAt(previousItemPosition);
		await tester.pumpAndSettle();
		expect(harness.activations, 1);
		expect(harness.changes, [(false, KlpAnchoredPopupChangeReason.anchorUnavailable)]);
		expect(tester.takeException(), isNull);
	});

	testWidgets('同一有效宣告的錨點暫時失效，恢復後仍遵守 consumer 的 open', (tester) async {
		final harness = _PopupLayoutHarness();
		addTearDown(harness.runtime.dispose);
		await harness.show(tester, const Offset(120, 90));
		final frame = harness.runtime.frame!;
		final itemPosition = tester.getCenter(find.text('Active project'));

		// 宿主只改變幾何；consumer 不回填關閉，也不提交另一份宣告。
		await harness.show(tester, const Offset(120, 90), hostSize: Size.zero);
		expect(harness.runtime.frame, same(frame));
		expect(frame.lease.isActive, isTrue);
		expect(harness.changes, [(false, KlpAnchoredPopupChangeReason.anchorUnavailable)]);
		expect(find.text('Active project'), findsNothing);
		await tester.tapAt(itemPosition);
		await tester.pumpAndSettle();
		expect(harness.activations, 0);
		expect(harness.changes, [(false, KlpAnchoredPopupChangeReason.anchorUnavailable)]);

		await harness.show(tester, const Offset(120, 90), hostSize: const Size(160, 48));
		expect(harness.runtime.frame, same(frame));
		expect(frame.lease.isActive, isTrue);
		expect(find.text('Active project'), findsOneWidget);
		await tester.tap(find.text('Active project'));
		await tester.pumpAndSettle();
		expect(harness.activations, 1);
		expect(harness.changes, [(false, KlpAnchoredPopupChangeReason.anchorUnavailable)]);

		// 完全離開 viewport 是另一段失效；恢復時仍使用原本有效 lease。
		await harness.show(tester, const Offset(-1000, -1000));
		expect(harness.runtime.frame, same(frame));
		expect(frame.lease.isActive, isTrue);
		expect(find.text('Active project'), findsNothing);
		expect(harness.changes, [(false, KlpAnchoredPopupChangeReason.anchorUnavailable), (false, KlpAnchoredPopupChangeReason.anchorUnavailable)]);
		await tester.tapAt(itemPosition);
		await tester.pumpAndSettle();
		expect(harness.activations, 1);
		await harness.show(tester, const Offset(120, 90));
		expect(harness.runtime.frame, same(frame));
		expect(find.text('Active project'), findsOneWidget);
		await tester.tap(find.text('Active project'));
		await tester.pumpAndSettle();
		expect(harness.activations, 2);
		expect(harness.changes, [(false, KlpAnchoredPopupChangeReason.anchorUnavailable), (false, KlpAnchoredPopupChangeReason.anchorUnavailable)]);
	});

	testWidgets('輸出供人類檢查的 popup 圖片', (tester) async {
		// package 字型交給真正的非同步環境載入，避免原生資產等待虛擬時鐘。
		await tester.runAsync(() async {
			for (final entry in <String, List<String>>{
				'IBM Plex Mono': ['IBMPlexMono-Regular.ttf', 'IBMPlexMono-SemiBold.ttf'],
				'IBM Plex Sans TC': ['IBMPlexSansTC-Regular.ttf', 'IBMPlexSansTC-SemiBold.ttf'],
				'Noto Sans TC': ['NotoSansTC-Variable.ttf'],
				'Flaticon UIcons Regular Rounded': ['FlaticonUIcons-RegularRounded.ttf'],
				'Flaticon UIcons Thin Rounded': ['FlaticonUIcons-ThinRounded.ttf'],
			}.entries) {
				final loader = FontLoader('packages/kallopis/${entry.key}');
				for (final asset in entry.value) {
					loader.addFont(rootBundle.load('packages/kallopis/assets/fonts/$asset'));
				}
				await loader.load();
			}
		});
		final harness = _PopupLayoutHarness();
		addTearDown(harness.runtime.dispose);
		await harness.show(tester, const Offset(160, 100));
		final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_captureKey));

		// 原生影像轉碼與檔案寫入使用同一個真正非同步區段。
		await tester.runAsync(() async {
			final image = await boundary.toImage();
			try {
				final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
				final output = File('D:/Projects/Kallopis-flow-evidence/popup.png');
				await output.parent.create(recursive: true);
				await output.writeAsBytes(bytes!.buffer.asUint8List());
			}
			finally {
				image.dispose();
			}
		});
	}, skip: Platform.environment['KLP_POPUP_CAPTURE'] != '1');
}

/// 真實 runtime 配合可移動的測試宿主；不讀取 popup 私有型別或狀態。
final class _PopupLayoutHarness {

	final runtime = KlpTreeRuntime();
	final changes = <(bool, KlpAnchoredPopupChangeReason)>[];
	var activations = 0;
	var position = Offset.zero;
	var hostSize = const Size(160, 48);
	var visible = true;
	var direction = TextDirection.ltr;
	OverlayEntry? entry;

	Future<void> show(WidgetTester tester, Offset nextPosition, {TextDirection direction = TextDirection.ltr, bool visible = true, Size hostSize = const Size(160, 48)}) async {
		position = nextPosition;
		this.hostSize = hostSize;
		this.direction = direction;
		this.visible = visible;
		if (entry == null) {
			final popup = KlpAnchoredPopup(
				id: KlpId.root('geometry-popup'),
				trigger: KlpWorkspaceBlock(id: KlpId.root('geometry-trigger'), kind: KlpWorkspaceBlockKind.action, title: 'Projects'),
				open: true,
				accessibilityLabel: 'Geometry popup',
				title: 'Manage projects',
				items: [
					KlpAnchoredPopupItem(id: KlpId.root('active-project'), label: 'Active project', subtitle: 'Ready to edit', current: true, onPressed: () => activations++),
					KlpAnchoredPopupItem(id: KlpId.root('archived-project'), label: 'Archived project', enabled: false),
				],
				onOpenChanged: (open, reason) => changes.add((open, reason)),
			);
			runtime.update(root: popup, adapters: klpApplicationAdapters(), primitives: KlpWorkspacePreset.light());
			entry = OverlayEntry(builder: (_) => Directionality(textDirection: this.direction, child: Stack(children: [
				if (this.visible) Positioned(left: position.dx, top: position.dy, width: this.hostSize.width, height: this.hostSize.height, child: SizedBox(key: _anchorKey, child: KlpFlutterRenderer(content: runtime.frame!.content))),
			])));
		}
		else {
			entry!.markNeedsBuild();
		}
		await tester.pumpWidget(WidgetsApp(color: const Color(0xffeeeeee), builder: (_, _) => RepaintBoundary(key: _captureKey, child: ColoredBox(color: const Color(0xffeeeeee), child: Overlay(initialEntries: [entry!])))));
		await tester.pumpAndSettle();
		expect(tester.takeException(), isNull);
	}
}
