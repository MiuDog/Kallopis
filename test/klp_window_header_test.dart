import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
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
    await tester.tap(closeFinder);
    expect(closed, isTrue);
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
