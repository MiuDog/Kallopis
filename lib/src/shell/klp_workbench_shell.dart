import 'package:flutter/widgets.dart';

import '../layout/klp_layout.dart';
import '../theme/klp_theme.dart';

/// 三欄工作區外殼：主要面板、舞台、次要面板，兩側可拖曳調寬並依斷點自動收合。
/// 這是桌面型應用最外層的版面骨架。
class KlpWorkbenchShell extends StatelessWidget {
  const KlpWorkbenchShell({
    super.key,
    required this.primary,
    required this.stage,
    required this.secondary,
    this.primaryVisible = true,
    this.secondaryVisible = true,
    this.primaryWidth,
    this.secondaryWidth,
    this.onPrimaryWidthChanged,
    this.onSecondaryWidthChanged,
    this.padding,
    this.paneGap,
  }) : assert(paneGap == null || (paneGap >= 0 && paneGap != double.infinity));

  final Widget primary;
  final Widget stage;
  final Widget secondary;
  final bool primaryVisible;
  final bool secondaryVisible;
  final double? primaryWidth;
  final double? secondaryWidth;
  final ValueChanged<double>? onPrimaryWidthChanged;
  final ValueChanged<double>? onSecondaryWidthChanged;

  /// 外殼與三欄內容之間的留白；`null` 時頂部貼齊全寬 header，
  /// 其餘三邊沿用緊湊間距。
  final EdgeInsetsGeometry? padding;

  /// 相鄰欄位之間的留白與拖曳命中寬度；`null` 時沿用緊湊間距。
  final double? paneGap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final geometry = context.klp.geometry.layout;
    final effectivePrimaryWidth = primaryWidth ?? geometry.primaryPaneWidth;
    final effectiveSecondaryWidth =
        secondaryWidth ?? geometry.secondaryPaneWidth;
    final compact = context.klp.space.compact;
    final effectivePadding =
        padding ?? EdgeInsets.fromLTRB(compact, 0, compact, compact);
    final effectivePaneGap = paneGap ?? context.klp.space.compact;

    return LayoutBuilder(
      builder: (context, constraints) {
        final showPrimaryContent =
            primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneContentBreakpoint;
        final showPrimary =
            primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneBreakpoint;
        final showSecondary =
            secondaryVisible &&
            constraints.maxWidth >= geometry.secondaryPaneBreakpoint;
        final resolvedPrimaryWidth = showPrimaryContent
            ? effectivePrimaryWidth
            : context.klp.space.chromeRail + context.klp.space.base;

        return ColoredBox(
          color: tokens.app,
          child: Padding(
            padding: effectivePadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showPrimary) ...[
                  SizedBox(width: resolvedPrimaryWidth, child: primary),
                  KlpResizeHandle(
                    key: const ValueKey('primary-pane-resize-handle'),
                    enabled:
                        showPrimaryContent && onPrimaryWidthChanged != null,
                    width: effectivePaneGap,
                    onDelta: (delta) => onPrimaryWidthChanged?.call(
                      effectivePrimaryWidth + delta,
                    ),
                  ),
                ],
                Expanded(child: stage),
                if (showSecondary) ...[
                  KlpResizeHandle(
                    key: const ValueKey('secondary-pane-resize-handle'),
                    enabled: onSecondaryWidthChanged != null,
                    width: effectivePaneGap,
                    onDelta: (delta) => onSecondaryWidthChanged?.call(
                      effectiveSecondaryWidth - delta,
                    ),
                  ),
                  SizedBox(width: effectiveSecondaryWidth, child: secondary),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
