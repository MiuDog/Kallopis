import '../internal/klp_form_dependencies.dart';

part 'primitives/klp_tag_chip_frame.dart';

/// 標籤膠囊元件。呈現單一標籤並支援移除操作。
class KlpTagChip extends StatelessWidget {
  const KlpTagChip({super.key, required this.label, this.onRemove});

  final String label;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return _KlpTagChipFrame(
      child: KlpRow(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(label, role: KlpTextRole.code),
          if (onRemove != null) ...[
            const KlpGap.widthSize(KlpSpaceSize.tight),
            KlpGestureRegion(
              behavior: HitTestBehavior.opaque,
              onTap: onRemove,
              child: const KlpText(
                '×',
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
