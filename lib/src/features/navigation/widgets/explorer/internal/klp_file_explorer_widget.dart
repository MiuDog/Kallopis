part of '../klp_file_explorer.dart';

/// 檔案瀏覽器（File Explorer）。
///
/// 支援分類分組（可折疊）、資料夾樹狀結構（可展開）與一般檔案節點選取。
/// 支援受控（傳入 `expandedSectionIds` / `expandedItemIds` / `selectedId`）
/// 與非受控（讀取各 Section 與 Item 的 `expanded` / `selected` 屬性）兩種模式。
class KlpFileExplorer extends StatefulWidget {
	const KlpFileExplorer({
		super.key,
		required this.sections,
		this.expandedSectionIds,
		this.expandedItemIds,
		this.selectedId,
		this.onSectionToggle,
		this.onItemToggle,
		this.onItemSelected,
		this.spacing = KlpFileExplorerSpacing.standard,
		this.emptyStateSections = const [],
		this.scrollController,
	});

	final List<KlpFileExplorerSection> sections;
	final Set<String>? expandedSectionIds;
	final Set<String>? expandedItemIds;
	final String? selectedId;
	final ValueChanged<String>? onSectionToggle;
	final ValueChanged<String>? onItemToggle;
	final ValueChanged<String>? onItemSelected;
	final KlpFileExplorerSpacing spacing;
	final ScrollController? scrollController;

	/// [sections] 沒有資料時仍需保留的視覺分區。
	///
	/// 這只描述 Explorer 結構，不會把 placeholder section 寫回資料模型。
	final List<KlpFileExplorerSection> emptyStateSections;

	@override
	State<KlpFileExplorer> createState() => _KlpFileExplorerState();
}
