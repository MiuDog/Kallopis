import 'package:flutter/widgets.dart';

import '../controls/klp_checkbox.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../surface/klp_dashed_border.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

@immutable
class KlpDataColumn {
  const KlpDataColumn({
    required this.id,
    required this.label,
    this.width,
    this.sortable = false,
    this.alignment = KlpDataAlignment.start,
    this.verbatim = false,
  });

  final String id;
  final String label;
  final double? width;
  final bool sortable;
  final KlpDataAlignment alignment;
  final bool verbatim;
}

enum KlpDataAlignment { start, end }

enum KlpSortDirection { ascending, descending }

@immutable
class KlpDataSort {
  const KlpDataSort({required this.columnId, required this.direction});

  final String columnId;
  final KlpSortDirection direction;
}

@immutable
class KlpDataRow {
  const KlpDataRow({required this.id, required this.cells});

  final String id;
  final Map<String, Object> cells;
}

class KlpDataTable extends StatelessWidget {
  const KlpDataTable({
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

  final List<KlpDataColumn> columns;
  final List<KlpDataRow> rows;
  final ValueChanged<String>? onRowPressed;
  final bool selectable;
  final Set<String> selectedIds;
  final KlpDataSort? sort;
  final ValueChanged<Set<String>>? onSelected;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.klp.shape.card),
      child: KlpSurface(
        tone: KlpSurfaceTone.component,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _KlpTableLine(
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
            if (rows.isNotEmpty) const KlpDashedDivider(),
            for (var index = 0; index < rows.length; index++) ...[
              _KlpTableLine(
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
              if (index < rows.length - 1) const KlpDashedDivider(),
            ],
          ],
        ),
      ),
    );
  }
}

