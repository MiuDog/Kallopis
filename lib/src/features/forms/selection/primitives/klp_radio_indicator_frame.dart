part of '../klp_radio_group.dart';

class _KlpRadioIndicatorFrame extends StatelessWidget {
	const _KlpRadioIndicatorFrame({required this.label, required this.selected, required this.style});

	final String label;
	final bool selected;
	final _KlpRadioItemStyle style;

	@override
	Widget build(BuildContext context) {
		return Semantics(
			checked: selected,
			inMutuallyExclusiveGroup: true,
			label: label,
			child: Material(
				color: style.clearColor,
				shape: const CircleBorder(),
				child: DecoratedBox(
					decoration: BoxDecoration(
						shape: BoxShape.circle,
						border: Border.all(color: style.borderColor, width: style.strokeWidth),
					),
					child: SizedBox.square(
						dimension: style.controlExtent,
						child: Padding(
							padding: EdgeInsets.all(style.indicatorInset),
							child: AnimatedContainer(
								duration: style.duration,
								decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? style.fillColor : null),
							),
						),
					),
				),
			),
		);
	}
}
