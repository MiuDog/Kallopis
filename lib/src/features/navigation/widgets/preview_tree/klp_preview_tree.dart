import 'package:flutter/widgets.dart';

import '../../../collections/advanced/klp_advanced_data.dart';
import '../../../../foundation/interaction/klp_exclude_semantics.dart';
import '../../../../foundation/interaction/klp_semantic_region.dart';
import '../../../../foundation/interaction/primitives/klp_pointer_blocker.dart';
import '../../../../foundation/layout/klp_column.dart';
import 'models/klp_preview_tree_node.dart';

part 'internal/klp_preview_tree_item.dart';

/// 非 canonical 內容的預覽樹，與正式導覽節點維持明確語意區隔。
class KlpPreviewTree extends StatelessWidget {
	const KlpPreviewTree({super.key, required this.label, required this.nodes, this.enabled = true, this.onSelected});

	final String label;
	final List<KlpPreviewTreeNode> nodes;
	final bool enabled;
	final ValueChanged<String>? onSelected;

	@override
	Widget build(BuildContext context) => KlpSemanticRegion(
		enabled: enabled,
		label: label,
		child: KlpPointerBlocker(
			blocking: !enabled,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					for (final node in nodes)
						_KlpPreviewTreeItem(node: node, onSelected: onSelected),
				],
			),
		),
	);
}
