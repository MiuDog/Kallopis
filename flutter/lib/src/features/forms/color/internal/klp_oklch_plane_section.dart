part of '../klp_oklch_color_picker.dart';

class _KlpOklchPlaneSection extends StatelessWidget {
  const _KlpOklchPlaneSection({
    required this.kind,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.chromaRange,
    required this.style,
  });

  final _OklchPlaneKind kind;
  final String label;
  final KlpOklchColor value;
  final ValueChanged<KlpOklchColor>? onChanged;
  final KlpOklchChromaRange chromaRange;
  final _KlpOklchColorPickerStyle style;

  @override
  Widget build(BuildContext context) {
    return _KlpOklchSectionFrame(
      style: style,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpExcludeSemantics(child: KlpText(label, role: KlpTextRole.caption)),
          const KlpGap.heightSize(KlpSpaceSize.tight),
          _KlpOklchPlaneExtentFrame(
            style: style,
            child: _OklchPlane(
              kind: kind,
              label: label,
              value: value,
              chromaRange: chromaRange,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
