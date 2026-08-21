import 'package:flutter/widgets.dart';

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
  });

  final Widget primary;
  final Widget stage;
  final Widget secondary;
  final bool primaryVisible;
  final bool secondaryVisible;
  final double? primaryWidth;
  final double? secondaryWidth;
  final ValueChanged<double>? onPrimaryWidthChanged;
  final ValueChanged<double>? onSecondaryWidthChanged;

  /// 外殼與三欄內容之間的留白；`null` 時四邊沿用基礎間距。
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final geometry = context.klp.geometry.layout;
    final effectivePrimaryWidth = primaryWidth ?? geometry.primaryPaneWidth;
    final effectiveSecondaryWidth =
        secondaryWidth ?? geometry.secondaryPaneWidth;
    final effectivePadding = padding ?? EdgeInsets.all(context.klp.space.base);

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
                  _KlpPaneResizeHandle(
                    key: const ValueKey('primary-pane-resize-handle'),
                    enabled:
                        showPrimaryContent && onPrimaryWidthChanged != null,
                    value: effectivePrimaryWidth,
                    onChanged: onPrimaryWidthChanged,
                  ),
                ],
                Expanded(child: stage),
                if (showSecondary) ...[
                  _KlpPaneResizeHandle(
                    key: const ValueKey('secondary-pane-resize-handle'),
                    enabled: onSecondaryWidthChanged != null,
                    value: effectiveSecondaryWidth,
                    reverse: true,
                    onChanged: onSecondaryWidthChanged,
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

class _KlpPaneResizeHandle extends StatefulWidget {
  const _KlpPaneResizeHandle({
    super.key,
    required this.enabled,
    required this.value,
    required this.onChanged,
    this.reverse = false,
  });

  final bool enabled;
  final double value;
  final ValueChanged<double>? onChanged;
  final bool reverse;

  @override
  State<_KlpPaneResizeHandle> createState() => _KlpPaneResizeHandleState();
}

class _KlpPaneResizeHandleState extends State<_KlpPaneResizeHandle> {
  double _dragStartValue = 0;
  double _accumulatedDelta = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: widget.enabled
            ? (_) {
                _dragStartValue = widget.value;
                _accumulatedDelta = 0;
              }
            : null,
        onHorizontalDragUpdate: widget.enabled
            ? (details) {
                _accumulatedDelta += details.primaryDelta ?? 0;
                final direction = widget.reverse ? -1 : 1;
                widget.onChanged?.call(
                  _dragStartValue + _accumulatedDelta * direction,
                );
              }
            : null,
        child: SizedBox(width: context.klp.space.base),
      ),
    );
  }
}
