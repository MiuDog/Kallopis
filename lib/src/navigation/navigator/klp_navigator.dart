import 'package:flutter/material.dart';

import '../../foundation/klp_icon.dart';
import '../../foundation/klp_icons.dart';
import '../../interaction/klp_pressable.dart';
import '../../interaction/klp_state_highlight.dart';
import '../../surface/klp_surface.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';
import 'klp_navigator_models.dart';

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
		this.indent,
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
	final double? indent;
	final KlpSurfaceTone surfaceTone;
	final Key? scrollKey;
	final ScrollController? scrollController;

	@override
	State<KlpNavigator> createState() => _KlpNavigatorState();
}

class _KlpNavigatorState extends State<KlpNavigator> {

	late final Set<String> _expandedCategoryIds = _initialExpandedCategories();
	late final Set<String> _expandedElementIds = _initialExpandedElements();
	String? _selectedElementId;

	@override
	void initState() {
		super.initState();
		_selectedElementId = widget.selectedElementId ?? _initialSelectedElement();
	}

	Set<String> _initialExpandedCategories() {
		final result = <String>{};

		void collect(List<KlpNavigatorItem> items) {
			for (final item in items) {
				if (item case KlpNavigatorCategory(:final id, :final expanded, :final items)) {
					if (expanded) result.add(id);
					collect(items);
				}
			}
		}

		collect(widget.items);
		return result;
	}

	Set<String> _initialExpandedElements() {
		final result = <String>{};

		void collectElements(List<KlpNavigatorElement> elements) {
			for (final element in elements) {
				if (element.expanded) result.add(element.id);
				collectElements(element.children);
			}
		}

		void collectItems(List<KlpNavigatorItem> items) {
			for (final item in items) {
				switch (item) {
					case KlpNavigatorCategory(:final items):
						collectItems(items);
					case KlpNavigatorElement():
						collectElements([item]);
					case KlpNavigatorComponent():
						break;
				}
			}
		}

		collectItems(widget.items);
		return result;
	}

	String? _initialSelectedElement() {
		String? result;

		void collectElements(List<KlpNavigatorElement> elements) {
			for (final element in elements) {
				if (result != null) return;
				if (element.selected) result = element.id;
				collectElements(element.children);
			}
		}

		void collectItems(List<KlpNavigatorItem> items) {
			for (final item in items) {
				if (result != null) return;
				switch (item) {
					case KlpNavigatorCategory(:final items):
						collectItems(items);
					case KlpNavigatorElement():
						collectElements([item]);
					case KlpNavigatorComponent():
						break;
				}
			}
		}

		collectItems(widget.items);
		return result;
	}

	void _toggleCategory(String id) {
		if (widget.onCategoryToggle != null) {
			widget.onCategoryToggle!(id);
			return;
		}

		setState(() {
			if (!_expandedCategoryIds.remove(id)) _expandedCategoryIds.add(id);
		});
	}

	void _toggleElement(String id) {
		if (widget.onElementToggle != null) {
			widget.onElementToggle!(id);
			return;
		}

		setState(() {
			if (!_expandedElementIds.remove(id)) _expandedElementIds.add(id);
		});
	}

	void _selectElement(String id) {
		if (widget.onElementSelected != null) {
			widget.onElementSelected!(id);
			return;
		}

		setState(() => _selectedElementId = id);
	}

	@override
	Widget build(BuildContext context) {
		final expandedCategoryIds = widget.expandedCategoryIds ?? _expandedCategoryIds;
		final expandedElementIds = widget.expandedElementIds ?? _expandedElementIds;
		final selectedElementId = widget.selectedElementId ?? _selectedElementId;
		final indent = widget.indent ?? context.klp.space.tight;

		return KlpSurface(
			tone: widget.surfaceTone,
			child: _KlpNavigatorScope(
				expandedCategoryIds: Set.unmodifiable(expandedCategoryIds),
				expandedElementIds: Set.unmodifiable(expandedElementIds),
				selectedElementId: selectedElementId,
				indent: indent,
				onCategoryToggle: _toggleCategory,
				onElementToggle: _toggleElement,
				onElementSelected: _selectElement,
				child: ListView(
					key: widget.scrollKey,
					controller: widget.scrollController,
					shrinkWrap: true,
					physics: const ClampingScrollPhysics(),
					padding: EdgeInsets.zero,
					children: [
						for (final item in widget.items) _KlpNavigatorItemView(item: item, level: 0),
					],
				),
			),
		);
	}
}

class _KlpNavigatorScope extends InheritedWidget {

	const _KlpNavigatorScope({
		required this.expandedCategoryIds,
		required this.expandedElementIds,
		required this.selectedElementId,
		required this.indent,
		required this.onCategoryToggle,
		required this.onElementToggle,
		required this.onElementSelected,
		required super.child,
	});

	final Set<String> expandedCategoryIds;
	final Set<String> expandedElementIds;
	final String? selectedElementId;
	final double indent;
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
			selectedElementId != oldWidget.selectedElementId ||
			indent != oldWidget.indent;
	}
}

class _KlpNavigatorItemView extends StatelessWidget {

	const _KlpNavigatorItemView({required this.item, required this.level});

	final KlpNavigatorItem item;
	final int level;

	@override
	Widget build(BuildContext context) {
		return switch (item) {
			KlpNavigatorCategory() => _KlpNavigatorCategoryView(category: item as KlpNavigatorCategory),
			KlpNavigatorElement() => _KlpNavigatorElementView(element: item as KlpNavigatorElement, level: level),
			KlpNavigatorComponent() => KeyedSubtree(
				key: ValueKey(item.id),
				child: (item as KlpNavigatorComponent).child,
			),
		};
	}
}

