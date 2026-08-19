import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../theme/klp_typography_theme.dart';

enum KlpTextRole {
  display,
  h1,
  h2,
  h3,
  h4,
  lead,
  body,
  sub,
  caption,
  micro,
  title,
  section,
  editor,
  terminal,
  bodyStrong,
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

abstract final class KlpTextStyles {
  /// 字級與行高由 theme 決定，因此不能是編譯期常數的 map。
  static Map<KlpTextRole, KlpTextStyleDefinition> definitionsFor(
    KlpTypographyTheme type,
  ) => {
    KlpTextRole.display: KlpTextStyleDefinition(
      fontSize: type.display,
      lineHeight: type.displayLeading,
      fontWeight: type.bold,
      letterSpacing: type.displayTracking,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.h1: KlpTextStyleDefinition(
      fontSize: type.h1,
      lineHeight: type.h1Leading,
      fontWeight: type.bold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.h2: KlpTextStyleDefinition(
      fontSize: type.h2,
      lineHeight: type.h2Leading,
      fontWeight: type.semiBold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.h3: KlpTextStyleDefinition(
      fontSize: type.h3,
      lineHeight: type.h3Leading,
      fontWeight: type.semiBold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.h4: KlpTextStyleDefinition(
      fontSize: type.h4,
      lineHeight: type.h4Leading,
      fontWeight: type.semiBold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.lead: KlpTextStyleDefinition(
      fontSize: type.lead,
      lineHeight: type.leadLeading,
      fontWeight: type.semiBold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.body: KlpTextStyleDefinition(
      fontSize: type.body,
      lineHeight: type.bodyLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.sub: KlpTextStyleDefinition(
      fontSize: type.sub,
      lineHeight: type.subLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.caption: KlpTextStyleDefinition(
      fontSize: type.caption,
      lineHeight: type.captionLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.micro: KlpTextStyleDefinition(
      fontSize: type.micro,
      lineHeight: type.microLeading,
      fontWeight: type.semiBold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.title: KlpTextStyleDefinition(
      fontSize: type.title,
      lineHeight: type.h1Leading,
      fontWeight: type.bold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.section: KlpTextStyleDefinition(
      fontSize: type.section,
      lineHeight: type.h3Leading,
      fontWeight: type.semiBold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.editor: KlpTextStyleDefinition(
      fontSize: type.body,
      lineHeight: type.bodyLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.prominent,
      family: KlpFontRole.body,
    ),
    KlpTextRole.terminal: KlpTextStyleDefinition(
      fontSize: type.body,
      lineHeight: type.bodyLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.prominent,
      family: KlpFontRole.mono,
    ),
    KlpTextRole.bodyStrong: KlpTextStyleDefinition(
      fontSize: type.body,
      lineHeight: type.bodyLeading,
      fontWeight: type.semiBold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.label: KlpTextStyleDefinition(
      fontSize: type.sub,
      lineHeight: type.labelLeading,
      fontWeight: type.semiBold,
      letterSpacing: type.labelTracking,
      tier: KlpTextColorTier.prominent,
      family: KlpFontRole.mono,
    ),
    KlpTextRole.code: KlpTextStyleDefinition(
      fontSize: type.sub,
      lineHeight: type.codeLeading,
      fontWeight: type.regular,
      tier: KlpTextColorTier.prominent,
      family: KlpFontRole.mono,
    ),
  };

  static KlpTextStyleDefinition definitionOf(
    KlpTextRole role,
    KlpTypographyTheme type,
  ) {
    return definitionsFor(type)[role]!;
  }

  /// 角色對應的色階預設皆為 prominent（淺色最黑 ink900，深色最白 ink50）。
  /// 只有註解與說明 explicitly 傳入 tone 時才套用 muted / faint。
  static const Map<KlpTextRole, KlpTextColorTier> tiers = {
    KlpTextRole.display: KlpTextColorTier.prominent,
    KlpTextRole.h1: KlpTextColorTier.prominent,
    KlpTextRole.h2: KlpTextColorTier.prominent,
    KlpTextRole.h3: KlpTextColorTier.prominent,
    KlpTextRole.h4: KlpTextColorTier.prominent,
    KlpTextRole.lead: KlpTextColorTier.prominent,
    KlpTextRole.body: KlpTextColorTier.prominent,
    KlpTextRole.sub: KlpTextColorTier.prominent,
    KlpTextRole.caption: KlpTextColorTier.prominent,
    KlpTextRole.micro: KlpTextColorTier.prominent,
    KlpTextRole.title: KlpTextColorTier.prominent,
    KlpTextRole.section: KlpTextColorTier.prominent,
    KlpTextRole.editor: KlpTextColorTier.prominent,
    KlpTextRole.terminal: KlpTextColorTier.prominent,
    KlpTextRole.bodyStrong: KlpTextColorTier.prominent,
    KlpTextRole.label: KlpTextColorTier.prominent,
    KlpTextRole.code: KlpTextColorTier.prominent,
  };

  static Color colorFor(
    KlpThemeData tokens, {
    required KlpTextRole role,
    KlpTextTone tone = KlpTextTone.automatic,
    Color? requestedColor,
  }) {
    if (requestedColor != null) {
      return requestedColor;
    }
    final tier = _tierForTone(role, tone);

    return switch (tier) {
      KlpTextColorTier.prominent => tokens.text,
      KlpTextColorTier.standard => tokens.textMuted,
      KlpTextColorTier.subdued => tokens.textFaint,
    };
  }

  static KlpTextColorTier _tierForTone(KlpTextRole role, KlpTextTone tone) {
    return switch (tone) {
      KlpTextTone.automatic => tiers[role] ?? KlpTextColorTier.prominent,
      KlpTextTone.primary || KlpTextTone.accent => KlpTextColorTier.prominent,
      KlpTextTone.faint => KlpTextColorTier.subdued,
      KlpTextTone.muted => KlpTextColorTier.standard,
      KlpTextTone.danger || KlpTextTone.success => KlpTextColorTier.prominent,
    };
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
    final roleDef = KlpTextStyles.definitionOf(role, type);
    final roleStyle = roleDef.toTextStyle(type);
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

    // 等寬字型（如 JetBrains Mono / Consolas）相較 UI 字型與圖示視覺重心偏下，
    // 在此統一進行 -1.0px 的光學基線偏移補償，使其與 icon、色票圓點保持精確垂直對齊。
    final double yOffset =
        (roleDef.family == KlpFontRole.mono ? -1.0 : 0.0) +
        KlpTypography.uiBaselineOffset;

    return Transform.translate(offset: Offset(0, yOffset), child: text);
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
