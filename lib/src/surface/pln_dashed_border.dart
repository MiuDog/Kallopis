import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import 'pln_stroke.dart';

class PlnDashedBorder extends StatelessWidget {
  const PlnDashedBorder({
    super.key,
    required this.child,
    this.radius = PlnRadius.control,
    this.width = PlnLine.hairline,
    this.dashLength = PlnLine.dashedLength,
    this.gapLength = PlnLine.dashedGap,
    this.opacity = PlnLine.dashedOpacity,
  });

  final Widget child;
  final double radius;
  final double width;
  final double dashLength;
  final double gapLength;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return PlnStrokeFrame(
      role: PlnStrokeRole.latent,
      radius: radius,
      width: width,
      dashLength: dashLength,
      gapLength: gapLength,
      opacity: opacity,
      child: child,
    );
  }
}

class PlnDashedDivider extends StatelessWidget {
  const PlnDashedDivider({
    super.key,
    this.width = PlnLine.hairline,
    this.dashLength = PlnLine.dashedLength,
    this.gapLength = PlnLine.dashedGap,
    this.opacity = PlnLine.dashedOpacity,
  });

  final double width;
  final double dashLength;
  final double gapLength;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      width: double.infinity,
      child: CustomPaint(
        painter: _PlnDashedDividerPainter(
          color: context.plnTheme.guide.withValues(alpha: opacity),
          width: width,
          dashLength: dashLength,
          gapLength: gapLength,
        ),
      ),
    );
  }
}

class _PlnDashedDividerPainter extends CustomPainter {
  const _PlnDashedDividerPainter({
    required this.color,
    required this.width,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double width;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;
    var left = 0.0;

    while (left < size.width) {
      final right = (left + dashLength).clamp(0.0, size.width).toDouble();
      canvas.drawLine(
        Offset(left, size.height / 2),
        Offset(right, size.height / 2),
        paint,
      );
      left = right + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant _PlnDashedDividerPainter oldDelegate) {
    return color != oldDelegate.color ||
        width != oldDelegate.width ||
        dashLength != oldDelegate.dashLength ||
        gapLength != oldDelegate.gapLength;
  }
}
