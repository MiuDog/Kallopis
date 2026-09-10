part of '../klp_command_menu.dart';

@immutable
class KlpCommandSectionData {
  const KlpCommandSectionData({required this.label, required this.items});

  final String label;
  final List<KlpCommandItemData> items;
}
