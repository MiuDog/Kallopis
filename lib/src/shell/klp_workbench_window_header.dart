import 'package:flutter/material.dart';

import '../controls/klp_icon_button.dart';
import '../foundation/klp_icons.dart';
import '../theme/klp_geometry_theme.dart';
import '../theme/klp_theme.dart';
import 'klp_window_header.dart';

/// Workbench 專用的單一視窗列。
///
/// 在標準 [KlpWindowHeader] 上，依兩側 pane 的即時寬度定位收合按鈕；
/// pane 收合後，Primary 按鈕會跟在標題右方，Secondary 按鈕則留在右側動作區。
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
    this.secondaryPaneWidth,
    this.secondaryVisible = false,
    this.onToggleSecondary,
    this.collapseSecondaryLabel,
    this.expandSecondaryLabel,
    this.appIcon,
    this.appIconButton,
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
  final double? secondaryPaneWidth;
  final bool secondaryVisible;
  final VoidCallback? onToggleSecondary;
  final String? collapseSecondaryLabel;
  final String? expandSecondaryLabel;
  final Widget? appIcon;
  final Widget? appIconButton;
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
    final panelMargin = klp.space.compact / 2;
    final primaryToggle = KlpIconButton(
      icon: primaryVisible ? KlpIcons.panelLeft : KlpIcons.panelRight,
      label: primaryVisible ? collapseLabel : expandLabel,
      onPressed: onTogglePrimary,
      size: KlpIconButtonSize.window,
      tone: KlpIconButtonTone.inline,
    );
    final hasSecondaryToggle =
        onToggleSecondary != null &&
        collapseSecondaryLabel != null &&
        expandSecondaryLabel != null;
    final secondaryToggle = hasSecondaryToggle
        ? KlpIconButton(
            icon: secondaryVisible ? KlpIcons.panelRight : KlpIcons.panelLeft,
            label: secondaryVisible
                ? collapseSecondaryLabel!
                : expandSecondaryLabel!,
            onPressed: onToggleSecondary,
            size: KlpIconButtonSize.window,
            tone: KlpIconButtonTone.inline,
          )
        : null;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: KlpWindowHeader(
              titleText: titleText,
              titleTrailing: primaryVisible ? null : primaryToggle,
              appIcon: appIcon,
              appIconButton: appIconButton,
              actions: actions,
              trailing: !secondaryVisible ? secondaryToggle : null,
              height: headerHeight,
              onMinimize: onMinimize,
              onToggleMaximize: onToggleMaximize,
              onClose: onClose,
              isMaximized: isMaximized,
              showWindowControls: showWindowControls,
            ),
          ),
          if (primaryVisible)
            PositionedDirectional(
              start:
                  primaryPaneWidth -
                  panelMargin -
                  layout.windowHeaderControlSize,
              top: 0,
              bottom: 0,
              child: Center(child: primaryToggle),
            ),
          if (secondaryVisible &&
              secondaryToggle != null &&
              secondaryPaneWidth != null)
            PositionedDirectional(
              end:
                  secondaryPaneWidth! -
                  panelMargin -
                  layout.windowHeaderControlSize,
              top: 0,
              bottom: 0,
              child: Center(child: secondaryToggle),
            ),
        ],
      ),
    );
  }
}
