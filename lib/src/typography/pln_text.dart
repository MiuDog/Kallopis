import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';

enum PlnTextRole {
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

enum PlnTextTone { automatic, primary, muted, faint, accent, danger, success }

enum PlnTextColorTier { prominent, standard, subdued }

/// 字族角色。UI chrome 走等寬保住終端機識別度；編輯器內容走比例字體以利長文
/// 閱讀；程式碼固定等寬。三者互斥，故以 enum 表達而非多個 bool。
enum PlnFontRole { ui, body, mono }

@immutable
class PlnTextStyleDefinition {
  const PlnTextStyleDefinition({
    required this.fontSize,
    required this.lineHeight,
    required this.fontWeight,
    required this.tier,
    this.letterSpacing,
    this.family = PlnFontRole.ui,
  });

  final double fontSize;
  final double lineHeight;
  final FontWeight fontWeight;
  final PlnTextColorTier tier;
  final double? letterSpacing;
  final PlnFontRole family;

  TextStyle toTextStyle() {
    return TextStyle(
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      fontFamily: switch (family) {
        PlnFontRole.mono => PlnTypography.monoFamily,
        PlnFontRole.body => PlnTypography.bodyFamily,
        PlnFontRole.ui => PlnTypography.uiFamily,
      },
      fontFamilyFallback: switch (family) {
        PlnFontRole.mono => PlnTypography.monoFallback,
        PlnFontRole.body => PlnTypography.bodyFallback,
        PlnFontRole.ui => PlnTypography.uiFallback,
      },
    );
  }
}

abstract final class PlnTextStyles {
  static const Map<PlnTextRole, PlnTextStyleDefinition> definitions = {
    PlnTextRole.display: PlnTextStyleDefinition(
      fontSize: PlnTypography.display,
      lineHeight: PlnTypography.displayLineHeight,
      fontWeight: PlnTypography.bold,
      letterSpacing: PlnTypography.displayLetterSpacing,
      tier: PlnTextColorTier.prominent,
    ),
    PlnTextRole.title: PlnTextStyleDefinition(
      fontSize: PlnTypography.title,
      lineHeight: PlnTypography.headingLineHeight,
      fontWeight: PlnTypography.bold,
      tier: PlnTextColorTier.prominent,
    ),
    PlnTextRole.section: PlnTextStyleDefinition(
      fontSize: PlnTypography.section,
      lineHeight: PlnTypography.headingLineHeight,
      fontWeight: PlnTypography.bold,
      tier: PlnTextColorTier.prominent,
    ),
    PlnTextRole.editor: PlnTextStyleDefinition(
      fontSize: PlnTypography.body,
      lineHeight: PlnTypography.bodyLineHeight,
      fontWeight: PlnTypography.regular,
      tier: PlnTextColorTier.prominent,
      family: PlnFontRole.body,
    ),
    PlnTextRole.body: PlnTextStyleDefinition(
      fontSize: PlnTypography.body,
      lineHeight: PlnTypography.bodyLineHeight,
      fontWeight: PlnTypography.regular,
      tier: PlnTextColorTier.standard,
    ),
    PlnTextRole.terminal: PlnTextStyleDefinition(
      fontSize: PlnTypography.body,
      lineHeight: PlnTypography.bodyLineHeight,
      fontWeight: PlnTypography.regular,
      tier: PlnTextColorTier.standard,
      family: PlnFontRole.mono,
    ),
    PlnTextRole.bodyStrong: PlnTextStyleDefinition(
      fontSize: PlnTypography.body,
      lineHeight: PlnTypography.bodyLineHeight,
      fontWeight: PlnTypography.semibold,
      tier: PlnTextColorTier.standard,
    ),
    PlnTextRole.caption: PlnTextStyleDefinition(
      fontSize: PlnTypography.small,
      lineHeight: PlnTypography.compactLineHeight,
      fontWeight: PlnTypography.regular,
      tier: PlnTextColorTier.standard,
    ),
    PlnTextRole.label: PlnTextStyleDefinition(
      fontSize: PlnTypography.small,
      lineHeight: PlnTypography.labelLineHeight,
      fontWeight: PlnTypography.regular,
      letterSpacing: PlnTypography.labelLetterSpacing,
      tier: PlnTextColorTier.standard,
    ),
    PlnTextRole.code: PlnTextStyleDefinition(
      fontSize: PlnTypography.small,
      lineHeight: PlnTypography.bodyLineHeight,
      fontWeight: PlnTypography.regular,
      tier: PlnTextColorTier.standard,
      family: PlnFontRole.mono,
    ),
  };

  static PlnTextStyleDefinition definitionOf(PlnTextRole role) {
    return definitions[role]!;
  }

  static Color colorFor(
    PlnThemeData tokens, {
    required PlnTextRole role,
    PlnTextTone tone = PlnTextTone.automatic,
    Color? requestedColor,
  }) {
    final tier = requestedColor == null
        ? _tierForTone(role, tone)
        : _tierForRequestedColor(tokens, requestedColor);

    return switch (tier) {
      PlnTextColorTier.prominent => tokens.text,
      PlnTextColorTier.standard => tokens.textMuted,
      PlnTextColorTier.subdued => tokens.textFaint,
    };
  }

  static PlnTextColorTier _tierForTone(PlnTextRole role, PlnTextTone tone) {
    return switch (tone) {
      PlnTextTone.automatic => definitionOf(role).tier,
      PlnTextTone.primary || PlnTextTone.accent => PlnTextColorTier.prominent,
      PlnTextTone.faint => PlnTextColorTier.subdued,
      PlnTextTone.muted ||
      PlnTextTone.danger ||
      PlnTextTone.success => PlnTextColorTier.standard,
    };
  }

  static PlnTextColorTier _tierForRequestedColor(
    PlnThemeData tokens,
    Color color,
  ) {
    if (color == tokens.text ||
        color == tokens.onSelection ||
        color == tokens.selectionForeground) {
      return PlnTextColorTier.prominent;
    }
    if (color == tokens.textFaint || color.a < 1) {
      return PlnTextColorTier.subdued;
    }

    return PlnTextColorTier.standard;
  }
}

class PlnText extends StatelessWidget {
  const PlnText(
    this.data, {
    super.key,
    this.role = PlnTextRole.body,
    this.tone = PlnTextTone.automatic,
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
  final PlnTextRole role;
  final PlnTextTone tone;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final Color? color;
  final TextDecoration? decoration;
  final String? ellipsisText;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final roleStyle = PlnTextStyles.definitionOf(role).toTextStyle();
    final style = roleStyle.copyWith(
      color: PlnTextStyles.colorFor(
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
      offset: const Offset(0, PlnTypography.uiBaselineOffset),
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
