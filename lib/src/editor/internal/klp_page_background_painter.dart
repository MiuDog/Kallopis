import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../klp_page_background_recipe.dart';

/// renderer 已解析的 semantic 預設值；不包含產品或編輯狀態。
@immutable
class KlpPageBackgroundVisuals {
  const KlpPageBackgroundVisuals({
    required this.surface,
    required this.pattern,
    required this.spacing,
    required this.markWidth,
    required this.dotWidth,
  });

  final Color surface;
  final Color pattern;
  final double spacing;
  final double markWidth;
  final double dotWidth;

  @override
  bool operator ==(Object other) {
    return other is KlpPageBackgroundVisuals &&
        other.surface == surface &&
        other.pattern == pattern &&
        other.spacing == spacing &&
        other.markWidth == markWidth &&
        other.dotWidth == dotWidth;
  }

  @override
  int get hashCode =>
      Object.hash(surface, pattern, spacing, markWidth, dotWidth);
}

/// 所有頁面背景 recipe 共用的內部 renderer。
///
/// 呼叫端應使用 `KlpPageBackground`，不直接依賴這個實作型別。
class KlpPageBackgroundPainter extends CustomPainter {
  const KlpPageBackgroundPainter({
    required this.recipe,
    required this.viewport,
    required this.visuals,
  });

  final KlpPageBackgroundRecipe recipe;
  final KlpPageBackgroundViewport viewport;
  final KlpPageBackgroundVisuals visuals;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    canvas.drawRect(Offset.zero & size, Paint()..color = visuals.surface);

