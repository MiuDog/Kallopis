part of '../klp_filter_bar.dart';

class _KlpFilterRemoveAction extends StatelessWidget {
	const _KlpFilterRemoveAction({
		required this.onPressed,
		required this.foreground,
	});

	final VoidCallback onPressed;
	final Color foreground;

	@override
	Widget build(BuildContext context) {
		return KlpGestureRegion(
			behavior: HitTestBehavior.opaque,
			onTap: onPressed,
			child: KlpIcon(
				KlpIcons.close,
				size: context.klp.space.iconSmall,
				color: foreground,
			),
		);
	}
}
