import 'package:flutter/material.dart';

import '../controls/klp_icon_button.dart';
import '../foundation/klp_icons.dart';
import '../theme/klp_geometry_theme.dart';
import '../theme/klp_theme.dart';
import 'klp_window_header.dart';

/// Workbench 專用的單一視窗列。
///
/// 在標準 [KlpWindowHeader] 上，依 Primary Sidebar 的即時寬度定位收合按鈕；
/// 呼叫端不需要另外疊一層產品標頭。
class KlpWorkbenchWindowHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const KlpWorkbenchWindowHeader({
    super.key,
    required this.titleText,
    required this.primaryPaneWidth,
    required this.primaryVisible,
    required this.onTogglePrimary,
    required this.collapseLabel,
    required this.expandLabel,
    this.appIcon,
    this.actions,
    this.onMinimize,
    this.onToggleMaximize,
    this.onClose,
    this.isMaximized = false,
    this.showWindowControls = true,
  });

  final String titleText;
  final double primaryPaneWidth;
  final bool primaryVisible;
  final VoidCallback? onTogglePrimary;
  final String collapseLabel;
  final String expandLabel;
  final Widget? appIcon;
  final List<Widget>? actions;
  final VoidCallback? onMinimize;
  final VoidCallback? onToggleMaximize;
  final VoidCallback? onClose;
  final bool isMaximized;
  final bool showWindowControls;

  @override
  Size get preferredSize =>
      Size.fromHeight(klpWindowHeaderHeight(KlpGeometryTheme.standard));

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final layout = klp.geometry.layout;
    final headerHeight = klpWindowHeaderHeight(
      klp.geometry,
      compact: klp.space.compact,
    );
    final toggleStart = primaryVisible
        ? klp.space.compact +
              primaryPaneWidth -
              layout.windowHeaderControlSize -
              klp.space.tight
        : klp.space.compact;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: KlpWindowHeader(
              titleText: titleText,
              appIcon: appIcon,
              actions: actions,
              height: headerHeight,
              onMinimize: onMinimize,
              onToggleMaximize: onToggleMaximize,
              onClose: onClose,
              isMaximized: isMaximized,
              showWindowControls: showWindowControls,
            ),
          ),
          PositionedDirectional(
            start: toggleStart,
            top: 0,
            bottom: 0,
            child: Center(
              child: KlpIconButton(
                icon: primaryVisible ? KlpIcons.panelLeft : KlpIcons.panelRight,
                label: primaryVisible ? collapseLabel : expandLabel,
                onPressed: onTogglePrimary,
                size: KlpIconButtonSize.window,
                // 標題列本身已有背景；再給按鈕畫一塊底色，會讓它看起來像
                // 貼在標題列上的色塊，而不是標題列的一部分。
                tone: KlpIconButtonTone.inline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
