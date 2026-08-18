import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';

enum KlpStrokeRole { structure, latent, field }

enum KlpStrokeState { rest, hovered, focused, selected, disabled }

class KlpStrokeFrame extends StatelessWidget {
  const KlpStrokeFrame({
    super.key,
    required this.role,
    required this.child,
    this.state = KlpStrokeState.rest,
    this.radius,
    this.width,
    this.dashLength,
    this.gapLength,
    this.opacity,
  }) : assert(
         role == KlpStrokeRole.field || state == KlpStrokeState.rest,
         'Only field strokes accept an interaction state.',
       );

  final KlpStrokeRole role;
  final Widget child;
  final KlpStrokeState state;
  /// 以下皆為 `null` 表示沿用 theme。指定值只用於刻意偏離的場合——
  /// 建構子預設值是編譯期常數，讀不到 theme。
  final double? radius;
  final double? width;
  final double? dashLength;
  final double? gapLength;
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    final shape = context.klp.shape;
    final effectiveRadius = radius ?? shape.control;
    final effectiveWidth = width ?? shape.hairline;
    final effectiveDashLength = dashLength ?? shape.dashedLength;
    final effectiveGapLength = gapLength ?? shape.dashedGap;
    final effectiveOpacity = opacity ?? shape.dashedOpacity;

    return switch (role) {
      KlpStrokeRole.structure => child,
      KlpStrokeRole.latent => CustomPaint(
        foregroundPainter: _KlpLatentStrokePainter(
          color: context.klpColors.guide.withValues(alpha: effectiveOpacity),
          radius: effectiveRadius,
          width: effectiveWidth,
          dashLength: effectiveDashLength,
          gapLength: effectiveGapLength,
        ),
        child: child,
      ),
      KlpStrokeRole.field => DecoratedBox(
        decoration: BoxDecoration(
          color: KlpFieldStyle.colorFor(context.klpColors, _fieldFillState()),
          borderRadius: BorderRadius.circular(effectiveRadius),
        ),
        child: child,
      ),
    };
  }

  KlpFieldFillState _fieldFillState() {
    return switch (state) {
      KlpStrokeState.rest => KlpFieldFillState.rest,
      KlpStrokeState.hovered => KlpFieldFillState.hovered,
      KlpStrokeState.focused => KlpFieldFillState.focused,
      KlpStrokeState.selected => KlpFieldFillState.selected,
      KlpStrokeState.disabled => KlpFieldFillState.disabled,
    };
  }
}

class _KlpLatentStrokePainter extends CustomPainter {
  const _KlpLatentStrokePainter({
    required this.color,
    required this.radius,
    required this.width,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double radius;
  final double width;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = width / 2;
    final bounds = Rect.fromLTWH(
      inset,
      inset,
      size.width - width,
      size.height - width,
    );
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          bounds,
          Radius.circular((radius - inset).clamp(0, radius)),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;

      while (distance < metric.length) {
        final end = (distance + dashLength)
            .clamp(0.0, metric.length)
            .toDouble();
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _KlpLatentStrokePainter oldDelegate) {
    return color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        width != oldDelegate.width ||
        dashLength != oldDelegate.dashLength ||
        gapLength != oldDelegate.gapLength;
  }
}
