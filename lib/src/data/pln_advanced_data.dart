import 'package:flutter/widgets.dart';

import '../controls/pln_checkbox.dart';
import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_dashed_border.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

@immutable
class PlnDataColumn {
  const PlnDataColumn({
    required this.id,
    required this.label,
    this.width,
    this.sortable = false,
    this.alignment = PlnDataAlignment.start,
    this.verbatim = false,
  });

  final String id;
  final String label;
  final double? width;
  final bool sortable;
  final PlnDataAlignment alignment;
  final bool verbatim;
}

enum PlnDataAlignment { start, end }

enum PlnSortDirection { ascending, descending }

@immutable
class PlnDataSort {
  const PlnDataSort({required this.columnId, required this.direction});

  final String columnId;
  final PlnSortDirection direction;
}

@immutable
class PlnDataRow {
  const PlnDataRow({required this.id, required this.cells});

  final String id;
  final Map<String, Object> cells;
}

class PlnDataTable extends StatelessWidget {
  const PlnDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowPressed,
    this.selectable = false,
    this.selectedIds = const {},
    this.sort,
    this.onSelected,
    this.onSort,
  });

  final List<PlnDataColumn> columns;
  final List<PlnDataRow> rows;
  final ValueChanged<String>? onRowPressed;
  final bool selectable;
  final Set<String> selectedIds;
  final PlnDataSort? sort;
  final ValueChanged<Set<String>>? onSelected;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(PlnRadius.card),
      child: PlnSurface(
        tone: PlnSurfaceTone.component,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PlnTableLine(
              columns: columns,
              values: {for (final column in columns) column.id: column.label},
              header: true,
              selectable: selectable,
              selected: rows.isNotEmpty && selectedIds.length == rows.length,
              sort: sort,
              onSelectionChanged: onSelected == null
                  ? null
                  : (_) => onSelected!(
                      selectedIds.length == rows.length
                          ? <String>{}
                          : {for (final row in rows) row.id},
                    ),
              onSort: onSort,
            ),
            if (rows.isNotEmpty) const PlnDashedDivider(),
            for (var index = 0; index < rows.length; index++) ...[
              _PlnTableLine(
                columns: columns,
                values: rows[index].cells,
                rowId: rows[index].id,
                selectable: selectable,
                selected: selectedIds.contains(rows[index].id),
                onPressed: onRowPressed == null
                    ? null
                    : () => onRowPressed!(rows[index].id),
                onSelectionChanged: onSelected == null
                    ? null
                    : (selected) {
                        final next = {...selectedIds};
                        selected
                            ? next.add(rows[index].id)
                            : next.remove(rows[index].id);
                        onSelected!(next);
                      },
              ),
              if (index < rows.length - 1) const PlnDashedDivider(),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlnTableLine extends StatelessWidget {
  const _PlnTableLine({
    required this.columns,
    required this.values,
    this.header = false,
    this.rowId,
    this.selectable = false,
    this.selected = false,
    this.sort,
    this.onPressed,
    this.onSelectionChanged,
    this.onSort,
  });

  final List<PlnDataColumn> columns;
  final Map<String, Object?> values;
  final bool header;
  final String? rowId;
  final bool selectable;
  final bool selected;
  final PlnDataSort? sort;
  final VoidCallback? onPressed;
  final ValueChanged<bool>? onSelectionChanged;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: PlnSize.controlLarge),
        decoration: BoxDecoration(
          color: header || selected ? context.plnTheme.surfaceMuted : null,
        ),
        child: Row(
          children: [
            if (selectable)
              SizedBox(
                width: PlnSize.controlLarge,
                child: Center(
                  child: KeyedSubtree(
                    key: rowId == null
                        ? const ValueKey('pln-table-select-all')
                        : ValueKey('pln-table-select-$rowId'),
                    child: PlnCheckbox(
                      value: selected,
                      label: rowId == null ? 'Select all rows' : 'Select row',
                      showLabel: false,
                      onChanged: onSelectionChanged,
                    ),
                  ),
                ),
              ),
            for (final column in columns)
              Expanded(
                flex: column.width == null ? 1 : column.width!.round(),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: header && column.sortable && onSort != null
                      ? () => onSort!(column.id)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PlnSpace.md,
                      vertical: PlnSpace.sm,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          column.alignment == PlnDataAlignment.end
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: values[column.id] is Widget
                              ? values[column.id]! as Widget
                              : PlnText(
                                  '${values[column.id] ?? ''}',
                                  role: header || column.verbatim
                                      ? PlnTextRole.code
                                      : PlnTextRole.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                        if (header && column.sortable) ...[
                          const SizedBox(width: PlnSpace.xs),
                          RotatedBox(
                            quarterTurns:
                                sort?.columnId == column.id &&
                                    sort?.direction ==
                                        PlnSortDirection.descending
                                ? 2
                                : 0,
                            child: PlnIcon(
                              PlnIcons.chevronDown,
                              size: PlnSize.iconSmall,
                              color: sort?.columnId == column.id
                                  ? context.plnTheme.text
                                  : context.plnTheme.textFaint,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

@immutable
class PlnTreeNode {
  const PlnTreeNode({
    required this.id,
    required this.label,
    this.icon,
    this.children = const [],
    this.expanded = true,
    this.selected = false,
    this.hasChildren = false,
    this.deleted = false,
    this.badge,
  });

  final String id;
  final String label;
  final String? icon;
  final List<PlnTreeNode> children;
  final bool expanded;
  final bool selected;
  final bool hasChildren;
  final bool deleted;
  final String? badge;
}

class PlnTree extends StatelessWidget {
  const PlnTree({
    super.key,
    required this.nodes,
    this.label,
    this.expandedIds,
    this.selectedId,
    this.onSelected,
    this.onExpanded,
  });

  final List<PlnTreeNode> nodes;
  final String? label;
  final Set<String>? expandedIds;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final ValueChanged<String>? onExpanded;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final node in nodes)
            _PlnTreeNodeView(
              node: node,
              expandedIds: expandedIds,
              selectedId: selectedId,
              onSelected: onSelected,
              onExpanded: onExpanded,
            ),
        ],
      ),
    );
  }
}

class PlnTreeItem extends StatelessWidget {
  const PlnTreeItem({super.key, required this.node, this.onSelected});

  final PlnTreeNode node;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return _PlnTreeNodeView(node: node, onSelected: onSelected);
  }
}

class _PlnTreeNodeView extends StatelessWidget {
  const _PlnTreeNodeView({
    required this.node,
    required this.onSelected,
    this.expandedIds,
    this.selectedId,
    this.onExpanded,
  });

  final PlnTreeNode node;
  final Set<String>? expandedIds;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final ValueChanged<String>? onExpanded;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final selected = selectedId == null ? node.selected : selectedId == node.id;
    final expanded = expandedIds == null
        ? node.expanded
        : expandedIds!.contains(node.id);
    final expandable = node.hasChildren || node.children.isNotEmpty;
    final row = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelected == null ? null : () => onSelected!(node.id),
      child: Container(
        constraints: const BoxConstraints(minHeight: PlnSize.control),
        padding: const EdgeInsets.symmetric(horizontal: PlnSpace.sm),
        decoration: BoxDecoration(
          color: selected ? tokens.surfaceMuted : null,
          borderRadius: BorderRadius.circular(PlnRadius.control),
        ),
        child: Row(
          children: [
            if (expandable) ...[
              GestureDetector(
                key: ValueKey('pln-tree-expand-${node.id}'),
                behavior: HitTestBehavior.opaque,
                onTap: onExpanded == null ? null : () => onExpanded!(node.id),
                child: SizedBox.square(
                  dimension: PlnSize.icon,
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: expanded ? 0 : 3,
                      child: PlnIcon(
                        PlnIcons.chevronDown,
                        size: PlnSize.iconSmall,
                        color: tokens.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: PlnSpace.xs),
            ] else
              const SizedBox(width: PlnSize.icon + PlnSpace.xs),
            if (node.icon != null) ...[
              PlnIcon(
                node.icon!,
                size: PlnSize.iconSmall,
                color: selected ? tokens.selectionForeground : tokens.textMuted,
              ),
              const SizedBox(width: PlnSpace.sm),
            ],
            Expanded(
              child: PlnText(
                node.label,
                color: node.deleted
                    ? tokens.textFaint
                    : selected
                    ? tokens.selectionForeground
                    : tokens.textMuted,
                decoration: node.deleted ? TextDecoration.lineThrough : null,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                ellipsisText: '...',
              ),
            ),
            if (node.badge != null) ...[
              const SizedBox(width: PlnSpace.sm),
              PlnText(
                node.badge!,
                role: PlnTextRole.code,
                tone: PlnTextTone.faint,
              ),
            ],
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(left: PlnSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          row,
          if (expanded)
            for (final child in node.children)
              _PlnTreeNodeView(
                node: child,
                expandedIds: expandedIds,
                selectedId: selectedId,
                onSelected: onSelected,
                onExpanded: onExpanded,
              ),
        ],
      ),
    );
  }
}

@immutable
class PlnTimelineEntry {
  const PlnTimelineEntry({
    required this.id,
    required this.title,
    required this.metadata,
    this.description,
    this.tone,
    this.actor,
    this.status = PlnTimelineStatus.idle,
    this.superseded = false,
    this.redacted = false,
  });

  final String id;
  final String title;
  final String metadata;
  final String? description;
  final Color? tone;
  final String? actor;
  final PlnTimelineStatus status;
  final bool superseded;
  final bool redacted;
}

enum PlnTimelineStatus { success, failure, warning, info, idle }

@immutable
class PlnTimelineGroup {
  const PlnTimelineGroup({
    required this.id,
    required this.label,
    required this.entries,
  });

  final String id;
  final String label;
  final List<PlnTimelineEntry> entries;
}

class PlnTimeline extends StatelessWidget {
  const PlnTimeline({
    super.key,
    this.entries = const [],
    this.groups = const [],
    this.selectedId,
    this.hasMore = false,
    this.onSelected,
    this.onLoadMore,
  });

  final List<PlnTimelineEntry> entries;
  final List<PlnTimelineGroup> groups;
  final String? selectedId;
  final bool hasMore;
  final ValueChanged<String>? onSelected;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    final effectiveGroups = groups.isEmpty
        ? [PlnTimelineGroup(id: 'default', label: '', entries: entries)]
        : groups;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in effectiveGroups) ...[
          if (group.label.isNotEmpty) ...[
            PlnText(
              group.label,
              role: PlnTextRole.label,
              tone: PlnTextTone.muted,
            ),
            const SizedBox(height: PlnSpace.sm),
          ],
          for (var index = 0; index < group.entries.length; index++)
            _PlnTimelineRow(
              entry: group.entries[index],
              last: index == group.entries.length - 1,
              selected: selectedId == group.entries[index].id,
              onPressed: onSelected == null
                  ? null
                  : () => onSelected!(group.entries[index].id),
            ),
          if (group != effectiveGroups.last)
            const SizedBox(height: PlnSpace.lg),
        ],
        if (hasMore && onLoadMore != null)
          Align(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onLoadMore,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: PlnSpace.md,
                  vertical: PlnSpace.xs,
                ),
                decoration: BoxDecoration(
                  color: context.plnTheme.component,
                  borderRadius: BorderRadius.circular(PlnRadius.control),
                ),
                child: const PlnText(
                  'Load more',
                  role: PlnTextRole.caption,
                  tone: PlnTextTone.muted,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PlnTimelineRow extends StatelessWidget {
  const _PlnTimelineRow({
    required this.entry,
    required this.last,
    required this.selected,
    required this.onPressed,
  });

  final PlnTimelineEntry entry;
  final bool last;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final color =
        entry.tone ??
        switch (entry.status) {
          PlnTimelineStatus.success => tokens.success,
          PlnTimelineStatus.failure => tokens.danger,
          PlnTimelineStatus.warning => tokens.warning,
          PlnTimelineStatus.info => tokens.info,
          PlnTimelineStatus.idle => tokens.textFaint,
        };

    return Opacity(
      opacity: entry.superseded ? 0.55 : 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: PlnSpace.xl,
                child: Column(
                  children: [
                    const SizedBox(height: PlnSpace.xs),
                    Container(
                      width: PlnSpace.sm,
                      height: PlnSpace.sm,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(PlnRadius.sm),
                      ),
                    ),
                    if (!last)
                      Expanded(
                        child: Container(
                          width: PlnLine.hairline,
                          color: context.plnTheme.guide,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: PlnSpace.sm),
                  padding: const EdgeInsets.symmetric(
                    horizontal: PlnSpace.sm,
                    vertical: PlnSpace.xs,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? tokens.surfaceMuted : null,
                    borderRadius: BorderRadius.circular(PlnRadius.sm),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: PlnText(
                              entry.title,
                              role: PlnTextRole.bodyStrong,
                            ),
                          ),
                          PlnText(
                            entry.metadata,
                            role: PlnTextRole.code,
                            tone: PlnTextTone.faint,
                          ),
                        ],
                      ),
                      if (entry.description != null) ...[
                        const SizedBox(height: PlnSpace.xs),
                        PlnText(
                          entry.description!,
                          role: PlnTextRole.caption,
                          tone: PlnTextTone.muted,
                        ),
                      ],
                      if (entry.actor != null)
                        PlnText(
                          'by ${entry.actor}',
                          role: PlnTextRole.caption,
                          tone: PlnTextTone.muted,
                        ),
                      if (entry.superseded || entry.redacted)
                        PlnText(
                          entry.superseded ? 'superseded' : 'redacted',
                          role: PlnTextRole.caption,
                          tone: PlnTextTone.faint,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlnJsonTree extends StatelessWidget {
  const PlnJsonTree({
    super.key,
    required this.value,
    this.defaultDepth = 1,
    this.expandedPaths = const {},
    this.loading = false,
    this.invalid = false,
    this.onCopyPath,
  });

  final Object? value;
  final int defaultDepth;
  final Set<String> expandedPaths;
  final bool loading;
  final bool invalid;
  final ValueChanged<String>? onCopyPath;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: const EdgeInsets.all(PlnSpace.md),
      child: loading
          ? const PlnText(
              'Loading...',
              role: PlnTextRole.code,
              tone: PlnTextTone.muted,
            )
          : invalid
          ? const PlnText(
              'Invalid structured data',
              role: PlnTextRole.code,
              tone: PlnTextTone.danger,
            )
          : _PlnJsonNode(
              value: value,
              path: r'$',
              depth: 0,
              defaultDepth: defaultDepth,
              expandedPaths: expandedPaths,
              onCopyPath: onCopyPath,
            ),
    );
  }
}

class _PlnJsonNode extends StatefulWidget {
  const _PlnJsonNode({
    required this.value,
    required this.path,
    required this.depth,
    required this.defaultDepth,
    required this.expandedPaths,
    required this.onCopyPath,
    this.name,
  });

  final Object? value;
  final String? name;
  final String path;
  final int depth;
  final int defaultDepth;
  final Set<String> expandedPaths;
  final ValueChanged<String>? onCopyPath;

  @override
  State<_PlnJsonNode> createState() => _PlnJsonNodeState();
}

class _PlnJsonNodeState extends State<_PlnJsonNode> {
  late bool _expanded;

  bool get _structured => widget.value is Map || widget.value is Iterable;

  @override
  void initState() {
    super.initState();
    _expanded =
        widget.expandedPaths.contains(widget.path) ||
        widget.depth < widget.defaultDepth;
  }

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    if (!_structured) return _buildScalar(context);

    final entries = widget.value is Map
        ? (widget.value as Map).entries
              .map((entry) => MapEntry('${entry.key}', entry.value))
              .toList()
        : (widget.value as Iterable)
              .toList()
              .asMap()
              .entries
              .map((entry) => MapEntry('${entry.key}', entry.value))
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          key: ValueKey('pln-json-toggle-${widget.path}'),
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: Padding(
            padding: EdgeInsets.only(left: widget.depth * PlnSpace.md),
            child: Row(
              children: [
                RotatedBox(
                  quarterTurns: _expanded ? 0 : 3,
                  child: PlnIcon(
                    PlnIcons.chevronDown,
                    size: PlnSize.iconSmall,
                    color: context.plnTheme.textMuted,
                  ),
                ),
                const SizedBox(width: PlnSpace.xs),
                if (widget.name != null)
                  PlnText('${widget.name}:', role: PlnTextRole.code),
                if (widget.name != null) const SizedBox(width: PlnSpace.xs),
                PlnText(
                  widget.value is Map
                      ? '{${entries.length}}'
                      : '[${entries.length}]',
                  role: PlnTextRole.code,
                  tone: PlnTextTone.muted,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          for (final entry in entries)
            _PlnJsonNode(
              value: entry.value,
              name: entry.key,
              path: '${widget.path}.${entry.key}',
              depth: widget.depth + 1,
              defaultDepth: widget.defaultDepth,
              expandedPaths: widget.expandedPaths,
              onCopyPath: widget.onCopyPath,
            ),
      ],
    );
  }

  Widget _buildScalar(BuildContext context) {
    final value = switch (widget.value) {
      String value => '"$value"',
      null => 'null',
      _ => '${widget.value}',
    };

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onCopyPath == null
          ? null
          : () => widget.onCopyPath!(widget.path),
      child: Padding(
        padding: EdgeInsets.only(left: widget.depth * PlnSpace.md),
        child: Row(
          children: [
            const SizedBox(width: PlnSize.icon + PlnSpace.xs),
            if (widget.name != null) ...[
              PlnText(widget.name!, role: PlnTextRole.code),
              const PlnText(':', role: PlnTextRole.code),
              const SizedBox(width: PlnSpace.xs),
            ],
            PlnText(value, role: PlnTextRole.code, tone: PlnTextTone.muted),
          ],
        ),
      ),
    );
  }
}

enum PlnMetricTrend { up, down, flat }

class PlnMetric extends StatelessWidget {
  const PlnMetric({
    super.key,
    required this.label,
    required this.value,
    this.detail,
    this.unit,
    this.threshold,
    this.breached = false,
    this.trend,
    this.loading = false,
    this.noData = false,
    this.onOpenEvidence,
  });

  final String label;
  final String value;
  final String? detail;
  final String? unit;
  final String? threshold;
  final bool breached;
  final PlnMetricTrend? trend;
  final bool loading;
  final bool noData;
  final VoidCallback? onOpenEvidence;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final trendLabel = switch (trend) {
      PlnMetricTrend.up => '↑',
      PlnMetricTrend.down => '↓',
      PlnMetricTrend.flat => '→',
      null => null,
    };

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpenEvidence,
      child: Container(
        padding: const EdgeInsets.all(PlnSpace.md),
        decoration: BoxDecoration(
          color: breached
              ? tokens.danger.withValues(alpha: 0.16)
              : tokens.component,
          borderRadius: BorderRadius.circular(PlnRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlnText(label, role: PlnTextRole.label, tone: PlnTextTone.muted),
            const SizedBox(height: PlnSpace.sm),
            if (loading)
              Container(
                width: 64,
                height: PlnSpace.xl,
                decoration: BoxDecoration(
                  color: tokens.surfaceMuted,
                  borderRadius: BorderRadius.circular(PlnRadius.sm),
                ),
              )
            else if (noData)
              const PlnText('No data', tone: PlnTextTone.faint)
            else
              // 數值不截斷、也不溢出：擠不下時整列等比縮小。
              // 「1,284,5…」比小一號的完整數字更難讀，而溢出的條紋更糟。
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PlnText(
                      value,
                      role: PlnTextRole.title,
                      color: breached ? tokens.danger : tokens.text,
                    ),
                    if (unit != null) ...[
                      const SizedBox(width: PlnSpace.xs),
                      PlnText(unit!, role: PlnTextRole.caption),
                    ],
                    if (trendLabel != null) ...[
                      const SizedBox(width: PlnSpace.xs),
                      PlnText(
                        trendLabel,
                        role: PlnTextRole.caption,
                        tone: PlnTextTone.muted,
                      ),
                    ],
                  ],
                ),
              ),
            if (threshold != null || detail != null) ...[
              const SizedBox(height: PlnSpace.xs),
              PlnText(
                threshold == null
                    ? detail!
                    : '${breached ? 'Breached · threshold' : 'Threshold'} $threshold',
                role: PlnTextRole.caption,
                color: breached ? tokens.danger : tokens.textMuted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum PlnFilePreviewState { ready, loading, error, unsupported }

class PlnFilePreview extends StatelessWidget {
  const PlnFilePreview({
    super.key,
    required this.name,
    required this.metadata,
    this.icon = PlnIcons.box,
    this.preview,
    this.onPressed,
    this.state = PlnFilePreviewState.ready,
    this.height = 220,
    this.textContent,
    this.onOpenExternal,
    this.onDownload,
  });

  final String name;
  final String metadata;
  final String icon;
  final Widget? preview;
  final VoidCallback? onPressed;
  final PlnFilePreviewState state;
  final double height;
  final String? textContent;
  final VoidCallback? onOpenExternal;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final extension = name.contains('.')
        ? name.split('.').last.toUpperCase()
        : 'FILE';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: tokens.component,
          borderRadius: BorderRadius.circular(PlnRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PlnSpace.md,
                vertical: PlnSpace.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PlnText(
                      name,
                      role: PlnTextRole.code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PlnText(
                    metadata,
                    role: PlnTextRole.caption,
                    tone: PlnTextTone.muted,
                  ),
                ],
              ),
            ),
            const PlnDashedDivider(),
            SizedBox(
              height: height,
              child: ColoredBox(
                color: tokens.surfaceMuted,
                child: Center(child: _previewBody(context, extension)),
              ),
            ),
            if (onOpenExternal != null || onDownload != null) ...[
              const PlnDashedDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PlnSpace.md,
                  vertical: PlnSpace.xs,
                ),
                child: Row(
                  children: [
                    if (onOpenExternal != null)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onOpenExternal,
                        child: const PlnText(
                          'Open externally',
                          role: PlnTextRole.caption,
                          tone: PlnTextTone.muted,
                        ),
                      ),
                    if (onOpenExternal != null && onDownload != null)
                      const SizedBox(width: PlnSpace.lg),
                    if (onDownload != null)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onDownload,
                        child: const PlnText(
                          'Download',
                          role: PlnTextRole.caption,
                          tone: PlnTextTone.muted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _previewBody(BuildContext context, String extension) {
    return switch (state) {
      PlnFilePreviewState.loading => const PlnText(
        'Loading preview...',
        role: PlnTextRole.caption,
        tone: PlnTextTone.muted,
      ),
      PlnFilePreviewState.error => const PlnText(
        'Preview failed to load',
        role: PlnTextRole.caption,
        tone: PlnTextTone.danger,
      ),
      PlnFilePreviewState.unsupported => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlnText(extension, role: PlnTextRole.title),
          const SizedBox(height: PlnSpace.xs),
          const PlnText(
            'No preview available for this type',
            role: PlnTextRole.caption,
            tone: PlnTextTone.muted,
          ),
        ],
      ),
      PlnFilePreviewState.ready =>
        preview ??
            (textContent == null
                ? const PlnText(
                    'No preview content',
                    role: PlnTextRole.caption,
                    tone: PlnTextTone.muted,
                  )
                : Padding(
                    padding: const EdgeInsets.all(PlnSpace.md),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: PlnText(textContent!, role: PlnTextRole.code),
                    ),
                  )),
    };
  }
}
