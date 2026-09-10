part of 'klp_advanced_models.dart';

@immutable
class KlpDataSort {
  const KlpDataSort({required this.columnId, required this.direction});

  final String columnId;
  final KlpSortDirection direction;
}
