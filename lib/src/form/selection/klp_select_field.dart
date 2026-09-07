import '../internal/klp_form_dependencies.dart';
import 'klp_choice_option.dart';

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
class _KlpSelectFieldState extends State<KlpSelectField> {
	bool _expanded = false;
	bool _hovered = false;
	bool _focused = false;

	bool get _interactive => widget.enabled && !widget.readOnly && widget.onSelected != null;

	void _setHovered(bool value) {
		if (_hovered == value) return;

		setState(() => _hovered = value);
	}

	void _setFocused(bool value) {
		if (_focused == value) return;

		setState(() => _focused = value);
	}

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final state = !widget.enabled
			? KlpFieldFillState.disabled
			: widget.error != null
				? KlpFieldFillState.error
				: _expanded || _focused
					? KlpFieldFillState.focused
					: _hovered
						? KlpFieldFillState.hovered
						: KlpFieldFillState.rest;
		final fill = KlpFieldStyle.colorFor(klp.color, state, surface: klp.surface);

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(widget.label, role: KlpTextRole.caption),
			SizedBox(height: klp.space.tight),
			MouseRegion(
				onEnter: (_) => _setHovered(true),
				onExit: (_) => _setHovered(false),
				child: Focus(
					onFocusChange: _setFocused,
					child: Semantics(
						button: true,
						enabled: _interactive,
						readOnly: widget.readOnly,
						expanded: _expanded,
						child: Material(
							color: fill,
							borderRadius: BorderRadius.circular(klp.fieldRadius),
							clipBehavior: Clip.antiAlias,
							child: InkWell(
								onTap: _interactive ? () => setState(() => _expanded = !_expanded) : null,
								overlayColor: WidgetStatePropertyAll(klp.color.clear),
								child: SizedBox(
									height: klp.fieldHeight,
									child: Padding(
										padding: EdgeInsets.symmetric(horizontal: klp.fieldPaddingX),
										child: Row(
											children: [
												Expanded(
													child: KlpText(
														widget.valueLabel,
														tone: widget.enabled ? KlpTextTone.primary : KlpTextTone.faint,
													),
												),
												KlpIcon(
													KlpIcons.chevronDown,
													size: klp.space.iconSmall,
													weight: KlpIconWeight.thin,
													color: widget.enabled ? klp.color.textMuted : klp.color.textFaint,
												),
											],
										),
									),
								),
							),
						),
					),
				),
			),
				if (_expanded) ...[
			SizedBox(height: klp.space.tight),
					Container(
			padding: EdgeInsets.all(klp.space.tight),
						decoration: BoxDecoration(
				color: klp.color.component,
				borderRadius: BorderRadius.circular(klp.shape.card),
						),
						child: Column(
							children: [
								for (final option in widget.options)
									GestureDetector(
										behavior: HitTestBehavior.opaque,
										onTap: option.disabled
												? null
												: () {
														widget.onSelected?.call(option.id);
														setState(() => _expanded = false);
													},
										child: Container(
											constraints: BoxConstraints(
						minHeight: klp.fieldHeight,
											),
											alignment: Alignment.centerLeft,
											padding: EdgeInsets.symmetric(
						horizontal: klp.space.controlInset,
											),
											child: KlpText(
												option.label,
												tone: option.disabled
														? KlpTextTone.faint
														: KlpTextTone.primary,
											),
										),
									),
							],
						),
					),
				],
			if (widget.error != null) ...[
				SizedBox(height: klp.space.tight),
				KlpText(widget.error!, role: KlpTextRole.caption, tone: KlpTextTone.danger),
			],
			],
		);
	}
}
