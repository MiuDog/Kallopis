part of '../klp_block.dart';

class _KlpBlockHandle extends StatefulWidget {
  const _KlpBlockHandle({
    super.key,
    required this.label,
    required this.onPressed,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
  });

  final String label;
  final ValueChanged<Offset> onPressed;
  final GestureDragStartCallback? onDragStart;
  final GestureDragUpdateCallback? onDragUpdate;
  final GestureDragEndCallback? onDragEnd;

  @override
  State<_KlpBlockHandle> createState() => _KlpBlockHandleState();
}

class _KlpBlockHandleState extends State<_KlpBlockHandle> {
  var _hovered = false;
  var _focused = false;
  var _dragging = false;

  bool get _draggable =>
      widget.onDragStart != null ||
      widget.onDragUpdate != null ||
      widget.onDragEnd != null;

  void _openMenu() {
    final box = context.findRenderObject()! as RenderBox;
    final anchor = box.localToGlobal(Offset(0, box.size.height));
    widget.onPressed(anchor);
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() => _dragging = true);
    widget.onDragStart?.call(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() => _dragging = false);
    widget.onDragEnd?.call(details);
  }

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final active = _hovered || _focused || _dragging;
    final background = active
        ? Color.alphaBlend(klp.selectionWash, klp.color.component)
        : klp.color.clear;

    return Semantics(
      button: true,
      label: widget.label,
      child: MouseRegion(
        cursor: _dragging
            ? SystemMouseCursors.grabbing
            : _draggable
            ? SystemMouseCursors.grab
            : SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: _draggable ? _handleDragStart : null,
          onPanUpdate: _draggable ? widget.onDragUpdate : null,
          onPanEnd: _draggable ? _handleDragEnd : null,
          child: Material(
            color: background,
            borderRadius: BorderRadius.circular(klp.shape.control),
            child: InkWell(
              onTap: _openMenu,
              onHover: (value) => setState(() => _hovered = value),
              onFocusChange: (value) => setState(() => _focused = value),
              overlayColor: WidgetStatePropertyAll(klp.color.clear),
              borderRadius: BorderRadius.circular(klp.shape.control),
              child: SizedBox.square(
                dimension: klp.space.iconButton,
                child: Center(
                  child: KlpIcon(
                    KlpIcons.gripVertical,
                    size: klp.space.icon,
                    color: klp.color.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
