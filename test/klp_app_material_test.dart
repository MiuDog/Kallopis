import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

const _hostileStyle = TextStyle(
  color: Colors.red,
  decoration: TextDecoration.underline,
  decorationStyle: TextDecorationStyle.double,
  decorationColor: Colors.yellow,
);

Widget _hostileTextStyle(BuildContext context, Widget? child) =>
    DefaultTextStyle(style: _hostileStyle, child: child!);

void main() {
  for (final showHeader in [false, true]) {
    for (final hostile in [false, true]) {
      testWidgets(
        'app supplies Material with header=$showHeader and hostile=$hostile',
        (tester) async {
          var taps = 0;
          final children = <Widget>[
            const KlpText('Kallopis text', key: ValueKey('klp-copy')),
            const Text('Native text', key: ValueKey('native-copy')),
            KlpButton(label: 'Action', onPressed: () => taps++),
          ];
          final app = KlpApp(
            startMaximized: false,
            showWindowHeader: showHeader,
            builder: hostile ? _hostileTextStyle : null,
            home: KlpPanelFrame(content: Column(children: children)),
          );
          await tester.pumpWidget(app);

          // 確認實際排版文字與按鈕共用 App 提供的 Material，而非逐個文字清除裝飾。
          for (final key in ['klp-copy', 'native-copy']) {
            final copy = find.byKey(ValueKey(key));
            final context = tester.element(copy);
            final material = context.findAncestorWidgetOfExactType<Material>();
            expect(material?.type, MaterialType.transparency);
            final paragraph = tester.renderObject<RenderParagraph>(
              find.descendant(of: copy, matching: find.byType(RichText)).first,
            );
            expect(
              paragraph.text.style?.decoration ?? TextDecoration.none,
              TextDecoration.none,
            );
            expect(
              DefaultTextStyle.of(context).style.decoration ??
                  TextDecoration.none,
              TextDecoration.none,
            );
          }

          await tester.tap(find.text('Action'));
          expect(taps, 1);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
