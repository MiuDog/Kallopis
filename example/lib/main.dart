import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

import 'catalog_page.dart';
import 'catalog_shell.dart';
import 'pages/controls_catalog.dart';
import 'pages/foundations_catalog.dart';
import 'pages/status_visual_iteration_catalog.dart';

void main() => runApp(const KallopisCatalogApp());

/// Kallopis 的元件目錄，同時是 token 架構的**眼見為憑**。
///
/// 右上角的風格切換不是 demo 功能：切換時**沒有任何元件程式碼被執行到不同分支**，
/// 只有 `ThemeData.extensions` 換了一組值。若某個元件在切換後外觀沒變，那就是它還在
/// 硬編碼風格——這個畫面是唯一能一眼看出這件事的地方。
class KallopisCatalogApp extends StatefulWidget {
  const KallopisCatalogApp({super.key});

  @override
  State<KallopisCatalogApp> createState() => _KallopisCatalogAppState();
}

class _KallopisCatalogAppState extends State<KallopisCatalogApp> {
  KlpVisualStyle _style = KlpVisualStyle.modern;
  Brightness _brightness = Brightness.light;
  int _selected = 0;

  bool get _isTerminal => _style.name == KlpVisualStyle.terminal.name;

  void _toggleStyle() {
    setState(() {
      if (_isTerminal) {
        _style = KlpVisualStyle.modern;
        _brightness = Brightness.light;
      } else {
        _style = KlpVisualStyle.terminal;
        _brightness = Brightness.dark;
      }
    });
  }

  void _toggleBrightness() {
    setState(() {
      _brightness = _brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
      _style = _style.copyWith(
        colors: _brightness == Brightness.dark
            ? (_isTerminal ? KlpThemeData.ultraDark : KlpThemeData.dark)
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
      home: Stack(
        children: [
          CatalogShell(
            pages: pages,
            selected: _selected.clamp(0, pages.length - 1),
            onSelected: (index) => setState(() => _selected = index),
            onToggleTheme: _toggleBrightness,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: _StyleSwitcher(
              styleName: _style.name,
              onToggle: _toggleStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _StyleSwitcher extends StatelessWidget {
  const _StyleSwitcher({required this.styleName, required this.onToggle});

  final String styleName;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    // 這個元件本身也遵守紀律：所有數值來自 token，沒有一個字面值。
    final klp = context.klp;

    return KlpSurface(
      tone: KlpSurfaceTone.overlay,
      padding: EdgeInsets.symmetric(
        horizontal: klp.space.base,
        vertical: klp.space.compact,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText('style', role: KlpTextRole.label),
          SizedBox(width: klp.space.compact),
          KlpButton(label: styleName, onPressed: onToggle),
        ],
      ),
    );
  }
}
