part of '../klp_combobox.dart';

/// [KlpCombobox] 的一個候選項。
@immutable
class KlpComboboxOption {
	const KlpComboboxOption({required this.id, required this.label});

	/// 穩定識別碼，用於 `Key` 與比對，不用於顯示。
	final String id;

	/// 顯示文字，也是輸入時比對過濾的依據。
	final String label;
}
