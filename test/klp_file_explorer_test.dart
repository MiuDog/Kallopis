import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('KlpFileExplorer 可將沒有子項目的節點明確呈現為資料夾', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const Scaffold(
          body: KlpFileExplorer(
            sections: [
              KlpFileExplorerSection(
                id: 'pages',
                title: '頁面',
                items: [
                  KlpFileExplorerItem(
                    id: 'empty-folder',
                    label: '空資料夾',
                    folder: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(KlpFileExplorerFolderView), findsOneWidget);
    expect(find.byType(KlpFileExplorerItemView), findsNothing);
  });

  testWidgets('KlpFileExplorer 支援分類折疊、資料夾樹狀展開與檔案項目選取', (tester) async {
    String? selectedId = 'file-1';

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => KlpFileExplorer(
              selectedId: selectedId,
              onItemSelected: (id) => setState(() => selectedId = id),
              sections: const [
                KlpFileExplorerSection(
                  id: 'sec-1',
                  title: '筆記',
                  items: [
                    KlpFileExplorerItem(
                      id: 'folder-1',
                      label: '規格文件',
                      children: [
                        KlpFileExplorerItem(
                          id: 'file-1',
                          label: 'ADR-0001 : Page-first',
                        ),
                        KlpFileExplorerItem(
                          id: 'file-2',
                          label: 'ADR-0002 : 保留 Project',
                        ),
                      ],
                    ),
                    KlpFileExplorerItem(id: 'file-3', label: 'ADR-0003 : 團隊導向'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // 初始狀態：包含分類「筆記」、資料夾「規格文件」、檔案「ADR-0003」
    expect(find.text('筆記'), findsOneWidget);
    final sectionText = tester.widget<KlpText>(
      find.widgetWithText(KlpText, '筆記'),
    );
    expect(sectionText.role, KlpTextRole.caption);
    final type = tester.element(find.text('筆記')).klp.type;
    final sectionDefinition = KlpTextStyles.definitionOf(
      sectionText.role,
      type,
    );
    expect(sectionDefinition.fontSize, type.caption);
    expect(sectionDefinition.family, KlpFontRole.ui);
    expect(find.text('規格文件'), findsOneWidget);
    expect(find.text('ADR-0003 : 團隊導向'), findsOneWidget);
    // 子檔案尚未展開
    expect(find.text('ADR-0001 : Page-first'), findsNothing);

    // 展開資料夾「規格文件」
    await tester.tap(find.text('規格文件'));
    await tester.pumpAndSettle();

    // 展開後能看到子檔案
    expect(find.text('ADR-0001 : Page-first'), findsOneWidget);
    expect(find.text('ADR-0002 : 保留 Project'), findsOneWidget);

    final context = tester.element(find.byType(KlpFileExplorer));
    final sectionAndFolderChevrons = find.byWidgetPredicate(
      (widget) => widget is KlpIcon && widget.icon == KlpIcons.chevronDown,
    );
    expect(sectionAndFolderChevrons, findsNWidgets(2));
    expect(
      tester.getTopLeft(sectionAndFolderChevrons.at(1)).dx,
      tester.getTopLeft(sectionAndFolderChevrons.at(0)).dx,
    );
    expect(
      tester.getTopLeft(find.text('ADR-0001 : Page-first')).dx -
          tester.getTopLeft(find.text('ADR-0003 : 團隊導向')).dx,
      context.klp.space.tight,
    );

    // 點擊檔案「ADR-0002」進行選取
    await tester.tap(find.text('ADR-0002 : 保留 Project'));
    await tester.pumpAndSettle();

    expect(selectedId, 'file-2');
    // 選取現在以高亮色表達，不再畫虛線框。
    expect(
      find.byKey(const ValueKey('klp-state-highlight')),
      findsWidgets,
      reason: '選取應該疊上 KlpStateHighlight 的高亮層',
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.text('ADR-0003 : 團隊導向')));
    await tester.pump();

    // hover 現在以高亮色表達，不再畫虛線框。
    expect(
      find.byKey(const ValueKey('klp-state-highlight')),
      findsWidgets,
      reason: 'hover 應該疊上 KlpStateHighlight 的高亮層',
    );

    // 點擊分類「筆記」進行收合
    await tester.tap(find.text('筆記'));
    await tester.pumpAndSettle();

    // 收合後項目不可見
    expect(find.text('規格文件'), findsNothing);
    expect(find.text('ADR-0003 : 團隊導向'), findsNothing);
  });

  testWidgets('explorer rows use the extra-small control height semantic', (
    tester,
  ) async {
    final style = KlpVisualStyle.defaultStyle.copyWith(
      spacing: KlpSpacingTheme.comfortableDensity.copyWith(
        controlHeightXSmall: 24,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light, style: style),
        home: const Scaffold(
          body: KlpFileExplorer(
            sections: [
              KlpFileExplorerSection(
                id: 'pages',
                title: '頁面',
                collapsible: false,
                items: [
                  KlpFileExplorerItem(id: 'folder', label: '資料夾', folder: true),
                  KlpFileExplorerItem(id: 'file', label: '檔案'),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final context = tester.element(find.byType(KlpFileExplorer));
    final space = context.klp.space;
    final adjustment =
        context.klp.geometry.control.fileExplorerRowHeightAdjustment;

    expect(
      tester.getSize(find.byType(KlpFileExplorerFolderView)).height,
      space.controlHeightXSmall + space.hairline * 2,
    );
    expect(
      tester.getSize(find.byType(KlpFileExplorerItemView)).height,
      space.controlHeightXSmall + adjustment + space.hairline * 2,
    );
  });

  testWidgets('folder and file icons align at every shared nesting level', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const Scaffold(
          body: KlpFileExplorer(
            sections: [
              KlpFileExplorerSection(
                id: 'design',
                title: 'DESIGN',
                items: [
                  KlpFileExplorerItem(
                    id: 'root-folder',
                    label: 'Root folder',
                    folder: true,
                    expanded: true,
                    icon: KlpIcons.folder,
                    children: [
                      KlpFileExplorerItem(
                        id: 'nested-folder',
                        label: 'Nested folder',
                        folder: true,
                        icon: KlpIcons.archive,
                      ),
                      KlpFileExplorerItem(
                        id: 'nested-file',
                        label: 'Nested file',
                        icon: KlpIcons.bookmark,
                      ),
                    ],
                  ),
                  KlpFileExplorerItem(
                    id: 'root-file',
                    label: 'Root file',
                    icon: KlpIcons.clipboard,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    Finder icon(KlpIconData data) => find.byWidgetPredicate(
      (widget) => widget is KlpIcon && widget.icon.codePoint == data.codePoint,
    );

    final rootFolder = icon(KlpIcons.folder);
    final rootFile = icon(KlpIcons.clipboard);
    final nestedFolder = icon(KlpIcons.archive);
    final nestedFile = icon(KlpIcons.bookmark);
    final context = tester.element(find.byType(KlpFileExplorer));

    for (final finder in [rootFolder, rootFile, nestedFolder, nestedFile]) {
      expect(finder, findsOneWidget);
    }
    final rootFolderView = find.byWidgetPredicate(
      (widget) =>
          widget is KlpFileExplorerFolderView &&
          widget.item.id == 'root-folder',
    );
    final rootFileView = find.byWidgetPredicate(
      (widget) =>
          widget is KlpFileExplorerItemView && widget.item.id == 'root-file',
    );
    Finder leadingArea(Finder view) => find.descendant(
      of: view,
      matching: find.byKey(const ValueKey('klp-file-explorer-leading-area')),
    );
    Finder contentArea(Finder view) => find.descendant(
      of: view,
      matching: find.byKey(const ValueKey('klp-file-explorer-content-area')),
    );

    expect(leadingArea(rootFolderView), findsOneWidget);
    expect(leadingArea(rootFileView), findsOneWidget);
    expect(
      find.descendant(
        of: leadingArea(rootFolderView),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is KlpIcon &&
              widget.icon.codePoint == KlpIcons.chevronDown.codePoint,
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: leadingArea(rootFileView),
        matching: find.byType(KlpIcon),
      ),
      findsNothing,
    );
    expect(
      tester.getTopLeft(contentArea(rootFolderView)).dx,
      tester.getTopLeft(rootFolder).dx,
    );
    expect(
      tester.getTopLeft(contentArea(rootFileView)).dx,
      tester.getTopLeft(rootFile).dx,
    );
    expect(tester.getTopLeft(rootFolder).dx, tester.getTopLeft(rootFile).dx);
    expect(
      tester.getTopLeft(nestedFolder).dx,
      tester.getTopLeft(nestedFile).dx,
    );
    expect(
      tester.getTopLeft(nestedFolder).dx - tester.getTopLeft(rootFolder).dx,
      context.klp.space.tight,
    );
  });

  testWidgets('only one item is selected and sidebar foreground rules apply', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: const Scaffold(
          body: KlpFileExplorer(
            sections: [
              KlpFileExplorerSection(
                id: 'design',
                title: 'DESIGN',
                items: [
                  KlpFileExplorerItem(
                    id: 'first',
                    label: 'First',
                    icon: KlpIcons.clipboard,
                    selected: true,
                  ),
                  KlpFileExplorerItem(
                    id: 'second',
                    label: 'Second',
                    icon: KlpIcons.bookmark,
                    selected: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final items = tester.widgetList<KlpFileExplorerItemView>(
      find.byType(KlpFileExplorerItemView),
    );
    expect(items.where((item) => item.isSelected).length, 1);
    expect(items.first.isSelected, isTrue);
    expect(items.last.isSelected, isFalse);

    final first = find.byWidgetPredicate(
      (widget) =>
          widget is KlpFileExplorerItemView && widget.item.id == 'first',
    );
    final second = find.byWidgetPredicate(
      (widget) =>
          widget is KlpFileExplorerItemView && widget.item.id == 'second',
    );
    final context = tester.element(first);
    final category = tester.widget<KlpText>(
      find.widgetWithText(KlpText, 'DESIGN'),
    );
    final firstText = tester.widget<KlpText>(
      find.descendant(
        of: first,
        matching: find.widgetWithText(KlpText, 'First'),
      ),
    );
    final secondText = tester.widget<KlpText>(
      find.descendant(
        of: second,
        matching: find.widgetWithText(KlpText, 'Second'),
      ),
    );
    final firstIcon = tester.widget<KlpIcon>(
      find.descendant(of: first, matching: find.byType(KlpIcon)),
    );
    final secondIcon = tester.widget<KlpIcon>(
      find.descendant(of: second, matching: find.byType(KlpIcon)),
    );

    expect(category.tone, KlpTextTone.muted);
    expect(firstText.color, context.klpColors.text);
    expect(secondText.color, context.klpColors.text);
    expect(firstIcon.color, context.klpColors.text);
    expect(secondIcon.color, context.klpColors.textMuted);
    expect(
      tester
          .widget<KlpStateHighlight>(
            find.descendant(
              of: first,
              matching: find.byType(KlpStateHighlight),
            ),
          )
          .state,
      KlpHighlightState.hover,
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(second));
    await tester.pump();
    expect(
      tester
          .widget<KlpStateHighlight>(
            find.descendant(
              of: second,
              matching: find.byType(KlpStateHighlight),
            ),
          )
          .state,
      KlpHighlightState.hover,
    );
  });
}
