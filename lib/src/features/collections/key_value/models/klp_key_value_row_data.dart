part of '../klp_key_value_table.dart';

@immutable
class KlpKeyValueRowData {
	const KlpKeyValueRowData({required this.label, required this.value});

	final String label;
	final String value;
}
