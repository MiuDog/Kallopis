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
class KallopisCatalogApp extends StatefulWidget {
  const KallopisCatalogApp({super.key});

  @override
  State<KallopisCatalogApp> createState() => _KallopisCatalogAppState();
}

class _KallopisCatalogAppState extends State<KallopisCatalogApp> {
  KlpVisualStyle _style = KlpVisualStyle.modern;
  Brightness _brightness = Brightness.light;
  int _selected = 0;

  void _toggleBrightness() {
    setState(() {
      _brightness = _brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
      _style = _style.copyWith(
        colors: _brightness == Brightness.dark
            ? KlpThemeData.dark
            : KlpThemeData.light,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kallopis Catalog',
      theme: buildKlpTheme(_brightness, style: _style),
      home: CatalogShell(
        groups: catalogGroups,
        pages: catalogPages,
        selected: _selected.clamp(0, catalogPages.length - 1),
        onSelected: (index) => setState(() => _selected = index),
        onToggleTheme: _toggleBrightness,
      ),
    );
  }
}
