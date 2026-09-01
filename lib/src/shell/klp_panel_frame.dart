import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import 'internal/klp_panel_padding.dart';

/// 通用面板：header 與 content，選用 footer。高度預設沿用 theme 的外殼密度。
/// 文字顏色依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）渲染。
class KlpPanelFrame extends StatelessWidget {
  const KlpPanelFrame({
    super.key,
    this.header,
    required this.content,
    this.footer,
    this.headerHeight,
    this.footerHeight,
    this.background,
    this.padding,
    this.flushContent = false,
  });

  final Widget? header;
  final Widget content;
  final Widget? footer;

  /// `null` 表示沿用 theme 的外殼高度。
  final double? headerHeight;
  final double? footerHeight;
  final Color? background;

  /// 面板邊界往內的共用 padding。預設只提供左右各 8px；上下節奏由
  /// header、content、footer 自己決定。
  final EdgeInsetsGeometry? padding;

  /// 舊版只控制 content padding 的相容參數。面板現在由 [padding] 統一管理
  /// 三個區域，因此此值不再改變 padding。
  @Deprecated('Use padding to configure the panel padding.')
  final bool flushContent;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final effectiveBackground = background ?? tokens.surface;
    final surfaceTokens = tokens.onBackground(effectiveBackground);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(context.klp.shape.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          context.klp.shape.panel - context.klp.shape.stroke,
        ),
        child: KlpTokenOverride(
          colors: surfaceTokens,
          child: Padding(
            padding: resolveKlpPanelPadding(context, padding: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null)
                  SizedBox(
                    height: headerHeight ?? context.klp.space.chromeHeader,
                    child: header!,
                  ),
                Expanded(child: content),
                if (footer != null)
                  SizedBox(
                    height: footerHeight ?? context.klp.space.chromeStatusBar,
                    child: footer!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
