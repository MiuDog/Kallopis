import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/features/overlays/klp_menu.dart';
import 'package:kallopis/src/features/workspace/components/klp_workspace_command.dart';
import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_commands.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_menu.dart';

void main() {
	testWidgets('命令選單使用 KlpMenu，選取只執行一次，取消與失效不提交', (tester) async {
		tester.view.physicalSize = const Size(800, 600);
		tester.view.devicePixelRatio = 1;
		addTearDown(tester.view.resetPhysicalSize);
		addTearDown(tester.view.resetDevicePixelRatio);
		for (final family in ['Noto Sans TC', 'packages/kallopis/Noto Sans TC']) {
			final loader = FontLoader(family);
			loader.addFont(rootBundle.load('assets/fonts/NotoSansTC-Variable.ttf'));
			await loader.load();
		}
		final icons = FontLoader('packages/kallopis/Flaticon UIcons Regular Rounded');
		icons.addFont(rootBundle.load('assets/fonts/FlaticonUIcons-RegularRounded.ttf'));
		await icons.load();
		final mono = FontLoader('packages/kallopis/IBM Plex Mono');
		mono.addFont(rootBundle.load('assets/fonts/IBMPlexMono-Regular.ttf'));
		await mono.load();
		var calls = 0;
		var active = true;
		const style = KlpFlutterCommandStyle(surface: Color(0xfff8f6f1), foreground: Color(0xff222222), muted: Color(0xff777777), interaction: Color(0xffdddddd), destructive: Color(0xffaa2222), text: TextStyle(fontSize: 14, fontFamily: 'packages/kallopis/Noto Sans TC'), extent: 32, inset: 8, radius: 8);
		final command = KlpBoundWorkspaceCommand.fromCommand(KlpWorkspaceCommand(label: 'New Flow', onInvoke: (_) { calls++; }));
		await tester.pumpWidget(MaterialApp(theme: ThemeData(platform: TargetPlatform.windows), home: Scaffold(body: Builder(builder: (context) => TextButton(onPressed: () { showKlpCommandMenu(context, [command], const Offset(50, 50), style, () => active); }, child: const Text('Open'))))));
		await tester.tap(find.text('Open'));
		await tester.pumpAndSettle();
		expect(find.byType(KlpMenu), findsOneWidget);
		expect(find.byType(PopupMenuItem), findsNothing);
		await tester.runAsync(() async {
			final image = await (tester.binding.renderViews.single.debugLayer! as OffsetLayer).toImage(const Rect.fromLTWH(0, 0, 800, 600));
			final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
			await Directory('build/menu-review').create(recursive: true);
			await File('build/menu-review/menu.png').writeAsBytes(bytes!.buffer.asUint8List());
			image.dispose();
		});
		await tester.tap(find.text('New Flow'));
		await tester.pumpAndSettle();
		expect(calls, 1);
		await tester.tap(find.text('Open'));
		await tester.pumpAndSettle();
		await tester.tapAt(const Offset(700, 500));
		await tester.pumpAndSettle();
		expect(calls, 1);
		await tester.tap(find.text('Open'));
		await tester.pumpAndSettle();
		active = false;
		await tester.tap(find.text('New Flow'));
		await tester.pumpAndSettle();
		expect(calls, 1);
		expect(tester.takeException(), isNull);
	});
	testWidgets('區塊選單保留分類說明圖示快捷鍵，方向鍵捲動到末項', (tester) async {
		tester.view.physicalSize = const Size(600, 480);
		tester.view.devicePixelRatio = 1;
		addTearDown(tester.view.resetPhysicalSize);
		addTearDown(tester.view.resetDevicePixelRatio);
		int? selected;
		final items = [
			KlpMenuItemData(label: "Heading 1", group: "Headings", description: "Top-level heading", shortcut: "Ctrl-Alt-1", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M13 20H11V13H4V20H2V4H4V11H11V4H13V20ZM21.0005 8V20H19.0005L19 10.204L17 10.74V8.67L19.5005 8H21.0005Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Heading 2", group: "Headings", description: "Key section heading", shortcut: "Ctrl-Alt-2", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M4 4V11H11V4H13V20H11V13H4V20H2V4H4ZM18.5 8C20.5711 8 22.25 9.67893 22.25 11.75C22.25 12.6074 21.9623 13.3976 21.4781 14.0292L21.3302 14.2102L18.0343 18H22V20H15L14.9993 18.444L19.8207 12.8981C20.0881 12.5908 20.25 12.1893 20.25 11.75C20.25 10.7835 19.4665 10 18.5 10C17.5818 10 16.8288 10.7071 16.7558 11.6065L16.75 11.75H14.75C14.75 9.67893 16.4289 8 18.5 8Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Heading 3", group: "Headings", description: "Subsection and group heading", shortcut: "Ctrl-Alt-3", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M22 8L21.9984 10L19.4934 12.883C21.0823 13.3184 22.25 14.7728 22.25 16.5C22.25 18.5711 20.5711 20.25 18.5 20.25C16.674 20.25 15.1528 18.9449 14.8184 17.2166L16.7821 16.8352C16.9384 17.6413 17.6481 18.25 18.5 18.25C19.4665 18.25 20.25 17.4665 20.25 16.5C20.25 15.5335 19.4665 14.75 18.5 14.75C18.214 14.75 17.944 14.8186 17.7056 14.9403L16.3992 13.3932L19.3484 10H15V8H22ZM4 4V11H11V4H13V20H11V13H4V20H2V4H4Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Quote", group: "Basic blocks", description: "Quote or excerpt", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M21 4H3V6H21V4ZM21 11H8V13H21V11ZM21 18H8V20H21V18ZM5 11H3V20H5V11Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Toggle List", group: "Basic blocks", description: "List with hideable sub-items", shortcut: "Ctrl-Shift-6", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M22 18V20H2V18H22ZM2 3.5L10 8.5L2 13.5V3.5ZM22 11V13H12V11H22ZM22 4V6H12V4H22Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Numbered List", group: "Basic blocks", description: "List with ordered items", shortcut: "Ctrl-Shift-7", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M8 4H21V6H8V4ZM5 3V6H6V7H3V6H4V4H3V3H5ZM3 14V11.5H5V11H3V10H6V12.5H4V13H6V14H3ZM5 19.5H3V18.5H5V18H3V17H6V21H3V20H5V19.5ZM8 11H21V13H8V11ZM8 18H21V20H8V18Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Bullet List", group: "Basic blocks", description: "List with unordered items", shortcut: "Ctrl-Shift-8", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M8 4H21V6H8V4ZM4.5 6.5C3.67157 6.5 3 5.82843 3 5C3 4.17157 3.67157 3.5 4.5 3.5C5.32843 3.5 6 4.17157 6 5C6 5.82843 5.32843 6.5 4.5 6.5ZM4.5 13.5C3.67157 13.5 3 12.8284 3 12C3 11.1716 3.67157 10.5 4.5 10.5C5.32843 10.5 6 11.1716 6 12C6 12.8284 5.32843 13.5 4.5 13.5ZM4.5 20.4C3.67157 20.4 3 19.7284 3 18.9C3 18.0716 3.67157 17.4 4.5 17.4C5.32843 17.4 6 18.0716 6 18.9C6 19.7284 5.32843 20.4 4.5 20.4ZM8 11H21V13H8V11ZM8 18H21V20H8V18Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Check List", group: "Basic blocks", description: "List with checkboxes", shortcut: "Ctrl-Shift-9", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M8.00008 6V9H5.00008V6H8.00008ZM3.00008 4V11H10.0001V4H3.00008ZM13.0001 4H21.0001V6H13.0001V4ZM13.0001 11H21.0001V13H13.0001V11ZM13.0001 18H21.0001V20H13.0001V18ZM10.7072 16.2071L9.29297 14.7929L6.00008 18.0858L4.20718 16.2929L2.79297 17.7071L6.00008 20.9142L10.7072 16.2071Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Paragraph", group: "Basic blocks", description: "The body of your document", shortcut: "Ctrl-Alt-0", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M13 6V21H11V6H5V4H19V6H13Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Code Block", group: "Basic blocks", description: "Code block with syntax highlighting", shortcut: "Ctrl-Alt-c", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M3.41436 5.99995L5.70726 3.70706L4.29304 2.29285L0.585938 5.99995L4.29304 9.70706L5.70726 8.29285L3.41436 5.99995ZM9.58594 5.99995L7.29304 3.70706L8.70726 2.29285L12.4144 5.99995L8.70726 9.70706L7.29304 8.29285L9.58594 5.99995ZM14.0002 2.99995H21.0002C21.5524 2.99995 22.0002 3.44767 22.0002 3.99995V20C22.0002 20.5522 21.5524 21 21.0002 21H3.00015C2.44787 21 2.00015 20.5522 2.00015 20V12H4.00015V19H20.0002V4.99995H14.0002V2.99995Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Divider", group: "Basic blocks", description: "Visually divide blocks", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M5 11V13H19V11H5Z\"></path></svg>", onPressed: () {}),
			KlpMenuItemData(label: "Table", group: "Advanced", description: "Table with editable cells", iconSvg: "<svg stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" viewBox=\"0 0 24 24\" height=\"18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M13 10V14H19V10H13ZM11 10H5V14H11V10ZM13 19H19V16H13V19ZM11 19V16H5V19H11ZM13 5V8H19V5H13ZM11 5H5V8H11V5ZM4 3H20C20.5523 3 21 3.44772 21 4V20C21 20.5523 20.5523 21 20 21H4C3.44772 21 3 20.5523 3 20V4C3 3.44772 3.44772 3 4 3Z\"></path></svg>", onPressed: () {}),
		];
		await tester.pumpWidget(MaterialApp(theme: ThemeData(platform: TargetPlatform.windows), home: Scaffold(body: Builder(builder: (context) => TextButton(onPressed: () async {
			selected = await showKlpMenuItems(context: context, anchor: const Offset(30, 20), items: items, surface: const Color(0xfff8f6f1), foreground: const Color(0xff222222), fontFamily: 'packages/kallopis/Noto Sans TC');
		}, child: const Text('Open'))))));
		await tester.tap(find.text('Open'));
		await tester.pumpAndSettle();
		expect(find.text('Headings'), findsOneWidget);
		expect(find.text('Basic blocks'), findsOneWidget);
		expect(find.text('Top-level heading'), findsOneWidget);
		expect(find.text('Ctrl-Alt-1'), findsOneWidget);
		expect(find.byType(Scrollbar), findsOneWidget);
		final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
		final bounds = tester.getRect(find.byType(Scrollbar));
		final contentBounds = tester.getRect(find.byType(KlpMenuItem).first);
		expect(contentBounds.right, lessThanOrEqualTo(bounds.right - scrollbar.thickness!));
		await tester.runAsync(() async {
			final image = await (tester.binding.renderViews.single.debugLayer! as OffsetLayer).toImage(const Rect.fromLTWH(0, 0, 600, 480));
			final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
			await File('build/menu-review/blocks.png').writeAsBytes(bytes!.buffer.asUint8List());
			image.dispose();
		});
		await tester.sendKeyEvent(LogicalKeyboardKey.end);
		await tester.pumpAndSettle();
		expect(find.text('Table').hitTestable(), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.pumpAndSettle();
		expect(selected, items.length - 1);
		expect(tester.takeException(), isNull);
	});

	testWidgets('搜尋選單限制三分之一高度，篩選保留原始索引並接管隱藏游標', (tester) async {
		tester.view.physicalSize = const Size(800, 600);
		tester.view.devicePixelRatio = 1;
		addTearDown(tester.view.resetPhysicalSize);
		addTearDown(tester.view.resetDevicePixelRatio);
		int? selected;
		final items = [for (var index = 0; index < 12; index++) KlpMenuItemData(label: 'Heading $index', description: 'Description $index', group: 'Headings', onPressed: () {})];
		await tester.pumpWidget(MaterialApp(theme: ThemeData(platform: TargetPlatform.windows), home: MouseRegion(cursor: SystemMouseCursors.none, child: Scaffold(body: Builder(builder: (context) => TextButton(onPressed: () async {
			selected = await showKlpMenuItems(context: context, anchor: const Offset(30, 20), items: items, surface: const Color(0xfff8f6f1), foreground: const Color(0xff222222), fontFamily: 'packages/kallopis/Noto Sans TC', searchable: true);
		}, child: const Text('Open')))))));
		final mouse = TestGesture(dispatcher: tester.sendEventToBinding, kind: ui.PointerDeviceKind.mouse, device: 7);
		await mouse.addPointer(location: const Offset(700, 500));
		addTearDown(mouse.removePointer);
		await tester.pump();
		expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(7), SystemMouseCursors.none);
		await tester.tap(find.text('Open'));
		await tester.pumpAndSettle();
		expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(7), SystemMouseCursors.basic);
		expect(tester.getSize(find.byType(KlpMenu)).height, lessThanOrEqualTo(200));
		expect(find.byType(Scrollbar), findsOneWidget);
		await tester.runAsync(() async {
			final image = await (tester.binding.renderViews.single.debugLayer! as OffsetLayer).toImage(const Rect.fromLTWH(0, 0, 800, 600));
			final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
			await File('build/menu-review/search.png').writeAsBytes(bytes!.buffer.asUint8List());
			image.dispose();
		});
		final searchTop = tester.getTopLeft(find.byType(EditableText));
		await mouse.moveTo(tester.getCenter(find.byType(EditableText)));
		await tester.pump();
		expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(7), SystemMouseCursors.text);
		await tester.enterText(find.byType(EditableText), 'Heading 9');
		await tester.pumpAndSettle();
		expect(find.descendant(of: find.byType(KlpMenuItem), matching: find.text('Heading 9')), findsOneWidget);
		expect(find.text('Heading 8'), findsNothing);
		expect(tester.getTopLeft(find.byType(EditableText)), searchTop);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.pumpAndSettle();
		expect(selected, 9);
		await tester.tap(find.text('Open'));
		await tester.pumpAndSettle();
		await tester.enterText(find.byType(EditableText), 'missing');
		await tester.pumpAndSettle();
		expect(find.text('沒有符合的元件'), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await tester.pumpAndSettle();
		expect(find.byType(KlpMenu), findsNothing);
		expect(tester.takeException(), isNull);
	});

}
