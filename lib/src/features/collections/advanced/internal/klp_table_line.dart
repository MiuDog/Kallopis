part of '../klp_advanced_data.dart';

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
    final style = _KlpAdvancedStyle.from(context);
    final labels = KlpLocalizations.of(context);
    final children = <Widget>[];

    if (selectable) {
      children.add(
        _KlpTableSelectionSlot(
          style: style,
          rowId: rowId,
          selected: selected,
          onChanged: onSelectionChanged,
          labels: labels,
        ),
      );
    }
    for (final column in columns) {
      children.add(_buildCell(style, column));
    }

    return _KlpTableLineFrame(
      style: style,
      header: header,
      selected: selected,
      onPressed: onPressed,
      child: KlpRow(children: children),
    );
  }

  Widget _buildCell(_KlpAdvancedStyle style, KlpDataColumn column) {
    final cellChildren = <Widget>[KlpFlexible(child: _buildValue(column))];

    if (header && column.sortable) {
      final isCurrent = sort?.columnId == column.id;
      cellChildren.add(const KlpGap.tight());
      cellChildren.add(
        _KlpTableSortIndicator(
          descending:
              isCurrent && sort?.direction == KlpSortDirection.descending,
          child: KlpIcon(
            KlpIcons.chevronDown,
            size: style.iconSmall,
            color: isCurrent ? style.text : style.textFaint,
          ),
        ),
      );
    }

    final alignment = column.alignment == KlpDataAlignment.end
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
    final onTap = header && column.sortable && onSort != null
        ? () => onSort!(column.id)
        : null;

    return _KlpTableCellFrame(
      style: style,
      flex: column.span.flex,
      onTap: onTap,
      child: KlpRow(mainAxisAlignment: alignment, children: cellChildren),
    );
  }

  Widget _buildValue(KlpDataColumn column) {
    final value = values[column.id];
    if (value is Widget) return value;

    return KlpText(
      '${value ?? ''}',
      role: header || column.verbatim ? KlpTextRole.code : KlpTextRole.body,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
