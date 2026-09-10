part of '../klp_compound_field.dart';

/// 在單一控制框內組合主要文字與受控尾端選項。
class KlpCompoundField extends StatefulWidget {
	const KlpCompoundField({
		super.key,
		required this.label,
		required this.selectedOptionLabel,
		required this.options,
		this.controller,
		this.initialValue,
		this.placeholder,
		this.onChanged,
		this.onOptionSelected,
		this.enabled = true,
		this.readOnly = false,
		this.error,
		this.optionsLabel,
	}) : assert(controller == null || initialValue == null);

	final String label;
	final TextEditingController? controller;
	final String? initialValue;
	final String? placeholder;
	final String selectedOptionLabel;
	final List<KlpChoiceOption> options;
	final ValueChanged<String>? onChanged;
	final ValueChanged<String>? onOptionSelected;
	final bool enabled;
	final bool readOnly;
	final String? error;
	final String? optionsLabel;

	@override
	State<KlpCompoundField> createState() => _KlpCompoundFieldState();
}
