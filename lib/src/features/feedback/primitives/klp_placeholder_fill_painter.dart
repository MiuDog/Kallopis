part of '../klp_region_placeholder.dart';

/// 繪製 Placeholder 的底色與斜線填充。
class _KlpPlaceholderFillPainter extends CustomPainter {
  const _KlpPlaceholderFillPainter({
    required this.fillColor,
    required this.hatchColor,
    required this.hatched,
    required this.hatchBand,
    required this.hatchGap,
  });

  final Color fillColor;
  final Color hatchColor;
  final bool hatched;
  final double hatchBand;
  final double hatchGap;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = fillColor);
    if (!hatched) {
      canvas.restore();
      return;
    }

    final strokeWidth = hatchBand;
    final step = (hatchBand + hatchGap) * math.sqrt2;
    final paint = Paint()
      ..color = hatchColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final extra = size.height + strokeWidth * 4;
    final startOffset = -size.height - strokeWidth * 4;
    final endOffset = size.width + size.height + strokeWidth * 4;

    for (var offset = startOffset; offset < endOffset; offset += step) {
      canvas.drawLine(
        Offset(offset - extra, -extra),
        Offset(offset + size.height + extra, size.height + extra),
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _KlpPlaceholderFillPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        hatchColor != oldDelegate.hatchColor ||
        hatched != oldDelegate.hatched ||
        hatchBand != oldDelegate.hatchBand ||
        hatchGap != oldDelegate.hatchGap;
  }
}
