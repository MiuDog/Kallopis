import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
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
    final selectedBorder = tester.widget<KlpDashedBorder>(
      find.byType(KlpDashedBorder),
    );
    expect(
      selectedBorder.color,
      tester.element(find.byType(KlpFileExplorer)).klp.color.textMuted,
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.text('ADR-0003 : 團隊導向')));
    await tester.pump();

    final borderColors = tester
        .widgetList<KlpDashedBorder>(find.byType(KlpDashedBorder))
        .map((border) => border.color);
    expect(
      borderColors,
      contains(tester.element(find.byType(KlpFileExplorer)).klp.hoverBorder),
    );

    // 點擊分類「筆記」進行收合
    await tester.tap(find.text('筆記'));
    await tester.pumpAndSettle();

    // 收合後項目不可見
    expect(find.text('規格文件'), findsNothing);
    expect(find.text('ADR-0003 : 團隊導向'), findsNothing);
  });
}
