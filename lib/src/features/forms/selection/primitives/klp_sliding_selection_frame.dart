part of '../klp_sliding_selection.dart';

class _KlpSlidingSelectionFrame extends StatelessWidget {
	const _KlpSlidingSelectionFrame({
		required this.label,
		required this.selectedIndex,
		required this.options,
		required this.onSelected,
		required this.style,
	});

	final String label;
	final int selectedIndex;
	final List<KlpSelectionOption> options;
	final ValueChanged<int>? onSelected;
	final _KlpSlidingSelectionStyle style;

	@override
	Widget build(BuildContext context) {
		final selectedColor = style.toneColor(options[selectedIndex].tone);
		return Semantics(
			label: label,
			enabled: onSelected != null,
			child: Container(
				width: style.totalWidth(options.length),
				height: style.controlHeight,
				padding: EdgeInsets.all(style.padding),
				decoration: BoxDecoration(
					color: style.surfaceColor,
					borderRadius: BorderRadius.circular(style.controlRadius),
					border: Border.all(color: style.dividerColor, width: style.borderWidth),
				),
				child: Stack(
					children: [
						AnimatedPositioned(
							key: ValueKey('pln-selection-indicator-$label'),
							duration: style.stateDuration,
							curve: style.curve,
							left: selectedIndex * style.segmentWidth,
							top: 0,
							width: style.segmentWidth,
							height: style.indicatorHeight,
							child: AnimatedContainer(
								duration: style.styleDuration,
								decoration: BoxDecoration(
									color: selectedColor.withValues(alpha: style.statusFillOpacity),
									borderRadius: BorderRadius.circular(style.indicatorRadius),
									border: Border.all(color: selectedColor, width: style.borderWidth),
								),
							),
						),
						Row(
							mainAxisSize: MainAxisSize.min,
							children: [
								for (var index = 0; index < options.length; index++)
									SizedBox(
										width: style.segmentWidth,
										height: style.indicatorHeight,
										child: Center(
											child: KlpIcon(
												options[index].icon,
												size: context.klp.space.iconSmall,
												color: index == selectedIndex ? style.toneColor(options[index].tone) : style.mutedColor,
											),
										),
									),
							],
						),
						Row(
							mainAxisSize: MainAxisSize.min,
							children: [
								for (var index = 0; index < options.length; index++)
									Material(
										color: style.clearColor,
										borderRadius: BorderRadius.circular(style.indicatorRadius),
										child: InkWell(
											key: ValueKey('pln-selection-hit-$label-$index'),
											onTap: onSelected == null ? null : () => onSelected!(index),
											borderRadius: BorderRadius.circular(style.indicatorRadius),
											child: SizedBox(width: style.segmentWidth, height: style.indicatorHeight),
										),
									),
							],
						),
					],
				),
			),
		);
	}
}
