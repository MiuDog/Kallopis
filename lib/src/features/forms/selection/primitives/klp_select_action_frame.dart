part of '../klp_select.dart';

class _KlpSelectActionFrame extends StatelessWidget {
	const _KlpSelectActionFrame({
		required this.onPressed,
		required this.onHover,
		required this.onFocusChange,
		required this.style,
		required this.child,
	});

	final VoidCallback? onPressed;
	final ValueChanged<bool> onHover;
	final ValueChanged<bool> onFocusChange;
	final _KlpSelectStyle style;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Material(
			color: style.clearColor,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.radius)),
			child: InkWell(
				onTap: onPressed,
				onHover: onHover,
				onFocusChange: onFocusChange,
				borderRadius: BorderRadius.circular(style.radius),
				child: SizedBox(
					height: style.height,
					child: Padding(
						padding: EdgeInsets.symmetric(horizontal: style.horizontalInset),
						child: child,
					),
				),
			),
		);
	}
}
