import 'package:kallopis/src/styling/primitives/klp_style_value.dart';

/// Frame 微立體配方；完整色階與尺度解析後才交給 renderer。
abstract final class KlpFrameReliefRecipe {

	static const referenceScale = 4.0;
	static const offsetX = 2.0;
	static const offsetY = 3.0;
	static const blur = 5.0;
	static const spread = -1.0;
	static const highlightOffset = -1.0;

	static double factor(double scale) => scale / referenceScale;

	static bool _isDark(KlpColor surface) => surface.red < 100 && surface.green < 100 && surface.blue < 100;

	static KlpColor shadow(KlpColor surface, KlpColor source) => KlpColor(source.red, source.green, source.blue, alpha: _isDark(surface) ? 122 : 46);

	static KlpColor highlight(KlpColor surface) => KlpColor(255, 255, 255, alpha: _isDark(surface) ? 18 : 217);
}
