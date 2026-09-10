import 'package:flutter/widgets.dart';

import '../../styling/legacy_theme/klp_typography_theme.dart';
import 'klp_font_role.dart';
import 'klp_text_color_tier.dart';

/// 單一文字角色由目前 theme 解析後的完整樣式參數。
@immutable
class KlpTextStyleDefinition {
  const KlpTextStyleDefinition({
    required this.fontSize,
    required this.lineHeight,
    required this.fontWeight,
    required this.tier,
    this.letterSpacing,
    this.family = KlpFontRole.ui,
  });

  final double fontSize;
  final double lineHeight;
  final FontWeight fontWeight;
  final KlpTextColorTier tier;
  final double? letterSpacing;
  final KlpFontRole family;

  TextStyle toTextStyle(KlpTypographyTheme type) {
    final resolvedFamily = switch (family) {
      KlpFontRole.mono => type.codeFamily,
      KlpFontRole.body => type.bodyFamily,
      KlpFontRole.ui => type.uiFamily,
    };
    final fallbacks = type.fallbackFor(resolvedFamily);

    return TextStyle(
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      fontFamily: resolvedFamily.isEmpty ? null : resolvedFamily,
      fontFamilyFallback: fallbacks.isEmpty ? null : fallbacks,
    );
  }
}
