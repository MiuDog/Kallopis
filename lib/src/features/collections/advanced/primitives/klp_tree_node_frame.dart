part of '../klp_advanced_data.dart';

class _KlpTreeNodeFrame extends StatelessWidget {
	const _KlpTreeNodeFrame({
		required this.style,
		required this.background,
		required this.child,
	});

	final _KlpAdvancedStyle style;
	final Color? background;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Container(
			constraints: BoxConstraints(minHeight: style.controlHeight),
			padding: EdgeInsets.symmetric(horizontal: style.controlInset),
			decoration: BoxDecoration(
				color: background,
				borderRadius: BorderRadius.circular(style.controlRadius),
			),
			child: child,
		);
	}
}
