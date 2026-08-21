import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import 'klp_panel_frame.dart';

/// 側邊欄：header、rail（圖示軌）、content 與選用的 footer。
class KlpSidebarFrame extends StatelessWidget {
  const KlpSidebarFrame({
    super.key,
    required this.header,
    this.rail,
    required this.content,
    this.footer,
  });

  final Widget header;
  final Widget? rail;
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
          if (rail != null) ...[
            SizedBox(width: context.klp.space.chromeRail, child: rail!),
            SizedBox(width: context.klp.space.tight),
          ],
          Expanded(child: content),
        ],
      ),
    );
  }
}
