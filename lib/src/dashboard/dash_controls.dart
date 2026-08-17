import 'package:flutter/material.dart';

import '../controls/pln_button.dart';
import '../controls/pln_icon_button.dart';
import '../controls/pln_segmented_control.dart';
import '../controls/pln_toggle.dart';
import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class DashFilterChip {
  const DashFilterChip({
    required this.id,
    required this.label,
    required this.valueLabel,
    this.locked = false,
  });

  final String id;
  final String label;
  final String valueLabel;
  final bool locked;
}

class DashRangePreset {
  const DashRangePreset({required this.id, required this.label});

  final String id;
  final String label;
}

class DashFilterBar extends StatelessWidget {
  const DashFilterBar({
    super.key,
    this.rangePresets = const [],
    this.activeRangeId,
    this.rangeSummary,
    this.comparisonLabel,
    this.comparisonOn = false,
    this.filters = const [],
    this.breakdownLabel,
    this.updatedLabel,
    this.refreshing = false,
    this.onSelectRange,
    this.onToggleComparison,
    this.onRemoveFilter,
    this.onAddFilter,
    this.onClearAll,
    this.onRefresh,
    this.onExport,
  });

  final List<DashRangePreset> rangePresets;
  final String? activeRangeId;
  final String? rangeSummary;
  final String? comparisonLabel;
  final bool comparisonOn;
  final List<DashFilterChip> filters;
  final String? breakdownLabel;
  final String? updatedLabel;
  final bool refreshing;
  final ValueChanged<String>? onSelectRange;
  final ValueChanged<bool>? onToggleComparison;
  final ValueChanged<String>? onRemoveFilter;
  final VoidCallback? onAddFilter;
  final VoidCallback? onClearAll;
  final VoidCallback? onRefresh;
  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context) {
    final activeIndex = rangePresets.indexWhere(
      (preset) => preset.id == activeRangeId,
    );

    return Wrap(
      spacing: PlnSpace.sm,
      runSpacing: PlnSpace.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (rangePresets.isNotEmpty)
          PlnSegmentedControl(
            items: [for (final preset in rangePresets) preset.label],
            selected: activeIndex < 0 ? 0 : activeIndex,
            onSelected: (index) => onSelectRange?.call(rangePresets[index].id),
          ),
        if (rangeSummary != null)
          PlnText(
            rangeSummary!,
            role: PlnTextRole.code,
            tone: PlnTextTone.muted,
          ),
        if (comparisonLabel != null)
          PlnToggle(
            value: comparisonOn,
            label: comparisonLabel!,
            onChanged: onToggleComparison,
          ),
        for (final filter in filters)
          _DashFilterChipView(
            filter: filter,
            onRemove: filter.locked || onRemoveFilter == null
                ? null
                : () => onRemoveFilter!(filter.id),
          ),
        if (onAddFilter != null)
          PlnButton(
            label: 'Add filter',
            tone: PlnButtonTone.ghost,
            compact: true,
            onPressed: onAddFilter,
          ),
        if (onClearAll != null && filters.any((filter) => !filter.locked))
          PlnButton(
            label: 'Clear all',
            tone: PlnButtonTone.ghost,
            compact: true,
            onPressed: onClearAll,
          ),
        if (breakdownLabel != null)
          PlnText(
            breakdownLabel!,
            role: PlnTextRole.caption,
            tone: PlnTextTone.muted,
          ),
        if (updatedLabel != null)
          PlnText(
            updatedLabel!,
            role: PlnTextRole.caption,
            tone: PlnTextTone.faint,
          ),
        if (onRefresh != null)
          PlnIconButton(
            icon: PlnIcons.switchVertical,
            label: refreshing ? 'Refreshing' : 'Refresh',
            onPressed: refreshing ? null : onRefresh,
          ),
        if (onExport != null)
          PlnIconButton(
            icon: PlnIcons.archive,
            label: 'Export',
            onPressed: onExport,
          ),
      ],
    );
  }
}

class _DashFilterChipView extends StatelessWidget {
  const _DashFilterChipView({required this.filter, this.onRemove});

