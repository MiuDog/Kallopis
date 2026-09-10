part of '../klp_stage_frame.dart';

/// 套用舞台表面與對應內容色票的底層邊界。
class _KlpStageSurface extends StatelessWidget {
	const _KlpStageSurface({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		final background = context.klpColors.stageSurface;

		return ColoredBox(
			color: background,
			child: KlpTokenOverride(
				colors: context.klpColors.onBackground(background),
				child: child,
			),
		);
	}
}
