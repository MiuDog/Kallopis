part of '../klp_oklch_color_picker.dart';

class _KlpOklchSectionFrame extends StatelessWidget {
	const _KlpOklchSectionFrame({required this.style, required this.child});

	final _KlpOklchColorPickerStyle style;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return SizedBox(width: style.planeExtent, child: child);
	}
}
