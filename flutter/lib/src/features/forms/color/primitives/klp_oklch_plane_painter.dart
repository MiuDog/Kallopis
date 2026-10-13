part of '../klp_oklch_color_picker.dart';

class _OklchPlanePainter extends CustomPainter {
  const _OklchPlanePainter({
    required this.kind,
    required this.value,
    required this.chromaRange,
    required this.style,
  });

  static const int _samples = 32;
  static const double _opaqueAlpha = 1;

  final _OklchPlaneKind kind;
  final KlpOklchColor value;
  final KlpOklchChromaRange chromaRange;
  final _KlpOklchPlaneStyle style;

  double get _maximumChroma => chromaRange.upperBound;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / _samples;
    final cellHeight = size.height / _samples;
    final paint = Paint();

    // 逐格取樣 OKLCH 平面，重疊一個像素避免格線縫隙。
    for (var row = 0; row < _samples; row++) {
      for (var column = 0; column < _samples; column++) {
        final x = (column + 0.5) / _samples;
        final y = (row + 0.5) / _samples;
        paint.color = _colorAt(x, y);
        canvas.drawRect(
          Rect.fromLTWH(
            column * cellWidth,
            row * cellHeight,
            cellWidth + 1,
            cellHeight + 1,
          ),
          paint,
        );
      }
    }

    // 邊框與游標最後繪製，確保不被色彩取樣覆蓋。
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.borderWidth
      ..color = style.borderColor;
    canvas.drawRect(Offset.zero & size, paint);

    final cursor = _cursorOffset(size);
    paint
      ..style = PaintingStyle.fill
      ..color = KlpThemeContrast.foregroundFor(value.toColor());
    canvas.drawCircle(cursor, style.cursorRadius, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.cursorWidth
      ..color = value.toColor();
    canvas.drawCircle(cursor, style.cursorRadius, paint);
  }

  Color _colorAt(double x, double y) {
    final normalizedHue = (value.hue % 360 + 360) % 360;
    final sample = switch (kind) {
      _OklchPlaneKind.lightness => value.copyWith(
        lightness: 1 - y,
        chroma: x * _maximumChroma,
        alpha: _opaqueAlpha,
      ),
      _OklchPlaneKind.chroma => value.copyWith(
        chroma: (1 - y) * _maximumChroma,
        hue: x * 360,
        alpha: _opaqueAlpha,
      ),
      _OklchPlaneKind.hue => value.copyWith(
        lightness: 1 - y,
        hue: x * 360,
        alpha: _opaqueAlpha,
      ),
    };
    if (kind == _OklchPlaneKind.lightness) {
      return sample.copyWith(hue: normalizedHue).toColor();
    }

    return sample.toColor();
  }

  Offset _cursorOffset(Size size) {
    final normalizedHue = (value.hue % 360 + 360) % 360;
    final normalized = switch (kind) {
      _OklchPlaneKind.lightness => Offset(
        value.chroma / _maximumChroma,
        1 - value.lightness,
      ),
      _OklchPlaneKind.chroma => Offset(
        normalizedHue / 360,
        1 - value.chroma / _maximumChroma,
      ),
      _OklchPlaneKind.hue => Offset(normalizedHue / 360, 1 - value.lightness),
    };

    return Offset(
      normalized.dx.clamp(0, 1) * size.width,
      normalized.dy.clamp(0, 1) * size.height,
    );
  }

  @override
  bool shouldRepaint(covariant _OklchPlanePainter oldDelegate) {
    return kind != oldDelegate.kind ||
        value != oldDelegate.value ||
        chromaRange.upperBound != oldDelegate.chromaRange.upperBound ||
        style.borderColor != oldDelegate.style.borderColor ||
        style.borderWidth != oldDelegate.style.borderWidth ||
        style.cursorRadius != oldDelegate.style.cursorRadius ||
        style.cursorWidth != oldDelegate.style.cursorWidth;
  }
}
