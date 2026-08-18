import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `ThemeExtension` 的完整性閘門。
///
/// Flutter 用 `==` 判斷 theme 有沒有變。**漏比一個欄位，改那個 token 就不會觸發重建**
/// ——畫面不動、不拋錯、analyze 不抗議，看起來就像那個 token 沒有生效。
///
/// 這道檢查是實測出來的：某次 token 擴充後，`KlpSpacingTheme` 有 42 個欄位而 `==` 只比 4 個，
/// `KlpThemeData` 與 `KlpDataVisualizationTheme` 甚至完全沒有定義 `==`。當時所有測試全綠。
void main() {
  final files = Directory('lib/src/theme')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  final fieldPattern = RegExp(r'^  final [\w<>?, ]+ (\w+);', multiLine: true);

  for (final file in files) {
    final source = file.readAsStringSync();
    if (!source.contains('extends ThemeExtension')) continue;

    final name = file.uri.pathSegments.last;
    final fields = fieldPattern
        .allMatches(source)
        .map((m) => m.group(1)!)
        .where((f) => !f.startsWith('_'))
        .toList();

    if (fields.isEmpty) continue;

    test('$name 的 == 涵蓋每一個欄位', () {
      final missing = fields
          .where(
            (f) =>
                !source.contains('$f == other.$f') &&
                !source.contains('listEquals($f, other.$f)'),
          )
          .toList();

      expect(
        missing,
        isEmpty,
        reason:
            '$name 有 ${fields.length} 個欄位，但這些沒有出現在 == 裡：\n'
            '${missing.join('、')}\n'
            '漏比的欄位改了之後 Flutter 不會重建——token 看起來沒有生效。',
      );
    });

    test('$name 的 hashCode 涵蓋每一個欄位', () {
      final start = source.indexOf('int get hashCode');
      expect(start, greaterThan(0), reason: '$name 沒有定義 hashCode');

      final end = source.indexOf(');', start);
      final body = source.substring(start, end < 0 ? source.length : end);

      final missing = fields
          .where((f) => !RegExp(r'(?<![\w.])' + f + r'(?![\w])').hasMatch(body))
          .toList();

      expect(
        missing,
        isEmpty,
        reason:
            '$name 的 hashCode 沒有涵蓋：${missing.join('、')}\n'
            'hashCode 與 == 不一致會讓相等的物件落在不同的雜湊桶。',
      );
    });

    test('$name 的 copyWith 涵蓋每一個欄位', () {
      final marker = RegExp(r'\n  \w+ copyWith\(');
      final m = marker.firstMatch(source);
      expect(m, isNotNull, reason: '$name 沒有定義 copyWith');

      final body = source.substring(m!.start);
      // 容忍換行：formatter 會把過長的指派折成兩行，精確字串比對會誤報，
      // 而會誤報的閘門沒有人會信。
      final missing = fields
          .where(
            (f) => !RegExp(
              '$f'
              r'\s*:\s*'
              '$f'
              r'\s*\?\?\s*this\.'
              '$f',
            ).hasMatch(body),
          )
          .toList();

      expect(
        missing,
        isEmpty,
        reason:
            '$name 的 copyWith 沒有涵蓋：${missing.join('、')}\n'
            '漏掉的欄位在 copyWith 之後會靜默回到預設值。',
      );
    });
  }
}
