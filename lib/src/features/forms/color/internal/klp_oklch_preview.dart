part of '../klp_oklch_color_picker.dart';

class _KlpOklchPreview extends StatelessWidget {
  const _KlpOklchPreview({
    required this.label,
    required this.color,
    required this.style,
  });

  final String label;
  final Color color;
  final _KlpOklchColorPickerStyle style;

  @override
  Widget build(BuildContext context) {
    return KlpSemanticRegion(
      label: label,
      container: false,
      child: _KlpOklchSectionFrame(
        style: style,
        child: KlpColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpExcludeSemantics(
              child: KlpText(label, role: KlpTextRole.caption),
            ),
            const KlpGap.heightSize(KlpSpaceSize.tight),
            _KlpOklchPreviewFrame(color: color, style: style),
          ],
        ),
      ),
    );
  }
}