  final DashFilterChip filter;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return Container(
      padding: const EdgeInsets.only(
        left: PlnSpace.sm,
        top: PlnSpace.xs,
        bottom: PlnSpace.xs,
        right: PlnSpace.xs,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceInset,
        borderRadius: BorderRadius.circular(PlnRadius.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlnText(
            '${filter.label} ${filter.valueLabel}',
            role: PlnTextRole.caption,
          ),
          const SizedBox(width: PlnSpace.xs),
          if (onRemove == null)
            PlnText(
              filter.locked ? 'LOCKED' : '',
              role: PlnTextRole.label,
              tone: PlnTextTone.faint,
            )
          else
            Semantics(
              button: true,
              label: 'Remove ${filter.label} filter',
              child: InkWell(
                key: ValueKey('dashboard-filter-remove-${filter.id}'),
                onTap: onRemove,
                borderRadius: BorderRadius.circular(PlnRadius.full),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: PlnSpace.xs),
                  child: PlnText('×', role: PlnTextRole.bodyStrong),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum DashViewKind {
  table,
  board,
  timeline,
  calendar,
  list,
  gallery,
  chart,
  feed,
  map,
}

class DashViewTab {
  const DashViewTab({
    required this.id,
    required this.kind,
    required this.label,
    this.count,
    this.locked = false,
  });

  final String id;
  final DashViewKind kind;
  final String label;
  final int? count;
  final bool locked;
}

class DashViewSwitcher extends StatelessWidget {
  const DashViewSwitcher({
    super.key,
    required this.views,
    required this.activeViewId,
    required this.onSelect,
    this.grid = false,
    this.filterSummary,
    this.sortSummary,
    this.onAddView,
    this.onOpenFilters,
    this.onOpenSort,
  });

  final List<DashViewTab> views;
  final String activeViewId;
  final ValueChanged<String> onSelect;
  final bool grid;
  final String? filterSummary;
  final String? sortSummary;
  final VoidCallback? onAddView;
  final VoidCallback? onOpenFilters;
  final VoidCallback? onOpenSort;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: PlnSpace.xs,
      runSpacing: PlnSpace.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final view in views)
          _DashViewButton(
            view: view,
            selected: view.id == activeViewId,
            grid: grid,
            onPressed: () => onSelect(view.id),
          ),
        if (onAddView != null)
          PlnButton(
            label: 'Add view',
            tone: PlnButtonTone.ghost,
            compact: true,
            onPressed: onAddView,
          ),
        if (filterSummary != null)
          PlnButton(
            label: filterSummary!,
            tone: PlnButtonTone.ghost,
            compact: true,
            onPressed: onOpenFilters,
          ),
        if (sortSummary != null)
          PlnButton(
            label: sortSummary!,
            tone: PlnButtonTone.ghost,
            compact: true,
            onPressed: onOpenSort,
          ),
      ],
    );
  }
}

class _DashViewButton extends StatelessWidget {
  const _DashViewButton({
    required this.view,
    required this.selected,
    required this.grid,
    required this.onPressed,
  });

  final DashViewTab view;
  final bool selected;
  final bool grid;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final body = Container(
      constraints: BoxConstraints(minWidth: grid ? 92 : 0),
      padding: const EdgeInsets.symmetric(
        horizontal: PlnSpace.sm,
        vertical: PlnSpace.sm,
      ),
      decoration: BoxDecoration(
        color: selected ? tokens.selectionBackground : const Color(0x00000000),
        borderRadius: BorderRadius.circular(PlnRadius.control),
      ),
      child: grid
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlnIcon(_iconFor(view.kind), color: tokens.text),
                const SizedBox(height: PlnSpace.xs),
                _label(),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlnIcon(
                  _iconFor(view.kind),
                  size: PlnSize.iconSmall,
                  color: selected
                      ? tokens.selectionForeground
                      : tokens.textMuted,
                ),
                const SizedBox(width: PlnSpace.xs),
                _label(),
              ],
            ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: view.locked ? '${view.label}, locked' : view.label,
      child: PlnPressable(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: body,
      ),
    );
  }

  Widget _label() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlnText(view.label, role: PlnTextRole.body),
        if (view.count != null) ...[
          const SizedBox(width: PlnSpace.xs),
          PlnText('${view.count}', role: PlnTextRole.code),
        ],
        if (view.locked) ...[
          const SizedBox(width: PlnSpace.xs),
          const PlnText('LOCKED', role: PlnTextRole.label),
        ],
      ],
    );
  }

  String _iconFor(DashViewKind kind) {
    return switch (kind) {
      DashViewKind.table => PlnIcons.container,
      DashViewKind.board => PlnIcons.grid,
      DashViewKind.timeline => PlnIcons.switchVertical,
      DashViewKind.calendar => PlnIcons.calendar,
      DashViewKind.list => PlnIcons.clipboard,
      DashViewKind.gallery => PlnIcons.box,
      DashViewKind.chart => PlnIcons.telescope,
      DashViewKind.feed => PlnIcons.inbox,
      DashViewKind.map => PlnIcons.grid,
    };
  }
}
