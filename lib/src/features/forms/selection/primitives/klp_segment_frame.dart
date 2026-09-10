part of '../klp_segmented_control.dart';

class _KlpSegmentFrame extends StatelessWidget {
	const _KlpSegmentFrame({
		required this.label,
		required this.selected,
		required this.onPressed,
		required this.onHover,
		required this.style,
		required this.child,
	});

	final String label;
	final bool selected;
	final VoidCallback onPressed;
	final ValueChanged<bool> onHover;
	final _KlpSegmentStyle style;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Semantics(
			button: true,
			selected: selected,
			child: Material(
				color: style.background,
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.radius)),
				child: InkWell(
					onTap: onPressed,
					onHover: onHover,
					overlayColor: WidgetStatePropertyAll(style.clearColor),
					borderRadius: BorderRadius.circular(style.radius),
					child: SizedBox(
						height: style.height,
						child: Padding(
							padding: EdgeInsets.symmetric(horizontal: style.horizontalInset, vertical: style.verticalInset),
							child: child,
						),
					),
				),
			),
		);
	}
}
