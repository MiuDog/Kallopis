part of '../klp_icon_button.dart';

/// 圖示按鈕專用的底層繪製、語意與互動框。
class _KlpIconButtonFrame extends StatelessWidget {
	const _KlpIconButtonFrame({
		required this.label,
		required this.selected,
		required this.onPressed,
		required this.onHover,
		required this.onFocusChange,
		required this.quarterTurns,
		required this.style,
		required this.child,
	});

	final String label;
	final bool selected;
	final VoidCallback? onPressed;
	final ValueChanged<bool> onHover;
	final ValueChanged<bool> onFocusChange;
	final int quarterTurns;
	final _KlpIconButtonStyle style;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Semantics(
			button: true,
			selected: selected,
			label: label,
			child: Material(
				color: style.background,
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(style.radius),
				),
				child: InkWell(
					onTap: onPressed,
					onHover: onHover,
					onFocusChange: onFocusChange,
					borderRadius: BorderRadius.circular(style.radius),
					child: SizedBox.square(
						dimension: style.dimension,
						child: Center(
							child: RotatedBox(quarterTurns: quarterTurns, child: child),
						),
					),
				),
			),
		);
	}
}
