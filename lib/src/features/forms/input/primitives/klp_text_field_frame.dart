part of '../klp_text_field.dart';

class _KlpTextFieldFrame extends StatelessWidget {
	const _KlpTextFieldFrame({
		required this.style,
		required this.controller,
		required this.initialValue,
		required this.focusNode,
		required this.autofocus,
		required this.enabled,
		required this.readOnly,
		required this.obscureText,
		required this.multiline,
		required this.minLines,
		required this.maxLines,
		required this.maxLength,
		required this.placeholder,
		required this.leadingIcon,
		required this.leadingIconWeight,
		required this.suffix,
		required this.onChanged,
		required this.onSubmitted,
		required this.onFocusChanged,
	});

	final _KlpTextFieldStyle style;
	final TextEditingController? controller;
	final String? initialValue;
	final FocusNode? focusNode;
	final bool autofocus;
	final bool enabled;
	final bool readOnly;
	final bool obscureText;
	final bool multiline;
	final int minLines;
	final int? maxLines;
	final int? maxLength;
	final String? placeholder;
	final KlpIconData? leadingIcon;
	final KlpIconWeight leadingIconWeight;
	final Widget? suffix;
	final ValueChanged<String>? onChanged;
	final ValueChanged<String>? onSubmitted;
	final ValueChanged<bool> onFocusChanged;

	@override
	Widget build(BuildContext context) {
		return Container(
			height: multiline ? null : style.fieldHeight,
			decoration: BoxDecoration(
				color: style.fillColor,
				borderRadius: BorderRadius.circular(style.radius),
				border: style.borderWidth == context.klp.shape.none
						? null
						: Border.all(color: style.borderColor, width: style.borderWidth),
			),
			alignment: multiline ? Alignment.topLeft : Alignment.centerLeft,
			child: Material(
				type: MaterialType.transparency,
				child: Focus(
					onFocusChange: onFocusChanged,
					child: TextFormField(
						controller: controller,
						initialValue: initialValue,
						focusNode: focusNode,
						autofocus: autofocus,
						enabled: enabled,
						readOnly: readOnly,
						obscureText: obscureText,
						textAlignVertical: multiline
								? TextAlignVertical.top
								: TextAlignVertical.center,
						inputFormatters: maxLength == null
								? null
								: [LengthLimitingTextInputFormatter(maxLength)],
						onChanged: onChanged,
						onFieldSubmitted: onSubmitted,
						minLines: minLines,
						maxLines: maxLines,
						style: TextStyle(
							color: style.textColor,
							fontSize: style.fontSize,
							height: style.lineHeight,
							fontFamily: style.fontFamily,
							fontFamilyFallback: style.fontFamilyFallback,
						),
						cursorColor: style.cursorColor,
						decoration: InputDecoration(
							isDense: true,
							hintText: placeholder,
							hintStyle: TextStyle(
								color: style.hintColor,
								fontSize: style.fontSize,
								fontFamily: style.fontFamily,
								fontFamilyFallback: style.fontFamilyFallback,
							),
							prefixIcon: leadingIcon == null
									? null
									: Padding(
											padding: EdgeInsets.all(style.controlInset),
											child: KlpIcon(
												leadingIcon!,
												weight: leadingIconWeight,
												color: style.iconColor,
											),
										),
							prefixIconConstraints: BoxConstraints(
								minWidth: style.fieldHeight,
								minHeight: style.fieldHeight,
							),
							suffixIcon: suffix,
							suffixIconConstraints: BoxConstraints(
								minHeight: style.fieldHeight,
							),
							filled: false,
							border: InputBorder.none,
							enabledBorder: InputBorder.none,
							focusedBorder: InputBorder.none,
							errorBorder: InputBorder.none,
							focusedErrorBorder: InputBorder.none,
							disabledBorder: InputBorder.none,
							contentPadding: EdgeInsets.symmetric(
								horizontal: style.horizontalPadding,
								vertical: style.verticalPadding,
							),
						),
					),
				),
			),
		);
	}
}
