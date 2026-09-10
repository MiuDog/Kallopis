part of '../klp_theme_preview_tile.dart';

/// 主題預覽插圖的裁切、尺寸與選取覆層 primitive。
class _KlpThemePreviewArtwork extends StatelessWidget {
	const _KlpThemePreviewArtwork({
		required this.mode,
		required this.selected,
	});

	final KlpThemePreviewMode mode;
	final bool selected;

	@override
	Widget build(BuildContext context) {
		return AspectRatio(
			aspectRatio: _KlpThemePreviewPainter.designAspectRatio,
			child: ClipRRect(
				borderRadius: BorderRadius.circular(context.klp.shape.panel),
				child: Stack(
					fit: StackFit.expand,
					children: [
						CustomPaint(
							painter: _KlpThemePreviewPainter(
								mode,
								context.klp.shape.panel,
							),
						),
						if (selected)
							Positioned.fill(
								child: IgnorePointer(
									child: ColoredBox(
										color: context.klp.selectionWash,
									),
								),
							),
					],
				),
			),
		);
	}
}
