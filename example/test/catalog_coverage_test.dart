import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis_catalog/catalog/registry.dart';
import 'package:kallopis_catalog/catalog_shell.dart';

/// 目錄的閘門。
///
/// **列不出來的元件等於不存在。** 一個沒有出現在目錄裡的元件，沒有人會知道它存在、
/// 長什麼樣、該用在哪裡——它會被重新發明一次。因此「每個匯出的 widget 都要被歸類」
/// 是機械檢查，不是自律。
void main() {
  /// 從庫的原始碼直接讀出公開的 widget 名。
  ///
  /// 不用反射：Dart 沒有可靠的執行期型別列舉，而且從原始碼讀才能在**新增元件當下**
  /// 就發現漏歸類，不必等到有人去用它。
  Set<String> exportedWidgets() {
    final declaration = RegExp(
      r'^class\s+(Klp[A-Za-z0-9]+)\s+extends\s+'
      r'(?:StatelessWidget|StatefulWidget)',
    );
    final names = <String>{};

    for (final file in Directory('../lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      for (final line in const LineSplitter().convert(
        file.readAsStringSync(),
      )) {
        final match = declaration.firstMatch(line);
        if (match != null) names.add(match.group(1)!);
      }
    }
    return names;
  }

  test('每一個匯出的 widget 都有被歸類', () {
    final missing = exportedWidgets().difference(catalogedComponents).toList()
      ..sort();

    expect(
      missing,
      isEmpty,
      reason:
          '這些 widget 沒有出現在目錄的任何一頁：\n${missing.join('\n')}\n'
          '請在 example/lib/catalog/ 底下把它加進對應的頁面。',
    );
  });

  test('目錄裡沒有已經不存在的元件', () {
    final exported = exportedWidgets();
    final stale = catalogedComponents.difference(exported).toList()..sort();

    expect(
      stale,
      isEmpty,
      reason:
          '目錄列了這些元件，但庫裡已經沒有了：\n${stale.join('\n')}\n'
          '名字打錯也會出現在這裡——Specimen.name 必須與型別名完全一致。',
    );
  });

  test('沒有重複歸類', () {
    final seen = <String, String>{};
    final duplicates = <String>[];

    for (final page in catalogPages) {
      for (final specimen in page.specimens) {
        final previous = seen[specimen.name];
        if (previous != null) {
          duplicates.add('${specimen.name}：${page.label} 與 $previous');
        } else {
          seen[specimen.name] = page.label;
        }
      }
    }

    expect(
      duplicates,
      isEmpty,
      reason: '同一個元件被歸在多頁，讀者會不知道該看哪一頁：\n${duplicates.join('\n')}',
    );
  });

  test('每一頁都有內容', () {
    final empty = catalogPages
        .where((p) => p.specimens.isEmpty && p.tokenView == null)
        .map((p) => p.label)
        .toList();

    expect(empty, isEmpty, reason: '這些頁面既沒有元件也沒有 token 視圖：$empty');
  });

  test('示範覆蓋率只能上升', () {
    // 有歸類但還沒寫示範的元件。目錄仍會列出它們並標記為未展示——藏起來只會讓缺口
    // 消失在視線外。
    const baselineUndemoed = 1;

    final undemoed = [
      for (final page in catalogPages)
        for (final specimen in page.specimens)
          if (!specimen.hasDemo) specimen.name,
    ]..sort();

    expect(
      undemoed.length,
      lessThanOrEqualTo(baselineUndemoed),
      reason: '未展示的元件從 $baselineUndemoed 增加到 ${undemoed.length}：\n'
          '${undemoed.join('\n')}',
    );
  });

  testWidgets('每一頁都能在明暗兩態下渲染', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final brightness in Brightness.values) {
      for (var index = 0; index < catalogPages.length; index++) {
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
        await tester.pump(const Duration(milliseconds: 200));

        expect(
          tester.takeException(),
          isNull,
          reason:
              '${catalogPages[index].label} 在 ${brightness.name} 下渲染時丟出例外',
        );
      }
    }
  });
}
