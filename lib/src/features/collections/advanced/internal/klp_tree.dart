part of '../klp_advanced_data.dart';

/// 樹狀節點清單，用於檔案總管與大綱等階層式導覽。
class KlpTree extends StatelessWidget {
  const KlpTree({
    super.key,
    required this.nodes,
    this.label,
    this.expandedIds,
    this.selectedId,
    this.onSelected,
    this.onExpanded,
  });

  final List<KlpTreeNode> nodes;
  final String? label;
  final Set<String>? expandedIds;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final ValueChanged<String>? onExpanded;

  @override
  Widget build(BuildContext context) {
    final children = [
      for (final node in nodes)
        _KlpTreeNodeView(
          node: node,
          expandedIds: expandedIds,
          selectedId: selectedId,
          onSelected: onSelected,
          onExpanded: onExpanded,
        ),
    ];

    return _KlpAdvancedSemantics(
      label: label,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
