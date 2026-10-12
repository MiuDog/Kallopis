part of '../klp_theme_preview_tile.dart';

/// 主題預覽磚的 responsive 尺寸、語意與互動 primitive。
class _KlpThemePreviewTileFrame extends StatelessWidget {
  const _KlpThemePreviewTileFrame({
    required this.mode,
    required this.semanticLabel,
    required this.selected,
    required this.enabled,
    required this.onSelected,
    required this.child,
  });

  final KlpThemePreviewMode mode;
  final String semanticLabel;
  final bool selected;
  final bool enabled;
  final VoidCallback? onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final preferredWidth =
            context.klp.geometry.layout.themePreviewTileWidth;
        final width = constraints.hasBoundedWidth
            ? math.min(constraints.maxWidth, preferredWidth)
            : preferredWidth;

        return Semantics(
          button: onSelected != null,
          enabled: enabled,
          selected: selected,
          label: semanticLabel,
          child: SizedBox(
            key: ValueKey('theme-preview-${mode.name}'),
            width: width,
            child: KlpPressable(
              onPressed: enabled ? onSelected : null,
              borderRadius: BorderRadius.circular(context.klp.shape.panel),
              child: Opacity(
                opacity: enabled
                    ? 1
                    : context.klp.surface.themePreviewDisabledOpacity,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
