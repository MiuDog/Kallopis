part of '../klp_key_value_table.dart';

@immutable
class KlpKeyValueItem {
  const KlpKeyValueItem({
    required this.id,
    required this.label,
    required this.value,
    this.verbatim = false,
    this.copyable = false,
  });

  final String id;
  final String label;
  final Widget value;
  final bool verbatim;
  final bool copyable;
}
