part of '../klp_theme_preview_tile.dart';

/// 以固定插圖座標描繪顏色模式，不承擔產品表面布局。
class _KlpThemePreviewPainter extends CustomPainter {
  const _KlpThemePreviewPainter(this.mode, this.cornerRadius);

  static const double _designWidth = 168;
  static const double _designHeightFactor = 0.66;
  static const double designAspectRatio = 1 / _designHeightFactor;

  final KlpThemePreviewMode mode;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _designWidth;
    final previewRect = Offset.zero & size;
    final clip = RRect.fromRectAndRadius(
      previewRect,
      Radius.circular(cornerRadius * scale),
    );
    canvas.save();
    canvas.clipRRect(clip);

    final front = _skinFor(mode);
    final back = mode == KlpThemePreviewMode.system
        ? _KlpThemePreviewSkin.dark
        : front;
    _paintBackdrop(canvas, previewRect, front);
    canvas.scale(scale);
    _paintWindow(
      canvas,
      const Rect.fromLTWH(14, 11, 104, 66),
      back,
      dimTraffic: true,
      glass: mode == KlpThemePreviewMode.transparent,
    );
    _paintWindow(
      canvas,
      const Rect.fromLTWH(46, 31, 112, 70),
      front,
      glass: mode == KlpThemePreviewMode.transparent,
    );
    canvas.restore();
  }

  void _paintBackdrop(Canvas canvas, Rect rect, _KlpThemePreviewSkin front) {
    if (mode == KlpThemePreviewMode.system) {
      canvas.drawRect(
        Rect.fromLTRB(rect.left, rect.top, rect.center.dx, rect.bottom),
        Paint()..color = _KlpThemePreviewSkin.light.app,
      );
      canvas.drawRect(
        Rect.fromLTRB(rect.center.dx, rect.top, rect.right, rect.bottom),
        Paint()..color = _KlpThemePreviewSkin.dark.app,
      );
      return;
    }

    if (mode == KlpThemePreviewMode.transparent) {
      // 此色帶只模擬桌布，透明度與座標皆屬插圖本身。
      canvas.drawRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: KlpDecorativePalette.previewWallpaper,
            stops: KlpDecorativePalette.previewWallpaperStops,
          ).createShader(rect),
      );
      return;
    }

    canvas.drawRect(rect, Paint()..color = front.app);
  }

  void _paintWindow(
    Canvas canvas,
    Rect rect,
    _KlpThemePreviewSkin skin, {
    bool dimTraffic = false,
    bool glass = false,
  }) {
    final window = RRect.fromRectAndRadius(rect, const Radius.circular(7));
    canvas.save();
    canvas.clipRRect(window);
    canvas.drawRRect(
      window,
      Paint()..color = glass ? skin.app.withValues(alpha: 0.62) : skin.app,
    );

    final titleBar = Rect.fromLTWH(rect.left, rect.top, rect.width, 13);
    canvas.drawRect(
      titleBar,
      Paint()
        ..color = glass ? skin.surface.withValues(alpha: 0.44) : skin.surface,
    );
    _paintTrafficLights(canvas, titleBar, skin, dimTraffic);

    final contentTop = rect.top + 13;
    final sidebarWidth = (rect.width * 0.28).roundToDouble();
    final sidebar = Rect.fromLTWH(
      rect.left,
      contentTop,
      sidebarWidth,
      rect.height - 13,
    );
    canvas.drawRect(
      sidebar,
      Paint()
        ..color = glass ? skin.surface.withValues(alpha: 0.32) : skin.surface,
    );
    _paintRules(canvas, sidebar.deflate(5), skin, const [1, 0.7, 0.85, 0.6]);

    final content = Rect.fromLTRB(
      sidebar.right + 5,
      contentTop + 5,
      rect.right - 5,
      rect.bottom - 5,
    );
    _paintRules(canvas, content, skin, const [0.58, 0.95, 0.8, 0.88, 0.55]);
    final button = RRect.fromRectAndRadius(
      Rect.fromLTWH(content.left, content.bottom - 9, content.width * 0.42, 9),
      const Radius.circular(3),
    );
    canvas.drawRRect(button, Paint()..color = skin.well);
    canvas.restore();

    canvas.drawRRect(
      window,
      Paint()
        ..color = skin.outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.75,
    );
  }

  void _paintTrafficLights(
    Canvas canvas,
    Rect titleBar,
    _KlpThemePreviewSkin skin,
    bool dim,
  ) {
    const colors = KlpDecorativePalette.windowTrafficLights;
    for (var index = 0; index < colors.length; index++) {
      canvas.drawCircle(
        Offset(titleBar.left + 7 + index * 7, titleBar.center.dy),
        2,
        Paint()..color = dim ? skin.faint : colors[index],
      );
    }
  }

  void _paintRules(
    Canvas canvas,
    Rect rect,
    _KlpThemePreviewSkin skin,
    List<double> widths,
  ) {
    for (var index = 0; index < widths.length; index++) {
      final line = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          rect.left,
          rect.top + index * 6,
          rect.width * widths[index],
          index == 0 ? 3.5 : 2.5,
        ),
        const Radius.circular(2),
      );
      canvas.drawRRect(
        line,
        Paint()..color = index == 0 ? skin.ink : skin.faint,
      );
    }
  }

  _KlpThemePreviewSkin _skinFor(KlpThemePreviewMode value) {
    return switch (value) {
      KlpThemePreviewMode.light => _KlpThemePreviewSkin.light,
      KlpThemePreviewMode.dark => _KlpThemePreviewSkin.dark,
      KlpThemePreviewMode.ultraDark => _KlpThemePreviewSkin.ultraDark,
      KlpThemePreviewMode.system => _KlpThemePreviewSkin.light,
      KlpThemePreviewMode.transparent => _KlpThemePreviewSkin.transparent,
    };
  }

  @override
  bool shouldRepaint(covariant _KlpThemePreviewPainter oldDelegate) {
    return oldDelegate.mode != mode || oldDelegate.cornerRadius != cornerRadius;
  }
}
