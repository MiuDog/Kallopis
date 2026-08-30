import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';

/// 通用面板：header 與 content，選用 footer。高度預設沿用 theme 的外殼密度。
/// 文字顏色依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）渲染。
class KlpPanelFrame extends StatelessWidget {
  const KlpPanelFrame({
    super.key,
    required this.header,
    required this.content,
    this.footer,
    this.headerHeight,
    this.footerHeight,
    this.background,
    this.padding,
    this.flushContent = false,
  });

  final Widget header;
  final Widget content;
  final Widget? footer;

  /// `null` 表示沿用 theme 的外殼高度。
  final double? headerHeight;
  final double? footerHeight;
  final Color? background;

  /// 內容與面板之間的內距。預設使用 Workbench 的語意緊湊間距。
  final EdgeInsetsGeometry? padding;

  /// 讓內容自行管理內距；用於 explorer 這類每列已具備水平節奏的面板。
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: headerHeight ?? context.klp.space.chromeHeader,
                child: header,
              ),
              Expanded(
                child: Padding(
                  padding:
                      padding ??
                      (flushContent
                          ? EdgeInsets.zero
                          : EdgeInsets.all(context.klp.space.compact)),
                  child: content,
                ),
              ),
              if (footer != null)
                SizedBox(
                  height: footerHeight ?? context.klp.space.chromeStatusBar,
                  child: footer!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
