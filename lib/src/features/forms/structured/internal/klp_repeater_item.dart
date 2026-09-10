part of '../klp_repeater_field.dart';

/// [KlpRepeaterField] 裡的一個項目：識別碼加上該項目自己的輸入內容。
///
/// [child] 是整個項目的內容 widget（例如一組欄位），[id] 只用來在
/// [KlpRepeaterField.onRemove] 回報要刪除哪一項，與顯示內容無關。
@immutable
class KlpRepeaterItem {
	const KlpRepeaterItem({required this.id, required this.child});

	final String id;
	final Widget child;
}
