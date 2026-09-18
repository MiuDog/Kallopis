import 'package:flutter/widgets.dart';

import 'package:kallopis/src/foundation/interaction/klp_gesture_region.dart';
import 'package:kallopis/src/foundation/layout/klp_align.dart';
import 'package:kallopis/src/foundation/layout/klp_box.dart';
import 'package:kallopis/src/foundation/layout/klp_expanded.dart';
import 'package:kallopis/src/foundation/layout/klp_gap.dart';
import 'package:kallopis/src/foundation/layout/klp_row.dart';
import 'package:kallopis/src/foundation/layout/klp_stack.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'klp_window_action.dart';

/// macOS 平台的視窗標題列排版元件。
class KlpWindowHeaderMacLayout extends StatelessWidget {
  const KlpWindowHeaderMacLayout({
    super.key,
    required this.identity,
    required this.controls,
    this.leading,
    this.trailing,
    this.titleTrailing,
    this.actions,
    this.onToggleMaximize,
  });

  final Widget identity;
  final Widget controls;
  final Widget? leading;
  final Widget? trailing;
  final Widget? titleTrailing;
  final List<Widget>? actions;
  final VoidCallback? onToggleMaximize;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpStack(
      alignment: Alignment.center,
      children: [
        KlpRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            controls,
            if (leading != null) ...[
              KlpGap.width(klp.space.chromeToolbarGap),
              leading!,
            ],
            KlpExpanded(
              child: KlpGestureRegion(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: () =>
                    (onToggleMaximize ?? KlpWindowAction.toggleMaximize)(),
                child: const KlpBox.expand(),
              ),
            ),
            if (actions != null) ...?actions,
            if (trailing != null) ...[
              KlpGap.width(klp.space.chromeToolbarGap),
              trailing!,
            ],
          ],
        ),
        KlpAlign(
          alignment: Alignment.center,
          child: KlpRow(
            mainAxisSize: MainAxisSize.min,
            children: [
              KlpGestureRegion(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: () =>
                    (onToggleMaximize ?? KlpWindowAction.toggleMaximize)(),
                child: identity,
              ),
              if (titleTrailing != null) ...[
                KlpGap.width(klp.geometry.layout.windowIdentityGap),
                titleTrailing!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