    switch (recipe) {
      case KlpPlainPageBackgroundRecipe():
        return;
      case KlpRuledPageBackgroundRecipe recipe:
        _paintRuled(canvas, size, recipe);
      case KlpDotsPageBackgroundRecipe recipe:
        _paintPeriodic(canvas, size, recipe, dots: true);
      case KlpGridPageBackgroundRecipe recipe:
        _paintPeriodic(canvas, size, recipe, dots: false);
      case KlpCustomPageBackgroundRecipe recipe:
        _paintCustom(canvas, recipe);
    }
  }

  void _paintRuled(
    Canvas canvas,
    Size size,
    KlpRuledPageBackgroundRecipe recipe,
  ) {
    final spacing = recipe.spacing ?? visuals.spacing;
    if (spacing * viewport.scale < visuals.markWidth) return;

    final paint = _paintFor(recipe.axis, recipe.strokeBehavior);
    final firstRow = (viewport.origin.dy / spacing).ceil();

    for (var row = firstRow; ; row += 1) {
      final y = _toViewportCoordinate(row * spacing, viewport.origin.dy);
      if (y > size.height) break;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintPeriodic(
    Canvas canvas,
    Size size,
    KlpPeriodicPageBackgroundRecipe recipe, {
    required bool dots,
  }) {
    final majorSpacing = recipe.majorSpacing ?? visuals.spacing;
    if (majorSpacing * viewport.scale < visuals.markWidth) return;

    final divisionCount = recipe.minorAxisCount + 1;
    final minorSpacing = majorSpacing / divisionCount;
    final showMinor = minorSpacing * viewport.scale >= visuals.markWidth;
    final visibleSpacing = showMinor ? minorSpacing : majorSpacing;
    final visibleDivisionCount = showMinor ? divisionCount : 1;
    final firstColumn = (viewport.origin.dx / visibleSpacing).ceil();
    final firstRow = (viewport.origin.dy / visibleSpacing).ceil();

    if (dots) {
      _paintDots(
        canvas,
        size,
        recipe,
        visibleDivisionCount,
        visibleSpacing,
        firstColumn,
        firstRow,
      );
      return;
    }

    final minorPaint = _paintFor(recipe.minorAxis, recipe.strokeBehavior);
    final majorPaint = _paintFor(recipe.majorAxis, recipe.strokeBehavior);

    for (var column = firstColumn; ; column += 1) {
      final x = _toViewportCoordinate(
        column * visibleSpacing,
        viewport.origin.dx,
      );
      if (x > size.width) break;
      final paint = column % visibleDivisionCount == 0
          ? majorPaint
          : minorPaint;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (var row = firstRow; ; row += 1) {
      final y = _toViewportCoordinate(row * visibleSpacing, viewport.origin.dy);
      if (y > size.height) break;
      final paint = row % visibleDivisionCount == 0 ? majorPaint : minorPaint;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintDots(
    Canvas canvas,
    Size size,
    KlpPeriodicPageBackgroundRecipe recipe,
    int divisionCount,
    double spacing,
    int firstColumn,
    int firstRow,
  ) {
    final minorPaint = _paintFor(
      recipe.minorAxis,
      recipe.strokeBehavior,
      defaultWidth: visuals.dotWidth,
    );
    final majorPaint = _paintFor(
      recipe.majorAxis,
      recipe.strokeBehavior,
      defaultWidth: visuals.dotWidth,
    );
    final minorRadius = minorPaint.strokeWidth / 2;
    final majorRadius = majorPaint.strokeWidth / 2;

    for (var row = firstRow; ; row += 1) {
      final y = _toViewportCoordinate(row * spacing, viewport.origin.dy);
      if (y > size.height) break;

      for (var column = firstColumn; ; column += 1) {
        final x = _toViewportCoordinate(column * spacing, viewport.origin.dx);
        if (x > size.width) break;

        final isMajor = row % divisionCount == 0 && column % divisionCount == 0;
        canvas.drawCircle(
          Offset(x, y),
          isMajor ? majorRadius : minorRadius,
          isMajor ? majorPaint : minorPaint,
        );
      }
    }
  }

  void _paintCustom(Canvas canvas, KlpCustomPageBackgroundRecipe recipe) {
    final points = <int, KlpPageBackgroundPoint>{
      for (final point in recipe.points) point.id: point,
    };
    final linePaint = _paintFor(recipe.lineStyle, recipe.strokeBehavior);
    final pointPaint = _paintFor(recipe.pointStyle, recipe.strokeBehavior);
    final pointRadius = pointPaint.strokeWidth / 2;

    for (final line in recipe.lines) {
      final start = points[line.startPointId];
      final end = points[line.endPointId];
      if (start == null || end == null) continue;
      canvas.drawLine(
        viewport.pageToViewport(start.position),
        viewport.pageToViewport(end.position),
        linePaint,
      );
    }

    for (final point in recipe.points) {
      canvas.drawCircle(
        viewport.pageToViewport(point.position),
        pointRadius,
        pointPaint,
      );
    }
  }

  Paint _paintFor(
    KlpPageBackgroundAxisStyle axis,
    KlpPageBackgroundStrokeBehavior behavior, {
    double? defaultWidth,
  }) {
    return Paint()
      ..color = axis.color ?? visuals.pattern
      ..strokeWidth = resolveMarkWidth(
        axis,
        behavior,
        defaultWidth: defaultWidth,
      )
      ..strokeCap = StrokeCap.round;
  }

  @visibleForTesting
  double resolveMarkWidth(
    KlpPageBackgroundAxisStyle axis,
    KlpPageBackgroundStrokeBehavior behavior, {
    double? defaultWidth,
  }) {
    final scale = behavior == KlpPageBackgroundStrokeBehavior.scaled
        ? viewport.scale
        : 1.0;
    return (axis.width ?? defaultWidth ?? visuals.markWidth) * scale;
  }

  double _toViewportCoordinate(double coordinate, double origin) {
    return (coordinate - origin) * viewport.scale;
  }

  @override
  bool shouldRepaint(covariant KlpPageBackgroundPainter oldDelegate) {
    return oldDelegate.recipe != recipe ||
        oldDelegate.viewport != viewport ||
        oldDelegate.visuals != visuals;
  }
}
