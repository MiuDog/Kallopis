part of '../klp_entity_picker.dart';

class _KlpEntityResultFrame extends StatelessWidget {
	const _KlpEntityResultFrame({
		required this.selected,
		required this.onPressed,
		required this.child,
	});

	final bool selected;
	final VoidCallback? onPressed;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final radius = BorderRadius.circular(klp.shape.control);

		return Material(
			color: selected ? klp.color.surfaceMuted : klp.color.clear,
			borderRadius: radius,
			child: InkWell(
				onTap: onPressed,
				borderRadius: radius,
				child: child,
			),
		);
	}
}
