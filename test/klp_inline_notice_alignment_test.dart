import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

void main() {
	testWidgets('KlpInlineNotice icon 等於 body 字級且混合字體共用基線', (tester) async {
		for (final style in [KlpVisualStyle.defaultStyle, contrastingStyle]) {
			await tester.pumpWidget(_specimen(style));

			final icon = tester.widget<KlpIcon>(find.byType(KlpIcon));
			expect(icon.size, style.typography.body);
			expect(_baseline(tester, find.text('INFO')), closeTo(_baseline(tester, find.text('狀態')), 0.01));
			expect(tester.getCenter(find.byType(KlpIcon)).dy, closeTo(tester.getCenter(find.text('狀態')).dy, 2));
			expect(tester.takeException(), isNull);
		}
	});
}

Widget _specimen(KlpVisualStyle style) {
	final home = const SizedBox(width: 220, child: KlpInlineNotice(title: '狀態', tone: KlpFeedbackTone.info));
	return MaterialApp(key: ValueKey(style.name), theme: buildKlpTheme(Brightness.dark, style: style), home: home);
}

double _baseline(WidgetTester tester, Finder finder) {
	final text = tester.widget<Text>(finder);
	final painter = TextPainter(text: TextSpan(text: text.data, style: text.style), textDirection: TextDirection.ltr)..layout();
	return tester.getTopLeft(finder).dy + painter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
}
