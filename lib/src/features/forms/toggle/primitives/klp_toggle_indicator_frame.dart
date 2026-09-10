part of '../klp_toggle.dart';

class _KlpToggleIndicatorFrame extends StatelessWidget {
	const _KlpToggleIndicatorFrame({required this.style});

	final _KlpToggleIndicatorStyle style;

	@override
	Widget build(BuildContext context) {
		return ExcludeSemantics(
			child: SizedBox(
				width: style.width,
				height: style.height,
				child: DecoratedBox(
					decoration: BoxDecoration(
						color: style.trackColor,
						borderRadius: BorderRadius.circular(style.trackRadius),
					),
					child: Padding(
						padding: EdgeInsets.all(style.inset),
						child: Align(
							alignment: style.alignment,
							child: DecoratedBox(
								decoration: BoxDecoration(
									color: style.thumbColor,
									borderRadius: BorderRadius.circular(style.thumbRadius),
								),
								child: SizedBox.square(dimension: style.thumb),
							),
						),
					),
				),
			),
		);
	}
}
