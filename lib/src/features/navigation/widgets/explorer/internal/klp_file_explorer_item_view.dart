part of '../klp_file_explorer.dart';

/// 一般檔案項目視圖（含檔案圖示、文字標題、選取高亮與 Hover 回饋）。
class KlpFileExplorerItemView extends StatefulWidget {
	const KlpFileExplorerItemView({
		super.key,
		required this.item,
		required this.level,
		required this.isSelected,
		required this.onTap,
		this.spacing = KlpFileExplorerSpacing.standard,
	});

	final KlpFileExplorerItem item;
	final int level;
	final bool isSelected;
	final VoidCallback onTap;
	final KlpFileExplorerSpacing spacing;

	@override
	State<KlpFileExplorerItemView> createState() =>
			_KlpFileExplorerItemViewState();
}
