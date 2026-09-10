part of '../klp_oklch_color_editor.dart';

/// 以 Lightness、Chroma、Hue 與 Alpha 編輯 [KlpOklchColor] 的控制項。
class KlpOklchColorEditor extends StatelessWidget {
  const KlpOklchColorEditor({
    super.key,
    required this.value,
    required this.onChanged,
    this.chromaRange = KlpOklchChromaRange.standard,
  });

  final KlpOklchColor value;
  final ValueChanged<KlpOklchColor>? onChanged;

  /// Chroma slider 的編輯範圍；不限制 [KlpOklchColor] 可表達的值。
  final KlpOklchChromaRange chromaRange;

  @override
  Widget build(BuildContext context) {
    final labels = KlpLocalizations.of(context);

    return KlpLayoutBuilder(
      builder: (context, constraints) {
        final style = _KlpOklchColorEditorStyle.resolve(
          context.klp,
          constraints,
        );

        return KlpColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpWrap(
              spacingSize: KlpSpaceSize.base,
              runSpacingSize: KlpSpaceSize.contentStack,
              children: [
                _KlpOklchControlSlotFrame(
                  style: style,
                  child: _lightness(labels),
                ),
                _KlpOklchControlSlotFrame(style: style, child: _chroma(labels)),
                _KlpOklchControlSlotFrame(style: style, child: _hue(labels)),
                _KlpOklchControlSlotFrame(style: style, child: _alpha(labels)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _lightness(KlpLocalizations labels) {
    return KlpSemanticRegion(
      label: labels.oklchLightnessLabel,
      value: value.lightness.toStringAsFixed(3),
      container: false,
      child: KlpSlider(
        label: labels.oklchLightnessLabel,
        value: value.lightness,
        onChanged: onChanged == null
            ? null
            : (next) => onChanged!(value.copyWith(lightness: next)),
        divisions: 100,
        displayValue: value.lightness.toStringAsFixed(3),
      ),
    );
  }

  Widget _chroma(KlpLocalizations labels) {
    final maximum = chromaRange.upperBound;

    return KlpSemanticRegion(
      label: labels.oklchChromaLabel,
      value: value.chroma.toStringAsFixed(3),
      container: false,
      child: KlpSlider(
        label: labels.oklchChromaLabel,
        value: value.chroma.clamp(0, maximum),
        onChanged: onChanged == null
            ? null
            : (next) => onChanged!(value.copyWith(chroma: next)),
        max: maximum,
        divisions: 100,
        displayValue: value.chroma.toStringAsFixed(3),
      ),
    );
  }

  Widget _hue(KlpLocalizations labels) {
    final normalizedHue = (value.hue % 360 + 360) % 360;

    return KlpSemanticRegion(
      label: labels.oklchHueLabel,
      value: normalizedHue.toStringAsFixed(1),
      container: false,
      child: KlpSlider(
        label: labels.oklchHueLabel,
        value: normalizedHue,
        onChanged: onChanged == null
            ? null
            : (next) => onChanged!(value.copyWith(hue: next)),
        max: 360,
        divisions: 360,
        displayValue: normalizedHue.toStringAsFixed(1),
      ),
    );
  }

  Widget _alpha(KlpLocalizations labels) {
    return KlpSemanticRegion(
      label: labels.oklchAlphaLabel,
      value: value.alpha.toStringAsFixed(3),
      container: false,
      child: KlpSlider(
        label: labels.oklchAlphaLabel,
        value: value.alpha,
        onChanged: onChanged == null
            ? null
            : (next) => onChanged!(value.copyWith(alpha: next)),
        divisions: 100,
        displayValue: value.alpha.toStringAsFixed(3),
      ),
    );
  }
}
