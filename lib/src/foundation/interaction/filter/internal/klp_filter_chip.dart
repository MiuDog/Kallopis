part of '../klp_filter_bar.dart';

class _KlpFilterChip extends StatelessWidget {
  const _KlpFilterChip({
    required this.label,
    this.value,
    required this.selected,
    required this.onPressed,
    this.onRemove,
  });

  final String label;
  final String? value;
  final bool selected;
  final VoidCallback onPressed;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return _KlpFilterChipFrame(
      selected: selected,
      onPressed: onPressed,
      builder: (context, style) => KlpRow(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(label, role: KlpTextRole.caption, color: style.label),
          if (value != null) ...[
            const KlpGap.widthSize(KlpSpaceSize.tight),
            KlpText(
              value!,
              role: KlpTextRole.monoCaptionStrong,
              color: style.value,
            ),
          ],
          if (onRemove != null) ...[
            const KlpGap.widthSize(KlpSpaceSize.tight),
            _KlpFilterRemoveAction(
              onPressed: onRemove!,
              foreground: style.remove,
            ),
          ],
        ],
      ),
    );
  }
}
