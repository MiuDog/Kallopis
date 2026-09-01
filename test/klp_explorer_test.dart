import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  Widget buildExplorer({
    bool allowNesting = true,
    ValueChanged<String>? onNodeSelected,
  }) {
    return MaterialApp(
      theme: buildKlpTheme(Brightness.light),
      home: Scaffold(
        body: SizedBox(
          width: 320,
          height: 520,
          child: KlpExplorer(
            allowNesting: allowNesting,
            onNodeSelected: onNodeSelected,
            categories: const [
              KlpExplorerCategory(
                id: 'foundation',
                label: 'Foundation',
                nodes: [
                  KlpExplorerNode(
                    id: 'tokens',
                    label: 'Design Tokens',
                    kind: KlpExplorerNodeKind.folder,
                    expanded: true,
                    children: [
                      KlpExplorerNode(
                        id: 'colors',
                        label: 'Colors',
                        kind: KlpExplorerNodeKind.file,
                      ),
                    ],
                  ),
                  KlpExplorerNode(
                    id: 'guides',
                    label: 'Guides',
                    kind: KlpExplorerNodeKind.file,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('owns the category and nested explorer layout', (tester) async {
    await tester.pumpWidget(buildExplorer());

    expect(find.byType(KlpFileExplorerFolderView), findsOneWidget);
    expect(find.text('Colors'), findsOneWidget);

    final categoryText = find.widgetWithText(KlpText, 'Foundation');
    final categoryPressable = find.ancestor(
      of: categoryText,
      matching: find.byType(KlpPressable),
    );
    final explorer = find.byType(KlpExplorer);
    final text = tester.widget<KlpText>(categoryText);

    expect(text.role, KlpTextRole.caption);
    expect(
      tester.getSize(categoryPressable).width,
      tester.getSize(explorer).width,
    );
    expect(
      tester.getTopLeft(categoryPressable).dy,
      tester.getTopLeft(explorer).dy,
    );
  });

  testWidgets('flattens folder and file nodes when nesting is disabled', (
    tester,
  ) async {
    String? selectedId;
    await tester.pumpWidget(
      buildExplorer(
        allowNesting: false,
        onNodeSelected: (id) => selectedId = id,
      ),
    );

    expect(find.byType(KlpFileExplorerFolderView), findsNothing);
    expect(find.text('Design Tokens'), findsOneWidget);
    expect(find.text('Colors'), findsOneWidget);
    expect(find.text('Guides'), findsOneWidget);

    await tester.tap(find.text('Colors'));
    expect(selectedId, 'colors');
  });

  testWidgets('categories can be collapsed', (tester) async {
    await tester.pumpWidget(buildExplorer());

    await tester.tap(find.text('Foundation'));
    await tester.pumpAndSettle();

    expect(find.text('Foundation'), findsOneWidget);
    expect(find.text('Design Tokens'), findsNothing);
    expect(find.text('Colors'), findsNothing);
    expect(find.text('Guides'), findsNothing);
  });
}
