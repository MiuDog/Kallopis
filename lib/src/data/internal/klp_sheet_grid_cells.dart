part of '../klp_sheet_grid.dart';

final class _KlpSheetHeader extends StatelessWidget {
  const _KlpSheetHeader({
    required this.geometry,
    required this.firstColumn,
    required this.lastColumn,
  });

  final KlpSheetGridGeometry geometry;
  final int firstColumn;
  final int lastColumn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: geometry.totalWidth,
      height: geometry.headerHeight,
      child: Stack(
        children: [
          _KlpSheetHeaderCell(
            width: geometry.rowHeaderWidth,
            height: geometry.headerHeight,
            label: '',
          ),
          for (var column = firstColumn; column <= lastColumn; column++)
            Positioned(
              left: geometry.columnOffset(column),
              child: _KlpSheetHeaderCell(
                width: geometry.columnWidth,
                height: geometry.headerHeight,
                label: _columnLabel(column),
              ),
            ),
        ],
      ),
    );
  }
}

final class _KlpSheetRow extends StatelessWidget {
  const _KlpSheetRow({
    required this.row,
    required this.geometry,
    required this.firstColumn,
    required this.lastColumn,
    required this.selectedRow,
    required this.selectedColumn,
    required this.editing,
    required this.cellValueAt,
    required this.editorController,
    required this.editorFocus,
    required this.onCellTap,
    required this.onCellDoubleTap,
    required this.onSubmitted,
  });

  final int row;
  final KlpSheetGridGeometry geometry;
  final int firstColumn;
  final int lastColumn;
  final int selectedRow;
  final int selectedColumn;
  final bool editing;
  final KlpSheetCellValueAt cellValueAt;
  final TextEditingController editorController;
  final FocusNode editorFocus;
  final void Function(int row, int column) onCellTap;
  final void Function(int row, int column) onCellDoubleTap;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: geometry.totalWidth,
      height: geometry.rowHeight,
      child: Stack(
        children: [
          _KlpSheetHeaderCell(
            width: geometry.rowHeaderWidth,
            height: geometry.rowHeight,
            label: '${row + 1}',
          ),
          for (var column = firstColumn; column <= lastColumn; column++)
            Positioned(
              left: geometry.columnOffset(column),
              child: _KlpSheetCell(
                row: row,
                column: column,
                width: geometry.columnWidth,
                height: geometry.rowHeight,
                value: cellValueAt(row, column),
                selected: row == selectedRow && column == selectedColumn,
                editing:
                    editing && row == selectedRow && column == selectedColumn,
                editorController: editorController,
                editorFocus: editorFocus,
                onTap: () => onCellTap(row, column),
                onDoubleTap: () => onCellDoubleTap(row, column),
                onSubmitted: onSubmitted,
              ),
            ),
        ],
      ),
    );
  }
}

final class _KlpSheetHeaderCell extends StatelessWidget {
  const _KlpSheetHeaderCell({
    required this.width,
    required this.height,
    required this.label,
  });

  final double width;
  final double height;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tokens.surfaceInset,
        border: Border(
          right: BorderSide(color: tokens.divider, width: klp.shape.hairline),
          bottom: BorderSide(color: tokens.divider, width: klp.shape.hairline),
        ),
      ),
      child: KlpText(label, role: KlpTextRole.caption, tone: KlpTextTone.muted),
    );
  }
}

final class _KlpSheetCell extends StatelessWidget {
  const _KlpSheetCell({
    required this.row,
    required this.column,
    required this.width,
    required this.height,
    required this.value,
    required this.selected,
    required this.editing,
    required this.editorController,
    required this.editorFocus,
    required this.onTap,
    required this.onDoubleTap,
    required this.onSubmitted,
  });

  final int row;
  final int column;
  final double width;
  final double height;
  final String? value;
  final bool selected;
  final bool editing;
  final TextEditingController editorController;
  final FocusNode editorFocus;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;
    final content = Container(
      key: selected ? ValueKey('klp-sheet-selection-r$row-c$column') : null,
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: klp.space.compact),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: selected ? klp.selectionWash : tokens.stageSurface,
        border: Border(
          right: BorderSide(color: tokens.divider, width: klp.shape.hairline),
          bottom: BorderSide(color: tokens.divider, width: klp.shape.hairline),
        ),
      ),
      child: editing
          ? KlpTextField(
              key: ValueKey('klp-sheet-editor-r$row-c$column'),
              controller: editorController,
              focusNode: editorFocus,
              autofocus: true,
              size: KlpControlSize.sm,
              onSubmitted: onSubmitted,
            )
          : KlpText(
              value ?? '',
              role: KlpTextRole.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    );

    final cell = SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          if (selected)
            IgnorePointer(
              child: KlpDashedBorder(
                radius: klp.shape.none,
                child: const SizedBox.expand(),
              ),
            ),
        ],
      ),
    );

    return Semantics(
      label: '${_columnLabel(column)}${row + 1}',
      selected: selected,
      button: true,
      onTap: onTap,
      child: GestureDetector(
        key: ValueKey('klp-sheet-cell-r$row-c$column'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        child: cell,
      ),
    );
  }
}

String _columnLabel(int column) {
  var value = column + 1;
  final characters = <int>[];
  while (value > 0) {
    value--;
    characters.add(65 + value % 26);
    value ~/= 26;
  }
  return String.fromCharCodes(characters.reversed);
}
