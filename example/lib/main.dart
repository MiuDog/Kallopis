import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

import 'catalog/registry.dart';
import 'catalog_shell.dart';

void main() => runApp(const KallopisCatalogApp());

/// Kallopis 的元件目錄。
///
/// 只使用出貨的 `defaultStyle` 風格；明暗與超深色切換在左下角。
/// 「換整套風格」的驗收由 `test/style_switch_golden_test.dart` 以離屏算圖負責，
/// 不佔用目錄的畫面。
///
/// 接入方式本身就是 [KlpApp] 的自我驗證：目錄用起來不順，消費者也不會順。
class KallopisCatalogApp extends StatefulWidget {
  const KallopisCatalogApp({super.key});

  @override
  State<KallopisCatalogApp> createState() => _KallopisCatalogAppState();
}

class _KallopisCatalogAppState extends State<KallopisCatalogApp>
    with WidgetsBindingObserver {
  int _selected = 0;
  KlpThemeVariant _variant = KlpThemeVariant.light;
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _queryMaximized();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _queryMaximized();
  }

  Future<void> _queryMaximized() async {
    final isMax = await KlpWindowAction.checkIsMaximized();
    if (mounted && isMax != _isMaximized) {
      setState(() => _isMaximized = isMax);
    }
  }

  void _cycleTheme() {
    setState(() {
      _variant = switch (_variant) {
        KlpThemeVariant.light => KlpThemeVariant.dark,
        KlpThemeVariant.dark => KlpThemeVariant.ultraDark,
        KlpThemeVariant.ultraDark => KlpThemeVariant.light,
        KlpThemeVariant.transparent => KlpThemeVariant.light,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = buildKlpThemeVariant(_variant);

    return KlpApp(
      debugShowCheckedModeBanner: false,
      title: 'Kallopis',
      appIcon: const KlpIcon(KlpIcons.sparkles),
      minWidth: 800,
      minHeight: 500,
      isMaximized: _isMaximized,
      headerActions: [
        _CatalogThemeButton(variant: _variant, onPressed: _cycleTheme),
      ],
      builder: (context, child) =>
          Theme(data: themeData, child: child ?? const SizedBox.shrink()),
      home: CatalogShell(
        groups: catalogGroups,
        pages: catalogPages,
        selected: _selected.clamp(0, catalogPages.length - 1),
        onSelected: (index) => setState(() => _selected = index),
      ),
    );
  }
}

class _CatalogThemeButton extends StatelessWidget {
  const _CatalogThemeButton({required this.variant, required this.onPressed});

  final KlpThemeVariant variant;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Center(
      child: KlpTooltip(
        message:
            '切換主題（目前：${switch (variant) {
              KlpThemeVariant.light => '淺色',
              KlpThemeVariant.dark => '深色',
              KlpThemeVariant.ultraDark => '超深色',
              KlpThemeVariant.transparent => '透明',
            }}）',
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 22.0,
            padding: EdgeInsets.symmetric(horizontal: klp.space.compact),
            decoration: BoxDecoration(
              color: klp.color.component,
              borderRadius: BorderRadius.circular(klp.shape.control),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                KlpIcon(
                  KlpIcons.sparkles,
                  size: 12.0,
                  color: klp.color.textMuted,
                ),
                SizedBox(width: klp.space.tight),
                KlpText(
                  switch (variant) {
                    KlpThemeVariant.light => 'Light',
                    KlpThemeVariant.dark => 'Dark',
                    KlpThemeVariant.ultraDark => 'Ultra Dark',
                    KlpThemeVariant.transparent => 'Acrylic',
                  },
                  role: KlpTextRole.micro,
                  tone: KlpTextTone.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
