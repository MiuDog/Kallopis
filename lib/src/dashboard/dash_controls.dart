import 'package:flutter/material.dart';

import '../controls/klp_button.dart';
import '../controls/klp_icon_button.dart';
import '../controls/klp_segmented_control.dart';
import '../controls/klp_toggle.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../interaction/klp_pressable.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

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
      spacing: KlpSpace.sm,
      runSpacing: KlpSpace.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (rangePresets.isNotEmpty)
          KlpSegmentedControl(
            items: [for (final preset in rangePresets) preset.label],
            selected: activeIndex < 0 ? 0 : activeIndex,
            onSelected: (index) => onSelectRange?.call(rangePresets[index].id),
          ),
        if (rangeSummary != null)
          KlpText(
            rangeSummary!,
            role: KlpTextRole.code,
            tone: KlpTextTone.muted,
          ),
        if (comparisonLabel != null)
          KlpToggle(
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
          KlpButton(
            label: 'Add filter',
            tone: KlpButtonTone.ghost,
            compact: true,
            onPressed: onAddFilter,
          ),
        if (onClearAll != null && filters.any((filter) => !filter.locked))
          KlpButton(
            label: 'Clear all',
            tone: KlpButtonTone.ghost,
            compact: true,
            onPressed: onClearAll,
          ),
        if (breakdownLabel != null)
          KlpText(
            breakdownLabel!,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
        if (updatedLabel != null)
          KlpText(
            updatedLabel!,
            role: KlpTextRole.caption,
            tone: KlpTextTone.faint,
          ),
        if (onRefresh != null)
          KlpIconButton(
            icon: KlpIcons.switchVertical,
            label: refreshing ? 'Refreshing' : 'Refresh',
            onPressed: refreshing ? null : onRefresh,
          ),
        if (onExport != null)
          KlpIconButton(
            icon: KlpIcons.archive,
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
        left: KlpSpace.sm,
        top: KlpSpace.xs,
        bottom: KlpSpace.xs,
        right: KlpSpace.xs,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceInset,
        borderRadius: BorderRadius.circular(KlpRadius.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(
            '${filter.label} ${filter.valueLabel}',
            role: KlpTextRole.caption,
          ),
          const SizedBox(width: KlpSpace.xs),
          if (onRemove == null)
            KlpText(
              filter.locked ? 'LOCKED' : '',
              role: KlpTextRole.label,
              tone: KlpTextTone.faint,
            )
          else
            Semantics(
              button: true,
              label: 'Remove ${filter.label} filter',
              child: InkWell(
                key: ValueKey('dashboard-filter-remove-${filter.id}'),
                onTap: onRemove,
                borderRadius: BorderRadius.circular(KlpRadius.full),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: KlpSpace.xs),
                  child: KlpText('×', role: KlpTextRole.bodyStrong),
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
      spacing: KlpSpace.xs,
      runSpacing: KlpSpace.xs,
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
          KlpButton(
            label: 'Add view',
            tone: KlpButtonTone.ghost,
            compact: true,
            onPressed: onAddView,
          ),
        if (filterSummary != null)
          KlpButton(
            label: filterSummary!,
            tone: KlpButtonTone.ghost,
            compact: true,
            onPressed: onOpenFilters,
          ),
        if (sortSummary != null)
          KlpButton(
            label: sortSummary!,
            tone: KlpButtonTone.ghost,
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
        horizontal: KlpSpace.sm,
        vertical: KlpSpace.sm,
      ),
      decoration: BoxDecoration(
        color: selected ? tokens.selectionBackground : const Color(0x00000000),
        borderRadius: BorderRadius.circular(KlpRadius.control),
      ),
      child: grid
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                KlpIcon(_iconFor(view.kind), color: tokens.text),
                const SizedBox(height: KlpSpace.xs),
                _label(),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                KlpIcon(
                  _iconFor(view.kind),
                  size: KlpSize.iconSmall,
                  color: selected
                      ? tokens.selectionForeground
                      : tokens.textMuted,
                ),
                const SizedBox(width: KlpSpace.xs),
                _label(),
              ],
            ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: view.locked ? '${view.label}, locked' : view.label,
      child: KlpPressable(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(KlpRadius.control),
        child: body,
      ),
    );
  }

  Widget _label() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KlpText(view.label, role: KlpTextRole.body),
        if (view.count != null) ...[
          const SizedBox(width: KlpSpace.xs),
          KlpText('${view.count}', role: KlpTextRole.code),
        ],
        if (view.locked) ...[
          const SizedBox(width: KlpSpace.xs),
          const KlpText('LOCKED', role: KlpTextRole.label),
        ],
      ],
    );
  }

  String _iconFor(DashViewKind kind) {
    return switch (kind) {
      DashViewKind.table => KlpIcons.container,
      DashViewKind.board => KlpIcons.grid,
      DashViewKind.timeline => KlpIcons.switchVertical,
      DashViewKind.calendar => KlpIcons.calendar,
      DashViewKind.list => KlpIcons.clipboard,
      DashViewKind.gallery => KlpIcons.box,
      DashViewKind.chart => KlpIcons.telescope,
      DashViewKind.feed => KlpIcons.inbox,
      DashViewKind.map => KlpIcons.grid,
    };
  }
}
