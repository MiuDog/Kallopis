import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis_catalog/catalog/registry.dart';
import 'package:kallopis_catalog/catalog_shell.dart';

/// 每一頁在明暗兩態下的像素基準。
///
/// 在此之前整個 repo 只有 5 張 golden，而庫裡有 160 多個 widget。後果很具體：
/// 一次動到六個檔案的 token 重構，golden 只間接覆蓋其中一個元件，其餘五個的
/// 「畫面沒變」完全沒有像素級證據——只有「build 沒拋錯」的證據，而那證明不了
/// 任何視覺主張。
///
/// 這個庫的核心承諾是「只修改 theme 就能換一套視覺風格」。那個承諾能不能被驗證，
/// 完全取決於有沒有東西會在畫面變了的時候紅起來。
///
/// **這些圖證明什麼、不證明什麼**：截的是 [CatalogShell] 在 1400×900 視窗下的完整
/// 畫面，也就是使用者實際看到的東西（導覽 ＋ 內容區）。內容比視窗高的頁面，捲動線
/// 以下的部分不在基準內——所以它抓得到 token 層級的整體改變，抓不到只發生在長頁面
/// 下半部的局部改變。要補那一塊得改成逐 specimen 截圖，那是另一個量級的工程。
///
/// 更新基準前先確認畫面**應該**要變。golden 紅了預設是回歸，不是基準過期。
void main() {
  setUpAll(() async {
    // 不載入字型的話文字會渲染成方塊，基準就失去意義。
    if (KlpTypographyTheme.proportional.sansFamily.isNotEmpty) {
      final sans = FontLoader(KlpTypographyTheme.proportional.sansFamily)
        ..addFont(
          rootBundle.load(
            'packages/kallopis/assets/fonts/IBMPlexSansTC-Regular.ttf',
          ),
        );
      await sans.load();
    }
    if (KlpTypographyTheme.proportional.monoFamily.isNotEmpty) {
      final mono = FontLoader(KlpTypographyTheme.proportional.monoFamily)
        ..addFont(
          rootBundle.load(
            'packages/kallopis/assets/fonts/IBMPlexMono-Regular.ttf',
          ),
        );
      await mono.load();
    }
  });

  /// 檔名用頁面標籤推導，改了標籤就會找不到基準——那是刻意的，
  /// 標籤是頁面的身分，換了身分本來就該重新確認畫面。
  String slug(String label) => label
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');

  for (var index = 0; index < catalogPages.length; index++) {
    final page = catalogPages[index];

    for (final brightness in Brightness.values) {
      testWidgets('${page.label} · ${brightness.name}', (tester) async {
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: buildKlpTheme(brightness),
            home: CatalogShell(
              groups: catalogGroups,
              pages: catalogPages,
              selected: index,
              onSelected: (_) {},
              onToggleTheme: () {},
            ),
          ),
        );

        // 不用 pumpAndSettle：目錄裡有不會結束的動畫（spinner、不定量進度）。
        // 測試綁定用的是假時鐘，固定推進同樣的時間就會停在同一幀，因此仍是決定性的。
        await tester.pump(const Duration(milliseconds: 200));

        await expectLater(
          find.byType(CatalogShell),
          matchesGoldenFile(
            'goldens/page_${slug(page.label)}_${brightness.name}.png',
          ),
        );
      });
    }
  }
}
