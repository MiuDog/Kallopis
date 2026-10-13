part of '../klp_date_grid.dart';

/// 單一日期格的 Kallopis 內容組裝。
class _KlpDateGridCell extends StatelessWidget {
  const _KlpDateGridCell({
    required this.item,
    required this.index,
    required this.itemCount,
    required this.onSelected,
  });

  final KlpDateGridItem item;
  final int index;
  final int itemCount;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return KlpGestureRegion(
      behavior: HitTestBehavior.opaque,
      onTap: onSelected == null ? null : () => onSelected!(index),
      child: _KlpDateGridCellFrame(
        index: index,
        itemCount: itemCount,
        selected: item.selected,
        child: KlpColumn(
          children: [
            KlpText(
              item.label,
              role: item.selected ? KlpTextRole.bodyStrong : KlpTextRole.body,
              tone: item.selected ? KlpTextTone.automatic : KlpTextTone.faint,
            ),
            const KlpGap.heightSize(KlpSpaceSize.tight),
            for (final line in item.lines) ...[
              KlpText(line, role: KlpTextRole.body),
              const KlpGap.heightSize(KlpSpaceSize.hairline),
            ],
          ],
        ),
      ),
    );
  }
}
