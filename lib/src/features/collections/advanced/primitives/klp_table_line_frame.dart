part of '../klp_advanced_data.dart';

class _KlpTableLineFrame extends StatelessWidget {
	const _KlpTableLineFrame({
		required this.style,
		required this.header,
		required this.selected,
		required this.onPressed,
		required this.child,
	});

	final _KlpAdvancedStyle style;
	final bool header;
	final bool selected;
	final VoidCallback? onPressed;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			behavior: HitTestBehavior.opaque,
			onTap: onPressed,
			child: Container(
				constraints: BoxConstraints(minHeight: style.controlHeight),
				decoration: BoxDecoration(
					color: header
							? style.surfaceInset
							: (selected ? style.surfaceMuted : null),
				),
				child: child,
			),
		);
	}
}
