part of '../klp_stepper.dart';

class _KlpStepConnector extends StatelessWidget {
	const _KlpStepConnector({required this.completed, required this.direction});

	final bool completed;
	final KlpStepperDirection direction;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final klp = context.klp;
		final color = completed ? tokens.text : tokens.divider;

		return switch (direction) {
			KlpStepperDirection.horizontal => SizedBox(
				width: double.infinity,
				height: klp.shape.stroke,
				child: ColoredBox(color: color),
			),
			KlpStepperDirection.vertical => SizedBox(
				width: klp.shape.stroke,
				height: double.infinity,
				child: ColoredBox(color: color),
			),
		};
	}
}
