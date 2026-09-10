import '../internal/klp_form_dependencies.dart';
import 'klp_tag_chip.dart';

part 'primitives/klp_tag_input_action_frame.dart';

/// 標籤輸入與群組欄位。支援新增、移除個別標籤與清空所有標籤。
class KlpTagInputField extends StatelessWidget {
  const KlpTagInputField({
    super.key,
    required this.label,
    required this.tags,
    this.onAdd,
    this.onRemove,
    this.onClearAll,
    this.maxCount,
  });

  final String label;
  final List<String> tags;
  final VoidCallback? onAdd;
  final ValueChanged<String>? onRemove;
  final VoidCallback? onClearAll;
  final int? maxCount;

  @override
  Widget build(BuildContext context) {
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        const KlpGap.heightSize(KlpSpaceSize.tight),
        KlpWrap(
          spacingSize: KlpSpaceSize.tight,
          runSpacingSize: KlpSpaceSize.tight,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final tag in tags)
              KlpTagChip(
                label: tag,
                onRemove: onRemove == null ? null : () => onRemove!(tag),
              ),
            if (onAdd != null)
              KlpGestureRegion(
                behavior: HitTestBehavior.opaque,
                onTap: onAdd,
                child: const _KlpTagInputActionFrame(
                  child: KlpText('+ Add', role: KlpTextRole.caption),
                ),
              ),
            if (maxCount != null || onClearAll != null) ...[
              const KlpGap.widthSize(KlpSpaceSize.tight),
              if (maxCount != null)
                KlpText(
                  '${tags.length}/$maxCount',
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.faint,
                ),
              if (onClearAll != null)
                KlpGestureRegion(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClearAll,
                  child: const KlpText(
                    ' Clear all',
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }
}
