part of '../klp_oklch_color_editor.dart';

class _KlpOklchColorEditorStyle {
	const _KlpOklchColorEditorStyle({required this.controlExtent});

	final double controlExtent;

	factory _KlpOklchColorEditorStyle.resolve(
		KlpTheme klp,
		BoxConstraints constraints,
	) {
		return _KlpOklchColorEditorStyle(
			controlExtent: math.min(
				klp.geometry.control.colorPlaneExtent,
				constraints.maxWidth,
			),
		);
	}
}
