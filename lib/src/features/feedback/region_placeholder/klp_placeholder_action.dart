part of '../klp_region_placeholder.dart';

class _PlaceholderAction extends StatelessWidget {
	const _PlaceholderAction({required this.label, required this.onPressed});

	final String label;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) {
		final geometry = context.klp.geometry.data;

		return KlpSurface(
			tone: KlpSurfaceTone.base,
			radius: context.klp.shape.control,
			child: KlpActionRegion(
				label: label,
				onPressed: onPressed,
				shape: KlpActionRegionShape.control,
				builder: (context, style) {
					return KlpBox(
						insets: KlpBoxInsets.directional(
							start: context.klp.space.controlPaddingXSmall,
							top: geometry.placeholderActionPaddingY,
							end: context.klp.space.controlPaddingXSmall,
							bottom: geometry.placeholderActionPaddingY,
						),
						child: KlpText(
							label.toUpperCase(),
							role: KlpTextRole.code,
							color: context.klpColors.text,
							tracking: KlpTextTracking.placeholder,
							applyOpticalShift: false,
							excludeFromSemantics: true,
						),
					);
				},
			),
		);
	}
}
