import '../internal/klp_form_dependencies.dart';

/// 結構化設定與程式碼編輯器欄位。支援頂部動作列、行內錯誤／警告提示與底部運算式動作列。
class KlpCodeEditorField extends StatelessWidget {
	const KlpCodeEditorField({
		super.key,
		required this.label,
		this.subtitle,
		this.actions,
		required this.code,
		this.error,
		this.warning,
		this.footerLeft,
		this.footerRight,
	});

	final String label;
	final String? subtitle;
	final List<String>? actions;
	final String code;
	final String? error;
	final String? warning;
	final Widget? footerLeft;
	final Widget? footerRight;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final klp = context.klp;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Row(
							children: [
								KlpText(label, role: KlpTextRole.caption),
								if (subtitle != null) ...[
									SizedBox(width: klp.space.contentInlineGap),
									KlpText(
										subtitle!,
										role: KlpTextRole.caption,
										tone: KlpTextTone.muted,
									),
								],
							],
						),
						if (actions != null)
							Row(
								children: [
									for (final action in actions!) ...[
										Padding(
											padding: EdgeInsets.only(left: klp.space.actionGap),
											child: KlpText(action, role: KlpTextRole.caption),
										),
									],
								],
							),
					],
				),
				SizedBox(height: klp.space.tight),
				Container(
					padding: EdgeInsets.all(klp.space.base),
					decoration: BoxDecoration(
						color: tokens.surfaceInset,
						borderRadius: BorderRadius.circular(klp.shape.card),
						border: Border.all(color: tokens.border, width: klp.shape.hairline),
					),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							KlpText(code, role: KlpTextRole.code),
							if (footerLeft != null || footerRight != null) ...[
								SizedBox(height: klp.space.base),
								Container(
									padding: EdgeInsets.symmetric(
										horizontal: klp.space.contentInset,
										vertical: klp.space.tight,
									),
									decoration: BoxDecoration(
										color: tokens.component,
										borderRadius: BorderRadius.circular(klp.shape.control),
									),
									child: Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											footerLeft ?? const SizedBox.shrink(),
											footerRight ?? const SizedBox.shrink(),
										],
									),
								),
							],
						],
					),
				),
				if (error != null) ...[
					SizedBox(height: klp.space.tight),
					KlpText(error!, role: KlpTextRole.caption, tone: KlpTextTone.danger),
				],
				if (warning != null) ...[
					SizedBox(height: klp.space.tight),
					KlpText(warning!, role: KlpTextRole.caption, color: tokens.warning),
				],
			],
		);
	}
}
