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
}
