import '../../styling/primitives/klp_style_value.dart';
import '../../styling/semantics/klp_semantic_key.dart';

/// 文字呈現所需的完整型別參照，實際值由本庫語意解析取得。
final class KlpTextSemantics {

	final KlpSemanticKey<KlpColor> color;
	final KlpSemanticKey<KlpFontFamily> fontFamily;
	final KlpSemanticKey<KlpFontSize> fontSize;
	final KlpSemanticKey<KlpFontWeight> fontWeight;
	final KlpSemanticKey<KlpLineHeight> lineHeight;
	final KlpSemanticKey<KlpLetterSpacing> letterSpacing;

	const KlpTextSemantics({
		required this.color,
		required this.fontFamily,
		required this.fontSize,
		required this.fontWeight,
		required this.lineHeight,
		required this.letterSpacing,
	});
}
