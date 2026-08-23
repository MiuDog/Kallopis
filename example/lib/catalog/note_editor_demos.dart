import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

class NoteBlockCanvasDemo extends StatefulWidget {
  const NoteBlockCanvasDemo({super.key});

  @override
  State<NoteBlockCanvasDemo> createState() => _NoteBlockCanvasDemoState();
}

class _NoteBlockCanvasDemoState extends State<NoteBlockCanvasDemo> {
  var _selected = 1;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return SizedBox(
      height: klp.space.pageLarge * 3,
      child: KlpBlockCanvas(
        constrained: true,
        children: [
          Positioned(
            left: klp.space.section,
            top: klp.space.section,
            child: _CanvasBlock(
              label: '研究題目',
              selected: _selected == 0,
              onPressed: () => setState(() => _selected = 0),
            ),
          ),
          Positioned(
            left: klp.space.pageLarge * 2,
            top: klp.space.pageLarge,
            child: _CanvasBlock(
              label: '待驗證假設',
              selected: _selected == 1,
              onPressed: () => setState(() => _selected = 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _CanvasBlock extends StatefulWidget {
  const _CanvasBlock({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  State<_CanvasBlock> createState() => _CanvasBlockState();
}

class _CanvasBlockState extends State<_CanvasBlock> {
  final _menuController = KlpContextMenuController();

  @override
  Widget build(BuildContext context) {
    return KlpContextMenu(
      controller: _menuController,
      label: 'Block actions',
      items: [
        KlpMenuItemData(label: 'Duplicate', onPressed: widget.onPressed),
        KlpMenuItemData(label: 'Delete', onPressed: widget.onPressed),
      ],
      child: KlpBlock(
        selected: widget.selected,
        handleLabel: '${widget.label} actions',
        onHandlePressed: _menuController.openAt,
        onPressed: widget.onPressed,
        child: KlpText(widget.label),
      ),
    );
  }
}

class NoteSheetDemo extends StatefulWidget {
  const NoteSheetDemo({super.key});

  @override
  State<NoteSheetDemo> createState() => _NoteSheetDemoState();
}

class _NoteSheetDemoState extends State<NoteSheetDemo> {
  final _cells = <(int, int), String>{
    (0, 0): '工作項目',
    (0, 1): '狀態',
    (0, 2): '負責人',
    (1, 0): '整理訪談',
    (1, 1): '進行中',
    (1, 2): 'Yun',
    (2, 0): '更新原型',
    (2, 1): '待處理',
    (2, 2): 'Kai',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.klp.space.pageLarge * 5,
      child: KlpSheetGrid(
        cellValueAt: (row, column) => _cells[(row, column)],
        onCellCommitted: (row, column, value) {
          setState(() => _cells[(row, column)] = value);
        },
      ),
    );
  }
}
