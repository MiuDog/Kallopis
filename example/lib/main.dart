import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

import 'catalog/registry.dart';
import 'catalog_shell.dart';

void main() => runApp(const KallopisCatalogApp());

/// Kallopis 的元件目錄。
///
/// 只使用出貨的 `modern` 風格；明暗切換在左下角。
/// 「換整套風格」的驗收由 `test/style_switch_golden_test.dart` 以離屏算圖負責，
/// 不佔用目錄的畫面。
///
/// 接入方式本身就是 [KlpApp] 的自我驗證：目錄用起來不順，消費者也不會順。
class KallopisCatalogApp extends StatefulWidget {
  const KallopisCatalogApp({super.key});

  @override
  State<KallopisCatalogApp> createState() => _KallopisCatalogAppState();
}

class _KallopisCatalogAppState extends State<KallopisCatalogApp> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return KlpApp(
      debugShowCheckedModeBanner: false,
      title: 'Kallopis Catalog',
      home: Builder(
        builder: (context) => CatalogShell(
          groups: catalogGroups,
          pages: catalogPages,
          selected: _selected.clamp(0, catalogPages.length - 1),
          onSelected: (index) => setState(() => _selected = index),
          onToggleTheme: () => KlpApp.of(context).toggleBrightness(),
        ),
      ),
    );
  }
}
