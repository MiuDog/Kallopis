part of 'klp_advanced_models.dart';

@immutable
class KlpDataRow {
	const KlpDataRow({required this.id, required this.cells});

	final String id;
	final Map<String, Object> cells;
}
