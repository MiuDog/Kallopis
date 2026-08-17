import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import 'pln_panel_frame.dart';

class PlnSidebarFrame extends StatelessWidget {
  const PlnSidebarFrame({
    super.key,
    required this.header,
    required this.rail,
    required this.content,
    this.footer,
  });

  final Widget header;
  final Widget rail;
  final Widget content;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return PlnPanelFrame(
      header: header,
      footer: footer,
      background: context.plnTheme.surface,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: PlnSize.rail, child: rail),
          const SizedBox(width: PlnSpace.xs),
          Expanded(child: content),
        ],
      ),
    );
  }
}
