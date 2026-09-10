part of '../klp_file_explorer.dart';

/// 檔案瀏覽器中的節點資料模型（可為折疊資料夾或一般檔案項目）。
@immutable
class KlpFileExplorerItem {
	const KlpFileExplorerItem({
		required this.id,
		required this.label,
		this.icon,
		this.children = const [],
		this.folder = false,
		this.expanded = false,
		this.selected = false,
		this.badge,
		this.tone,
		this.trailing,
		this.data,
	});

	final String id;
	final String label;
	final KlpIconData? icon;
	final List<KlpFileExplorerItem> children;
	final bool folder;
	final bool expanded;
	final bool selected;
	final String? badge;
	final KlpFeedbackTone? tone;
	final Widget? trailing;
	final Object? data;

	bool get isFolder => folder || children.isNotEmpty;
}
