import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

void main() {
  testWidgets('sidebar button group owns chrome inset and button style', (
    tester,
  ) async {
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: SizedBox(
            width: 240,
            child: KlpSidebarButtonGroup(
              items: [
                KlpSidebarButtonData(
                  label: 'Assistant',
                  icon: KlpIcons.sparkles,
                  onPressed: () {},
                  selected: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final group = find.byType(KlpSidebarButtonGroup);
    final padding = tester.widget<Padding>(
      find.descendant(of: group, matching: find.byType(Padding)).first,
    );
    final button = tester.widget<KlpSidebarNavigationButton>(
      find.byType(KlpSidebarNavigationButton),
    );
    final space = tester.element(group).klp.space;

    expect(padding.padding, EdgeInsets.all(space.chromePanelInset));
    expect(button.label, 'Assistant');
    expect(button.selected, isTrue);
  });
}
