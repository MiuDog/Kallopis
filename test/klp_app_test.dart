import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// `KlpApp` 是消費者唯一必經的接入點，也是這個庫裡少數帶狀態機的地方
/// （明暗解析、切換方向、router 掛載）。這些路徑先前只有人工執行 example 時
/// 才會被走到——沒有任何自動化測試把關。
void main() {
  const windowChannel = MethodChannel('kallopis/window');

  /// 取出目前實際套用的 `KlpThemeData`，用來驗證 theme 真的換了，
  /// 而不只是 controller 的欄位變了。
  Future<(KlpAppController, KlpThemeData)> pumpAndRead(
    WidgetTester tester, {
    ThemeMode initialThemeMode = ThemeMode.light,
    KlpRouter? router,
  }) async {
    late KlpAppController controller;
    late KlpThemeData colors;

    await tester.pumpWidget(
      KlpApp(
        initialThemeMode: initialThemeMode,
        router: router,
        home: Builder(
          builder: (context) {
            controller = KlpApp.of(context);
            colors = context.klp.color;
            return const SizedBox.shrink(key: ValueKey('test_target'));
          },
        ),
      ),
    );

    return (controller, colors);
  }

  testWidgets('預設套用淺色 token', (tester) async {
    final (controller, colors) = await pumpAndRead(tester);

    expect(controller.brightness, Brightness.light);
    expect(controller.themeMode, ThemeMode.light);
    expect(colors.surface.toARGB32(), KlpThemeData.light.surface.toARGB32());
  });

  testWidgets('toggleBrightness 真的換掉套用中的 token', (tester) async {
    final (controller, _) = await pumpAndRead(tester);

    controller.toggleBrightness();
    await tester.pump();

    expect(controller.brightness, Brightness.dark);

    final context = tester.element(find.byKey(const ValueKey('test_target')));
    expect(
      context.klp.color.surface.toARGB32(),
      KlpThemeData.dark.surface.toARGB32(),
      reason: 'controller 的欄位變了但 theme 沒跟著換，代表沒有真的重建',
    );
  });

  testWidgets('從 system 切換後會定在明確的 mode，不會被系統設定蓋回去', (tester) async {
    final (controller, _) = await pumpAndRead(
      tester,
      initialThemeMode: ThemeMode.system,
    );

    final before = controller.brightness;
    controller.toggleBrightness();
    await tester.pump();

    expect(
      controller.themeMode,
      before == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
    );
    expect(controller.themeMode, isNot(ThemeMode.system));
  });

  testWidgets('setThemeMode 可以切回 system', (tester) async {
    final (controller, _) = await pumpAndRead(tester);

    controller.setThemeMode(ThemeMode.system);
    await tester.pump();

    expect(controller.themeMode, ThemeMode.system);
  });

  testWidgets('主題切換不做過場', (tester) async {
    await pumpAndRead(tester);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(
      app.themeAnimationDuration,
      Duration.zero,
      reason:
          '過場中途會有半數 token 停在舊值上，看起來就是「有些元件沒跟著變」。'
          '見 README「深淺切換不做過場」。',
    );
  });

  testWidgets('KlpApp header 套用標準品牌位置與尺寸', (tester) async {
    await tester.pumpWidget(
      const KlpApp(
        title: 'Notist',
        appIcon: Icon(Icons.edit, key: ValueKey('app_icon')),
        home: SizedBox.shrink(),
      ),
    );

    final iconFinder = find.byKey(const ValueKey('app_icon'));
    final iconContext = tester.element(iconFinder);
    final compact = iconContext.klp.space.compact;
    final layout = iconContext.klp.geometry.layout;
    final headerRect = tester.getRect(find.byType(KlpWindowHeader));
    final fittedBoxFinder = find.ancestor(
      of: iconFinder,
      matching: find.byType(FittedBox),
    );
    final iconRect = tester.getRect(fittedBoxFinder);
    final titleRect = tester.getRect(find.text('Notist'));
    final appFrameBackground = tester.widget<ColoredBox>(
      find.byKey(const ValueKey('klp-app-frame-background')),
    );

    expect(fittedBoxFinder, findsOneWidget);
    expect(appFrameBackground.color, iconContext.klpColors.app);
    expect(headerRect.left, compact / 2);
    expect(headerRect.top, compact / 2);
    expect(headerRect.height, klpWindowHeaderHeight(iconContext.klp.geometry));
    expect(
      tester.getSize(fittedBoxFinder),
      Size.square(layout.windowAppIconSize),
    );
    expect(iconRect.left, headerRect.left + compact / 2);
    expect(titleRect.left - iconRect.right, layout.windowIdentityGap);
  });

  testWidgets('視窗轉場暫時低於 header 高度時不產生垂直溢出', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(800.0, 19.0);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const KlpApp(title: 'Notist', home: SizedBox.expand()),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('最小視窗尺寸於建立與更新時傳給 Windows runner', (tester) async {
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(windowChannel, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(windowChannel, null));

    await tester.pumpWidget(
      const KlpApp(
        key: ValueKey('app'),
        minWidth: 640.0,
        minHeight: 480.0,
        home: SizedBox.shrink(),
      ),
    );
    await tester.pump();

    await tester.pumpWidget(
      const KlpApp(
        key: ValueKey('app'),
        minWidth: 720.0,
        minHeight: 540.0,
        home: SizedBox.shrink(),
      ),
    );
    await tester.pump();

    final minSizeCalls = calls
        .where((call) => call.method == 'setMinSize')
        .toList();
    expect(minSizeCalls, hasLength(2));
    expect(minSizeCalls[0].arguments, <String, double>{
      'width': 640.0,
      'height': 480.0,
    });
    expect(minSizeCalls[1].arguments, <String, double>{
      'width': 720.0,
      'height': 540.0,
    });
  });

  testWidgets('KlpApp 預設只在首次建立時確保視窗最大化', (tester) async {
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(windowChannel, (call) async {
      calls.add(call);
      if (call.method == 'isMaximized') return false;
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(windowChannel, null));

    await tester.pumpWidget(
      const KlpApp(key: ValueKey('app'), home: SizedBox.shrink()),
    );
    await tester.pump();
    await tester.pumpWidget(
      const KlpApp(key: ValueKey('app'), home: SizedBox.shrink()),
    );
    await tester.pump();

    expect(
      calls.map((call) => call.method),
      orderedEquals(['isMaximized', 'maximize']),
    );
  });

  testWidgets('原生視窗已最大化時不切換回視窗化', (tester) async {
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(windowChannel, (call) async {
      calls.add(call);
      if (call.method == 'isMaximized') return true;
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(windowChannel, null));

    await tester.pumpWidget(const KlpApp(home: SizedBox.shrink()));
    await tester.pump();

    expect(calls.map((call) => call.method), orderedEquals(['isMaximized']));
  });

  testWidgets('消費端可停用啟動最大化', (tester) async {
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(windowChannel, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(windowChannel, null));

    await tester.pumpWidget(
      const KlpApp(startMaximized: false, home: SizedBox.shrink()),
    );
    await tester.pump();

    expect(calls, isEmpty);
  });

  test('最小視窗尺寸必須是正的邏輯像素', () {
    expect(
      () => KlpApp(minWidth: 0.0, home: const SizedBox.shrink()),
      throwsAssertionError,
    );
    expect(
      () => KlpApp(minHeight: -1.0, home: const SizedBox.shrink()),
      throwsAssertionError,
    );
  });

  testWidgets('給了 router 就自動架好 KlpRouterScope', (tester) async {
    final router = KlpRouter(
      routes: [KlpRoute(id: 'home', builder: (_) => const SizedBox.shrink())],
      initialId: 'home',
    );

    await pumpAndRead(tester, router: router);

    expect(find.byType(KlpRouterScope), findsOneWidget);
  });

  testWidgets('沒有 KlpApp 祖先時 KlpApp.of 明確拋錯', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            expect(() => KlpApp.of(context), throwsStateError);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
