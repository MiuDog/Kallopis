import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// 這組測試是 token 架構的閘門。
///
/// 「不要硬編碼風格」寫在文件裡只是承諾；承諾不會擋下任何一次提交。這裡把它變成
/// 機械判準：新增的硬編碼會讓測試失敗，而既有的欠債列在 allowlist 裡——數量只能減少，
/// 不能增加。
void main() {
  final sourceFiles = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  String relative(File file) => file.path.replaceAll(r'\', '/');

  group('顏色只能定義在 primitive 層', () {
    // 唯一允許出現 Color(0x…) 的地方。
    const primitiveLayer = {
      'lib/src/foundation/klp_palette.dart',
      'lib/src/theme/klp_data_visualization_theme.dart',
      'lib/src/foundation/klp_accent.dart',
    };

    // 抽取自 Planist 時的欠債已全數清空。**這個集合只能維持為空。**
    // 若不得不再加入項目，必須在同一次提交寫明何時移除。
    const knownOffenders = <String>{};

    test('沒有新的元件直接寫 Color(0x…)', () {
      final violations = <String>[];

      for (final file in sourceFiles) {
        final path = relative(file);
        if (primitiveLayer.contains(path) || knownOffenders.contains(path)) {
          continue;
        }
        if (RegExp(r'Color\(0x').hasMatch(file.readAsStringSync())) {
          violations.add(path);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            '這些檔案直接寫死了顏色。顏色必須取自 KlpPalette（primitive）或\n'
            'context.klpColors（semantic）——寫死的顏色在換 theme 時不會跟著變，\n'
            '而且不會有任何錯誤訊息告訴你它沒變：\n${violations.join('\n')}',
      );
    });

    test('allowlist 沒有殘留已修好的項目', () {
      final stale = knownOffenders.where((path) {
        final file = File(path);
        if (!file.existsSync()) return true;
        return !RegExp(r'Color\(0x').hasMatch(file.readAsStringSync());
      }).toList();

      expect(
        stale,
        isEmpty,
        reason:
            '這些檔案已經不再硬編碼顏色，請從 knownOffenders 移除，\n'
            '否則 allowlist 會變成永久豁免：\n${stale.join('\n')}',
      );
    });
  });

  group('時長只能定義在 primitive 與 motion 層', () {
    const motionLayer = {
      'lib/src/tokens/klp_scale.dart',
      'lib/src/theme/klp_motion_theme.dart',
    };

    const knownOffenders = <String>{};

    test('沒有新的元件直接寫 Duration(milliseconds:…)', () {
      final violations = <String>[];

      for (final file in sourceFiles) {
        final path = relative(file);
        if (motionLayer.contains(path) || knownOffenders.contains(path)) {
          continue;
        }
        if (RegExp(
          r'Duration\(milliseconds:',
        ).hasMatch(file.readAsStringSync())) {
          violations.add(path);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            '這些檔案直接寫死了動畫時長。時長必須取自 context.klp.motion——\n'
            '寫死的 duration 不會出錯，只會讓兩個看起來一樣的元件動得不一樣快：\n'
            '${violations.join('\n')}',
      );
    });
  });

  test('元件不直接參照 primitive 層的 KlpScale', () {
    // KlpScale 是給 semantic 層組裝用的字彙表。元件跳過 semantic 直接讀 primitive，
    // 等於繞過整個繼承樹——值會正確，但消費者覆寫 theme 時它不會跟著變。
    final violations = <String>[];

    for (final file in sourceFiles) {
      final path = relative(file);
      if (path.startsWith('lib/src/tokens/') ||
          path.startsWith('lib/src/theme/')) {
        continue;
      }
      if (RegExp(r'\bKlpScale\.').hasMatch(file.readAsStringSync())) {
        violations.add(path);
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          '這些元件直接讀 primitive token，跳過了 semantic 層：\n'
          '${violations.join('\n')}',
    );
  });

  test('舊 static token 的引用數只能下降', () {
    // 抽取自 Planist 時元件層有 515 處引用 KlpSpace／KlpRadius 這類編譯期常數。值正確，
    // 但**不會隨 theme 改變**——當時 terminal 風格下 toggle 仍是膠囊形就是這個原因。
    //
    // 目前剩 16 處，全部是刻意保留的：
    //   - 面板寬度與 responsive 斷點（版面預設值，消費者以 widget 參數覆寫，不是風格）
    //   - 選單幾何（要在 build 之前算彈出位置，取不到 context）
    //   - 視窗透明度（屬於色彩層自身）
    //   - dense 變體的固定高度與單一 glyph 尺寸
    //
    // 新增靜態引用一律視為回退。真要加，必須在同一次提交寫明它為什麼不是風格。
    const baseline = 16;

    final pattern = RegExp(
      r'(KlpRadius|KlpSpace|KlpSize|KlpTypography|KlpInsets|KlpMotion|'
      r'KlpLayoutGap|KlpLine|KlpElevation|KlpInteraction|KlpTransparency)\.',
    );

    var count = 0;
    for (final file in sourceFiles) {
      count += pattern.allMatches(file.readAsStringSync()).length;
    }

    expect(
      count,
      lessThanOrEqualTo(baseline),
      reason:
          '舊 static token 的引用數從 $baseline 增加到 $count。'
          '新程式碼請改讀 context.klp——static const 不會隨 theme 改變，'
          '而且不會有任何錯誤訊息告訴你它沒變。',
    );

    // 降下去後忘記調低 baseline，棘輪會停在舊刻度上，之後的回退就不會被擋下。
    expect(
      count,
      greaterThanOrEqualTo(baseline - 4),
      reason: '引用數已降到 $count，請把 baseline 一併調低到這個數字。',
    );
  });

  test('元件裡的尺寸與透明度字面值只能減少', () {
    // 寫死一個 `height: 10` 或 `alpha: 0.16` 不會出錯、不會被 analyze 抓到、換主題時
    // 也不會拋例外——它只是不跟著變。這正是最難發現的一類風格漂移。
    //
    // 目前剩 3 處，全部在 KlpThemePreviewTile：那個元件畫的是一張「視窗的圖」，
    // 這些透明度是插圖的繪製參數（等同 SVG 裡的座標），不是產品表面的風格。
    // 把它們搬進 theme 反而會宣稱它們可被覆寫，而覆寫它們只會讓那張圖畫錯。
    const baseline = 3;

    final pattern = RegExp(
      r'(?:width|height|dimension|size|alpha)\s*:\s*(?:const\s+)?'
      r'\d+(?:\.\d+)?\s*[,)]',
    );

    final offenders = <String>[];
    for (final file in sourceFiles) {
      final lines = file.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (pattern.hasMatch(lines[i])) {
          offenders.add('${relative(file)}:${i + 1}  ${lines[i].trim()}');
        }
      }
    }

    expect(
      offenders.length,
      lessThanOrEqualTo(baseline),
      reason:
          '元件裡的尺寸／透明度字面值從 $baseline 增加到 ${offenders.length}：\n'
          '${offenders.join('\n')}\n'
          '請改成 context.klp.space 或 context.klp.surface 上的 token。',
    );

    expect(
      offenders.length,
      greaterThanOrEqualTo(baseline - 1),
      reason: '已降到 ${offenders.length}，請把 baseline 一併調低到這個數字。',
    );
  });

  test('公開型別的 dartdoc 覆蓋率只能上升', () {
    // 抽取自 Planist 時 215 個公開型別只有 3 個有 dartdoc。寫消費者探針時第一次就猜錯
    // 四個建構子簽名——API 只能靠讀原始碼發現，就等於沒有 API。
    //
    // 一次補完不成比例，因此用棘輪：未文件化的數量只能下降。消費者最先碰到的
    // 舊型別補上 dartdoc 時只准調低，不准調高。
    const baseline = 78;

    final declaration = RegExp(
      r'^(?:abstract final class|final class|class|enum) (Klp[A-Za-z]+)',
    );

    var undocumented = 0;
    for (final file in sourceFiles) {
      final lines = const LineSplitter().convert(file.readAsStringSync());
      for (var i = 0; i < lines.length; i++) {
        if (!declaration.hasMatch(lines[i])) continue;
        // 往回跳過標註（`@immutable` 等）——它們夾在 dartdoc 與宣告之間，
        // 只看前一行會把有文件的型別誤判為沒有。
        var j = i - 1;
        while (j >= 0 && lines[j].trimLeft().startsWith('@')) {
          j--;
        }
        final previous = j < 0 ? '' : lines[j].trim();
        if (!previous.startsWith('///')) undocumented++;
      }
    }

    expect(
      undocumented,
      lessThanOrEqualTo(baseline),
      reason:
          '未文件化的公開型別從 $baseline 增加到 $undocumented。'
          '新增公開型別請一併寫 dartdoc——說明它是什麼、以及哪些決定不歸它管。',
    );

    expect(
      undocumented,
      greaterThanOrEqualTo(baseline - 15),
      reason: '已降到 $undocumented，請把 baseline 一併調低到這個數字。',
    );
  });
}
