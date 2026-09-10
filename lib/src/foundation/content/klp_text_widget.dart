import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../styling/legacy_theme/klp_theme.dart';
import 'klp_text.dart';

part 'klp_optical_shift.dart';
part 'klp_render_optical_shift.dart';

/// 以語意角色指定樣式的文字原語。
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
    this.excludeFromSemantics = false,
    this.tracking,
    this.applyOpticalShift = true,
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
  final bool excludeFromSemantics;
  final KlpTextTracking? tracking;
  final bool applyOpticalShift;

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
      letterSpacing: switch (tracking) {
        KlpTextTracking.placeholder =>
          context.klp.geometry.data.placeholderLabelTracking,
        null => null,
      },
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

    // 等寬字型相較 UI 字型與圖示視覺重心偏下，統一套用 theme 的光學位移。
    final optical = context.klp.geometry.optical;
    final yOffset = roleDef.family == KlpFontRole.mono
        ? optical.monoBaselineOffsetY
        : optical.uiBaselineOffsetY;

    final rendered = applyOpticalShift
        ? _KlpOpticalShift(offsetY: yOffset, child: text)
        : text;
    return excludeFromSemantics ? ExcludeSemantics(child: rendered) : rendered;
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
