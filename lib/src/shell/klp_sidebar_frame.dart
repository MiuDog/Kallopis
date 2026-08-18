import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import 'klp_panel_frame.dart';

class KlpSidebarFrame extends StatelessWidget {
  const KlpSidebarFrame({
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
    return KlpPanelFrame(
      header: header,
      footer: footer,
      background: context.klpColors.surface,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: context.klp.space.chromeRail, child: rail),
          SizedBox(width: context.klp.space.tight),
          Expanded(child: content),
        ],
      ),
    );
  }
}
