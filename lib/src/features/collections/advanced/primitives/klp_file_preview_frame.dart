part of '../klp_advanced_data.dart';

class _KlpFilePreviewFrame extends StatelessWidget {
	const _KlpFilePreviewFrame({
		required this.style,
		required this.onPressed,
		required this.child,
	});

	final _KlpAdvancedStyle style;
	final VoidCallback? onPressed;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			behavior: HitTestBehavior.opaque,
			onTap: onPressed,
			child: Container(
				clipBehavior: Clip.antiAlias,
				decoration: BoxDecoration(
					color: style.component,
					borderRadius: BorderRadius.circular(style.cardRadius),
					border: Border.all(color: style.divider, width: style.strokeWidth),
				),
				child: child,
			),
		);
	}
}
