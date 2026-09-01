import 'package:flutter/material.dart';

import '../foundation/klp_icons.dart';
import '../layout/klp_layout.dart';
import '../surface/klp_surface.dart';
import 'klp_explorer_models.dart';
import 'klp_file_explorer.dart';

/// 具有統一表面、分類與節點排版的 Explorer。
///
/// 產品只提供 [categories] 與互動 callback。分類節奏、節點列高、縮排與
/// 表面層級全由 Kallopis 管理；查詢、搜尋 UI 與後端資料取得由產品負責。
class KlpExplorer extends StatelessWidget {
  const KlpExplorer({
    super.key,
    required this.categories,
    this.allowNesting = true,
    this.selectedNodeId,
    this.expandedCategoryIds,
    this.expandedNodeIds,
    this.onCategoryToggle,
    this.onNodeToggle,
    this.onNodeSelected,
    this.surfaceTone = KlpSurfaceTone.inset,
    this.scrollKey,
  });

  final List<KlpExplorerCategory> categories;

  /// 是否以樹狀階層呈現節點。
  ///
  /// `false` 時會以穩定的前序順序展平既有子節點，並且不顯示
  /// 展開控制；資料夾與檔案仍保留各自的 icon 語意。
  final bool allowNesting;
  final String? selectedNodeId;
  final Set<String>? expandedCategoryIds;
  final Set<String>? expandedNodeIds;
  final ValueChanged<String>? onCategoryToggle;
  final ValueChanged<String>? onNodeToggle;
  final ValueChanged<String>? onNodeSelected;
  final KlpSurfaceTone surfaceTone;
  final Key? scrollKey;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: surfaceTone,
      child: KlpScrollViewport(
        key: scrollKey,
        child: KlpFileExplorer(
          sections: [
            for (final category in categories)
              KlpFileExplorerSection(
                id: category.id,
                title: category.label,
                expanded: category.expanded,
                collapsible: category.collapsible,
                items: [
                  for (final node in _nodesForNestingPolicy(category.nodes))
                    _toLegacyItem(node),
                ],
              ),
          ],
          expandedSectionIds: expandedCategoryIds,
          expandedItemIds: expandedNodeIds,
          selectedId: selectedNodeId,
          onSectionToggle: onCategoryToggle,
          onItemToggle: allowNesting ? onNodeToggle : null,
          onItemSelected: onNodeSelected,
        ),
      ),
    );
  }

  List<KlpExplorerNode> _nodesForNestingPolicy(List<KlpExplorerNode> nodes) {
    if (allowNesting) return nodes;
    final flattened = <KlpExplorerNode>[];

    void append(List<KlpExplorerNode> source) {
      for (final node in source) {
        flattened.add(
          KlpExplorerNode(
            id: node.id,
            label: node.label,
            kind: node.kind,
            icon: node.icon,
            expanded: false,
            selected: node.selected,
            badge: node.badge,
            tone: node.tone,
            data: node.data,
          ),
        );
        append(node.children);
      }
    }

    append(nodes);
    return flattened;
  }

  KlpFileExplorerItem _toLegacyItem(KlpExplorerNode node) {
    return KlpFileExplorerItem(
      id: node.id,
      label: node.label,
      icon: node.icon ?? (node.isFolder ? KlpIcons.folder : KlpIcons.clipboard),
      folder: allowNesting && node.isFolder,
      expanded: node.expanded,
      selected: node.selected,
      badge: node.badge,
      tone: node.tone,
      data: node.data,
      children: [for (final child in node.children) _toLegacyItem(child)],
    );
  }
}
