import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';

class PlnPanelFrame extends StatelessWidget {
  const PlnPanelFrame({
    super.key,
    required this.header,
    required this.content,
    this.footer,
    this.headerHeight = PlnSize.header,
    this.footerHeight = PlnSize.statusBar,
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
    final tokens = context.plnTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? tokens.surface,
        borderRadius: BorderRadius.circular(PlnRadius.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PlnRadius.panel - PlnLine.width),
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
