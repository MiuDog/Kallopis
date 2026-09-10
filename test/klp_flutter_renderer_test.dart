import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/foundation/templates/klp_axis.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_renderer.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';

import 'support/klp_renderer_fixture.dart';

void main() {
  testWidgets(
    'extent keeps semantic width within tight parent and fills cross axis',
    (tester) async {
      final text = klpRendererText('content');
      final extent = KlpBoundExtent(KlpAxis.horizontal, KlpDistance(48), text);
      final child = Directionality(
        textDirection: TextDirection.ltr,
        child: KlpFlutterRenderer(content: extent),
      );
      await tester.pumpWidget(SizedBox.expand(child: child));
      final rendered = find.byWidgetPredicate(
        (widget) =>
            widget is KlpFlutterRenderer && identical(widget.content, text),
      );
      expect(tester.getSize(rendered), const Size(48, 600));
      expect(tester.getTopLeft(rendered), Offset.zero);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'extent clamps to available space and follows directional start',
    (tester) async {
      final text = klpRendererText('content');
      final extent = KlpBoundExtent(KlpAxis.horizontal, KlpDistance(48), text);
      final child = Directionality(
        textDirection: TextDirection.rtl,
        child: KlpFlutterRenderer(content: extent),
      );
      await tester.pumpWidget(SizedBox.expand(child: child));
      final rendered = find.byWidgetPredicate(
        (widget) =>
            widget is KlpFlutterRenderer && identical(widget.content, text),
      );
      expect(tester.getTopLeft(rendered), const Offset(752, 0));
      final oversized = KlpBoundExtent(
        KlpAxis.horizontal,
        KlpDistance(900),
        text,
      );
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: KlpFlutterRenderer(content: oversized),
        ),
      );
      expect(tester.getSize(rendered), const Size(800, 600));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'text conversion retains explicit style without inherited defaults',
    (tester) async {
      await tester.pumpWidget(klpRendererHost(klpRendererText('content')));
      final text = tester.widget<Text>(find.text('content'));
      expect(text.style?.inherit, isFalse);
      expect(text.style?.fontVariations, [const FontVariation('wght', 450)]);
      expect(text.style?.fontFamily, 'Test');
    },
  );

  testWidgets(
    'small regions preserve access to trailing content without overflow',
    (tester) async {
      final regions = KlpBoundRegions(
        axis: KlpAxis.vertical,
        leading: klpRendererText('leading', size: 50),
        body: klpRendererText('body', size: 50),
        trailing: klpRendererText('trailing', size: 50),
        leadingExtent: KlpDistance(50),
        trailingExtent: KlpDistance(50),
        minimumBodyExtent: KlpDistance(50),
      );
      final constrained = KlpBoundExtent(
        KlpAxis.vertical,
        KlpDistance(80),
        regions,
      );
      await tester.pumpWidget(klpRendererHost(constrained));
      expect(tester.takeException(), isNull);
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      expect(find.text('trailing').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'linear content scrolls instead of overflowing constrained main axis',
    (tester) async {
      final line = KlpBoundLinear(KlpAxis.horizontal, KlpDistance(10), [
        klpRendererText('first long text'),
        klpRendererText('second long text'),
      ]);
      final constrained = KlpBoundExtent(
        KlpAxis.horizontal,
        KlpDistance(60),
        line,
      );
      await tester.pumpWidget(klpRendererHost(constrained));
      expect(tester.takeException(), isNull);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
