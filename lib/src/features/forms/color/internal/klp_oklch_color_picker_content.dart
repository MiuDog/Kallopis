part of '../klp_oklch_color_picker.dart';

class _KlpOklchColorPickerContent extends StatelessWidget {
  const _KlpOklchColorPickerContent({
    required this.value,
    required this.onChanged,
    required this.chromaRange,
    required this.style,
  });

  final KlpOklchColor value;
  final ValueChanged<KlpOklchColor>? onChanged;
  final KlpOklchChromaRange chromaRange;
  final _KlpOklchColorPickerStyle style;

  @override
  Widget build(BuildContext context) {
    final labels = KlpLocalizations.of(context);

    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpWrap(
          spacingSize: KlpSpaceSize.base,
          runSpacingSize: KlpSpaceSize.base,
          children: [
            _KlpOklchPlaneSection(
              kind: _OklchPlaneKind.lightness,
              label: labels.oklchLightnessPlaneLabel,
              value: value,
              onChanged: onChanged,
              chromaRange: chromaRange,
              style: style,
            ),
            _KlpOklchPlaneSection(
              kind: _OklchPlaneKind.chroma,
              label: labels.oklchChromaPlaneLabel,
              value: value,
              onChanged: onChanged,
              chromaRange: chromaRange,
              style: style,
            ),
            _KlpOklchPlaneSection(
              kind: _OklchPlaneKind.hue,
              label: labels.oklchHuePlaneLabel,
              value: value,
              onChanged: onChanged,
              chromaRange: chromaRange,
              style: style,
            ),
          ],
        ),
        const KlpGap.heightSize(KlpSpaceSize.base),
        KlpOklchColorEditor(
          value: value,
          onChanged: onChanged,
          chromaRange: chromaRange,
        ),
        const KlpGap.heightSize(KlpSpaceSize.base),
        KlpWrap(
          spacingSize: KlpSpaceSize.base,
          runSpacingSize: KlpSpaceSize.contentStack,
          children: [
            _KlpOklchPreview(
              label: labels.oklchOriginalPreviewLabel,
              color: value.toColor(),
              style: style,
            ),
            _KlpOklchPreview(
              label: labels.oklchFallbackPreviewLabel,
              color: value.toSrgbFallbackColor(),
              style: style,
            ),
          ],
        ),
        if (!value.isInSrgbGamut) ...[
          const KlpGap.heightSize(KlpSpaceSize.contentStack),
          KlpText(
            labels.oklchFallbackWarningLabel,
            role: KlpTextRole.caption,
            tone: KlpTextTone.danger,
          ),
        ],
      ],
    );
  }
}
