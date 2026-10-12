part of '../klp_key_value_table.dart';

class _KlpKeyValueListRow extends StatelessWidget {
  const _KlpKeyValueListRow({
    required this.row,
    required this.labelWidth,
    required this.onCopy,
  });

  final KlpKeyValueItem row;
  final KlpKeyValueLabelWidth labelWidth;
  final ValueChanged<String>? onCopy;

  @override
  Widget build(BuildContext context) {
    return _KlpKeyValueRowFrame(
      child: KlpRow(
        children: [
          _KlpKeyValueLabelSlot(
            width: labelWidth,
            child: KlpText(
              row.label,
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const KlpGap.widthSize(KlpSpaceSize.base),
          KlpExpanded(
            child: _KlpKeyValueValueStyle(
              verbatim: row.verbatim,
              child: row.value,
            ),
          ),
          if (row.copyable && onCopy != null)
            KlpGestureRegion(
              key: ValueKey('pln-key-value-copy-${row.id}'),
              behavior: HitTestBehavior.opaque,
              onTap: () => onCopy!(row.id),
              child: KlpBox(
                paddingSize: KlpSpaceSize.tight,
                child: KlpIcon(
                  KlpIcons.clipboard,
                  size: context.klp.space.iconSmall,
                  color: context.klpColors.textFaint,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
