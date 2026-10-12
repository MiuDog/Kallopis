part of '../klp_artifact_workspace.dart';

/// 可排序 Token 清單的表格呈現；排序狀態由呼叫端持有。
class KlpTokenTable extends StatelessWidget {
  const KlpTokenTable({
    super.key,
    required this.tokens,
    required this.nameLabel,
    required this.typeLabel,
    required this.valueLabel,
    required this.referenceLabel,
    required this.statusLabel,
  });

  final List<KlpTokenDefinitionData> tokens;
  final String nameLabel;
  final String typeLabel;
  final String valueLabel;
  final String referenceLabel;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return KlpDataTable(
      columns: [
        KlpDataColumn(id: 'name', label: nameLabel),
        KlpDataColumn(id: 'type', label: typeLabel),
        KlpDataColumn(id: 'value', label: valueLabel),
        KlpDataColumn(id: 'reference', label: referenceLabel),
        KlpDataColumn(id: 'status', label: statusLabel),
      ],
      rows: [
        for (final token in tokens)
          KlpDataRow(
            id: token.name,
            cells: {
              'name': KlpText(token.name, role: KlpTextRole.code),
              'type': KlpText(token.typeLabel),
              'value': KlpRow(
                children: [
                  if (token.preview case final preview?) ...[
                    preview,
                    const KlpGap.widthSize(KlpSpaceSize.tight),
                  ],
                  KlpFlexible(child: KlpText(token.valueLabel)),
                ],
              ),
              'reference': KlpText(token.referenceLabel ?? ''),
              'status': KlpBadge(label: token.statusLabel),
            },
          ),
      ],
    );
  }
}
