part of '../klp_toggle.dart';

@immutable
class _KlpToggleFrameStyle {
	const _KlpToggleFrameStyle._({required this.radius, required this.clear});

	final double radius;
	final Color clear;

	factory _KlpToggleFrameStyle.resolve(KlpTheme klp) {
		return _KlpToggleFrameStyle._(radius: klp.shape.toggleTrack, clear: klp.color.clear);
	}
}
