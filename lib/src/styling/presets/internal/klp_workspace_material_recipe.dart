import 'package:kallopis/src/styling/primitives/klp_style_value.dart';

/// 工作區紙材只由 preset 色階選出；不增加 primitive schema 槽位。
abstract final class KlpWorkspaceMaterialRecipe {
	static KlpColor accent(KlpColor surface) => surface.red < 100 ? KlpColor(181, 195, 162) : KlpColor(88, 116, 73);

	static KlpColor sticky(KlpColor surface, {required bool sage}) {
		final dark = surface.red < 100 && surface.green < 100 && surface.blue < 100;
		if (dark) return sage ? KlpColor(60, 70, 54) : KlpColor(84, 75, 48);

		return sage ? KlpColor(225, 230, 215) : KlpColor(238, 227, 185);
	}
}
