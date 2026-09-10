part of '../klp_repeater_field.dart';

/// 可新增／刪除項目的重複欄位群組（例如「新增一組聯絡方式」）。
///
/// 不維護項目清單的狀態——[items] 由呼叫端持有，新增／刪除都只是透過
/// [onAdd]／[onRemove] 回報意圖，實際要不要新增一項、刪哪一項由呼叫端決定
/// 並重新傳入新的 [items]。
class KlpRepeaterField extends StatelessWidget {
  const KlpRepeaterField({
    super.key,
    required this.label,
    required this.addLabel,
    required this.removeLabel,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  final String label;
  final String addLabel;
  final String removeLabel;
  final List<KlpRepeaterItem> items;
  final VoidCallback? onAdd;
  final ValueChanged<String>? onRemove;

  @override
  Widget build(BuildContext context) {
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        const KlpGap.heightSize(KlpSpaceSize.tight),
        for (final item in items) ...[
          KlpSurface(
            tone: KlpSurfaceTone.component,
            padding: KlpBoxInsets.uniform(
              context.klp.space.contentInset,
            ).edgeInsets,
            child: KlpRow(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KlpExpanded(child: item.child),
                const KlpGap.widthSize(KlpSpaceSize.contentInline),
                KlpButton(
                  label: removeLabel,
                  compact: true,
                  tone: KlpButtonTone.ghost,
                  onPressed: onRemove == null ? null : () => onRemove!(item.id),
                ),
              ],
            ),
          ),
          const KlpGap.heightSize(KlpSpaceSize.tight),
        ],
        KlpAlign(
          alignment: Alignment.centerLeft,
          child: KlpButton(label: addLabel, compact: true, onPressed: onAdd),
        ),
      ],
    );
  }
}
