import 'package:flutter/widgets.dart';

import '../data/klp_advanced_data.dart';
import '../feedback/klp_finite_workflow.dart';

/// 尚未成為 canonical artifact 的預覽樹節點。
@immutable
class KlpPreviewTreeNode {
	const KlpPreviewTreeNode({
		required this.id,
		required this.label,
		required this.accessibilityLabel,
		this.children = const [],
		this.statusLabel,
	});

	final String id;
	final String label;
	final String accessibilityLabel;
	final List<KlpPreviewTreeNode> children;
	final String? statusLabel;
}

/// 提案專用樹；語意名稱明確區分預覽節點與 canonical 導覽節點。
class KlpPreviewTree extends StatelessWidget {
	const KlpPreviewTree({super.key, required this.label, required this.nodes, this.enabled = true, this.onSelected});

	final String label;
	final List<KlpPreviewTreeNode> nodes;
	final bool enabled;
	final ValueChanged<String>? onSelected;

	@override
	Widget build(BuildContext context) => Semantics(
		container: true,
		enabled: enabled,
		label: label,
		child: AbsorbPointer(
			absorbing: !enabled,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					for (final node in nodes)
						_KlpPreviewTreeItem(node: node, onSelected: onSelected),
				],
			),
		),
	);
}

class _KlpPreviewTreeItem extends StatelessWidget {
	const _KlpPreviewTreeItem({required this.node, required this.onSelected});

	final KlpPreviewTreeNode node;
	final ValueChanged<String>? onSelected;

	@override
	Widget build(BuildContext context) => Column(
		crossAxisAlignment: CrossAxisAlignment.stretch,
		children: [
			Semantics(
				label: node.accessibilityLabel,
				excludeSemantics: true,
				child: KlpTreeItem(
					node: KlpTreeNode(id: node.id, label: node.label, badge: node.statusLabel),
					onSelected: onSelected,
				),
			),
			for (final child in node.children)
				_KlpPreviewTreeItem(node: child, onSelected: onSelected),
		],
	);
}

/// 原子發布期間保持預覽樹穩定，並在其上呈現具名階段。
class KlpPublicationProgressOverlay extends StatelessWidget {
	const KlpPublicationProgressOverlay({super.key, required this.child, required this.visible, required this.progress});

	final Widget child;
	final bool visible;
	final KlpWorkflowProgress progress;

	@override
	Widget build(BuildContext context) => Stack(
		children: [
			AbsorbPointer(absorbing: visible, child: child),
			if (visible) Positioned.fill(child: progress),
		],
	);
}
