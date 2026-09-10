part of '../klp_tabs.dart';

/// 套用單一分頁的語意、互動與表面配方。
class _KlpTabFrame extends StatelessWidget {
	const _KlpTabFrame({
		required this.selected,
		required this.onPressed,
		required this.child,
	});

	final bool selected;
	final VoidCallback onPressed;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final radius = context.klp.shape.control;

		return Semantics(
			button: true,
			selected: selected,
			child: Material(
				color: selected
						? context.klpColors.surfaceMuted
						: context.klpColors.surfaceInset,
				borderRadius: BorderRadius.circular(radius),
				child: InkWell(
					onTap: onPressed,
					borderRadius: BorderRadius.circular(radius),
					child: Container(
						height: context.klp.space.chromeTab,
						alignment: Alignment.center,
						padding: EdgeInsets.symmetric(
							horizontal: context.klp.space.base,
						),
						child: child,
					),
				),
			),
		);
	}
}
