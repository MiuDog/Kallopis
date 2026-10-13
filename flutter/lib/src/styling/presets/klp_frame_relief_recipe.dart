import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:flutter/painting.dart';

/// Frame 微立體配方；由目前 semantic theme 供直接 Flutter 元件使用。
abstract final class KlpFrameReliefRecipe {

	/// 由公開 theme 已解析的表面、陰影色與尺度產生既有微立體效果。
	static List<BoxShadow> resolve(Color surface, Color shadowColor, double scale) {
		KlpColor channels(Color color) => KlpColor((color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round());
		Color flutterColor(KlpColor color) => Color.fromARGB(color.alpha, color.red, color.green, color.blue);
		final base = channels(surface);
		final unit = factor(scale);
		return [
			BoxShadow(color: flutterColor(shadow(base, channels(shadowColor))), offset: Offset(offsetX * unit, offsetY * unit), blurRadius: blur * unit, spreadRadius: spread * unit),
			BoxShadow(color: flutterColor(highlight(base)), offset: Offset(highlightOffset * unit, highlightOffset * unit)),
		];
	}

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
