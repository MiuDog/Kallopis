import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// 圖示資產的紀律閘門。
///
/// 圖示是最容易靜默走樣的一類資產：從別處拿一個 svg 丟進來，路徑對、顏色會被
/// colorFilter 蓋掉，看起來完全正常——但如果它畫在 32 的網格上或用 3 的線寬，
/// 排在其他圖示旁邊就是「那一個比較細」或「那一個比較粗」，而且沒有任何東西會報錯。
void main() {
  final assets = <String, String>{};

  setUpAll(() {
    final source = File('lib/src/foundation/klp_icons.dart').readAsStringSync();
    for (final match in RegExp(
      r"(\w+)\s*=\s*\n?\s*'(assets/icons/[^']+)'",
    ).allMatches(source)) {
      assets[match.group(1)!] = match.group(2)!;
    }
  });

  test('KlpIcons 指向的檔案都存在', () {
    expect(assets, isNotEmpty, reason: '沒有解析到任何圖示，這個閘門本身失效了');

    final missing = assets.entries
        .where((e) => !File(e.value).existsSync())
        .map((e) => '${e.key} → ${e.value}')
        .toList();

    expect(
      missing,
      isEmpty,
      reason: '這些圖示的檔案不存在，執行時會是空白：\n${missing.join('\n')}',
    );
  });

  test('所有圖示畫在同一個 24 網格上', () {
    final offGrid = <String>[];

    assets.forEach((name, path) {
      final source = File(path).readAsStringSync();
      final viewBox = RegExp(r'viewBox="([^"]+)"').firstMatch(source)?.group(1);
      if (viewBox != '0 0 24 24') {
        offGrid.add('$name → viewBox="$viewBox"');
      }
    });

    expect(
      offGrid,
      isEmpty,
      reason:
          '這些圖示不在 24 網格上：\n${offGrid.join('\n')}\n'
          '網格不同代表同一個 size 畫出來的筆畫粗細不同——32 網格縮到 24 會細 25%。',
    );
  });

  test('有描邊的圖示線寬一致', () {
    final widths = <String, Set<String>>{};

    assets.forEach((name, path) {
      final source = File(path).readAsStringSync();
      final found = RegExp(
        r'stroke-width="([^"]+)"',
      ).allMatches(source).map((m) => m.group(1)!).toSet();
      // 實心字形（三角形、握把點）本來就沒有描邊，不在這條規則裡。
      if (found.isNotEmpty) widths[name] = found;
    });

    final wrong = widths.entries
        .where((e) => e.value.length != 1 || e.value.single != '2')
        .map((e) => '${e.key} → ${e.value.join('、')}')
        .toList();

    expect(
      wrong,
      isEmpty,
      reason: '這些圖示的線寬不是 2：\n${wrong.join('\n')}\n排在其他圖示旁邊會明顯偏粗或偏細。',
    );
  });

  test('圖示尺寸從 token 取得，不是建構子常數', () {
    // KlpIcon 的 size 預設必須是 null 並在 build 時解析，否則預設值會是編譯期常數，
    // 讀不到 theme。
    final source = File('lib/src/foundation/klp_icon.dart').readAsStringSync();

    expect(source, contains('this.size,'), reason: 'size 不再是可選參數');
    expect(
      source,
      contains('size ?? context.klp.space.icon'),
      reason: 'KlpIcon 沒有在 build 時從 theme 解析尺寸',
    );
  });
}
