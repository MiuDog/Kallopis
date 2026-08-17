import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';

enum PlnStrokeRole { structure, latent, field }

enum PlnStrokeState { rest, hovered, focused, selected, disabled }

class PlnStrokeFrame extends StatelessWidget {
  const PlnStrokeFrame({
    super.key,
    required this.role,
    required this.child,
    this.state = PlnStrokeState.rest,
    this.radius = PlnRadius.control,
    this.width = PlnLine.hairline,
    this.dashLength = PlnLine.dashedLength,
    this.gapLength = PlnLine.dashedGap,
    this.opacity = PlnLine.dashedOpacity,
  }) : assert(
         role == PlnStrokeRole.field || state == PlnStrokeState.rest,
         'Only field strokes accept an interaction state.',
       );

  final PlnStrokeRole role;
  final Widget child;
  final PlnStrokeState state;
  final double radius;
  final double width;
  final double dashLength;
  final double gapLength;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return switch (role) {
      PlnStrokeRole.structure => child,
      PlnStrokeRole.latent => CustomPaint(
        foregroundPainter: _PlnLatentStrokePainter(
          color: context.plnTheme.guide.withValues(alpha: opacity),
          radius: radius,
          width: width,
          dashLength: dashLength,
          gapLength: gapLength,
        ),
        child: child,
      ),
      PlnStrokeRole.field => DecoratedBox(
        decoration: BoxDecoration(
          color: PlnFieldStyle.colorFor(context.plnTheme, _fieldFillState()),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    };
  }

  PlnFieldFillState _fieldFillState() {
    return switch (state) {
      PlnStrokeState.rest => PlnFieldFillState.rest,
      PlnStrokeState.hovered => PlnFieldFillState.hovered,
      PlnStrokeState.focused => PlnFieldFillState.focused,
      PlnStrokeState.selected => PlnFieldFillState.selected,
      PlnStrokeState.disabled => PlnFieldFillState.disabled,
    };
  }
}

class _PlnLatentStrokePainter extends CustomPainter {
  const _PlnLatentStrokePainter({
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
  bool shouldRepaint(covariant _PlnLatentStrokePainter oldDelegate) {
    return color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        width != oldDelegate.width ||
        dashLength != oldDelegate.dashLength ||
        gapLength != oldDelegate.gapLength;
  }
}
