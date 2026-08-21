import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/klp_theme_scope.dart';
import 'klp_page_background.dart';
import 'klp_page_background_recipe.dart';

/// 編輯受限 point／line 背景 recipe 的受控視覺元件。
class KlpPageBackgroundEditor extends StatefulWidget {
  const KlpPageBackgroundEditor({
    super.key,
    required this.recipe,
    required this.tool,
    required this.onChanged,
    this.viewport,
    this.onSelectionChanged,
    this.child,
  });

  final KlpCustomPageBackgroundRecipe recipe;
  final KlpPageBackgroundEditorTool tool;
  final ValueChanged<KlpCustomPageBackgroundRecipe> onChanged;
  final KlpPageBackgroundViewport? viewport;
  final ValueChanged<KlpPageBackgroundSelection?>? onSelectionChanged;
  final Widget? child;

  @override
  State<KlpPageBackgroundEditor> createState() {
    return _KlpPageBackgroundEditorState();
  }
}

class _KlpPageBackgroundEditorState extends State<KlpPageBackgroundEditor> {
  int? _chainPointId;
  KlpPageBackgroundSelection? _selection;

  KlpPageBackgroundViewport get _viewport {
    return widget.viewport ?? KlpPageBackgroundViewport();
  }

  @override
  void didUpdateWidget(covariant KlpPageBackgroundEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tool != widget.tool) {
      _chainPointId = null;
    }
    if (_selection case final selection?) {
      if (!_selectionExists(selection, widget.recipe)) {
        _selection = null;
        final onSelectionChanged = widget.onSelectionChanged;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) onSelectionChanged?.call(null);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Focus(
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _handlePointerDown,
        child: CustomPaint(
          foregroundPainter: _KlpBackgroundSelectionPainter(
            recipe: widget.recipe,
            viewport: _viewport,
            selection: _selection,
            color: klp.color.interaction,
            guideColor: klp.color.pagePattern,
            width: klp.shape.hairline,
            snapSpacing: widget.recipe.snapSpacing ?? klp.space.loose,
          ),
          child: KlpPageBackground.recipe(
            recipe: widget.recipe,
            viewport: _viewport,
            child: widget.child ?? const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      setState(() => _chainPointId = null);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (event.buttons != kPrimaryButton) return;

    final pagePosition = _viewport.viewportToPage(event.localPosition);
    final hit = _hitTest(pagePosition);

    switch (widget.tool) {
      case KlpPageBackgroundEditorTool.connect:
        _connect(pagePosition, hit);
      case KlpPageBackgroundEditorTool.select:
        _setSelection(hit);
      case KlpPageBackgroundEditorTool.delete:
        _delete(hit);
    }
  }

  void _connect(Offset pagePosition, KlpPageBackgroundSelection? hit) {
    final existingPointId = hit?.kind == KlpPageBackgroundElementKind.point
        ? hit!.id
        : null;
    var recipe = widget.recipe;
    final targetId = existingPointId ?? recipe.nextPointId;

    if (existingPointId == null) {
      final position = HardwareKeyboard.instance.isShiftPressed
          ? pagePosition
          : _snap(pagePosition);
      recipe = recipe.copyWith(
        points: [
          ...recipe.points,
          KlpPageBackgroundPoint(id: targetId, position: position),
        ],
      );
    }

    final startId = _chainPointId;
    if (startId != null && startId != targetId) {
      recipe = recipe.copyWith(
        lines: [
          ...recipe.lines,
          KlpPageBackgroundLine(
            id: recipe.nextLineId,
            startPointId: startId,
            endPointId: targetId,
          ),
        ],
      );
    }

    setState(() => _chainPointId = targetId);
    if (recipe != widget.recipe) widget.onChanged(recipe);
  }

  Offset _snap(Offset position) {
    final spacing = widget.recipe.snapSpacing ?? context.klp.space.loose;
    return Offset(
      (position.dx / spacing).round() * spacing,
      (position.dy / spacing).round() * spacing,
    );
  }

  void _delete(KlpPageBackgroundSelection? hit) {
    if (hit == null) return;
    final recipe = switch (hit.kind) {
      KlpPageBackgroundElementKind.point => widget.recipe.removePoint(hit.id),
      KlpPageBackgroundElementKind.line => widget.recipe.removeLine(hit.id),
    };
    _setSelection(null);
    widget.onChanged(recipe);
  }

  KlpPageBackgroundSelection? _hitTest(Offset position) {
    final threshold = context.klp.space.compact / _viewport.scale;

    for (final point in widget.recipe.points.reversed) {
      if ((point.position - position).distance <= threshold) {
        return KlpPageBackgroundSelection.point(point.id);
      }
    }

    final points = <int, KlpPageBackgroundPoint>{
      for (final point in widget.recipe.points) point.id: point,
    };
    for (final line in widget.recipe.lines.reversed) {
      final start = points[line.startPointId];
      final end = points[line.endPointId];
      if (start == null || end == null) continue;
      if (_distanceToSegment(position, start.position, end.position) <=
          threshold) {
        return KlpPageBackgroundSelection.line(line.id);
      }
    }
    return null;
  }

  void _setSelection(KlpPageBackgroundSelection? selection) {
    if (_selection == selection) return;
    setState(() => _selection = selection);
    widget.onSelectionChanged?.call(selection);
  }
}

class _KlpBackgroundSelectionPainter extends CustomPainter {
  const _KlpBackgroundSelectionPainter({
    required this.recipe,
    required this.viewport,
    required this.selection,
    required this.color,
    required this.guideColor,
    required this.width,
    required this.snapSpacing,
  });

  final KlpCustomPageBackgroundRecipe recipe;
  final KlpPageBackgroundViewport viewport;
  final KlpPageBackgroundSelection? selection;
  final Color color;
  final Color guideColor;
  final double width;
  final double snapSpacing;

  @override
  void paint(Canvas canvas, Size size) {
    _paintCoordinateGrid(canvas, size);

    final selected = selection;
    if (selected == null) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    final points = <int, KlpPageBackgroundPoint>{
      for (final point in recipe.points) point.id: point,
    };

    switch (selected.kind) {
      case KlpPageBackgroundElementKind.point:
        final point = points[selected.id];
        if (point == null) return;
        canvas.drawCircle(
          viewport.pageToViewport(point.position),
          width + width,
          paint,
        );
      case KlpPageBackgroundElementKind.line:
        KlpPageBackgroundLine? selectedLine;
        for (final line in recipe.lines) {
          if (line.id == selected.id) selectedLine = line;
        }
        if (selectedLine == null) return;
        final start = points[selectedLine.startPointId];
        final end = points[selectedLine.endPointId];
        if (start == null || end == null) return;
        canvas.drawLine(
          viewport.pageToViewport(start.position),
          viewport.pageToViewport(end.position),
          paint,
        );
    }
  }

  void _paintCoordinateGrid(Canvas canvas, Size size) {
    final viewportSpacing = snapSpacing * viewport.scale;
    if (viewportSpacing < width) return;

    final paint = Paint()
      ..color = guideColor
      ..strokeWidth = width;
    final firstColumn = (viewport.origin.dx / snapSpacing).ceil();
    final firstRow = (viewport.origin.dy / snapSpacing).ceil();

    for (var column = firstColumn; ; column += 1) {
      final x = (column * snapSpacing - viewport.origin.dx) * viewport.scale;
      if (x > size.width) break;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var row = firstRow; ; row += 1) {
      final y = (row * snapSpacing - viewport.origin.dy) * viewport.scale;
      if (y > size.height) break;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _KlpBackgroundSelectionPainter oldDelegate) {
    return oldDelegate.recipe != recipe ||
        oldDelegate.viewport != viewport ||
        oldDelegate.selection != selection ||
        oldDelegate.color != color ||
        oldDelegate.guideColor != guideColor ||
        oldDelegate.width != width ||
        oldDelegate.snapSpacing != snapSpacing;
  }
}

bool _selectionExists(
  KlpPageBackgroundSelection selection,
  KlpCustomPageBackgroundRecipe recipe,
) {
  return switch (selection.kind) {
    KlpPageBackgroundElementKind.point => recipe.points.any(
      (point) => point.id == selection.id,
    ),
    KlpPageBackgroundElementKind.line => recipe.lines.any(
      (line) => line.id == selection.id,
    ),
  };
}

double _distanceToSegment(Offset point, Offset start, Offset end) {
  final segment = end - start;
  final lengthSquared = segment.dx * segment.dx + segment.dy * segment.dy;
  if (lengthSquared == 0) return (point - start).distance;

  final relative = point - start;
  final projection =
      (relative.dx * segment.dx + relative.dy * segment.dy) / lengthSquared;
  final clamped = math.max(0.0, math.min(1.0, projection));
  return (point - (start + segment * clamped)).distance;
}
