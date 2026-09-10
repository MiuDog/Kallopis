part of '../klp_combobox.dart';

/// 可輸入的下拉選單。輸入框重用 [KlpTextField]，下拉面板重用 [KlpMenu]。
///
/// 這是受控元件：[query]、[options] 由呼叫端持有，本元件只負責過濾、鍵盤
/// 導覽與事件分發。方向鍵移動候選，Enter 選定；允許自由文字時，沒有醒目
/// 候選的 Enter 會觸發 [onFreeTextSubmitted]；Esc 收起面板。
class KlpCombobox extends StatefulWidget {
	const KlpCombobox({
		super.key,
		required this.label,
		required this.query,
		required this.options,
		required this.menuLabel,
		required this.onQueryChanged,
		required this.onSelected,
		this.placeholder,
		this.helper,
		this.error,
		this.enabled = true,
		this.allowFreeText = false,
		this.onFreeTextSubmitted,
	}) : assert(
				 !allowFreeText || onFreeTextSubmitted != null,
				 'allowFreeText 為 true 時必須提供 onFreeTextSubmitted。',
			 );

	final String label;
	final String query;
	final List<KlpComboboxOption> options;
	final String menuLabel;
	final String? placeholder;
	final String? helper;
	final String? error;
	final bool enabled;
	final ValueChanged<String> onQueryChanged;
	final ValueChanged<KlpComboboxOption> onSelected;
	final bool allowFreeText;
	final ValueChanged<String>? onFreeTextSubmitted;

	@override
	State<KlpCombobox> createState() => _KlpComboboxState();
}
