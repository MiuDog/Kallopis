part of '../klp_text_field.dart';

class _KlpTextFieldStyle {
  const _KlpTextFieldStyle({
    required this.fillColor,
    required this.borderColor,
    required this.textColor,
    required this.hintColor,
    required this.iconColor,
    required this.cursorColor,
    required this.fieldHeight,
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.controlInset,
    required this.stepActionHeight,
    required this.radius,
    required this.borderWidth,
    required this.lineHeight,
    required this.fontFamily,
    required this.fontFamilyFallback,
    required this.defaultMinLines,
    required this.defaultMaxLines,
  });

  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final Color hintColor;
  final Color iconColor;
  final Color cursorColor;
  final double fieldHeight;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double controlInset;
  final double stepActionHeight;
  final double radius;
  final double borderWidth;
  final double lineHeight;
  final String fontFamily;
  final List<String> fontFamilyFallback;
  final int defaultMinLines;
  final int defaultMaxLines;

  factory _KlpTextFieldStyle.resolve(
    KlpTheme klp, {
    required KlpControlSize size,
    required bool enabled,
    required bool invalid,
    required bool multiline,
    required bool outlined,
    required bool focused,
  }) {
    final (fieldHeight, fontSize, horizontalPadding) = switch (size) {
      KlpControlSize.xs => (
        klp.space.controlHeightXSmall,
        klp.type.caption,
        klp.space.tight,
      ),
      KlpControlSize.sm => (
        klp.space.controlHeightSmall,
        klp.type.sub,
        klp.space.tight,
      ),
      KlpControlSize.md => (klp.fieldHeight, klp.type.body, klp.fieldPaddingX),
      KlpControlSize.lg => (
        klp.space.controlHeightLarge,
        klp.type.lead,
        klp.space.base,
      ),
      KlpControlSize.xl => (
        klp.space.controlHeightXLarge,
        klp.type.lead,
        klp.space.comfortable,
      ),
    };
    var borderWidth = klp.fieldBorderWidth;
    if (outlined) {
      borderWidth = borderWidth
          .clamp(klp.shape.stroke, double.infinity)
          .toDouble();
    }

    return _KlpTextFieldStyle(
      fillColor: KlpFieldStyle.inputFill(
        klp.color,
        error: invalid,
        surface: klp.surface,
      ),
      borderColor: outlined && focused
          ? klp.color.interaction
          : klp.color.border,
      textColor: enabled ? klp.color.text : klp.color.textFaint,
      hintColor: klp.color.textFaint,
      iconColor: enabled ? klp.color.textMuted : klp.color.textFaint,
      cursorColor: klp.color.interaction,
      fieldHeight: fieldHeight,
      fontSize: fontSize,
      horizontalPadding: horizontalPadding,
      verticalPadding: multiline
          ? klp.space.controlPaddingY
          : (fieldHeight -
                    fontSize * klp.geometry.control.textFieldLineHeightFactor) /
                2,
      controlInset: klp.space.controlInset,
      stepActionHeight:
          fieldHeight * klp.geometry.control.textFieldIndicatorHeightFactor,
      radius: klp.fieldRadius,
      borderWidth: borderWidth,
      lineHeight: klp.type.captionLeading,
      fontFamily: klp.type.uiFamily,
      fontFamilyFallback: klp.type.fallbackFor(klp.type.uiFamily),
      defaultMinLines: klp.geometry.control.textFieldMinLines,
      defaultMaxLines: klp.geometry.control.textFieldMaxLines,
    );
  }
}
