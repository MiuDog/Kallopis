part of '../klp_navigation_rail.dart';

class _KlpRailGroupDivider extends StatelessWidget {
  const _KlpRailGroupDivider();

  @override
  Widget build(BuildContext context) {
    final inset = context.klp.space.navigationRailInset;

    return KlpBox(
      insets: KlpBoxInsets.directional(top: inset, bottom: inset),
      child: const KlpRailDivider(id: 'group-boundary').build(context),
    );
  }
}
