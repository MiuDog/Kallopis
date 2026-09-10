part of '../klp_file_explorer.dart';

class _KlpFileExplorerDisclosure extends StatelessWidget {
  const _KlpFileExplorerDisclosure({
    required this.expanded,
    required this.size,
    this.selected = false,
  });

  final bool expanded;
  final _KlpFileExplorerDisclosureSize size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    return AnimatedRotation(
      turns: expanded ? 0 : -0.25,
      duration: klp.motion.stateTransition,
      curve: Curves.easeOutCubic,
      child: KlpIcon(
        KlpIcons.chevronDown,
        size: switch (size) {
          _KlpFileExplorerDisclosureSize.section =>
            klp.geometry.layout.disclosureIconSize,
          _KlpFileExplorerDisclosureSize.item => klp.space.iconSmall,
        },
        color: selected ? context.klpColors.text : context.klpColors.textMuted,
      ),
    );
  }
}
