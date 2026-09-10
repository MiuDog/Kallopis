part of '../klp_stepper.dart';

class _KlpStepMarker extends StatelessWidget {
	const _KlpStepMarker({required this.status, required this.index});

	final KlpStepStatus status;
	final int index;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final klp = context.klp;
		final size = klp.geometry.data.stepperMarkerSize;

		final Color background;
		final Color foreground;
		final Color borderColor;
		final double borderWidth;
		switch (status) {
			case KlpStepStatus.completed:
				background = tokens.text;
				foreground = KlpThemeContrast.foregroundFor(tokens.text);
				borderColor = tokens.text;
				borderWidth = klp.shape.stroke;
			case KlpStepStatus.current:
				background = tokens.clear;
				foreground = tokens.text;
				borderColor = tokens.text;
				borderWidth = klp.shape.stroke;
			case KlpStepStatus.upcoming:
				background = tokens.clear;
				foreground = tokens.textFaint;
				borderColor = tokens.guide;
				borderWidth = klp.shape.hairline;
		}

		return Container(
			width: size,
			height: size,
			alignment: Alignment.center,
			decoration: BoxDecoration(
				color: background,
				shape: BoxShape.circle,
				border: Border.all(color: borderColor, width: borderWidth),
			),
			child: status == KlpStepStatus.completed
				? KlpIcon(
					KlpIcons.check,
					size: klp.space.iconSmall,
					color: foreground,
				)
				: KlpText('${index + 1}', role: KlpTextRole.label, color: foreground),
		);
	}
}
