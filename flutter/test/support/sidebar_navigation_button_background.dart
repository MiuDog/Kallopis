import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// 讀取 Sidebar navigation button primitive 的實際背景色。
Color sidebarNavigationButtonBackground(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(KlpSidebarNavigationButton),
          matching: find.byType(Container),
        )
        .first,
  );

  return (container.decoration! as BoxDecoration).color!;
}
