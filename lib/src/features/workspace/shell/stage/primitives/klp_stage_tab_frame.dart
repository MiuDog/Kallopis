part of '../klp_stage_tab.dart';

class _KlpStageTabFrame extends StatelessWidget {
	const _KlpStageTabFrame({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final background = tokens.stageSurface;
		final radius = context.klp.buttonRadius;
		final connectionRadius = context.klp.shape.panel;

		return Material(
			color: context.klp.color.clear,
			child: DecoratedBox(
				decoration: BoxDecoration(
					color: background,
					borderRadius: BorderRadiusDirectional.only(
						topStart: Radius.circular(radius),
						topEnd: Radius.circular(radius),
						bottomEnd: Radius.circular(connectionRadius),
					),
				),
				child: KlpTokenOverride(
					colors: tokens.onBackground(background),
					child: Padding(
						padding: EdgeInsets.symmetric(
							horizontal: context.klp.space.chromePanelInset,
						),
						child: Align(
							alignment: AlignmentDirectional.topStart,
							child: SizedBox(
								height: context.klp.space.chromeTab,
								child: Center(child: child),
							),
						),
					),
				),
			),
		);
	}
}
