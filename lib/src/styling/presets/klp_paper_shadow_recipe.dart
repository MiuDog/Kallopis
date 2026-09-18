/// 本庫內部的紙張微浮配方；兩層共享解析後的顏色與尺度。
abstract final class KlpPaperShadowRecipe {

	static const referenceScale = 12.0;
	static const alpha = 34;
	static const contactOffsetY = 2.0;
	static const contactBlur = 3.0;
	static const ambientOffsetY = 8.0;
	static const ambientBlur = 20.0;

	static double factor(double scale) => scale / referenceScale;
}
