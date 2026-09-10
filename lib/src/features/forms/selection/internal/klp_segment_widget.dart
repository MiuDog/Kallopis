part of '../klp_segmented_control.dart';

class _KlpSegment extends StatefulWidget {
	const _KlpSegment({
		super.key,
		required this.label,
		required this.icon,
		required this.selected,
		required this.dense,
		required this.onPressed,
	});

	final String label;
	final KlpIconData? icon;
	final bool selected;
	final bool dense;
	final VoidCallback onPressed;

	@override
	State<_KlpSegment> createState() => _KlpSegmentState();
}
