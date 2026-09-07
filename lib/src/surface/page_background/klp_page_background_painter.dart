import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'klp_page_background_recipe.dart';

part 'internal/klp_page_background_paint_operations.dart';

/// Renderer 已解析的 semantic 預設值。
@immutable
class KlpPageBackgroundVisuals {
	const KlpPageBackgroundVisuals({
		required this.surface,
		required this.pattern,
		required this.spacing,
		required this.markWidth,
		required this.dotWidth,
	});

	final Color surface;
	final Color pattern;
	final double spacing;
	final double markWidth;
	final double dotWidth;

	@override
	bool operator ==(Object other) {
		return other is KlpPageBackgroundVisuals &&
			other.surface == surface &&
			other.pattern == pattern &&
			other.spacing == spacing &&
			other.markWidth == markWidth &&
			other.dotWidth == dotWidth;
	}

	@override
	int get hashCode => Object.hash(surface, pattern, spacing, markWidth, dotWidth);
}

/// 所有頁面背景 recipe 共用的 renderer。
class KlpPageBackgroundPainter extends CustomPainter {
	const KlpPageBackgroundPainter({
		required this.recipe,
		required this.viewport,
		required this.visuals,
	});

	final KlpPageBackgroundRecipe recipe;
	final KlpPageBackgroundViewport viewport;
	final KlpPageBackgroundVisuals visuals;

	@override
	void paint(Canvas canvas, Size size) {
		if (size.isEmpty) return;

		canvas.drawRect(Offset.zero & size, Paint()..color = visuals.surface);
		switch (recipe) {
			case KlpPlainPageBackgroundRecipe():
				return;
			case KlpRuledPageBackgroundRecipe recipe:
				_paintRuled(canvas, size, recipe);
			case KlpDotsPageBackgroundRecipe recipe:
				_paintPeriodic(canvas, size, recipe, dots: true);
			case KlpGridPageBackgroundRecipe recipe:
				_paintPeriodic(canvas, size, recipe, dots: false);
			case KlpCustomPageBackgroundRecipe recipe:
				_paintCustom(canvas, recipe);
		}
	}

	@visibleForTesting
	double resolveMarkWidth(
		KlpPageBackgroundAxisStyle axis,
		KlpPageBackgroundStrokeBehavior behavior, {
		double? defaultWidth,
	}) {
		final scale = behavior == KlpPageBackgroundStrokeBehavior.scaled ? viewport.scale : 1.0;
		return (axis.width ?? defaultWidth ?? visuals.markWidth) * scale;
	}

	double _toViewportCoordinate(double coordinate, double origin) => (coordinate - origin) * viewport.scale;

	@override
	bool shouldRepaint(covariant KlpPageBackgroundPainter oldDelegate) {
		return oldDelegate.recipe != recipe || oldDelegate.viewport != viewport || oldDelegate.visuals != visuals;
	}
}
