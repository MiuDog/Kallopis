part of '../klp_rail_menu_entry.dart';

class _KlpRailMenuEntryViewState extends State<_KlpRailMenuEntryView> {
  final GlobalKey _itemKey = GlobalKey();
  final KlpContextMenuController _menuController = KlpContextMenuController();
  Offset? _pointerPosition;

  void _openMenu() {
    final pointerPosition = _pointerPosition;
    _pointerPosition = null;
    if (pointerPosition != null) {
      _menuController.openAt(pointerPosition);
      return;
    }

    final box = _itemKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    _menuController.openAt(box.localToGlobal(Offset(box.size.width, 0)));
  }

  @override
  Widget build(BuildContext context) {
    return KlpContextMenu(
      controller: _menuController,
      label: widget.entry.label,
      items: widget.entry.items,
      child: _KlpRailPointerTracker(
        onPointerDown: (position) => _pointerPosition = position,
        child: KlpRailItem(
          key: _itemKey,
          icon: widget.entry.icon,
          label: widget.entry.label,
          onPressed: _openMenu,
          selected: widget.entry.selected,
          badge: widget.entry.badge,
        ),
      ),
    );
  }
}
