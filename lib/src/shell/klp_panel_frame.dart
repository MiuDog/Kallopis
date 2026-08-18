import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';

/// 通用面板：header 與 content，選用 footer。高度預設沿用 theme 的外殼密度。
class KlpPanelFrame extends StatelessWidget {
  const KlpPanelFrame({
    super.key,
    required this.header,
    required this.content,
    this.footer,
    this.headerHeight,
    this.footerHeight,
    this.background,
  });

  final Widget header;
  final Widget content;
  final Widget? footer;
  /// `null` 表示沿用 theme 的外殼高度。
  final double? headerHeight;
  final double? footerHeight;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? tokens.surface,
        borderRadius: BorderRadius.circular(context.klp.shape.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.klp.shape.panel - context.klp.shape.stroke),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: headerHeight ?? context.klp.space.chromeHeader,
              child: header,
            ),
            Expanded(child: content),
            if (footer != null) SizedBox(
                height: footerHeight ?? context.klp.space.chromeStatusBar,
                child: footer!,
              ),
          ],
        ),
      ),
    );
  }
}