class _KlpNavigatorCategoryView extends StatelessWidget {

	const _KlpNavigatorCategoryView({required this.category});

	final KlpNavigatorCategory category;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final scope = _KlpNavigatorScope.of(context);
		final isExpanded = scope.expandedCategoryIds.contains(category.id);

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			mainAxisSize: MainAxisSize.min,
			children: [
				SizedBox(
					width: double.infinity,
					height: klp.space.icon,
					child: KlpPressable(
						onPressed: category.collapsible ? () => scope.onCategoryToggle(category.id) : null,
						hoverHighlight: false,
						child: Padding(
							padding: EdgeInsets.symmetric(horizontal: klp.space.navigationItemInset),
							child: Row(
								children: [
									if (category.collapsible) ...[
										AnimatedRotation(
											turns: isExpanded ? 0 : -0.25,
											duration: klp.motion.stateTransition,
											curve: Curves.easeOutCubic,
											child: KlpIcon(
												KlpIcons.chevronDown,
												size: klp.geometry.layout.disclosureIconSize,
												color: context.klpColors.textMuted,
											),
										),
										SizedBox(width: klp.space.tight + klp.space.hairline),
									],
									Expanded(
										child: KlpText(
											category.label,
											role: KlpTextRole.caption,
											tone: KlpTextTone.muted,
										),
									),
									if (category.trailing != null) category.trailing!,
								],
							),
						),
					),
				),
				if (isExpanded)
					for (final item in category.items) _KlpNavigatorItemView(item: item, level: 0),
				SizedBox(height: klp.space.navigationSectionGap),
			],
		);
	}
}

class _KlpNavigatorElementView extends StatefulWidget {

	const _KlpNavigatorElementView({required this.element, required this.level});

	final KlpNavigatorElement element;
	final int level;

	@override
	State<_KlpNavigatorElementView> createState() => _KlpNavigatorElementViewState();
}

class _KlpNavigatorElementViewState extends State<_KlpNavigatorElementView> {

	bool _isHovered = false;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final scope = _KlpNavigatorScope.of(context);
		final element = widget.element;
		final isExpanded = scope.expandedElementIds.contains(element.id);
		final isSelected = scope.selectedElementId == element.id;
		final rowHeight = element.isBranch
			? klp.space.controlHeightXSmall
			: klp.space.controlHeightXSmall + klp.geometry.control.fileExplorerRowHeightAdjustment;

		final row = KlpStateHighlight(
			state: isSelected || _isHovered ? KlpHighlightState.hover : KlpHighlightState.none,
			borderRadius: BorderRadius.circular(klp.shape.control),
			child: Container(
				height: rowHeight,
				padding: EdgeInsets.only(right: klp.space.tight),
				child: _buildRow(context, scope, element, isExpanded, isSelected),
			),
		);

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			mainAxisSize: MainAxisSize.min,
			children: [
				MouseRegion(
					onEnter: (_) => setState(() => _isHovered = true),
					onExit: (_) => setState(() => _isHovered = false),
					child: GestureDetector(
						behavior: HitTestBehavior.opaque,
						onTap: () {
							if (element.isBranch) scope.onElementToggle(element.id);
							scope.onElementSelected(element.id);
						},
						child: Padding(
							padding: EdgeInsets.symmetric(
								horizontal: klp.space.navigationItemInset,
								vertical: klp.space.hairline,
							),
							child: row,
						),
					),
				),
				if (element.isBranch && isExpanded)
					for (final child in element.children)
						_KlpNavigatorElementView(element: child, level: widget.level + 1),
			],
		);
	}

	Widget _buildRow(
		BuildContext context,
		_KlpNavigatorScope scope,
		KlpNavigatorElement element,
		bool isExpanded,
		bool isSelected,
	) {
		final klp = context.klp;
		final tokens = context.klpColors;

		return Row(
			children: [
				Padding(
					padding: EdgeInsets.only(left: widget.level * scope.indent),
					child: SizedBox(
						width: klp.space.iconSmall + klp.geometry.layout.treeLeadingGap,
						child: element.isBranch
							? GestureDetector(
								behavior: HitTestBehavior.opaque,
								onTap: () => scope.onElementToggle(element.id),
								child: AnimatedRotation(
									turns: isExpanded ? 0 : -0.25,
									duration: klp.motion.stateTransition,
									curve: Curves.easeOutCubic,
									child: KlpIcon(
										KlpIcons.chevronDown,
										size: klp.space.iconSmall,
										color: isSelected ? tokens.text : tokens.textMuted,
									),
								),
							)
							: null,
					),
				),
				KlpIcon(
					element.icon ?? (element.isBranch ? KlpIcons.folder : KlpIcons.clipboard),
					size: klp.space.iconSmall,
					color: isSelected ? tokens.text : tokens.textMuted,
				),
				SizedBox(width: klp.space.contentInlineGap),
				Expanded(
					child: KlpText(
						element.label,
						role: KlpTextRole.code,
						color: tokens.text,
						overflow: TextOverflow.ellipsis,
					),
				),
				if (element.badge != null) ...[
					SizedBox(width: klp.space.contentInlineGap),
					KlpText(element.badge!, role: KlpTextRole.code, color: tokens.text),
				],
				if (element.trailing != null) element.trailing!,
			],
		);
	}
}
