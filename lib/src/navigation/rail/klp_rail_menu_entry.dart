import 'package:flutter/widgets.dart';

import '../../foundation/klp_icon.dart';
import '../../overlay/klp_context_menu.dart';
import '../../overlay/klp_menu.dart';
import 'klp_rail_entry.dart';
import 'klp_rail_item.dart';

/// 從 Rail item 開啟既有 Kallopis 選單的結構化資料。
final class KlpRailMenuEntry extends KlpRailEntry {
	final KlpIconData icon;
	final String label;
	final List<KlpMenuItemData> items;
	final bool selected;
	final String? badge;

	const KlpRailMenuEntry({
		required super.id,
		required this.icon,
		required this.label,
		required this.items,
		this.selected = false,
		this.badge,
	});

	@override
	Widget build(BuildContext context) => _KlpRailMenuEntryView(entry: this);
}

class _KlpRailMenuEntryView extends StatefulWidget {
	final KlpRailMenuEntry entry;

	const _KlpRailMenuEntryView({required this.entry});

	@override
	State<_KlpRailMenuEntryView> createState() => _KlpRailMenuEntryViewState();
}

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
			child: Listener(
				onPointerDown: (event) => _pointerPosition = event.position,
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
