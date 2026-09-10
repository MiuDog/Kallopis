part of '../klp_toggle.dart';

class KlpToggleIndicator extends StatelessWidget {
	const KlpToggleIndicator({super.key, required this.value, this.enabled = true});

	final bool value;
	final bool enabled;

	@override
	Widget build(BuildContext context) {
		return _KlpToggleIndicatorFrame(
			style: _KlpToggleIndicatorStyle.resolve(context.klp, value: value, enabled: enabled),
		);
	}
}
