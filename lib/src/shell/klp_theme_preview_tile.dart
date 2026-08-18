import 'package:flutter/material.dart';

import '../foundation/klp_palette.dart';
import '../interaction/klp_pressable.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

enum KlpThemePreviewMode { light, dark, ultraDark, system, transparent }

class KlpThemePreviewTile extends StatelessWidget {
  const KlpThemePreviewTile({
    super.key,
    required this.mode,
    required this.label,
    required this.description,
    this.width = 168,
    this.selected = false,
    this.enabled = true,
    this.onSelected,
  });

  final KlpThemePreviewMode mode;
  final String label;
  final String description;
  final double width;
  final bool selected;
  final bool enabled;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final radius = BorderRadius.circular(context.klp.shape.panel);
    final foreground = enabled ? tokens.text : tokens.textFaint;

    return Semantics(
      button: onSelected != null,
      enabled: enabled,
      selected: selected,
      label: '$label · $description',
      child: SizedBox(
        key: ValueKey('theme-preview-${mode.name}'),
        width: width,
        child: KlpPressable(
          onPressed: enabled ? onSelected : null,
          borderRadius: radius,
          child: Opacity(
            opacity: enabled ? 1 : 0.62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: selected ? tokens.selectionBackground : null,
                    borderRadius: radius,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(selected ? context.klp.space.tight : 0),
                    child: ClipRRect(
                      borderRadius: radius,
                      child: CustomPaint(
                        size: Size(width, width * 0.66),
                        painter: _ThemePreviewPainter(mode, context.klp.shape.panel),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.klp.space.tight),
                KlpText(label, role: KlpTextRole.caption, color: foreground),
                const SizedBox(height: 1),
                KlpText(
                  description,
                  role: KlpTextRole.caption,
                  color: enabled ? tokens.textFaint : tokens.warning,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemePreviewPainter extends CustomPainter {
  const _ThemePreviewPainter(this.mode, this.cornerRadius);

  final KlpThemePreviewMode mode;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 168;
    final previewRect = Offset.zero & size;
    final clip = RRect.fromRectAndRadius(
      previewRect,
      Radius.circular(cornerRadius * scale),
    );
    canvas.save();
    canvas.clipRRect(clip);

    final front = _skinFor(mode);
    final back = mode == KlpThemePreviewMode.system
        ? _ThemePreviewSkin.dark
        : front;
    _paintBackdrop(canvas, previewRect, front, back);
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

  void _paintBackdrop(
    Canvas canvas,
    Rect rect,
    _ThemePreviewSkin front,
    _ThemePreviewSkin back,
  ) {
    if (mode == KlpThemePreviewMode.system) {
      canvas.drawRect(
        Rect.fromLTRB(rect.left, rect.top, rect.center.dx, rect.bottom),
        Paint()..color = _ThemePreviewSkin.light.app,
      );
      canvas.drawRect(
        Rect.fromLTRB(rect.center.dx, rect.top, rect.right, rect.bottom),
        Paint()..color = _ThemePreviewSkin.dark.app,
      );
      return;
    }

    if (mode == KlpThemePreviewMode.transparent) {
      // 此色帶只模擬桌布，讓透明主題預覽能表達半透明表面的實際用途。
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
    _ThemePreviewSkin skin, {
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
    _ThemePreviewSkin skin,
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
    _ThemePreviewSkin skin,
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

  _ThemePreviewSkin _skinFor(KlpThemePreviewMode value) {
    return switch (value) {
      KlpThemePreviewMode.light => _ThemePreviewSkin.light,
      KlpThemePreviewMode.dark => _ThemePreviewSkin.dark,
      KlpThemePreviewMode.ultraDark => _ThemePreviewSkin.ultraDark,
      KlpThemePreviewMode.system => _ThemePreviewSkin.light,
      KlpThemePreviewMode.transparent => _ThemePreviewSkin.transparent,
    };
  }

  @override
  bool shouldRepaint(covariant _ThemePreviewPainter oldDelegate) {
    return oldDelegate.mode != mode;
  }
}

class _ThemePreviewSkin {
  const _ThemePreviewSkin({
    required this.app,
    required this.surface,
    required this.well,
    required this.outline,
    required this.ink,
    required this.faint,
  });

  final Color app;
  final Color surface;
  final Color well;
  final Color outline;
  final Color ink;
  final Color faint;

  static const light = _ThemePreviewSkin(
    app: KlpPalette.canvas,
    surface: KlpPalette.paper,
    well: KlpPalette.paperInset,
    outline: KlpPalette.divider,
    ink: KlpPalette.ink,
    faint: KlpPalette.inkFaint,
  );
  static const dark = _ThemePreviewSkin(
    app: KlpPalette.duskRaised,
    surface: KlpPalette.duskMuted,
    well: KlpPalette.duskLifted,
    outline: KlpPalette.duskDivider,
    ink: KlpPalette.chalk,
    faint: KlpPalette.chalkFaint,
  );
  static const ultraDark = _ThemePreviewSkin(
    app: KlpPalette.night,
    surface: KlpPalette.nightInset,
    well: KlpPalette.nightMuted,
    outline: KlpPalette.nightDivider,
    ink: KlpPalette.chalk,
    faint: KlpPalette.chalkFaint,
  );
  static const transparent = _ThemePreviewSkin(
    app: KlpPalette.transparent,
    surface: KlpPalette.transparentSurface,
    well: KlpPalette.transparentSurfaceInset,
    outline: KlpPalette.duskDivider,
    ink: KlpPalette.chalk,
    faint: KlpPalette.chalkFaint,
  );
}
