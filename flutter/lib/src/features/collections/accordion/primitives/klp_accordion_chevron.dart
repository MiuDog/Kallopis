part of '../klp_accordion.dart';

class _KlpAccordionChevron extends StatelessWidget {
  const _KlpAccordionChevron({required this.expanded});

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return AnimatedRotation(
      turns: expanded ? 0.5 : 0,
      duration: klp.motion.stateTransition,
      curve: klp.motion.standard,
      child: KlpIcon(
        KlpIcons.chevronDown,
        size: klp.space.iconSmall,
        color: klp.color.textMuted,
      ),
    );
  }
}
