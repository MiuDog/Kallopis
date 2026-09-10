part of '../klp_navigator.dart';

class _KlpNavigatorScope extends InheritedWidget {
	const _KlpNavigatorScope({
		required this.expandedCategoryIds,
		required this.expandedElementIds,
		required this.selectedElementId,
		required this.onCategoryToggle,
		required this.onElementToggle,
		required this.onElementSelected,
		required super.child,
	});

	final Set<String> expandedCategoryIds;
	final Set<String> expandedElementIds;
	final String? selectedElementId;
	final ValueChanged<String> onCategoryToggle;
	final ValueChanged<String> onElementToggle;
	final ValueChanged<String> onElementSelected;

	static _KlpNavigatorScope of(BuildContext context) {
		return context.dependOnInheritedWidgetOfExactType<_KlpNavigatorScope>()!;
	}

	@override
	bool updateShouldNotify(_KlpNavigatorScope oldWidget) {
		return expandedCategoryIds != oldWidget.expandedCategoryIds ||
			expandedElementIds != oldWidget.expandedElementIds ||
			selectedElementId != oldWidget.selectedElementId;
	}
}
