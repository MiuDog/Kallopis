part of '../klp_select_field.dart';

/// 單選下拉欄位：目前值顯示為一列文字，點擊展開選項清單並就地插入版面
/// （不是彈出層），選中後自動收合。
///
/// [valueLabel] 是呼叫端算好的顯示文字，不會反查 [options] 對應哪一項——
/// 這個元件不知道「目前選的是哪個 id」，只負責畫出清單與回報點擊。
/// 需要彈出式選單而非就地展開時請改用 [KlpMenu]。
class KlpSelectField extends StatefulWidget {
	const KlpSelectField({
		super.key,
		required this.label,
		required this.valueLabel,
		required this.options,
		required this.onSelected,
		this.enabled = true,
		this.readOnly = false,
		this.error,
	});

	final String label;
	final String valueLabel;
	final List<KlpChoiceOption> options;
	final ValueChanged<String>? onSelected;
	final bool enabled;
	final bool readOnly;
	final String? error;

	@override
	State<KlpSelectField> createState() => _KlpSelectFieldState();
}
