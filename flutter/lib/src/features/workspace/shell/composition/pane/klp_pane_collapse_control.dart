import 'package:flutter/widgets.dart';

import 'package:kallopis/src/foundation/klp_icon.dart';
import 'package:kallopis/src/foundation/klp_icons.dart';
import 'package:kallopis/src/foundation/interaction/klp_action_region.dart';
import 'package:kallopis/src/foundation/interaction/klp_action_region_shape.dart';
import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';

part 'primitives/klp_pane_collapse_icon_frame.dart';

/// Pane 的收合互動控制。
class KlpPaneCollapseControl extends StatelessWidget {
  const KlpPaneCollapseControl({
    super.key,
    this.icon,
    this.label,
    required this.collapsed,
    required this.onToggle,
  });

  final KlpIconData? icon;
  final String? label;
  final bool collapsed;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = icon ?? KlpIcons.panelLeft;
    final effectiveLabel =
        label ?? KlpLocalizations.of(context).panelToggleLabel;

    return KlpActionRegion(
      label: effectiveLabel,
      onPressed: onToggle,
      expanded: !collapsed,
      shape: KlpActionRegionShape.control,
      builder: (context, style) => _KlpPaneCollapseIconFrame(
        child: KlpIcon(
          effectiveIcon,
          size: context.klp.space.iconBase,
          color: collapsed ? context.klpColors.textFaint : style.foreground,
        ),
      ),
    );
  }
}
