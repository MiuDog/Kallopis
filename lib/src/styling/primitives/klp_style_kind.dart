import 'klp_style_value.dart';

/// 型別種類由本庫固定提供，消費端不能建立新的種類。
final class KlpStyleKind<T extends KlpStyleValue> {

	final String name;

	static const KlpStyleKind<KlpColor> color = KlpStyleKind._('color');
	static const KlpStyleKind<KlpDistance> distance = KlpStyleKind._('distance');
	static const KlpStyleKind<KlpRadius> radius = KlpStyleKind._('radius');
	static const KlpStyleKind<KlpStrokeWidth> strokeWidth = KlpStyleKind._('strokeWidth');
	static const KlpStyleKind<KlpFontSize> fontSize = KlpStyleKind._('fontSize');
	static const KlpStyleKind<KlpFontWeight> fontWeight = KlpStyleKind._('fontWeight');
	static const KlpStyleKind<KlpLineHeight> lineHeight = KlpStyleKind._('lineHeight');
	static const KlpStyleKind<KlpLetterSpacing> letterSpacing = KlpStyleKind._('letterSpacing');
	static const KlpStyleKind<KlpDuration> duration = KlpStyleKind._('duration');
	static const KlpStyleKind<KlpFontFamily> fontFamily = KlpStyleKind._('fontFamily');
	static const KlpStyleKind<KlpCurve> curve = KlpStyleKind._('curve');

	const KlpStyleKind._(this.name);

	bool accepts(KlpStyleValue value) => switch (name) {
		'color' => value is KlpColor,
		'distance' => value is KlpDistance,
		'radius' => value is KlpRadius,
		'strokeWidth' => value is KlpStrokeWidth,
		'fontSize' => value is KlpFontSize,
		'fontWeight' => value is KlpFontWeight,
		'lineHeight' => value is KlpLineHeight,
		'letterSpacing' => value is KlpLetterSpacing,
		'duration' => value is KlpDuration,
		'fontFamily' => value is KlpFontFamily,
		'curve' => value is KlpCurve,
		_ => false,
	};
}
