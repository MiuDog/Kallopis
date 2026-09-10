import '../../../styling/primitives/klp_style_value.dart';

/// 文字模板解析後的完整結果，轉換到平台型別由 renderer 負責。
final class KlpBoundTextStyle {
  final KlpColor color;
  final KlpFontFamily fontFamily;
  final KlpFontSize fontSize;
  final KlpFontWeight fontWeight;
  final KlpLineHeight lineHeight;
  final KlpLetterSpacing letterSpacing;

  const KlpBoundTextStyle({
    required this.color,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.lineHeight,
    required this.letterSpacing,
  });
}
