part of '../klp_menu.dart';

/// 計算 [KlpMenu] 彈出時的尺寸與位置，供呼叫端在插入 overlay 之前先算好座標。
abstract final class KlpMenuLayout {
	@Deprecated('Use widthOf(context) so JSON geometry is applied.')
	static double get width => KlpGeometryTheme.standard.layout.menuWidth;

	static double widthOf(BuildContext context) => _KlpMenuMetrics.width(context);

	static double estimatedHeight({
		required BuildContext context,
		required int itemCount,
		int separatorCount = 0,
	}) {
		return context.klp.space.tight * 2 +
				_KlpMenuMetrics.headerHeight(context) +
				context.klp.space.tight +
				itemCount * _KlpMenuMetrics.itemHeight(context) +
				separatorCount *
						(context.klp.shape.stroke + context.klp.space.tight * 2);
	}

	static Offset resolvePosition({
		required Offset anchor,
		required Size viewport,
		required BuildContext context,
		required int itemCount,
		int separatorCount = 0,
	}) {
		final height = estimatedHeight(
			context: context,
			itemCount: itemCount,
			separatorCount: separatorCount,
		);
		final left = anchor.dx
				.clamp(
					context.klp.geometry.layout.overlayViewportInset,
					viewport.width -
							_KlpMenuMetrics.width(context) -
							context.klp.geometry.layout.overlayViewportInset,
				)
				.toDouble();
		final top = anchor.dy
				.clamp(
					context.klp.geometry.layout.overlayViewportInset,
					viewport.height -
							height -
							context.klp.geometry.layout.overlayViewportInset,
				)
				.toDouble();

		return Offset(left, top);
	}

	static Offset resolveSubmenuPosition({
		required Offset parentPosition,
		required Size viewport,
		required BuildContext context,
		required int itemCount,
		int separatorCount = 0,
	}) {
		final height = estimatedHeight(
			context: context,
			itemCount: itemCount,
			separatorCount: separatorCount,
		);
		final preferredLeft = parentPosition.dx + width + context.klp.space.tight;
		final left =
				preferredLeft +
							width +
							context.klp.geometry.layout.overlayViewportInset <=
						viewport.width
						? preferredLeft
						: parentPosition.dx - width - context.klp.space.tight;
		final top = parentPosition.dy
				.clamp(
					context.klp.geometry.layout.overlayViewportInset,
					viewport.height -
							height -
							context.klp.geometry.layout.overlayViewportInset,
				)
				.toDouble();

		return Offset(
			left
					.clamp(
						context.klp.geometry.layout.overlayViewportInset,
						viewport.width - width,
					)
					.toDouble(),
			top,
		);
	}
}
