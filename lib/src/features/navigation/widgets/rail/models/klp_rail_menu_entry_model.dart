part of '../klp_rail_menu_entry.dart';

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
