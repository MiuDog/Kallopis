import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('password field 使用 Kallopis input 切換遮罩並派送輸入', (tester) async {
    String? changed;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpPasswordField(
          label: 'Password',
          value: 'secret',
          onChanged: (value) => changed = value,
        ),
      ),
    );

    expect(find.byType(KlpTextField), findsOneWidget);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isTrue,
    );
    expect(find.bySemanticsLabel('顯示密碼'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('顯示密碼'));
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isFalse,
    );
    expect(find.bySemanticsLabel('隱藏密碼'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'updated');
    expect(changed, 'updated');
  });

  testWidgets('password requirements 與錯誤使用語意文字 tone', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const KlpPasswordField(
          label: 'Password',
          required: true,
          error: 'Password is required',
          requirements: [
            KlpPasswordRequirement(
              label: 'At least 8 characters',
              satisfied: true,
            ),
            KlpPasswordRequirement(
              label: 'Contains a number',
              satisfied: false,
            ),
          ],
        ),
      ),
    );

    final satisfied = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'At least 8 characters',
      ),
    );
    final pending = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'Contains a number',
      ),
    );
    final error = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'Password is required',
      ),
    );
    expect(satisfied.tone, KlpTextTone.success);
    expect(pending.tone, KlpTextTone.muted);
    expect(error.tone, KlpTextTone.danger);
    expect(find.text('*'), findsOneWidget);
  });

  testWidgets('disabled password action 保留 disabled semantics 且不切換遮罩', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const KlpPasswordField(label: 'Password', enabled: false),
      ),
    );

    final semantics = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == '顯示密碼',
      ),
    );
    expect(semantics.properties.enabled, isFalse);
    final action = tester.widget<GestureDetector>(
      find.descendant(
        of: find.byWidget(semantics),
        matching: find.byType(GestureDetector),
      ),
    );
    expect(action.onTap, isNull);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isTrue,
    );
  });
}
