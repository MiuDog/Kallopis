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
        if (RegExp(r'Duration\(milliseconds:').hasMatch(
          file.readAsStringSync(),
        )) {
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
}
