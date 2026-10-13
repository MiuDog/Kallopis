part of 'klp_advanced_models.dart';

@immutable
class KlpDataColumn {
  const KlpDataColumn({
    required this.id,
    required this.label,
    this.span = KlpDataColumnSpan.single,
    this.sortable = false,
    this.alignment = KlpDataAlignment.start,
    this.verbatim = false,
  });

  final String id;
  final String label;
  final KlpDataColumnSpan span;
  final bool sortable;
  final KlpDataAlignment alignment;
  final bool verbatim;
}
