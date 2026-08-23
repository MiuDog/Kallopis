import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../shell/klp_theme_preview_tile.dart';
import '../theme/klp_theme.dart';

/// 顏色模式預覽的文案與可用狀態。
@immutable
class KlpThemeModeOption {
  const KlpThemeModeOption({
    required this.mode,
    required this.label,
    required this.description,
    this.enabled = true,
  });

  final KlpThemePreviewMode mode;
  final String label;
  final String description;
  final bool enabled;
}

/// 以 Kallopis 預覽磚排列受控的顏色模式選項。
class KlpThemeModePicker extends StatelessWidget {
  const KlpThemeModePicker({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<KlpThemeModeOption> options;
  final KlpThemePreviewMode selected;
  final ValueChanged<KlpThemePreviewMode> onSelected;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return LayoutBuilder(
      builder: (context, constraints) {
        final preferredWidth = klp.geometry.layout.themePreviewTileWidth;
        final tileWidth = constraints.hasBoundedWidth
            ? math.min(constraints.maxWidth, preferredWidth)
            : preferredWidth;

        return Wrap(
          spacing: klp.space.base,
          runSpacing: klp.space.comfortable,
          children: [
            for (final option in options)
              KlpThemePreviewTile(
                mode: option.mode,
                label: option.label,
                description: option.description,
                width: tileWidth,
                selected: option.mode == selected,
                enabled: option.enabled,
                onSelected: option.enabled
                    ? () => onSelected(option.mode)
                    : null,
              ),
          ],
        );
      },
    );
  }
}
