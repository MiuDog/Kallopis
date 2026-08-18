import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../theme/klp_typography_theme.dart';

enum KlpTextRole {
  display,
  title,
  section,
  editor,
  body,
  terminal,
  bodyStrong,
  caption,
  label,
  code,
}

enum KlpTextTone { automatic, primary, muted, faint, accent, danger, success }

enum KlpTextColorTier { prominent, standard, subdued }

/// 字族角色。實際家族由 theme 的 typography 層決定，這裡只表達「這段文字扮演什麼角色」
/// 閱讀；程式碼固定等寬。三者互斥，故以 enum 表達而非多個 bool。
enum KlpFontRole { ui, body, mono }

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

  /// 字體家族由 theme 決定，不是編譯期常數——「全域等寬」這種要求應該換 theme 就能
  /// 達成。呼叫端必須提供 [type]，因此忘記傳會是編譯錯誤而不是靜默用錯字體。
  TextStyle toTextStyle(KlpTypographyTheme type) {
    final resolvedFamily = switch (family) {
      KlpFontRole.mono => type.codeFamily,
      KlpFontRole.body => type.bodyFamily,
      KlpFontRole.ui => type.uiFamily,
    };

    return TextStyle(
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      fontFamily: resolvedFamily,
      fontFamilyFallback: type.fallbackFor(resolvedFamily),
    );
  }
}

