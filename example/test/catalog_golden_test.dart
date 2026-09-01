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
/// **這些圖證明什麼**：截的是 [CatalogShell] 的完整畫面（導覽 ＋ 內容區），
/// 而且**視窗高度由每一頁自己的內容決定**——先用一個高視窗量出該頁需要多高，
/// 再用那個高度截圖。因此不存在「捲動線以下沒被涵蓋」的死角，圖檔也不會為了
/// 遷就最長的那一頁而全部變大。
///
/// 先前用固定的 1400×900，實測有十頁的內容落在捲動線以下，最長的一頁有 4793px
/// 沒被涵蓋——那等於那些元件根本沒有像素級把關。
///
/// 更新基準前先確認畫面**應該**要變。golden 紅了預設是回歸，不是基準過期。
/// 基準視窗寬度。導覽 260 ＋ 內容區，接近實際使用的桌面寬度。
const double _width = 1400;

/// 基準視窗高度。內容比這個矮的頁面就用這個高度，避免圖檔底部一片空白。
const double _baseHeight = 900;

/// 基準高度上限。`Layout & Interaction` 有一個巢狀的虛擬清單，
/// 它回報的可捲動長度是十六萬 px——那是虛擬化的假象，不是真的要畫那麼長。
const double _maxHeight = 6000;

/// 內容區還差多少高度才裝得下。
///
/// 取所有可捲動區域中最大的 `maxScrollExtent`。側欄本身也是可捲動的，因此短頁面
/// 量到的其實是側欄——這正是我們要的：基準必須連側欄也完整涵蓋。
double _stageOverflow(WidgetTester tester) {
  double overflowFor(Key key) {
    final scrollable = find.descendant(
      of: find.byKey(key),
      matching: find.byType(Scrollable),
    );
    final position = tester.state<ScrollableState>(scrollable.first).position;
    return position.hasContentDimensions ? position.maxScrollExtent : 0;
  }

  return [
    overflowFor(const ValueKey('catalog-navigation-scroll')),
    overflowFor(const ValueKey('catalog-stage-scroll')),
  ].reduce((largest, value) => value > largest ? value : largest);
}

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
    final icons = FontLoader('packages/kallopis/${KlpIcon.fontFamily}')
      ..addFont(
        rootBundle.load(
          'packages/kallopis/assets/fonts/FlaticonUIcons-RegularRounded.ttf',
        ),
      );
    await icons.load();
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
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        Future<void> pumpAt(double height) async {
          tester.view.physicalSize = Size(_width, height);
          await tester.pumpWidget(
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: buildKlpTheme(brightness),
              home: CatalogShell(
                groups: catalogGroups,
                pages: catalogPages,
                selected: index,
                onSelected: (_) {},
              ),
            ),
          );
          // 不用 pumpAndSettle：目錄裡有不會結束的動畫（spinner、不定量進度）。
          // 測試綁定用的是假時鐘，固定推進同樣的時間就會停在同一幀，仍是決定性的。
          await tester.pump(const Duration(milliseconds: 200));
        }

        // 第一趟只為量高度。**必須在基準高度下量**——溢出是相對於視窗的，
        // 在一個一定裝得下的高視窗裡量，答案永遠是 0。
        await pumpAt(_baseHeight);
        final overflow = _stageOverflow(tester);

        // 第二趟才是基準。夾在上下限之間：太矮會漏內容，太高會讓圖檔為了
        // 一頁病態的巢狀虛擬清單而爆掉。
        final height = (_baseHeight + overflow).clamp(_baseHeight, _maxHeight);
        await pumpAt(height.toDouble());

        // 截圖前先確認這一頁真的整個裝進來了。少了這道斷言，「基準涵蓋整頁」
        // 就只是一個推論——高度算錯時圖仍然會產生，只是底部悄悄少一截。
        if (height < _maxHeight) {
          expect(
            _stageOverflow(tester),
            0,
            reason:
                '${page.label} 在 ${height}px 高的視窗下仍有內容在捲動線以下，'
                '基準不完整。',
          );
        }

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
