part of '../klp_advanced_data.dart';

/// 單一樹狀節點與其子節點的獨立渲染入口。
class KlpTreeItem extends StatelessWidget {
	const KlpTreeItem({super.key, required this.node, this.onSelected});

	final KlpTreeNode node;
	final ValueChanged<String>? onSelected;

	@override
	Widget build(BuildContext context) {
		return _KlpTreeNodeView(node: node, onSelected: onSelected);
	}
}
