import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  const windowChannel = MethodChannel('kallopis/window');

  Widget testBed({required Widget child}) {
    return MaterialApp(
      theme: buildKlpTheme(Brightness.light),
      home: Scaffold(body: child),
    );
  }

  testWidgets('Windows 模式下，左側渲染圖示與標題，右側渲染控制鈕', (tester) async {
    bool minimized = false;
    bool maximized = false;
    bool closed = false;

    await tester.pumpWidget(
      testBed(
        child: KlpWindowHeader(
          titleText: 'Planist',
          platform: TargetPlatform.windows,
          appIcon: const Icon(Icons.circle, key: ValueKey('app-icon')),
          onMinimize: () => minimized = true,
          onToggleMaximize: () => maximized = true,
          onClose: () => closed = true,
        ),
      ),
    );

    expect(find.text('Planist'), findsOneWidget);
    expect(find.byKey(const ValueKey('app-icon')), findsOneWidget);
    expect(find.byType(KlpWindowControls), findsOneWidget);

    // 驗證按鈕點擊
    final minimizeFinder = find.byWidgetPredicate(
      (w) => w is KlpTooltip && w.message == 'Minimize window',
    );
    expect(minimizeFinder, findsOneWidget);
    expect(
      tester.getSize(minimizeFinder),
      Size.square(
        tester.element(minimizeFinder).klp.geometry.layout.windowAppIconSize,
      ),
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(minimizeFinder));
    await tester.pump();

    final minimizeMaterial = find.descendant(
      of: minimizeFinder,
      matching: find.byType(Material),
    );
    expect(minimizeMaterial, findsOneWidget);
    expect(
      tester.widget<Material>(minimizeMaterial).color,
      tester.element(minimizeFinder).klp.selectionWash,
    );
    expect(
      find.descendant(
        of: minimizeFinder,
        matching: find.byType(KlpDashedBorder),
      ),
      findsNothing,
    );
    await tester.tap(minimizeFinder);
    expect(minimized, isTrue);

    final maxFinder = find.byWidgetPredicate(
      (w) => w is KlpTooltip && w.message == 'Maximize window',
    );
    expect(maxFinder, findsOneWidget);
    await tester.tap(maxFinder);
    expect(maximized, isTrue);

    final closeFinder = find.byWidgetPredicate(
      (w) => w is KlpTooltip && w.message == 'Close window',
    );
    expect(closeFinder, findsOneWidget);

    await mouse.moveTo(tester.getCenter(closeFinder));
    await tester.pump();

    final closeMaterial = find.descendant(
      of: closeFinder,
      matching: find.byType(Material),
    );
    final closeIcon = find.descendant(
      of: closeFinder,
      matching: find.byType(KlpIcon),
    );
    final closeTokens = tester.element(closeFinder).klpColors;
    expect(tester.widget<Material>(closeMaterial).color, closeTokens.danger);
    expect(tester.widget<KlpIcon>(closeIcon).color, closeTokens.onStatus);

    final space = tester.element(closeFinder).klp.space;
    final inset = space.compact / 2;
    final geometry = tester.element(closeFinder).klp.geometry;
    final headerRect = tester.getRect(find.byType(KlpWindowHeader));
    final closeRect = tester.getRect(closeFinder);
    expect(headerRect.height, klpWindowHeaderHeight(geometry));
    expect(closeRect.top, headerRect.top);
    expect(closeRect.right, headerRect.right - inset);
    expect(closeRect.bottom, headerRect.bottom);
    await tester.tap(closeFinder);
    expect(closed, isTrue);
  });

  testWidgets('沒有 App icon 時仍保留同尺寸 identity 槽位', (tester) async {
    await tester.pumpWidget(
      testBed(
        child: const KlpWindowHeader(
          titleText: 'Designist',
          platform: TargetPlatform.windows,
          showWindowControls: false,
        ),
      ),
    );

    final slot = find.byKey(const ValueKey(klpWindowAppIconSlotKey));
    final title = find.text('Designist');
    final layout = tester.element(slot).klp.geometry.layout;

    expect(slot, findsOneWidget);
    expect(tester.getSize(slot), Size.square(layout.windowAppIconSize));
    expect(
      tester.getRect(title).left - tester.getRect(slot).right,
      layout.windowIdentityGap,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Windows 模式在極窄寬度下保留控制鈕且不溢出', (tester) async {
    bool closed = false;

    await tester.pumpWidget(
      testBed(
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 156.0,
            child: KlpWindowHeader(
              titleText: 'A deliberately long application title',
              platform: TargetPlatform.windows,
              appIcon: const Icon(Icons.circle),
              onClose: () => closed = true,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);

    final closeFinder = find.byWidgetPredicate(
      (widget) => widget is KlpTooltip && widget.message == 'Close window',
    );
    expect(closeFinder, findsOneWidget);
    final space = tester.element(closeFinder).klp.space;
    expect(
      tester.getRect(closeFinder).right,
      tester.getRect(find.byType(KlpWindowHeader)).right - space.compact / 2,
    );

    await tester.tap(closeFinder);
    expect(closed, isTrue);
  });

  testWidgets('Windows 最大化時仍由原生標題列接手拖曳', (tester) async {
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(windowChannel, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(windowChannel, null));

    await tester.pumpWidget(
      testBed(
        child: const KlpWindowHeader(
          titleText: 'Kallopis',
          platform: TargetPlatform.windows,
          isMaximized: true,
        ),
      ),
    );

    await tester.drag(find.byType(KlpWindowHeader), const Offset(20.0, 0.0));
    await tester.pump(kDoubleTapTimeout);

    expect(calls.map((call) => call.method), contains('drag'));
  });

  testWidgets('macOS 模式下，標題置中且控制鈕在左側', (tester) async {
    await tester.pumpWidget(
      testBed(
        child: const KlpWindowHeader(
          titleText: 'Planist Mac',
          platform: TargetPlatform.macOS,
          appIcon: Icon(Icons.circle, key: ValueKey('mac-app-icon')),
        ),
      ),
    );

    expect(find.text('Planist Mac'), findsOneWidget);
    expect(find.byKey(const ValueKey('mac-app-icon')), findsOneWidget);
    expect(find.byType(KlpWindowControls), findsOneWidget);
  });
}
