import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// `KlpApp` 是消費者唯一必經的接入點，也是這個庫裡少數帶狀態機的地方
/// （明暗解析、切換方向、router 掛載）。這些路徑先前只有人工執行 example 時
/// 才會被走到——沒有任何自動化測試把關。
void main() {
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
            return const SizedBox.shrink();
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

    final context = tester.element(find.byType(SizedBox));
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
