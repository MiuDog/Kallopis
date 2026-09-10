part of '../klp_reference_picker.dart';

class _KlpReferenceOptionRow extends StatelessWidget {
  const _KlpReferenceOptionRow({required this.option, required this.onPressed});

  final KlpReferenceOption option;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return KlpGestureRegion(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: _KlpReferenceOptionFrame(
        child: KlpRow(
          children: [
            if (option.kind != null) ...[
              KlpBadge(label: option.kind!),
              const KlpGap.widthSize(KlpSpaceSize.tight),
            ],
            KlpExpanded(
              child: KlpText(
                option.label,
                tone: option.disabled ? KlpTextTone.faint : KlpTextTone.primary,
              ),
            ),
            if (option.metadata != null)
              KlpText(
                option.metadata!,
                role: KlpTextRole.caption,
                tone: KlpTextTone.faint,
              ),
          ],
        ),
      ),
    );
  }
}
