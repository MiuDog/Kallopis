part of '../klp_preview_tree.dart';

/// 將單一預覽節點投影為通用樹項目。
class _KlpPreviewTreeItem extends StatelessWidget {
	const _KlpPreviewTreeItem({required this.node, required this.onSelected});

	final KlpPreviewTreeNode node;
	final ValueChanged<String>? onSelected;

	@override
	Widget build(BuildContext context) => KlpColumn(
		crossAxisAlignment: CrossAxisAlignment.stretch,
		children: [
			KlpSemanticRegion(
				label: node.accessibilityLabel,
				child: KlpExcludeSemantics(
					child: KlpTreeItem(
						node: KlpTreeNode(
							id: node.id,
							label: node.label,
							badge: node.statusLabel,
						),
							onSelected: onSelected,
					),
				),
			),
			for (final child in node.children)
				_KlpPreviewTreeItem(node: child, onSelected: onSelected),
		],
	);
}
