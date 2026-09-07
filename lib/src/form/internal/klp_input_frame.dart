import 'klp_form_dependencies.dart';

/// Form recipe 共用的輸入外框，不屬於公開元件 API。
class KlpInputFrame extends StatefulWidget {
	final String label;
	final Widget child;
	final bool enabled;
	final bool readOnly;
	final String? error;

	const KlpInputFrame({
		super.key,
		required this.label,
		required this.child,
		required this.enabled,
		required this.readOnly,
		this.error,
	});

	@override
	State<KlpInputFrame> createState() => _KlpInputFrameState();
}
class _KlpInputFrameState extends State<KlpInputFrame> {
	bool _hovered = false;
	bool _focused = false;

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
				: _focused
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
							enabled: widget.enabled,
							readOnly: widget.readOnly,
							child: Container(
								height: klp.fieldHeight,
								clipBehavior: Clip.antiAlias,
								decoration: BoxDecoration(
									color: fill,
									borderRadius: BorderRadius.circular(klp.fieldRadius),
								),
								child: Material(type: MaterialType.transparency, child: widget.child),
							),
						),
					),
				),
				if (widget.error != null) ...[
					SizedBox(height: klp.space.tight),
					KlpText(widget.error!, role: KlpTextRole.caption, tone: KlpTextTone.danger),
				],
			],
		);
	}
}
