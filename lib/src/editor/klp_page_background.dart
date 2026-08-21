// 公開參數必須維持既有的 style 名稱，不能改成私有欄位形式。
// ignore_for_file: prefer_initializing_formals

import 'package:flutter/widgets.dart';

import '../theme/klp_theme_scope.dart';
import 'internal/klp_page_background_painter.dart';
import 'klp_page_background_recipe.dart';

/// 頁面的內建向量背景樣式；只描述視覺語意，不保存產品資料。
enum KlpPageBackgroundStyle { plain, ruled, dots, grid }

/// 在 [child] 下方繪製會隨 Kallopis theme 改變的頁面背景。
class KlpPageBackground extends StatelessWidget {
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

  /// 舊式樣建構式所選的內建樣式。
  ///
  /// recipe 建構式沒有對應 enum；該模式請讀 [recipe]，不要讀這個 getter。
  KlpPageBackgroundStyle get style => _style!;

  final KlpPageBackgroundRecipe? recipe;
  final KlpPageBackgroundViewport? viewport;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final visuals = KlpPageBackgroundVisuals(
      surface: klp.color.stageSurface,
      pattern: klp.color.pagePattern,
      spacing: klp.space.loose,
      markWidth: klp.shape.hairline,
      dotWidth: klp.shape.stroke,
    );

    return CustomPaint(
      painter: KlpPageBackgroundPainter(
        recipe: recipe ?? _recipeFor(_style!),
        viewport: viewport ?? KlpPageBackgroundViewport(),
        visuals: visuals,
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
