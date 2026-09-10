part of '../klp_navigator.dart';

class _KlpNavigatorDisclosure extends StatelessWidget {
	const _KlpNavigatorDisclosure({
		required this.expanded,
		required this.size,
		this.selected = false,
	});

	final bool expanded;
	final double size;
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
				size: size,
				color: selected ? context.klpColors.text : context.klpColors.textMuted,
			),
		);
	}
}
