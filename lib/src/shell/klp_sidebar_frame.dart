import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import 'klp_panel_frame.dart';

/// 側邊欄：外層只劃分 content 與 footer，再由各區域管理自己的風格。
///
/// Frame 一律只提供左右 8px；專案按鈕、Explorer、footer 的上下節奏由
/// [content] 與下一層元件自行決定。
class KlpSidebarFrame extends StatelessWidget {
  const KlpSidebarFrame({
    super.key,
    this.rail,
    required this.content,
    this.footer,
  });

  final Widget? rail;
  final Widget content;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return KlpPanelFrame(
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
