import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('multi-select 回傳下一個受控集合並忽略停用選項', (tester) async {
    Set<String>? nextSelection;

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(
            child: KlpMultiSelectField(
              label: 'Sports',
              options: const [
                KlpChoiceOption(id: 'football', label: 'Football'),
                KlpChoiceOption(
                  id: 'basketball',
                  label: 'Basketball',
                  disabled: true,
                ),
              ],
              selectedIds: const {'football'},
              onChanged: (value) => nextSelection = value,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Football'));
    expect(nextSelection, isEmpty);

    nextSelection = null;
    await tester.tap(find.text('Basketball'));
    expect(nextSelection, isNull);
    expect(find.byType(KlpWrap), findsOneWidget);
  });

  testWidgets('status swatches 派送 typed role 並標示受控選取', (tester) async {
    KlpStatusRole? selected;

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(
            child: KlpStatusRoleSwatches(
              label: 'Status',
              selectedRole: KlpStatusRole.success,
              onSelectRole: (role) => selected = role,
            ),
          ),
        ),
      ),
    );

    final success = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'SUCCESS',
      ),
    );
    expect(success.tone, KlpTextTone.primary);

    await tester.tap(find.text('DANGER'));
    expect(selected, KlpStatusRole.danger);
  });
}
