part of '../klp_theme_preview_tile.dart';

/// 預覽插圖內模擬視窗所使用的 theme preset 投影。
class _KlpThemePreviewSkin {
  const _KlpThemePreviewSkin({
    required this.app,
    required this.surface,
    required this.well,
    required this.outline,
    required this.ink,
    required this.faint,
  });

  factory _KlpThemePreviewSkin.from(KlpThemeData tokens) =>
      _KlpThemePreviewSkin(
        app: tokens.app,
        surface: tokens.surface,
        well: tokens.surfaceInset,
        outline: tokens.divider,
        ink: tokens.text,
        faint: tokens.textFaint,
      );

  final Color app;
  final Color surface;
  final Color well;
  final Color outline;
  final Color ink;
  final Color faint;

  static final light = _KlpThemePreviewSkin.from(KlpThemeData.light);
  static final dark = _KlpThemePreviewSkin.from(KlpThemeData.dark);
  static final ultraDark = _KlpThemePreviewSkin.from(KlpThemeData.ultraDark);
  static final transparent = _KlpThemePreviewSkin.from(
    KlpThemeData.transparent,
  );
}
