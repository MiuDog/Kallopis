import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// dartdoc 交叉引用的閘門。
///
/// `[KlpFoo]` 這種引用寫錯不會有任何東西報錯：`flutter analyze` 不驗證註解內容，
/// 測試也不會紅，dartdoc 產生的頁面只是少一個連結。它唯一的後果是——讀文件的人
/// 照著去找一個不存在的型別。
///
/// 這個閘門的由來：補文件時有一處寫了 `[KlpThemeScope.hoverBorder]`，而那個型別
/// 從來不存在（實際叫 `KlpTheme`）。錯的文件比沒有文件更糟，因為它會被相信。
void main() {
  test('dartdoc 裡的型別引用都指向真的存在的型別', () {
    final sources = Directory('lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList();

    // 先蒐集實際宣告的型別名。
    final declared = <String>{};
    final declaration = RegExp(
      r'^(?:abstract |final |sealed |base |mixin )*'
      r'(?:class|enum|extension|typedef|mixin)\s+(\w+)',
      multiLine: true,
    );
    for (final file in sources) {
      for (final match in declaration.allMatches(file.readAsStringSync())) {
        declared.add(match.group(1)!);
      }
    }

    expect(declared, isNotEmpty, reason: '沒有解析到任何型別，這個閘門本身失效了');

    // 只驗證型別名。成員名（尤其 enum 常數）要正確解析需要一個真的 parser，
    // 而半套的解析會誤報——會誤報的閘門沒有人會信。
    final reference = RegExp(r'\[(Klp\w+)(?:\.\w+)?\]');
    final broken = <String>[];

    for (final file in sources) {
      final path = file.path.replaceAll(r'\', '/');
      final lines = file.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (!lines[i].contains('///')) continue;
        for (final match in reference.allMatches(lines[i])) {
          if (!declared.contains(match.group(1))) {
            broken.add('$path:${i + 1}  ${match.group(0)}');
          }
        }
      }
    }

    expect(
      broken,
      isEmpty,
      reason:
          'dartdoc 引用了不存在的型別：\n${broken.join('\n')}\n'
          '讀文件的人會照著去找它。',
    );
  });
}
