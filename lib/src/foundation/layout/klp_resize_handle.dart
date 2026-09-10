import 'package:flutter/widgets.dart';

import '../../styling/legacy_theme/klp_theme.dart';

/// 拖曳調整水平或垂直尺寸的把手。
class KlpResizeHandle extends StatelessWidget {
  const KlpResizeHandle({
    super.key,
    required this.onDelta,
    this.axis = Axis.horizontal,
    this.onDragStart,
    this.onDragEnd,
    this.semanticLabel,
    this.width,
    this.height,
    this.enabled = true,
  });

  final Axis axis;
  final ValueChanged<double> onDelta;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final String? semanticLabel;
  final double? width;
  final double? height;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final isHorizontal = axis == Axis.horizontal;
    final lineLength = klp.space.loose - klp.space.tight;

    return Semantics(
      label: semanticLabel,
      child: MouseRegion(
        cursor: _resolveCursor(isHorizontal),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: enabled && isHorizontal ? (_) => onDragStart?.call() : null,
          onHorizontalDragUpdate: enabled && isHorizontal ? (details) => onDelta(details.delta.dx) : null,
          onHorizontalDragEnd: enabled && isHorizontal ? (_) => onDragEnd?.call() : null,
          onHorizontalDragCancel: enabled && isHorizontal ? onDragEnd : null,
          onVerticalDragStart: enabled && !isHorizontal ? (_) => onDragStart?.call() : null,
          onVerticalDragUpdate: enabled && !isHorizontal ? (details) => onDelta(details.delta.dy) : null,
          onVerticalDragEnd: enabled && !isHorizontal ? (_) => onDragEnd?.call() : null,
          onVerticalDragCancel: enabled && !isHorizontal ? onDragEnd : null,
          child: SizedBox(
            width: isHorizontal
                ? width ?? klp.geometry.layout.resizeHandleExtent
                : null,
            height: isHorizontal
                ? null
                : height ?? klp.geometry.layout.resizeHandleExtent,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.klpColors.border,
                  borderRadius: BorderRadius.circular(klp.shape.stroke),
                ),
                child: SizedBox(
                  width: isHorizontal ? klp.space.hairline : lineLength,
                  height: isHorizontal ? lineLength : klp.space.hairline,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  MouseCursor _resolveCursor(bool isHorizontal) {
    if (!enabled) return SystemMouseCursors.basic;
    return isHorizontal ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow;
  }
}
