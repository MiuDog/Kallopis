part of '../klp_advanced_data.dart';

class _KlpTableCellFrame extends StatelessWidget {
	const _KlpTableCellFrame({
		required this.style,
		required this.flex,
		required this.onTap,
		required this.child,
	});

	final _KlpAdvancedStyle style;
	final int flex;
	final VoidCallback? onTap;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Expanded(
			flex: flex,
			child: GestureDetector(
				behavior: HitTestBehavior.opaque,
				onTap: onTap,
				child: Padding(
					padding: EdgeInsets.symmetric(
						horizontal: style.baseSpace,
						vertical: style.tightSpace,
					),
					child: child,
				),
			),
		);
	}
}
