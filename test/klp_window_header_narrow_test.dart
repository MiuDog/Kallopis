import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  const windowChannel = MethodChannel('kallopis/window');

  testWidgets('Windows header action 只占自然寬度並保留 identity 拖曳區', (tester) async {
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(windowChannel, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(windowChannel, null));

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 800,
              child: KlpWindowHeader(
                titleText: 'Kallopis',
                platform: TargetPlatform.windows,
                appIcon: const FlutterLogo(key: ValueKey('app-icon')),
                actions: const [SizedBox(width: 48, child: Text('Light'))],
              ),
            ),
          ),
        ),
      ),
    );

    final titleFinder = find.text('Kallopis');
    final iconFinder = find.byKey(const ValueKey('app-icon'));
    expect(tester.getSize(titleFinder).width, greaterThan(0));
    expect(tester.getSize(iconFinder).width, greaterThan(0));

    await tester.drag(titleFinder, const Offset(20, 0));
    await tester.pump(kDoubleTapTimeout);

    expect(calls.map((call) => call.method), contains('drag'));
  });

  testWidgets('Windows header 在啟動窄寬度與 action 下不溢出', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 156,
              child: Builder(
                builder: (context) {
                  final klp = context.klp;

                  return KlpWindowHeader(
                    titleText: 'Kallopis',
                    platform: TargetPlatform.windows,
                    appIcon: const FlutterLogo(),
                    actions: [
                      Container(
                        height: 22,
                        padding: EdgeInsets.symmetric(
                          horizontal: klp.space.compact,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            KlpIcon(
                              KlpIcons.sparkles,
                              size: klp.space.iconSmall,
                            ),
                            SizedBox(width: klp.space.tight),
                            const KlpText('Light', role: KlpTextRole.micro),
                          ],
                        ),
                      ),
                    ],
                    onMinimize: () {},
                    onToggleMaximize: () {},
                    onClose: () {},
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(KlpWindowControls), findsOneWidget);
  });
}
