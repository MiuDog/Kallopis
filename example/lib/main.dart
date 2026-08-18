import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

import 'catalog_page.dart';
import 'catalog_shell.dart';
import 'pages/controls_catalog.dart';
import 'pages/foundations_catalog.dart';
import 'pages/status_visual_iteration_catalog.dart';

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
    const pages = <CatalogPageData>[
      CatalogPageData(
        label: 'Foundations',
        title: '基礎視覺語言',
        description: '字體、背景、基底區塊與 SVG 圖示',
        icon: KlpIcons.container,
        child: FoundationsCatalog(),
      ),
      CatalogPageData(
        label: 'Controls',
        title: '控制項與表單',
        description: '動作、輸入、選擇與完整驗證狀態',
        icon: KlpIcons.settings,
        child: ControlsCatalog(),
      ),
      CatalogPageData(
        label: 'Appearance',
        title: '外觀比較',
        description: '同一組元件在不同主題與風格下的並排對照',
        icon: KlpIcons.eye,
        child: StatusVisualIterationCatalog(),
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kallopis Catalog',
      theme: buildKlpTheme(_brightness, style: _style),
      home: CatalogShell(
        pages: pages,
        selected: _selected.clamp(0, pages.length - 1),
        onSelected: (index) => setState(() => _selected = index),
        onToggleTheme: _toggleBrightness,
      ),
    );
  }
}