class _KlpTableLine extends StatelessWidget {
  const _KlpTableLine({
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

  final List<KlpDataColumn> columns;
  final Map<String, Object?> values;
  final bool header;
  final String? rowId;
  final bool selectable;
  final bool selected;
  final KlpDataSort? sort;
  final VoidCallback? onPressed;
  final ValueChanged<bool>? onSelectionChanged;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(
          minHeight: context.klp.space.controlHeightLarge,
        ),
        decoration: BoxDecoration(
          color: header || selected ? context.klpColors.surfaceMuted : null,
        ),
        child: Row(
          children: [
            if (selectable)
              SizedBox(
                width: context.klp.space.controlHeightLarge,
                child: Center(
                  child: KeyedSubtree(
                    key: rowId == null
                        ? const ValueKey('pln-table-select-all')
                        : ValueKey('pln-table-select-$rowId'),
                    child: KlpCheckbox(
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
                    padding: EdgeInsets.symmetric(
                      horizontal: context.klp.space.base,
                      vertical: context.klp.space.compact,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          column.alignment == KlpDataAlignment.end
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: values[column.id] is Widget
                              ? values[column.id]! as Widget
                              : KlpText(
                                  '${values[column.id] ?? ''}',
                                  role: header || column.verbatim
                                      ? KlpTextRole.code
                                      : KlpTextRole.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                        if (header && column.sortable) ...[
                          SizedBox(width: context.klp.space.tight),
                          RotatedBox(
                            quarterTurns:
                                sort?.columnId == column.id &&
                                    sort?.direction ==
                                        KlpSortDirection.descending
                                ? 2
                                : 0,
                            child: KlpIcon(
                              KlpIcons.chevronDown,
                              size: context.klp.space.iconSmall,
                              color: sort?.columnId == column.id
                                  ? context.klpColors.text
                                  : context.klpColors.textFaint,
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
class KlpTreeNode {
  const KlpTreeNode({
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
  final List<KlpTreeNode> children;
  final bool expanded;
  final bool selected;
  final bool hasChildren;
  final bool deleted;
  final String? badge;
}

class KlpTree extends StatelessWidget {
  const KlpTree({
    super.key,
    required this.nodes,
    this.label,
    this.expandedIds,
    this.selectedId,
    this.onSelected,
    this.onExpanded,
  });

  final List<KlpTreeNode> nodes;
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
            _KlpTreeNodeView(
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

class KlpTreeItem extends StatelessWidget {
  const KlpTreeItem({super.key, required this.node, this.onSelected});

  final KlpTreeNode node;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return _KlpTreeNodeView(node: node, onSelected: onSelected);
  }
}

class _KlpTreeNodeView extends StatelessWidget {
  const _KlpTreeNodeView({
    required this.node,
    required this.onSelected,
    this.expandedIds,
    this.selectedId,
    this.onExpanded,
  });

  final KlpTreeNode node;
  final Set<String>? expandedIds;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final ValueChanged<String>? onExpanded;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final selected = selectedId == null ? node.selected : selectedId == node.id;
    final expanded = expandedIds == null
        ? node.expanded
        : expandedIds!.contains(node.id);
    final expandable = node.hasChildren || node.children.isNotEmpty;
    final row = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelected == null ? null : () => onSelected!(node.id),
      child: Container(
        constraints: BoxConstraints(minHeight: context.klp.space.controlHeight),
        padding: EdgeInsets.symmetric(horizontal: context.klp.space.compact),
        decoration: BoxDecoration(
          color: selected ? tokens.surfaceMuted : null,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
        ),
        child: Row(
          children: [
            if (expandable) ...[
              GestureDetector(
                key: ValueKey('pln-tree-expand-${node.id}'),
                behavior: HitTestBehavior.opaque,
                onTap: onExpanded == null ? null : () => onExpanded!(node.id),
                child: SizedBox.square(
                  dimension: context.klp.space.icon,
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: expanded ? 0 : 3,
                      child: KlpIcon(
                        KlpIcons.chevronDown,
                        size: context.klp.space.iconSmall,
                        color: tokens.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.klp.space.tight),
            ] else
              SizedBox(width: context.klp.space.icon + context.klp.space.tight),
            if (node.icon != null) ...[
              KlpIcon(
                node.icon!,
                size: context.klp.space.iconSmall,
                color: selected ? tokens.selectionForeground : tokens.textMuted,
              ),
              SizedBox(width: context.klp.space.compact),
            ],
            Expanded(
              child: KlpText(
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
              SizedBox(width: context.klp.space.compact),
              KlpText(
                node.badge!,
                role: KlpTextRole.code,
                tone: KlpTextTone.faint,
              ),
            ],
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(left: context.klp.space.compact),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          row,
          if (expanded)
            for (final child in node.children)
              _KlpTreeNodeView(
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
class KlpJsonTree extends StatelessWidget {
  const KlpJsonTree({
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
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: EdgeInsets.all(context.klp.space.base),
      child: loading
          ? const KlpText(
              'Loading...',
              role: KlpTextRole.code,
              tone: KlpTextTone.muted,
            )
          : invalid
          ? const KlpText(
              'Invalid structured data',
              role: KlpTextRole.code,
              tone: KlpTextTone.danger,
            )
          : _KlpJsonNode(
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

class _KlpJsonNode extends StatefulWidget {
  const _KlpJsonNode({
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
  State<_KlpJsonNode> createState() => _KlpJsonNodeState();
}

class _KlpJsonNodeState extends State<_KlpJsonNode> {
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
            padding: EdgeInsets.only(
              left: widget.depth * context.klp.space.base,
            ),
            child: Row(
              children: [
                RotatedBox(
                  quarterTurns: _expanded ? 0 : 3,
                  child: KlpIcon(
                    KlpIcons.chevronDown,
                    size: context.klp.space.iconSmall,
                    color: context.klpColors.textMuted,
                  ),
                ),
                SizedBox(width: context.klp.space.tight),
                if (widget.name != null)
                  KlpText('${widget.name}:', role: KlpTextRole.code),
                if (widget.name != null)
                  SizedBox(width: context.klp.space.tight),
                KlpText(
                  widget.value is Map
                      ? '{${entries.length}}'
                      : '[${entries.length}]',
                  role: KlpTextRole.code,
                  tone: KlpTextTone.muted,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          for (final entry in entries)
            _KlpJsonNode(
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
        padding: EdgeInsets.only(left: widget.depth * context.klp.space.base),
        child: Row(
          children: [
            SizedBox(width: context.klp.space.icon + context.klp.space.tight),
            if (widget.name != null) ...[
              KlpText(widget.name!, role: KlpTextRole.code),
              const KlpText(':', role: KlpTextRole.code),
              SizedBox(width: context.klp.space.tight),
            ],
            KlpText(value, role: KlpTextRole.code, tone: KlpTextTone.muted),
          ],
        ),
      ),
    );
  }
}

enum KlpFilePreviewState { ready, loading, error, unsupported }

class KlpFilePreview extends StatelessWidget {
  const KlpFilePreview({
    super.key,
    required this.name,
    required this.metadata,
    this.icon = KlpIcons.box,
    this.preview,
    this.onPressed,
    this.state = KlpFilePreviewState.ready,
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
  final KlpFilePreviewState state;
  final double height;
  final String? textContent;
  final VoidCallback? onOpenExternal;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
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
          borderRadius: BorderRadius.circular(context.klp.shape.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.klp.space.base,
                vertical: context.klp.space.compact,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: KlpText(
                      name,
                      role: KlpTextRole.code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  KlpText(
                    metadata,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ],
              ),
            ),
            const KlpDashedDivider(),
            SizedBox(
              height: height,
              child: ColoredBox(
                color: tokens.surfaceMuted,
                child: Center(child: _previewBody(context, extension)),
              ),
            ),
            if (onOpenExternal != null || onDownload != null) ...[
              const KlpDashedDivider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.klp.space.base,
                  vertical: context.klp.space.tight,
                ),
                child: Row(
                  children: [
                    if (onOpenExternal != null)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onOpenExternal,
                        child: const KlpText(
                          'Open externally',
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                        ),
                      ),
                    if (onOpenExternal != null && onDownload != null)
                      SizedBox(width: context.klp.space.comfortable),
                    if (onDownload != null)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onDownload,
                        child: const KlpText(
                          'Download',
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
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
      KlpFilePreviewState.loading => const KlpText(
        'Loading preview...',
        role: KlpTextRole.caption,
        tone: KlpTextTone.muted,
      ),
      KlpFilePreviewState.error => const KlpText(
        'Preview failed to load',
        role: KlpTextRole.caption,
        tone: KlpTextTone.danger,
      ),
      KlpFilePreviewState.unsupported => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(extension, role: KlpTextRole.title),
          SizedBox(height: context.klp.space.tight),
          const KlpText(
            'No preview available for this type',
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
        ],
      ),
      KlpFilePreviewState.ready =>
        preview ??
            (textContent == null
                ? const KlpText(
                    'No preview content',
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  )
                : Padding(
                    padding: EdgeInsets.all(context.klp.space.base),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: KlpText(textContent!, role: KlpTextRole.code),
                    ),
                  )),
    };
  }
}
