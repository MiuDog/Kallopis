import 'package:flutter/widgets.dart';

import '../styling/legacy_theme/klp_theme.dart';
import 'klp_icon_data.dart';
import 'klp_icon_weight.dart';

export 'klp_icon_data.dart';
export 'klp_icon_weight.dart';

class KlpIcon extends StatelessWidget {

	const KlpIcon(
		this.icon, {
		super.key,
		this.size,
		this.color,
		this.semanticLabel,
		this.weight = KlpIconWeight.regular,
	});

	final KlpIconData icon;

	/// `null` 表示沿用 theme 的圖示尺寸。
	final double? size;
	final Color? color;
	final String? semanticLabel;
	final KlpIconWeight weight;

	/// Regular Rounded 在 Flutter asset manifest 中登記的 family 名稱。
	static const regularFontFamily = 'Flaticon UIcons Regular Rounded';

	/// Thin Rounded 在 Flutter asset manifest 中登記的 family 名稱。
	static const thinFontFamily = 'Flaticon UIcons Thin Rounded';

	/// 向下相容的預設字型名稱。
	static const fontFamily = regularFontFamily;

	@override
	Widget build(BuildContext context) {
		final effectiveColor = color ?? DefaultTextStyle.of(context).style.color;
		final effectiveSize = size ?? context.klp.space.icon;
		final effectiveWeight = icon.supports(weight) ? weight : KlpIconWeight.regular;
		final effectiveFontFamily = effectiveWeight == KlpIconWeight.thin ? thinFontFamily : regularFontFamily;

		return Icon(
			IconData(
				// UIcons 整套字型就是散佈單位；字碼由 KlpIcons 的常數清單控制。
				// ignore: non_const_argument_for_const_parameter
				icon.codePointFor(effectiveWeight),
				// ignore: non_const_argument_for_const_parameter
				fontFamily: effectiveFontFamily,
				fontPackage: 'kallopis',
			),
			size: effectiveSize,
			color: effectiveColor,
			semanticLabel: semanticLabel,
		);
	}
}
