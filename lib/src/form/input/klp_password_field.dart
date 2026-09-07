import '../internal/klp_form_dependencies.dart';

/// 密碼規則要求項。包含檢核描述與是否滿足之狀態。
@immutable
class KlpPasswordRequirement {
	const KlpPasswordRequirement({required this.label, required this.satisfied});

	final String label;
	final bool satisfied;
}
/// 密碼輸入控制項。支援顯示／隱藏密碼切換與密碼強度／規則檢核清單。
class KlpPasswordField extends StatefulWidget {
	const KlpPasswordField({
		super.key,
		required this.label,
		this.value,
		this.placeholder,
		this.error,
		this.onChanged,
		this.enabled = true,
		this.readOnly = false,
		this.required = false,
		this.requirements,
	});

	final String label;
	final String? value;
	final String? placeholder;
	final String? error;
	final ValueChanged<String>? onChanged;
	final bool enabled;
	final bool readOnly;
	final bool required;
	final List<KlpPasswordRequirement>? requirements;

	@override
	State<KlpPasswordField> createState() => _KlpPasswordFieldState();
}
class _KlpPasswordFieldState extends State<KlpPasswordField> {
	bool _obscured = true;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final klp = context.klp;
		final labels = KlpLocalizations.of(context);

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Row(
					children: [
						KlpText(widget.label, role: KlpTextRole.caption),
						if (widget.required) ...[
							SizedBox(width: klp.space.tight),
							const KlpText(
								'*',
								role: KlpTextRole.caption,
								tone: KlpTextTone.danger,
							),
						],
					],
				),
				SizedBox(height: klp.space.tight),
				Material(
					type: MaterialType.transparency,
					child: TextFormField(
						initialValue: widget.value,
						obscureText: _obscured,
						enabled: widget.enabled,
			readOnly: widget.readOnly,
						onChanged: widget.onChanged,
						style: TextStyle(
							color: tokens.text,
							fontSize: klp.type.body,
							fontFamily: klp.type.uiFamily,
							fontFamilyFallback: klp.type.fallbackFor(klp.type.uiFamily),
						),
						cursorColor: tokens.interaction,
						decoration: InputDecoration(
							isDense: true,
							hintText: widget.placeholder,
							hintStyle: TextStyle(color: tokens.textFaint),
							filled: true,
							fillColor: KlpFieldStyle.inputFill(
								tokens,
								error: widget.error != null,
								surface: klp.surface,
							),
							border: KlpFieldStyle.borderFor(klp.shape),
							enabledBorder: KlpFieldStyle.borderFor(klp.shape),
							focusedBorder: KlpFieldStyle.borderFor(klp.shape),
							errorBorder: KlpFieldStyle.borderFor(klp.shape),
							focusedErrorBorder: KlpFieldStyle.borderFor(klp.shape),
							disabledBorder: KlpFieldStyle.borderFor(klp.shape),
							constraints: BoxConstraints.tightFor(
								height: klp.space.controlHeight,
							),
				prefixIcon: Padding(
				padding: EdgeInsets.all(klp.space.controlInset),
				child: KlpIcon(
					KlpIcons.lock,
					weight: KlpIconWeight.thin,
					color: widget.enabled ? tokens.textMuted : tokens.textFaint,
				),
				),
				prefixIconConstraints: BoxConstraints.tightFor(
				width: klp.space.controlHeight,
				height: klp.space.controlHeight,
				),
				suffixIcon: Semantics(
				button: true,
				enabled: widget.enabled,
				label: _obscured ? labels.formPasswordShowLabel : labels.formPasswordHideLabel,
				child: InkWell(
					onTap: !widget.enabled
						? null
						: () => setState(() => _obscured = !_obscured),
					overlayColor: WidgetStatePropertyAll(tokens.clear),
					child: Padding(
					padding: EdgeInsets.all(klp.space.controlInset),
					child: KlpIcon(
						_obscured ? KlpIcons.eyeCrossed : KlpIcons.eye,
						weight: KlpIconWeight.thin,
						color: widget.enabled ? tokens.textMuted : tokens.textFaint,
					),
					),
				),
				),
				suffixIconConstraints: BoxConstraints.tightFor(
				width: klp.space.controlHeight,
				height: klp.space.controlHeight,
				),
							contentPadding: EdgeInsets.symmetric(
								horizontal: klp.space.controlPaddingX,
								vertical: klp.space.controlPaddingY,
							),
						),
					),
				),
				if (widget.requirements != null && widget.requirements!.isNotEmpty) ...[
					SizedBox(height: klp.space.tight),
					Wrap(
						spacing: klp.space.base,
						runSpacing: klp.space.tight,
						children: [
							for (final req in widget.requirements!)
								Row(
									mainAxisSize: MainAxisSize.min,
									children: [
										KlpText(
											req.satisfied ? '✓ ' : '○ ',
											role: KlpTextRole.caption,
											tone: req.satisfied
													? KlpTextTone.success
													: KlpTextTone.muted,
										),
										KlpText(
											req.label,
											role: KlpTextRole.caption,
											tone: req.satisfied
													? KlpTextTone.success
													: KlpTextTone.muted,
										),
									],
								),
						],
					),
				],
				if (widget.error != null) ...[
					SizedBox(height: klp.space.tight),
					KlpText(
						widget.error!,
						role: KlpTextRole.caption,
						tone: KlpTextTone.danger,
					),
				],
			],
		);
	}
}
