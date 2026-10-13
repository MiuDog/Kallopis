part of '../klp_rail_item.dart';

class KlpRailItem extends StatelessWidget {
  const KlpRailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.badge,
  });

  final KlpIconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool selected;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return _KlpRailTooltipAnchor(
      message: label,
      child: KlpActionRegion(
        label: label,
        onPressed: onPressed,
        selected: selected,
        shape: KlpActionRegionShape.control,
        builder: (context, style) {
          return KlpBox(
            widthSize: KlpSpaceSize.navigationRailControl,
            heightSize: KlpSpaceSize.navigationRailControl,
            child: KlpStack(
              clipBehavior: Clip.none,
              children: [
                KlpCenter(
                  child: KlpIcon(
                    icon,
                    color: selected
                        ? context.klpColors.selectionForeground
                        : style.foreground,
                  ),
                ),
                if (badge != null) const _KlpRailBadgeIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
