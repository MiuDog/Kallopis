part of '../klp_rail_item.dart';

class _KlpRailBadgeIndicator extends StatelessWidget {
  const _KlpRailBadgeIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.klp.geometry.optical.railBadgeInset,
      right: context.klp.geometry.optical.railBadgeInset,
      child: SizedBox.square(
        dimension: context.klp.space.indicatorDotLarge,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.klpColors.info,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
