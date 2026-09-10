import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../foundation/klp_palette.dart';
import '../../../../foundation/interaction/klp_pressable.dart';
import '../../../../foundation/layout/klp_column.dart';
import '../../../../foundation/layout/klp_gap.dart';
import '../../../../foundation/layout/klp_space_size.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';
import 'klp_theme_preview_mode.dart';

export 'klp_theme_preview_mode.dart';

part 'internal/klp_theme_preview_skin.dart';
part 'primitives/klp_theme_preview_artwork.dart';
part 'primitives/klp_theme_preview_painter.dart';
part 'primitives/klp_theme_preview_tile_frame.dart';

/// 以插圖預覽受控的 Kallopis 顏色模式。
class KlpThemePreviewTile extends StatelessWidget {
  const KlpThemePreviewTile({
    super.key,
    required this.mode,
    required this.label,
    required this.description,
    this.selected = false,
    this.enabled = true,
    this.onSelected,
  });

  final KlpThemePreviewMode mode;
  final String label;
  final String description;
  final bool selected;
  final bool enabled;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.klpColors;

    return _KlpThemePreviewTileFrame(
      mode: mode,
      semanticLabel: '$label · $description',
      selected: selected,
      enabled: enabled,
      onSelected: onSelected,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _KlpThemePreviewArtwork(mode: mode, selected: selected),
          const KlpGap.heightSize(KlpSpaceSize.tight),
          KlpText(
            label,
            role: KlpTextRole.caption,
            tone: enabled ? KlpTextTone.automatic : KlpTextTone.faint,
          ),
          const KlpGap.heightSize(KlpSpaceSize.xxs),
          KlpText(
            description,
            role: KlpTextRole.caption,
            color: enabled ? colors.textFaint : colors.warning,
          ),
        ],
      ),
    );
  }
}
