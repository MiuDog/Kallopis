part of '../klp_avatar.dart';

/// Avatar 對 Flutter 圖片、尺寸與裝飾能力的唯一 primitive 邊界。
class _KlpAvatarFrame extends StatelessWidget {
	const _KlpAvatarFrame({
		required this.label,
		required this.image,
		required this.size,
		required this.tone,
		required this.child,
	});

	final String label;
	final ImageProvider? image;
	final KlpAvatarSize size;
	final KlpAvatarTone tone;
	final Widget? child;

	@override
	Widget build(BuildContext context) {
		final dimension = switch (size) {
			KlpAvatarSize.standard => context.klp.space.controlHeightLarge,
			KlpAvatarSize.small => context.klp.space.avatarSmall,
		};
		final emphasized = tone == KlpAvatarTone.emphasized;
		final colors = context.klpColors;
		final background = emphasized ? colors.accent : colors.surfaceMuted;
		final foreground = emphasized ? colors.onStatus : colors.text;

		return Semantics(
			label: label,
			image: image != null,
			child: KlpTokenOverride(
				colors: colors.copyWith(text: foreground),
				child: Container(
					width: dimension,
					height: dimension,
					alignment: Alignment.center,
					decoration: BoxDecoration(
						color: background,
						image: image == null
								? null
								: DecorationImage(
										image: image!,
										fit: BoxFit.cover,
									),
						borderRadius: BorderRadius.circular(
							emphasized ? context.klp.shape.pill : context.klp.shape.card,
						),
					),
					child: child ?? const SizedBox.shrink(),
				),
			),
		);
	}
}
