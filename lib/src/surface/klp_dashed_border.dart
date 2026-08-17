import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import 'klp_stroke.dart';

class KlpDashedBorder extends StatelessWidget {
  const KlpDashedBorder({
    super.key,
    required this.child,
    this.radius = KlpRadius.control,
    this.width = KlpLine.hairline,
    this.dashLength = KlpLine.dashedLength,
    this.gapLength = KlpLine.dashedGap,
    this.opacity = KlpLine.dashedOpacity,
  });

  final Widget child;
  final double radius;
  final double width;
  final double dashLength;
  final double gapLength;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return KlpStrokeFrame(
      role: KlpStrokeRole.latent,
      radius: radius,
      width: width,
      dashLength: dashLength,
      gapLength: gapLength,
      opacity: opacity,
      child: child,
    );
  }
}

class KlpDashedDivider extends StatelessWidget {
  const KlpDashedDivider({
    super.key,
    this.width = KlpLine.hairline,
    this.dashLength = KlpLine.dashedLength,
    this.gapLength = KlpLine.dashedGap,
    this.opacity = KlpLine.dashedOpacity,
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
        painter: _KlpDashedDividerPainter(
          color: context.klpColors.guide.withValues(alpha: opacity),
          width: width,
          dashLength: dashLength,
          gapLength: gapLength,
        ),
      ),
    );
  }
}

class _KlpDashedDividerPainter extends CustomPainter {
  const _KlpDashedDividerPainter({
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
  bool shouldRepaint(covariant _KlpDashedDividerPainter oldDelegate) {
    return color != oldDelegate.color ||
        width != oldDelegate.width ||
        dashLength != oldDelegate.dashLength ||
        gapLength != oldDelegate.gapLength;
  }
}
