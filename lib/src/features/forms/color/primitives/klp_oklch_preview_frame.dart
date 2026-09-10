part of '../klp_oklch_color_picker.dart';

class _KlpOklchPreviewFrame extends StatelessWidget {
	const _KlpOklchPreviewFrame({required this.color, required this.style});

	final Color color;
	final _KlpOklchColorPickerStyle style;

	@override
	Widget build(BuildContext context) {
		return ClipRRect(
			borderRadius: BorderRadius.circular(style.previewRadius),
			child: DecoratedBox(
				decoration: BoxDecoration(
					color: color,
					border: Border.all(
						color: style.previewBorderColor,
						width: style.previewBorderWidth,
					),
				),
				child: SizedBox(height: style.previewHeight),
			),
		);
	}
}
