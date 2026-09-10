part of '../klp_explorer_models.dart';

/// Explorer 的分類資料模型。
///
/// 分類只負責命名一組節點與宣告是否可收合；尺寸、內距與
/// 排版由 `KlpExplorer` 統一管理。
@immutable
class KlpExplorerCategory {
	const KlpExplorerCategory({
		required this.id,
		required this.label,
		this.nodes = const [],
		this.expanded = true,
		this.collapsible = true,
	});

	final String id;
	final String label;
	final List<KlpExplorerNode> nodes;
	final bool expanded;
	final bool collapsible;
}
