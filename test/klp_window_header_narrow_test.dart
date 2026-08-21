import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
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
