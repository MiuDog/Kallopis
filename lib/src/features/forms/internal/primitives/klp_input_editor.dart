import '../klp_form_dependencies.dart';

/// Form recipe 共用的無外框文字編輯 primitive，不屬於公開元件 API。
class KlpInputEditor extends StatelessWidget {
	final TextEditingController? controller;
	final String? initialValue;
	final String? placeholder;
	final ValueChanged<String>? onChanged;
	final bool enabled;
	final bool readOnly;

	const KlpInputEditor({
		super.key,
		this.controller,
		this.initialValue,
		this.placeholder,
		this.onChanged,
		required this.enabled,
		required this.readOnly,
	});

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return TextFormField(
			controller: controller,
			initialValue: controller == null ? initialValue : null,
			enabled: enabled,
			readOnly: readOnly,
			onChanged: onChanged,
			textAlignVertical: TextAlignVertical.center,
			style: TextStyle(
				color: enabled ? klp.color.text : klp.color.textFaint,
				fontSize: klp.type.body,
				fontFamily: klp.type.uiFamily,
				fontFamilyFallback: klp.type.fallbackFor(klp.type.uiFamily),
			),
			cursorColor: klp.color.interaction,
			decoration: InputDecoration(
				isDense: true,
				hintText: placeholder,
				hintStyle: TextStyle(
					color: klp.color.textFaint,
					fontSize: klp.type.body,
					fontFamily: klp.type.uiFamily,
					fontFamilyFallback: klp.type.fallbackFor(klp.type.uiFamily),
				),
				border: InputBorder.none,
				enabledBorder: InputBorder.none,
				focusedBorder: InputBorder.none,
				disabledBorder: InputBorder.none,
				contentPadding: EdgeInsets.symmetric(horizontal: klp.fieldPaddingX),
			),
		);
	}
}
