import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	for (final style in KlpPageBackgroundStyle.values) {
		testWidgets('KlpPageBackground renders ${style.name} from theme tokens', (tester) async {
			await tester.pumpWidget(
				KlpApp(
					home: KlpPanelFrame(padding: EdgeInsets.zero, content: SizedBox(
						width: 240,
						height: 180,
						child: KlpPageBackground(
							style: style,
							child: const SizedBox.expand(key: ValueKey('background-child')),
						),
					)),
				),
			);

			expect(find.byKey(ValueKey('klp-page-background-${style.name}')), findsOneWidget);
			expect(find.byKey(const ValueKey('background-child')), findsOneWidget);
			expect(tester.takeException(), isNull);
		});
	}
}
