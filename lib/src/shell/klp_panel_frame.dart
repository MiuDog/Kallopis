import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';

class KlpPanelFrame extends StatelessWidget {
  const KlpPanelFrame({
    super.key,
    required this.header,
    required this.content,
    this.footer,
    this.headerHeight = KlpSize.header,
    this.footerHeight = KlpSize.statusBar,
    this.background,
  });

  final Widget header;
  final Widget content;
  final Widget? footer;
  final double headerHeight;
  final double footerHeight;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? tokens.surface,
        borderRadius: BorderRadius.circular(KlpRadius.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KlpRadius.panel - KlpLine.width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: headerHeight, child: header),
            Expanded(child: content),
            if (footer != null) SizedBox(height: footerHeight, child: footer!),
          ],
        ),
      ),
    );
  }
}
