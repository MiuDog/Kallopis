import 'package:flutter/widgets.dart';

import 'package:kallopis/src/foundation/klp_icon.dart';
import 'package:kallopis/src/foundation/interaction/klp_action_region.dart';
import 'package:kallopis/src/foundation/interaction/klp_action_region_tone.dart';
import 'package:kallopis/src/foundation/layout/klp_box.dart';
import 'package:kallopis/src/foundation/layout/klp_center.dart';
import 'package:kallopis/src/features/overlays/klp_tooltip.dart';
import 'package:kallopis/src/features/workspace/shell/window/klp_window_controls_geometry.dart';

/// 視窗控制列內部的單一按鈕呈現。
class KlpWindowControlButton extends StatelessWidget {
  const KlpWindowControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.geometry,
    this.destructive = false,
  });

  final KlpIconData icon;
  final String label;
  final VoidCallback? onPressed;
  final KlpWindowControlsGeometry geometry;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return KlpTooltip(
      message: label,
      child: KlpActionRegion(
        label: label,
        onPressed: onPressed,
        tone: destructive
            ? KlpActionRegionTone.destructive
            : KlpActionRegionTone.neutral,
        builder: (context, style) => KlpBox.square(
          dimension: geometry.extent,
          child: KlpCenter(
            child: KlpIcon(
              icon,
              size: geometry.iconExtent,
              color: style.foreground,
            ),
          ),
        ),
      ),
    );
  }
}
