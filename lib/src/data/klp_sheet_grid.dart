import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controls/klp_control_size.dart';
import '../controls/klp_text_field.dart';
import '../l10n/klp_localizations.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'internal/klp_sheet_grid_geometry.dart';

part 'internal/klp_sheet_grid_cells.dart';

/// 依 row、column 取得受控 Sheet cell 文字。
typedef KlpSheetCellValueAt = String? Function(int row, int column);

/// 將使用者提交的 cell 編輯交還給消費端資料層。
typedef KlpSheetCellCommitted =
    void Function(int row, int column, String value);

/// 向右、向下持續擴充的受控試算表視圖。
///
/// 元件只保存選取、編輯與 viewport 狀態；cell 資料由 [cellValueAt] 提供，編輯結果透過
/// [onCellCommitted] 回傳。抵達目前右方或下方邊界時會增加虛擬軌道，不建立完整二維資料。
class KlpSheetGrid extends StatefulWidget {
  const KlpSheetGrid({
    super.key,
    required this.cellValueAt,
    required this.onCellCommitted,
    this.horizontalController,
    this.verticalController,
    this.initialRowCount = 100,
    this.initialColumnCount = 26,
  }) : assert(initialRowCount > 0),
       assert(initialColumnCount > 0);

  final KlpSheetCellValueAt cellValueAt;
  final KlpSheetCellCommitted onCellCommitted;
  final ScrollController? horizontalController;
  final ScrollController? verticalController;
  final int initialRowCount;
  final int initialColumnCount;

  @override
  State<KlpSheetGrid> createState() => _KlpSheetGridState();
}

class _KlpSheetGridState extends State<KlpSheetGrid> {
  static const int _rowExpansion = 50;
  static const int _columnExpansion = 10;

  final FocusNode _gridFocus = FocusNode(debugLabel: 'Kallopis Sheet grid');
  final FocusNode _editorFocus = FocusNode(debugLabel: 'Kallopis Sheet cell');
  final TextEditingController _editorController = TextEditingController();

  late final ScrollController _horizontalScroll =
      widget.horizontalController ?? ScrollController();
  late final ScrollController _verticalScroll =
      widget.verticalController ?? ScrollController();
  late int _rowCount = widget.initialRowCount;
  late int _columnCount = widget.initialColumnCount;
  int _selectedRow = 0;
  int _selectedColumn = 0;
  bool _editing = false;
  bool _extendedHorizontally = false;
  bool _extendedVertically = false;

  @override
  void initState() {
    super.initState();
    _horizontalScroll.addListener(_handleHorizontalScroll);
    _verticalScroll.addListener(_handleVerticalScroll);
  }

  @override
  void dispose() {
    _horizontalScroll.removeListener(_handleHorizontalScroll);
    _verticalScroll.removeListener(_handleVerticalScroll);
    if (widget.horizontalController == null) _horizontalScroll.dispose();
    if (widget.verticalController == null) _verticalScroll.dispose();
    _gridFocus.dispose();
    _editorFocus.dispose();
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final geometry = KlpSheetGridGeometry(
      rowHeaderWidth: klp.space.sectionLarge,
      columnWidth: klp.space.pageLarge,
      rowHeight: klp.space.controlHeight,
      headerHeight: klp.space.controlHeightSmall,
      columnCount: _columnCount,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalOffset = _horizontalScroll.hasClients
            ? _horizontalScroll.offset
            : 0.0;
        final (firstColumn, lastColumn) = geometry.visibleColumns(
          horizontalOffset,
          constraints.maxWidth,
        );

        return ColoredBox(
          color: context.klpColors.stageSurface,
          child: Focus(
            key: const ValueKey('klp-sheet-grid'),
            focusNode: _gridFocus,
            autofocus: true,
            onKeyEvent: _handleGridKey,
            child: Semantics(
              container: true,
              label: KlpLocalizations.of(context).sheetLabel,
              child: Scrollbar(
                controller: _horizontalScroll,
                notificationPredicate: (notification) =>
                    notification.depth == 0,
                child: SingleChildScrollView(
                  controller: _horizontalScroll,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: geometry.totalWidth,
                    child: Column(
                      children: [
                        _KlpSheetHeader(
                          geometry: geometry,
                          firstColumn: firstColumn,
                          lastColumn: lastColumn,
                        ),
                        Expanded(
                          child: Scrollbar(
                            controller: _verticalScroll,
                            child: ListView.builder(
                              controller: _verticalScroll,
                              itemExtent: geometry.rowHeight,
                              itemCount: _rowCount,
                              itemBuilder: (context, row) => _KlpSheetRow(
                                row: row,
                                geometry: geometry,
                                firstColumn: firstColumn,
                                lastColumn: lastColumn,
                                selectedRow: _selectedRow,
                                selectedColumn: _selectedColumn,
                                editing: _editing,
                                cellValueAt: widget.cellValueAt,
                                editorController: _editorController,
                                editorFocus: _editorFocus,
                                onCellTap: _selectCell,
                                onCellDoubleTap: _startEditing,
                                onSubmitted: _submitEditing,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  KeyEventResult _handleGridKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || _editing) return KeyEventResult.ignored;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp) return _moveSelection(-1, 0);
    if (key == LogicalKeyboardKey.arrowDown) return _moveSelection(1, 0);
    if (key == LogicalKeyboardKey.arrowLeft) return _moveSelection(0, -1);
    if (key == LogicalKeyboardKey.arrowRight) return _moveSelection(0, 1);
    if (key == LogicalKeyboardKey.enter) {
      _startEditing(_selectedRow, _selectedColumn);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _moveSelection(int rowDelta, int columnDelta) {
    _selectCell(
      (_selectedRow + rowDelta).clamp(0, _rowCount - 1),
      (_selectedColumn + columnDelta).clamp(0, _columnCount - 1),
    );
    return KeyEventResult.handled;
  }

  void _selectCell(int row, int column) {
    setState(() {
      _selectedRow = row;
      _selectedColumn = column;
      _editing = false;
    });
    _gridFocus.requestFocus();
  }

  void _startEditing(int row, int column) {
    setState(() {
      _selectedRow = row;
      _selectedColumn = column;
      _editing = true;
      final value = widget.cellValueAt(row, column) ?? '';
      _editorController.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    });
    _editorFocus.requestFocus();
  }

  void _submitEditing(String value) {
    widget.onCellCommitted(_selectedRow, _selectedColumn, value);
    setState(() => _editing = false);
    _gridFocus.requestFocus();
  }

  void _handleHorizontalScroll() {
    if (!_horizontalScroll.hasClients || !mounted) return;

    final position = _horizontalScroll.position;
    final nearEdge = position.extentAfter <= position.viewportDimension;
    if (!nearEdge) {
      _extendedHorizontally = false;
      setState(() {});
      return;
    }
    if (_extendedHorizontally) {
      setState(() {});
      return;
    }
    setState(() {
      _columnCount += _columnExpansion;
      _extendedHorizontally = true;
    });
  }

  void _handleVerticalScroll() {
    if (!_verticalScroll.hasClients || !mounted) return;

    final position = _verticalScroll.position;
    final nearEdge = position.extentAfter <= position.viewportDimension;
    if (!nearEdge) {
      _extendedVertically = false;
      return;
    }
    if (_extendedVertically) return;

    setState(() {
      _rowCount += _rowExpansion;
      _extendedVertically = true;
    });
  }
}
