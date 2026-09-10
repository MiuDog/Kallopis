part of '../klp_oklch_color_editor.dart';

class _KlpOklchControlSlotFrame extends StatelessWidget {
	const _KlpOklchControlSlotFrame({required this.style, required this.child});

	final _KlpOklchColorEditorStyle style;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return SizedBox(width: style.controlExtent, child: child);
	}
}
