// 公開參數維持 style 名稱，內部仍需區分 recipe 建構式。
// ignore_for_file: prefer_initializing_formals

import 'package:flutter/widgets.dart';

import '../../theme/klp_theme.dart';
import 'klp_page_background_painter.dart';
import 'klp_page_background_recipe.dart';

/// 頁面的內建向量背景樣式。
enum KlpPageBackgroundStyle { plain, ruled, dots, grid }

/// 在 [child] 下方繪製由 Kallopis theme 控制的頁面背景。
final class KlpPageBackground extends StatelessWidget {
	const KlpPageBackground({
		super.key,
		required KlpPageBackgroundStyle style,
		required this.child,
	}) : _style = style,
		recipe = null,
		viewport = null;

	const KlpPageBackground.recipe({
		super.key,
		required this.recipe,
		required this.child,
		this.viewport,
	}) : _style = null;

	final KlpPageBackgroundStyle? _style;
	KlpPageBackgroundStyle get style => _style!;
	final KlpPageBackgroundRecipe? recipe;
	final KlpPageBackgroundViewport? viewport;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return CustomPaint(
			key: ValueKey('klp-page-background-${_style?.name ?? 'recipe'}'),
			painter: KlpPageBackgroundPainter(
				recipe: recipe ?? _recipeFor(_style!),
				viewport: viewport ?? KlpPageBackgroundViewport(),
				visuals: KlpPageBackgroundVisuals(
					surface: klp.color.stageSurface,
					pattern: klp.color.pagePattern,
					spacing: klp.space.loose,
					markWidth: klp.shape.hairline,
					dotWidth: klp.shape.stroke,
				),
			),
			child: child,
		);
	}

	KlpPageBackgroundRecipe _recipeFor(KlpPageBackgroundStyle style) {
		return switch (style) {
			KlpPageBackgroundStyle.plain => const KlpPlainPageBackgroundRecipe(),
			KlpPageBackgroundStyle.ruled => KlpRuledPageBackgroundRecipe(),
			KlpPageBackgroundStyle.dots => KlpDotsPageBackgroundRecipe(),
			KlpPageBackgroundStyle.grid => KlpGridPageBackgroundRecipe(),
		};
	}
}
