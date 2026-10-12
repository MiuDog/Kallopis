import 'package:kallopis/src/styling/primitives/klp_primitive_set.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'klp_paper_shadow_recipe.dart';

/// 工作區框架的可選色調；各選項仍建立完整原料集合。
enum KlpWorkspaceTone { warm, neutral }

/// 顏色、padding、圓角與陰影採風格 v1.0.0；其他尺寸維持原規格。
final class KlpWorkspacePreset {
	static const styleVersion = '1.0.0';
	static KlpPrimitiveSet light({KlpWorkspaceTone tone = KlpWorkspaceTone.warm}) => _create(false, tone);
	static KlpPrimitiveSet dark({KlpWorkspaceTone tone = KlpWorkspaceTone.warm}) => _create(true, tone);
	static KlpPrimitiveSet _create(bool dark, KlpWorkspaceTone tone) => KlpPrimitiveSet(
		colors: _colors(dark, tone),
		distances: [0.0,4.0,8.0,12.0,20.0,32.0,40.0,48.0].map(KlpDistance.new).toList(),
		radii: [0.0,4.0,6.0,12.0,16.0,20.0,24.0,32.0].map((value) => KlpRadius(value)).toList(),
		strokeWidths: [0.0,1.0,1.5,2.0,2.5,3.0,3.5,4.0].map(KlpStrokeWidth.new).toList(),
		fontSizes: [10.0,12.0,14.0,16.0,18.0,20.0,24.0,32.0].map(KlpFontSize.new).toList(),
		fontWeights: [100,200,300,400,500,600,700,800].map(KlpFontWeight.new).toList(),
		lineHeights: [1.0,1.2,1.3,1.4,1.5,1.6,1.8,2.0].map(KlpLineHeight.new).toList(),
		letterSpacings: [-0.3,-0.2,-0.1,0.0,0.1,0.2,0.3,0.4].map(KlpLetterSpacing.new).toList(),
		durations: [0,60,100,140,180,240,320,400].map(KlpDuration.new).toList(),
		fontFamilies: [KlpFontFamily('packages/kallopis/Noto Sans TC'), KlpFontFamily('packages/kallopis/IBM Plex Mono'), for (var index = 2; index < 8; index++) KlpFontFamily('packages/kallopis/Noto Sans TC')],
		curves: List.generate(8, (_) => KlpCurve(0.2,0.0,0.2,1.0)),
	);

	static List<KlpColor> _colors(bool dark, KlpWorkspaceTone tone) {
		if (tone == KlpWorkspaceTone.neutral) {
			return dark
				? [KlpColor(34,34,34), KlpColor(240,237,230), KlpColor(41,41,41), KlpColor(50,50,50), KlpColor(186,181,170), KlpColor(68,68,68), KlpColor(0,0,0,alpha:KlpPaperShadowRecipe.alpha), KlpColor(160,184,224)]
				: [KlpColor(229,229,229), KlpColor(33,32,27), KlpColor(237,237,237), KlpColor(250,250,250), KlpColor(106,101,91), KlpColor(222,222,222), KlpColor(0,0,0,alpha:KlpPaperShadowRecipe.alpha), KlpColor(48,80,136)];
		}
		return dark
			? [KlpColor(32,31,28), KlpColor(240,237,230), KlpColor(41,39,36), KlpColor(53,50,45), KlpColor(186,181,170), KlpColor(72,67,57), KlpColor(0,0,0,alpha:KlpPaperShadowRecipe.alpha), KlpColor(160,184,224)]
			: [KlpColor(231,228,221), KlpColor(33,32,27), KlpColor(239,237,231), KlpColor(248,246,241), KlpColor(106,101,91), KlpColor(225,221,210), KlpColor(0,0,0,alpha:KlpPaperShadowRecipe.alpha), KlpColor(48,80,136)];
	}
}
