import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import 'klp_sidebar_frame.dart';

/// 桌面工作區的 Primary Sidebar 外框。
///
/// Identity、導覽與 Explorer 緊密排列；上下節奏由各區域自行決定。
/// content 與 footer 沿用 [KlpSidebarFrame] 的水平 padding 規則；footer 不再
/// 額外包覆垂直 padding。
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
    final compact = context.klp.space.compact;

    return KlpSidebarFrame(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: compact),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [header, navigation],
            ),
          ),
          Expanded(child: explorer),
        ],
      ),
      footer: footer,
    );
  }
}
