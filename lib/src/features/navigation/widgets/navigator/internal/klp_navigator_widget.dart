part of '../klp_navigator.dart';

/// Sidebar 的通用導覽組成。
///
/// Category 與 Element 沿用 Kallopis Catalog 目錄的視覺與高度；Component 是
/// 不受固定列高限制的插槽。產品只提供資料、受控狀態與事件。
class KlpNavigator extends StatefulWidget {
	const KlpNavigator({
		super.key,
		required this.items,
		this.expandedCategoryIds,
		this.expandedElementIds,
		this.selectedElementId,
		this.onCategoryToggle,
		this.onElementToggle,
		this.onElementSelected,
		this.surfaceTone = KlpSurfaceTone.inset,
		this.scrollKey,
		this.scrollController,
	});

	final List<KlpNavigatorItem> items;
	final Set<String>? expandedCategoryIds;
	final Set<String>? expandedElementIds;
	final String? selectedElementId;
	final ValueChanged<String>? onCategoryToggle;
	final ValueChanged<String>? onElementToggle;
	final ValueChanged<String>? onElementSelected;
	final KlpSurfaceTone surfaceTone;
	final Key? scrollKey;
	final ScrollController? scrollController;

	@override
	State<KlpNavigator> createState() => _KlpNavigatorState();
}
