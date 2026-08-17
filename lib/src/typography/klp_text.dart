import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';

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

/// 字族角色。UI chrome 走等寬保住終端機識別度；編輯器內容走比例字體以利長文
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

  TextStyle toTextStyle() {
    return TextStyle(
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      fontFamily: switch (family) {
        KlpFontRole.mono => KlpTypography.monoFamily,
        KlpFontRole.body => KlpTypography.bodyFamily,
        KlpFontRole.ui => KlpTypography.uiFamily,
      },
      fontFamilyFallback: switch (family) {
        KlpFontRole.mono => KlpTypography.monoFallback,
        KlpFontRole.body => KlpTypography.bodyFallback,
        KlpFontRole.ui => KlpTypography.uiFallback,
      },
    );
  }
}

abstract final class KlpTextStyles {
  static const Map<KlpTextRole, KlpTextStyleDefinition> definitions = {
    KlpTextRole.display: KlpTextStyleDefinition(
      fontSize: KlpTypography.display,
      lineHeight: KlpTypography.displayLineHeight,
      fontWeight: KlpTypography.bold,
      letterSpacing: KlpTypography.displayLetterSpacing,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.title: KlpTextStyleDefinition(
      fontSize: KlpTypography.title,
      lineHeight: KlpTypography.headingLineHeight,
      fontWeight: KlpTypography.bold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.section: KlpTextStyleDefinition(
      fontSize: KlpTypography.section,
      lineHeight: KlpTypography.headingLineHeight,
      fontWeight: KlpTypography.bold,
      tier: KlpTextColorTier.prominent,
    ),
    KlpTextRole.editor: KlpTextStyleDefinition(
      fontSize: KlpTypography.body,
      lineHeight: KlpTypography.bodyLineHeight,
      fontWeight: KlpTypography.regular,
      tier: KlpTextColorTier.prominent,
      family: KlpFontRole.body,
    ),
    KlpTextRole.body: KlpTextStyleDefinition(
      fontSize: KlpTypography.body,
      lineHeight: KlpTypography.bodyLineHeight,
      fontWeight: KlpTypography.regular,
      tier: KlpTextColorTier.standard,
    ),
    KlpTextRole.terminal: KlpTextStyleDefinition(
      fontSize: KlpTypography.body,
      lineHeight: KlpTypography.bodyLineHeight,
      fontWeight: KlpTypography.regular,
      tier: KlpTextColorTier.standard,
      family: KlpFontRole.mono,
    ),
    KlpTextRole.bodyStrong: KlpTextStyleDefinition(
      fontSize: KlpTypography.body,
      lineHeight: KlpTypography.bodyLineHeight,
      fontWeight: KlpTypography.semibold,
      tier: KlpTextColorTier.standard,
    ),
    KlpTextRole.caption: KlpTextStyleDefinition(
      fontSize: KlpTypography.small,
      lineHeight: KlpTypography.compactLineHeight,
      fontWeight: KlpTypography.regular,
      tier: KlpTextColorTier.standard,
    ),
    KlpTextRole.label: KlpTextStyleDefinition(
      fontSize: KlpTypography.small,
      lineHeight: KlpTypography.labelLineHeight,
      fontWeight: KlpTypography.regular,
      letterSpacing: KlpTypography.labelLetterSpacing,
      tier: KlpTextColorTier.standard,
    ),
    KlpTextRole.code: KlpTextStyleDefinition(
      fontSize: KlpTypography.small,
      lineHeight: KlpTypography.bodyLineHeight,
      fontWeight: KlpTypography.regular,
      tier: KlpTextColorTier.standard,
      family: KlpFontRole.mono,
    ),
  };

  static KlpTextStyleDefinition definitionOf(KlpTextRole role) {
    return definitions[role]!;
  }

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
      KlpTextTone.automatic => definitionOf(role).tier,
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
    final roleStyle = KlpTextStyles.definitionOf(role).toTextStyle();
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
