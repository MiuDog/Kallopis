part of '../klp_action_region.dart';

/// 統一封裝按鈕語意、hover、focus 與可點擊表面的互動原語。
class KlpActionRegion extends StatelessWidget {
  const KlpActionRegion({
    super.key,
    required this.label,
    required this.onPressed,
    required this.builder,
    this.tone = KlpActionRegionTone.neutral,
    this.selected = false,
    this.active = false,
    this.toggled,
    this.expanded,
    this.shape = KlpActionRegionShape.card,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget Function(BuildContext context, KlpActionRegionStyle style)
  builder;
  final KlpActionRegionTone tone;
  final bool selected;
  final bool active;
  final bool? toggled;
  final bool? expanded;
  final KlpActionRegionShape shape;

  @override
  Widget build(BuildContext context) {
    var hovered = false;
    var focused = false;

    return StatefulBuilder(
      builder: (context, setState) {
        final colors = context.klpColors;
        final radius = switch (shape) {
          KlpActionRegionShape.card => context.klp.shape.card,
          KlpActionRegionShape.control => context.klp.shape.control,
        };
        final enabled = onPressed != null;
        final effectiveActive =
            enabled && (selected || active || hovered || focused);
        final foreground = switch ((enabled, tone, selected, effectiveActive)) {
          (false, _, _, _) => colors.textFaint,
          (true, KlpActionRegionTone.destructive, _, true) => colors.onStatus,
          (true, KlpActionRegionTone.destructive, _, false) => colors.danger,
          (true, _, true, _) => colors.text,
          _ => colors.textMuted,
        };
        final background = switch ((tone, selected, effectiveActive)) {
          (_, true, _) => colors.selectionBackground,
          (KlpActionRegionTone.destructive, false, true) => colors.danger,
          (_, _, true) => context.klp.selectionWash,
          _ => colors.clear,
        };

        return Semantics(
          button: true,
          enabled: enabled,
          label: label,
          selected: selected,
          toggled: toggled,
          expanded: expanded,
          child: Material(
            color: background,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              onTap: onPressed,
              onHover: (value) => setState(() => hovered = value),
              onFocusChange: (value) => setState(() => focused = value),
              borderRadius: BorderRadius.circular(radius),
              child: builder(
                context,
                KlpActionRegionStyle(foreground: foreground),
              ),
            ),
          ),
        );
      },
    );
  }
}
