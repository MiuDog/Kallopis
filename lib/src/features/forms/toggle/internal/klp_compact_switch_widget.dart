part of '../klp_switch.dart';

class KlpCompactSwitch extends StatelessWidget {
	const KlpCompactSwitch({
		super.key,
		required this.value,
		required this.label,
		required this.onChanged,
	});

	final bool value;
	final String label;
	final ValueChanged<bool>? onChanged;

	@override
	Widget build(BuildContext context) {
		final enabled = onChanged != null;
		return _KlpCompactSwitchFrame(
			label: label,
			value: value,
			enabled: enabled,
			onPressed: enabled ? () => onChanged!(!value) : null,
			style: _KlpCompactSwitchStyle.resolve(context.klp, value: value),
		);
	}
}
