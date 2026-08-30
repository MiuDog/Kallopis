import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import 'klp_panel_frame.dart';

/// 桌面工作區的 Primary Sidebar 外框。
///
/// Identity、導覽、Explorer 與 footer 的尺寸節奏由 Kallopis 統一；消費者只組合
/// 產品內容，不需要覆寫 [KlpPanelFrame] 的 header 高度或內容 padding。
class KlpPrimarySidebarFrame extends StatelessWidget {
  const KlpPrimarySidebarFrame({
    super.key,
    required this.header,
    required this.navigation,
    required this.explorer,
    this.footer,
  });

  final Widget header;
  final Widget navigation;
  final Widget explorer;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;
    final compact = space.compact;

    return KlpPanelFrame(
      headerHeight: space.controlHeightSmall,
      flushContent: true,
      header: Padding(
        padding: EdgeInsets.symmetric(horizontal: compact),
        child: header,
      ),
      content: Padding(
        padding: EdgeInsets.all(compact),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            navigation,
            SizedBox(height: space.compact - space.tight),
            Expanded(child: explorer),
          ],
        ),
      ),
      footer: footer == null
          ? null
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: compact),
              child: footer,
            ),
    );
  }
}