abstract final class KlpTextStyles {
  /// 字級與行高由 theme 決定，因此不能是編譯期常數的 map。
  static Map<KlpTextRole, KlpTextStyleDefinition> definitionsFor(
    KlpTypographyTheme type,
  ) => {
    KlpTextRole.display: KlpTextStyleDefinition(
      fontSize: type.display,
      lineHeight: type.displayLeading,
      fontWeight: type.strong,
      letterSpacing: type.displayTracking,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.title: KlpTextStyleDefinition(
      fontSize: type.title,
      lineHeight: type.headingLeading,
      fontWeight: type.strong,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.section: KlpTextStyleDefinition(
      fontSize: type.section,
      lineHeight: type.headingLeading,
      fontWeight: type.strong,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.editor: KlpTextStyleDefinition(
      fontSize: type.body,
      lineHeight: type.bodyLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.prominent,
      family: KlpFontRole.body,
    ),
    KlpTextRole.body: KlpTextStyleDefinition(
      fontSize: type.body,
      lineHeight: type.bodyLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.standard,
    ),
    KlpTextRole.terminal: KlpTextStyleDefinition(
      fontSize: type.body,
      lineHeight: type.bodyLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.standard,
      family: KlpFontRole.mono,
    ),
    KlpTextRole.bodyStrong: KlpTextStyleDefinition(
      fontSize: type.body,
      lineHeight: type.bodyLeading,
      fontWeight: type.medium,
      tier: KlpTextColorTier.standard,
    ),
    KlpTextRole.caption: KlpTextStyleDefinition(
      fontSize: type.caption,
      lineHeight: type.captionLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.standard,
    ),
    // label 走等寬：徽章（SUCCESS／DANGER）與小標題（TEXT-SAFE STATUS）都是這個角色，
    // 它們是**標記**不是句子——等寬讓字寬一致，一整排徽章的視覺節奏才會齊。
    KlpTextRole.label: KlpTextStyleDefinition(
      fontSize: type.caption,
      lineHeight: type.labelLeading,
      fontWeight: type.regular,
      letterSpacing: type.labelTracking,
      tier: KlpTextColorTier.standard,
      family: KlpFontRole.mono,
    ),
    KlpTextRole.code: KlpTextStyleDefinition(
      fontSize: type.caption,
      lineHeight: type.bodyLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.standard,
      family: KlpFontRole.mono,
    ),
  };

  static KlpTextStyleDefinition definitionOf(
    KlpTextRole role,
    KlpTypographyTheme type,
  ) {
    return definitionsFor(type)[role]!;
  }

  /// 角色對應的色階與字級無關，不隨 theme 改變，因此獨立於 [definitionsFor]。
  /// 把它併回 definitions 會逼得只想知道色階的呼叫端也要先取得 typography theme。
  static const Map<KlpTextRole, KlpTextColorTier> tiers = {
    KlpTextRole.display: KlpTextColorTier.prominent,
    KlpTextRole.title: KlpTextColorTier.prominent,
    KlpTextRole.section: KlpTextColorTier.prominent,
    KlpTextRole.editor: KlpTextColorTier.prominent,
    KlpTextRole.body: KlpTextColorTier.standard,
    KlpTextRole.terminal: KlpTextColorTier.standard,
    KlpTextRole.bodyStrong: KlpTextColorTier.standard,
    KlpTextRole.caption: KlpTextColorTier.standard,
    KlpTextRole.label: KlpTextColorTier.standard,
    KlpTextRole.code: KlpTextColorTier.standard,
  };

  static Color colorFor(
    KlpThemeData tokens, {
    required KlpTextRole role,
    KlpTextTone tone = KlpTextTone.automatic,
    Color? requestedColor,
  }) {
    final tier = requestedColor == null
        ? _tierForTone(role, tone)
        : _tierForRequestedColor(tokens, requestedColor);

    return switch (tier) {
      KlpTextColorTier.prominent => tokens.text,
      KlpTextColorTier.standard => tokens.textMuted,
      KlpTextColorTier.subdued => tokens.textFaint,
    };
  }

  static KlpTextColorTier _tierForTone(KlpTextRole role, KlpTextTone tone) {
    return switch (tone) {
      KlpTextTone.automatic => tiers[role]!,
      KlpTextTone.primary || KlpTextTone.accent => KlpTextColorTier.prominent,
      KlpTextTone.faint => KlpTextColorTier.subdued,
      KlpTextTone.muted ||
      KlpTextTone.danger ||
      KlpTextTone.success => KlpTextColorTier.standard,
    };
  }

  static KlpTextColorTier _tierForRequestedColor(
    KlpThemeData tokens,
    Color color,
  ) {
    if (color == tokens.text ||
        color == tokens.onSelection ||
        color == tokens.selectionForeground) {
      return KlpTextColorTier.prominent;
    }
    if (color == tokens.textFaint || color.a < 1) {
      return KlpTextColorTier.subdued;
    }

    return KlpTextColorTier.standard;
  }
}

/// 文字。以**角色**指定樣式（`role`），不指定字級與字體——實際的字級、行高與
/// 家族由 theme 的 typography 層決定，因此換風格時整體會一起變。
class KlpText extends StatelessWidget {
  const KlpText(
    this.data, {
    super.key,
    this.role = KlpTextRole.body,
    this.tone = KlpTextTone.automatic,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.color,
    this.decoration,
    this.ellipsisText,
  }) : assert(
         ellipsisText == null ||
             ellipsisText != '' && overflow == TextOverflow.ellipsis,
       );

  final String data;
  final KlpTextRole role;
  final KlpTextTone tone;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final Color? color;
  final TextDecoration? decoration;
  final String? ellipsisText;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final type = context.klp.type;
    final roleStyle = KlpTextStyles.definitionOf(role, type).toTextStyle(type);
    final style = roleStyle.copyWith(
      color: KlpTextStyles.colorFor(
        tokens,
        role: role,
        tone: tone,
        requestedColor: color,
      ),
      decoration: decoration,
    );

    final text = ellipsisText == null
        ? Text(
            data,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              final visibleData = _resolveVisibleData(
                context,
                constraints,
                style,
              );
              return Semantics(
                label: data,
                excludeSemantics: true,
                child: Text(
                  visibleData,
                  style: style,
                  maxLines: maxLines,
                  overflow: TextOverflow.clip,
                  textAlign: textAlign,
                ),
              );
            },
          );

    return Transform.translate(
      offset: const Offset(0, KlpTypography.uiBaselineOffset),
      child: text,
    );
  }

  String _resolveVisibleData(
    BuildContext context,
    BoxConstraints constraints,
    TextStyle style,
  ) {
    if (!constraints.hasBoundedWidth ||
        _fits(context, data, constraints, style)) {
      return data;
    }

    final suffix = ellipsisText!;
    final codePoints = data.runes.toList(growable: false);
    var lowerBound = 0;
    var upperBound = codePoints.length;
    while (lowerBound < upperBound) {
      final candidateLength = (lowerBound + upperBound + 1) ~/ 2;
      final candidate =
          '${String.fromCharCodes(codePoints.take(candidateLength))}$suffix';
      if (_fits(context, candidate, constraints, style)) {
        lowerBound = candidateLength;
      } else {
        upperBound = candidateLength - 1;
      }
    }

    return '${String.fromCharCodes(codePoints.take(lowerBound))}$suffix';
  }

  bool _fits(
    BuildContext context,
    String value,
    BoxConstraints constraints,
    TextStyle style,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: style),
      textAlign: textAlign ?? TextAlign.start,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: maxLines,
      locale: Localizations.maybeLocaleOf(context),
    )..layout(maxWidth: constraints.maxWidth);

    return !painter.didExceedMaxLines;
  }
}
