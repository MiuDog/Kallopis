part of '../klp_badge.dart';

class _KlpTagFrame extends StatelessWidget {
	const _KlpTagFrame({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.symmetric(
				horizontal: context.klp.space.controlInset,
				vertical: context.klp.space.tight,
			),
			decoration: BoxDecoration(
				color: context.klpColors.surfaceInset,
				borderRadius: BorderRadius.circular(context.klp.shape.control),
				border: Border.all(
					color: context.klpColors.divider,
					width: context.klp.shape.hairline,
				),
			),
			child: child,
		);
	}
}
