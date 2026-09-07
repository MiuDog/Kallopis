import 'package:flutter/material.dart';

import '../../surface/klp_surface.dart';
import 'klp_explorer_models.dart';
import '../navigator/klp_navigator.dart';
import '../navigator/klp_navigator_models.dart';

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
		this.scrollController,
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
	final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
		return KlpNavigator(
			items: [
				for (final category in categories)
					KlpNavigatorCategory(
						id: category.id,
						label: category.label,
						expanded: category.expanded,
						collapsible: category.collapsible,
						items: [
							for (final node in _nodesForNestingPolicy(category.nodes))
								_toNavigatorElement(node),
						],
					),
			],
			expandedCategoryIds: expandedCategoryIds,
			expandedElementIds: expandedNodeIds,
			selectedElementId: selectedNodeId,
			onCategoryToggle: onCategoryToggle,
			onElementToggle: allowNesting ? onNodeToggle : null,
			onElementSelected: onNodeSelected,
			surfaceTone: surfaceTone,
			scrollKey: scrollKey,
			scrollController: scrollController,
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

	KlpNavigatorElement _toNavigatorElement(KlpExplorerNode node) {
		return KlpNavigatorElement(
			id: node.id,
			label: node.label,
			icon: node.icon,
			expandable: allowNesting && node.isFolder,
			expanded: node.expanded,
			selected: node.selected,
			badge: node.badge,
			data: node.data,
			children: [
				for (final child in node.children) _toNavigatorElement(child),
			],
		);
	}
}
