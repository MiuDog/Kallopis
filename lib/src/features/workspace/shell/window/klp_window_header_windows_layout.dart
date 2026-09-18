import 'package:flutter/widgets.dart';

import 'package:kallopis/src/foundation/interaction/klp_gesture_region.dart';
import 'package:kallopis/src/foundation/layout/klp_align.dart';
import 'package:kallopis/src/foundation/layout/klp_box.dart';
import 'package:kallopis/src/foundation/layout/klp_expanded.dart';
import 'package:kallopis/src/foundation/layout/klp_flexible.dart';
import 'package:kallopis/src/foundation/layout/klp_gap.dart';
import 'package:kallopis/src/foundation/layout/klp_row.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/features/workspace/shell/internal/klp_window_header_extras.dart';
import 'klp_window_action.dart';
import 'klp_window_header_keys.dart';

/// Windows 平台的視窗標題列排版元件。
class KlpWindowHeaderWindowsLayout extends StatelessWidget {
  const KlpWindowHeaderWindowsLayout({
    super.key,
    required this.identity,
    required this.controls,
    required this.controlExtent,
    this.leading,
    this.appIconButton,
    this.trailing,
    this.titleTrailing,
    this.actions,
    this.onToggleMaximize,
  });

  final Widget identity;
  final Widget controls;
  final double controlExtent;
  final Widget? leading;
  final Widget? appIconButton;
  final Widget? trailing;
  final Widget? titleTrailing;
  final List<Widget>? actions;
  final VoidCallback? onToggleMaximize;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final extras = actions == null && trailing == null
        ? null
        : buildKlpWindowHeaderRegion(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              if (actions != null) ...[
                ...actions!,
                KlpGap.width(klp.space.chromeToolbarGap),
              ],
              if (trailing != null) ...[
                trailing!,
                KlpGap.width(klp.space.chromeToolbarGap),
              ],
            ],
          );

    return KlpRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading!,
          KlpGap.width(klp.space.chromeToolbarGap),
        ],
        if (appIconButton != null) ...[
          KlpBox(
            key: const ValueKey(KlpWindowHeaderKeys.appIconSlot),
            width: controlExtent,
            height: controlExtent,
            child: appIconButton,
          ),
          KlpGap.width(klp.geometry.layout.windowIdentityGap),
        ],
        KlpExpanded(
          child: buildKlpWindowHeaderContent(
            identity: KlpRow(
              children: [
                KlpFlexible(
                  child: KlpGestureRegion(
                    behavior: HitTestBehavior.translucent,
                    onDoubleTap: () =>
                        (onToggleMaximize ?? KlpWindowAction.toggleMaximize)(),
                    child: KlpAlign(
                      alignment: Alignment.centerLeft,
                      shrinkWidth: true,
                      child: identity,
                    ),
                  ),
                ),
                if (titleTrailing != null) ...[
                  KlpGap.width(klp.geometry.layout.windowIdentityGap),
                  titleTrailing!,
                ],
                KlpExpanded(
                  child: KlpGestureRegion(
                    behavior: HitTestBehavior.translucent,
                    onDoubleTap: () =>
                        (onToggleMaximize ?? KlpWindowAction.toggleMaximize)(),
                    child: const KlpBox.expand(),
                  ),
                ),
              ],
            ),
            extras: extras,
          ),
        ),
        controls,
      ],
    );
  }
}
