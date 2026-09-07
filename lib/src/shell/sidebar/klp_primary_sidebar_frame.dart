import 'package:flutter/widgets.dart';

import '../../feedback/klp_status_indicator.dart';
import '../../theme/klp_theme.dart';
import '../status/klp_status_data.dart';
import 'klp_sidebar_frame.dart';

/// 桌面工作區的 Primary Sidebar 外框。
///
/// Identity、導覽與 Explorer 緊密排列；上下節奏由各區域自行決定。
/// content 與 footer 沿用 [KlpSidebarFrame] 的水平 padding 規則；footer 不再
/// 額外包覆垂直 padding。
class KlpPrimarySidebarFrame extends StatelessWidget {
  const KlpPrimarySidebarFrame({
    super.key,
    this.header,
    this.navigation,
    required this.explorer,
    this.footer,
    this.status,
    this.padding,
    this.headerNavigationPadding,
    this.headerNavigationGap,
  });

  final Widget? header;
  final Widget? navigation;
  final Widget explorer;
  final Widget? footer;

  /// 側欄底部狀態；提供時由框架使用共通狀態元件渲染。
  final KlpStatusItemData? status;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? headerNavigationPadding;
  final double? headerNavigationGap;

  @override
  Widget build(BuildContext context) {
    final inset = context.klp.space.navigationItemInset;

    return KlpSidebarFrame(
      padding: padding,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null || navigation != null)
            Padding(
              padding:
                  headerNavigationPadding ??
                  EdgeInsets.symmetric(vertical: inset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ?header,
                  if (header != null &&
                      navigation != null &&
                      headerNavigationGap != null)
                    SizedBox(height: headerNavigationGap),
                  ?navigation,
                ],
              ),
            ),
          Expanded(child: explorer),
        ],
      ),
      footer: status == null ? footer : KlpStatusIndicator(data: status!),
    );
  }
}
