part of '../klp_accordion.dart';

class _KlpAccordionBody extends StatelessWidget {
	const _KlpAccordionBody({
		required this.expanded,
		required this.child,
	});

	final bool expanded;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return AnimatedSize(
			duration: klp.motion.stateTransition,
			curve: klp.motion.standard,
			alignment: Alignment.topCenter,
			child: expanded
					? Padding(
							padding: EdgeInsets.only(
								left: klp.space.contentInset,
								right: klp.space.contentInset,
								bottom: klp.space.contentInset,
							),
							child: child,
						)
					: const SizedBox(width: double.infinity),
		);
	}
}
