import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';

class KlpWorkbenchShell extends StatelessWidget {
  const KlpWorkbenchShell({
    super.key,
    required this.primary,
    required this.stage,
    required this.secondary,
    this.primaryVisible = true,
    this.secondaryVisible = true,
    this.primaryWidth = KlpSize.sidebar,
    this.secondaryWidth = KlpSize.inspector,
    this.onPrimaryWidthChanged,
    this.onSecondaryWidthChanged,
  });

  final Widget primary;
  final Widget stage;
  final Widget secondary;
  final bool primaryVisible;
  final bool secondaryVisible;
  final double primaryWidth;
  final double secondaryWidth;
  final ValueChanged<double>? onPrimaryWidthChanged;
  final ValueChanged<double>? onSecondaryWidthChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final showPrimaryContent =
            primaryVisible &&
            constraints.maxWidth >= KlpSize.primaryPaneContentBreakpoint;
        final showPrimary =
            primaryVisible &&
            constraints.maxWidth >= KlpSize.primaryPaneBreakpoint;
        final showSecondary =
            secondaryVisible &&
            constraints.maxWidth >= KlpSize.secondaryPaneBreakpoint;
        final resolvedPrimaryWidth = showPrimaryContent
            ? primaryWidth
            : KlpSize.rail + KlpLayoutGap.lg;

        return ColoredBox(
          color: tokens.app,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              KlpLayoutGap.lg,
              0,
              KlpLayoutGap.lg,
              KlpLayoutGap.lg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showPrimary) ...[
                  SizedBox(width: resolvedPrimaryWidth, child: primary),
                  _KlpPaneResizeHandle(
                    key: const ValueKey('primary-pane-resize-handle'),
                    enabled:
                        showPrimaryContent && onPrimaryWidthChanged != null,
                    value: primaryWidth,
                    onChanged: onPrimaryWidthChanged,
                  ),
                ],
                Expanded(child: stage),
                if (showSecondary) ...[
                  _KlpPaneResizeHandle(
                    key: const ValueKey('secondary-pane-resize-handle'),
                    enabled: onSecondaryWidthChanged != null,
                    value: secondaryWidth,
                    reverse: true,
                    onChanged: onSecondaryWidthChanged,
                  ),
                  SizedBox(width: secondaryWidth, child: secondary),
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
        child: const SizedBox(width: KlpLayoutGap.lg),
      ),
    );
  }
}
