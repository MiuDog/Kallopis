import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'klp_paper_shadow_recipe.dart';

/// 舊選單的具名幾何配方；基準來自 KlpSize、spacing、shape 與紙面陰影。
/// 原料替換依已解析的各用途基準縮放，不修改其他元件的 preset。
abstract final class KlpMenuRecipe {

	static double width(KlpDistance scale) => scale.value * 50;
	static double rowExtent(KlpDistance scale) => scale.value * 7;
	static double headerExtent(KlpDistance scale) => scale.value * 7;
	static double padding(KlpDistance scale) => scale.value;
	static double inset(KlpDistance scale) => scale.value * 2;
	static double gap(KlpDistance scale) => scale.value * 2;
	static double itemGap(KlpDistance scale) => scale.value;
	static double iconExtent(KlpDistance scale) => scale.value * 3.5;
	static double iconOffset(KlpDistance scale) => scale.value / 4;
	static double panelRadius(KlpRadius scale) => scale.value * 7 / 6;
	static double itemRadius(KlpRadius scale) => scale.value;
	static double dashLength(KlpDistance scale) => scale.value * 3 / 4;
	static double dashGap(KlpDistance scale) => scale.value / 2;
	static double shadowBlur(KlpDistance scale) => KlpPaperShadowRecipe.ambientBlur * scale.value / 4;
	static double shadowOffset(KlpDistance scale) => KlpPaperShadowRecipe.ambientOffsetY * scale.value / 4;
	static double toggleWidth(KlpDistance scale) => scale.value * 7.5;
	static double toggleHeight(KlpDistance scale) => scale.value * 4;
	static double toggleThumb(KlpDistance scale) => scale.value * 3;
	static double toggleInset(KlpDistance scale) => scale.value / 2;
	static double toggleTrackRadius(KlpDistance scale) => scale.value;
	static double toggleThumbRadius(KlpDistance scale) => scale.value / 2;

	// 危險操作承接舊 semantic danger（red300），不以任意局部色值暴露給 consumer。
	static KlpColor get destructive => KlpColor(250, 108, 115);
}
