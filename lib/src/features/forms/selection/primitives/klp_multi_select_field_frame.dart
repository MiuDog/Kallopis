part of '../klp_multi_select_field.dart';

/// Multi-select 的語意與欄位表面 primitive。
class _KlpMultiSelectFieldFrame extends StatelessWidget {
	const _KlpMultiSelectFieldFrame({
		required this.label,
		required this.enabled,
		required this.readOnly,
		required this.hasError,
		required this.child,
	});

	final String label;
	final bool enabled;
	final bool readOnly;
	final bool hasError;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final fillState = !enabled
				? KlpFieldFillState.disabled
				: hasError
						? KlpFieldFillState.error
						: KlpFieldFillState.rest;
		final fill = KlpFieldStyle.colorFor(
			klp.color,
			fillState,
			surface: klp.surface,
		);

		return Semantics(
			enabled: enabled,
			readOnly: readOnly,
			label: label,
			child: Container(
				constraints: BoxConstraints(minHeight: klp.fieldHeight),
				padding: EdgeInsets.all(klp.space.tight),
				decoration: BoxDecoration(
					color: fill,
					borderRadius: BorderRadius.circular(klp.fieldRadius),
				),
				child: child,
			),
		);
	}
}
