part of '../klp_explorer_models.dart';

/// Explorer 的單一元素節點。
///
/// 資料夾與檔案共用同一種節點模型；是否呈現遞迴階層，由
/// `KlpExplorer.allowNesting` 決定，不由產品自行編排 Widget。
@immutable
class KlpExplorerNode {
	const KlpExplorerNode({
		required this.id,
		required this.label,
		required this.kind,
		this.icon,
		this.children = const [],
		this.expanded = false,
		this.selected = false,
		this.badge,
		this.tone,
		this.data,
	});

	final String id;
	final String label;
	final KlpExplorerNodeKind kind;
	final KlpIconData? icon;

	/// 子節點；只有 [KlpExplorerNodeKind.folder] 會呈現其內容。
	final List<KlpExplorerNode> children;
	final bool expanded;
	final bool selected;
	final String? badge;
	final KlpFeedbackTone? tone;
	final Object? data;

	bool get isFolder => kind == KlpExplorerNodeKind.folder;
}
