part of '../klp_tooltip.dart';

class KlpTooltipSurface extends StatelessWidget {
	const KlpTooltipSurface({super.key, required this.message, this.contentKey});

	final String message;
	final Key? contentKey;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		return KlpSurface(
			tone: KlpSurfaceTone.overlay,
			radius: klp.shape.control,
			child: KlpBox(
				key: contentKey,
				insets: KlpBoxInsets.directional(
					start: klp.space.overlayContentInset,
					top: klp.space.tight,
					end: klp.space.overlayContentInset,
					bottom: klp.space.tight,
				),
				child: KlpText(
					message,
					role: KlpTextRole.caption,
					tone: KlpTextTone.muted,
				),
			),
		);
	}
}
