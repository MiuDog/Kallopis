import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/inventory.dart';

/// `spec/component-inventory.md` 的閘門。
///
/// 一份會過期的架構文件比沒有文件更糟——它看起來仍然權威，但描述的是三個月前的
/// 程式碼，而且沒有任何徵兆告訴你它已經不對了。這裡讓過期變成測試失敗。
void main() {
  final inventory = File('spec/component-inventory.md');

  test('元件清單沒有過期', () {
    expect(
      inventory.existsSync(),
      isTrue,
      reason: '請跑 `dart run tool/inventory.dart`。',
    );

    final expected = generateInventory();
    final actual = inventory.readAsStringSync().replaceAll('\r\n', '\n');

    expect(
      actual,
      expected.replaceAll('\r\n', '\n'),
      reason: '元件清單與程式碼不同步。請跑 `dart run tool/inventory.dart`。',
    );
  });

  test('分層違規只能減少', () {
    // 15 條違規中有 12 條來自 klp_foundation_extras.dart——一個把 17 個類別塞在一起的
    // 雜物袋。它們被歸在 foundation，實際上卻依賴 surface 與 typography，
    // 代表它們根本不是 foundation。這與「布林參數過多」得到的是同一個結論，
    // 但這次是從組合關係獨立推導出來的。
    const baseline = 15;

    final violations = const LineSplitter()
        .convert(inventory.readAsStringSync())
        .skipWhile((l) => !l.startsWith('### 分層違規'))
        .takeWhile((l) => !l.startsWith('## 各領域'))
        .where((l) => l.startsWith('- `'))
        .length;

    expect(
      violations,
      lessThanOrEqualTo(baseline),
      reason:
          '分層違規從 $baseline 增加到 $violations。'
          '底層領域依賴上層代表該型別被歸錯領域——請移到正確的領域，'
          '而不是調整 tool/inventory.dart 的 categoryOrder 來追認現狀。',
    );

    expect(
      violations,
      greaterThanOrEqualTo(baseline - 3),
      reason: '已降到 $violations，請把 baseline 一併調低到這個數字。',
    );
  });
}
