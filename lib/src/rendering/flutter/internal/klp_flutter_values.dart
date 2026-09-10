import 'package:flutter/widgets.dart';

import '../../../foundation/binding/internal/klp_bound_text_style.dart';
import '../../../foundation/templates/klp_axis.dart';
import '../../../styling/primitives/klp_style_value.dart';

/// 平台型別轉換不新增預設值，也不重新求解語意。
Color klpFlutterColor(KlpColor color) => Color.fromARGB(color.alpha, color.red, color.green, color.blue);

Axis klpFlutterAxis(KlpAxis axis) => axis == KlpAxis.horizontal ? Axis.horizontal : Axis.vertical;

TextStyle klpFlutterTextStyle(KlpBoundTextStyle style) {
	// 靜態字型選最近的標準字重，變動字型同時保留完整連續字重。
	final weightIndex = (style.fontWeight.value / 100).round().clamp(1, 9) - 1;
	return TextStyle(
		inherit: false,
		color: klpFlutterColor(style.color),
		fontFamily: style.fontFamily.family,
		fontFamilyFallback: style.fontFamily.fallback,
		fontSize: style.fontSize.value,
		fontWeight: FontWeight.values[weightIndex],
		fontVariations: [FontVariation('wght', style.fontWeight.value.toDouble())],
		height: style.lineHeight.value,
		letterSpacing: style.letterSpacing.value,
	);
}
