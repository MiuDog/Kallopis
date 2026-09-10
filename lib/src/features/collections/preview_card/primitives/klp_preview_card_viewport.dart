part of '../klp_preview_card.dart';

/// 預覽卡專用的固定高度與控制項表面實作邊界。
class _KlpPreviewCardViewport extends StatelessWidget {
	const _KlpPreviewCardViewport({
		required this.size,
		required this.child,
	});

	final KlpPreviewCardSize size;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final geometry = context.klp.geometry.data;
		final height = switch (size) {
			KlpPreviewCardSize.compact => geometry.previewCardCompactHeight,
			KlpPreviewCardSize.standard => geometry.previewCardStandardHeight,
			KlpPreviewCardSize.large => geometry.previewCardLargeHeight,
		};

		return KlpDashedBorder(
			child: SizedBox(
				height: height,
				child: KlpSurface(
					tone: KlpSurfaceTone.component,
					radius: context.klp.shape.control,
					child: child,
				),
			),
		);
	}
}
