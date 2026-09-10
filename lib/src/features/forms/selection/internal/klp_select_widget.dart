part of '../klp_select.dart';

/// 下拉選擇的觸發器，只顯示目前值並轉送開啟選單事件。
class KlpSelect extends StatefulWidget {
	const KlpSelect({super.key, required this.label, required this.value, required this.onPressed, this.enabled = true});

	final String label;
	final String value;
	final VoidCallback onPressed;
	final bool enabled;

	@override
	State<KlpSelect> createState() => _KlpSelectState();
}
