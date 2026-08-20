import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// 這組測試是「庫不替產品決定用什麼語言」這條規則的閘門。
///
/// 見 `lib/src/l10n/klp_localizations.dart` 的 dartdoc、`KlpToast.closeLabel`
/// 與 `KlpCalendar` 的既有慣例。承諾寫在文件裡擋不下下一次提交裡新增的一個
/// 寫死字串——這裡把它變成機械判準。
///
/// ## 掃描範圍與判準
///
/// 掃 `lib/src`（排除 `lib/src/l10n` 自己——那裡本來就該放字串），找兩類字面值：
///
/// 1. 字串字面值裡出現中文字元——庫的消費者不必然說中文。
/// 2. 字串字面值裡出現當圖示用的符號（`×`、`✓`、`✕`、`○`、`⌃`、`⌄`、`•`、`↑`、`↓`
///    等）——這些多半該是 `KlpIcon`，不該是文字。
///
/// **不掃英文 UI 文案**：一般英文字串與例外訊息、識別碼、資產路徑在字面上無法
/// 用正則穩定分辨，硬掃只會製造大量誤報，讓閘門失去可信度。既有的寫死英文文案
/// 已經接上 `KlpLocalizations`（見 `spec/decisions/` 與 commit 紀錄），新增的
/// 英文文案要靠 code review 把關，不是這道閘門的職責。
///
/// ## 排除開發者訊息
///
/// `assert(...)`、`throw XxxError(...)` 與 `toString()` 覆寫都是說給開發者聽的
/// 錯誤訊息，不是使用者看得到的介面文字，不該被這道閘門擋下。判斷方式：找出
/// 命中位置所在的「這個敘述句」（往前找上一個 `;`／`{`／`}`，往後找下一個
/// `;`），如果這段文字包含 `assert(`、`throw `＋型別、或 `toString()`，
/// 視為開發者訊息而排除。
void main() {
  final sourceFiles = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .where((file) => !file.path.replaceAll(r'\', '/').contains('/l10n/'))
      .toList();

  String relative(File file) => file.path.replaceAll(r'\', '/');

  final chinesePattern = RegExp('[\'"][一-鿿]');
  final iconGlyphPattern = RegExp('[\'"][×✓✕○⌃⌄•↑↓✗✔☓✖]');
  final developerMessagePattern = RegExp(
    r'assert\(|throw\s+\w+\(|toString\(\)',
  );
  final statementBoundaryPattern = RegExp(r'[;{}]');

  /// 找出 [content] 裡每個 [matches] 命中點所在的「敘述句」，回傳其中不是
  /// 開發者訊息（assert／throw／toString）的命中點清單。
  List<String> findUserVisibleViolations(
    String path,
    String content,
    RegExp pattern,
  ) {
    final boundaries = statementBoundaryPattern
        .allMatches(content)
        .map((m) => m.start)
        .toList();

    int enclosingStart(int pos) {
      var start = 0;
      for (final boundary in boundaries) {
        if (boundary < pos) {
          start = boundary + 1;
        } else {
          break;
        }
      }
      return start;
    }

    int enclosingEnd(int pos) {
      for (final boundary in boundaries) {
        if (boundary >= pos) return boundary + 1;
      }
      return content.length;
    }

    final violations = <String>[];
    for (final match in pattern.allMatches(content)) {
      final statement = content.substring(
        enclosingStart(match.start),
        enclosingEnd(match.start),
      );
      if (developerMessagePattern.hasMatch(statement)) continue;

      final lineNumber =
          '\n'.allMatches(content, 0).length -
          '\n'.allMatches(content.substring(match.end)).length +
          1;
      violations.add('$path:$lineNumber');
    }
    return violations;
  }

  test('沒有新的元件寫死中文字串', () {
    // 抽取自 Planist 時散落的寫死中文字串已全數接上 KlpLocalizations
    // （見 lib/src/l10n/klp_localizations.dart）。**這個集合只能維持為空。**
    final violations = <String>[];
    for (final file in sourceFiles) {
      violations.addAll(
        findUserVisibleViolations(
          relative(file),
          file.readAsStringSync(),
          chinesePattern,
        ),
      );
    }

    expect(
      violations,
      isEmpty,
      reason:
          '這些位置寫死了中文字串。庫的消費者不必然說中文——文字要嘛透過\n'
          'KlpLocalizations 提供可覆寫的預設值，要嘛（若是開發者訊息）不該被這道\n'
          '閘門判定為使用者可見：\n${violations.join('\n')}',
    );
  });

  test('圖示用符號字面值的數量只能下降', () {
    // 目前庫裡還有一批用純文字符號（'×'、'✓'、'⌄' 等）充當圖示的地方，例如
    // KlpStructuredFields 的排序箭頭、KlpFormControls 的完成勾選。這批屬於
    // 「盤點分類 2」：該不該換成 KlpIcon 是視覺決策，換了就會動 golden，
    // 因此這次只鎖住數量不再增加，不強制清空。
    const baseline = 15;

    var count = 0;
    for (final file in sourceFiles) {
      count += findUserVisibleViolations(
        relative(file),
        file.readAsStringSync(),
        iconGlyphPattern,
      ).length;
    }

    expect(
      count,
      lessThanOrEqualTo(baseline),
      reason:
          '圖示符號字面值從 $baseline 增加到 $count。新的圖示用途請改用 KlpIcon，'
          '不要再用 KlpText 塞一個符號字元。',
    );

    // 降下去後忘記調低 baseline，棘輪會停在舊刻度上，之後的回退就不會被擋下。
    expect(
      count,
      greaterThanOrEqualTo(baseline - 2),
      reason: '已降到 $count，請把 baseline 一併調低到這個數字。',
    );
  });
}
