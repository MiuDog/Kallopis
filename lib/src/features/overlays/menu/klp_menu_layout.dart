part of '../klp_menu.dart';

/// 計算 [KlpMenu] 彈出時的尺寸與位置，供呼叫端在插入 overlay 之前先算好座標。
abstract final class KlpMenuLayout {
	@Deprecated('Use widthOf(context) so JSON geometry is applied.')
	static double get width => KlpGeometryTheme.standard.layout.menuWidth;

	static double widthOf(BuildContext context) => _KlpMenuMetrics.width(context);

	/// 詳細選單依實際文字量測寬度，避免說明和快捷鍵互相擠壓。
	static double widthForItems(BuildContext context, List<KlpMenuItemData> items, {bool scrollable = false}) {
		final gutter = scrollable ? context.klp.geometry.control.scrollbarThickness + context.klp.space.tight : 0.0;
		if (!items.any((item) => item.description != null)) return widthOf(context) + gutter;
		double measure(String text, KlpTextRole role) {
			final painter = TextPainter(
				text: TextSpan(text: text, style: KlpTextStyles.definitionOf(role, context.klp.type).toTextStyle(context.klp.type)),
				textDirection: Directionality.of(context),
				textScaler: MediaQuery.textScalerOf(context),
			)..layout();
			final width = painter.width;
			painter.dispose();
			return width;
		}
		var width = context.klp.geometry.layout.commandMenuWidth;
		for (final item in items) {
			final title = measure(item.label, KlpMenuStyle.textRole);
			final description = measure(item.description ?? '', KlpTextRole.caption);
			final content = title > description ? title : description;
			final leading = item.iconSvg != null ? _KlpMenuMetrics.itemHeight(context) : item.icon != null ? _KlpMenuMetrics.iconSize(context) : 0.0;
			final trailing = item.shortcut == null ? 0.0 : measure(item.shortcut!, KlpTextRole.caption) + _KlpMenuMetrics.iconGap(context);
			final needed = content + leading + (leading > 0 ? _KlpMenuMetrics.iconGap(context) : 0) + trailing
				+ _KlpMenuMetrics.horizontalPadding(context) * 2 + context.klp.space.tight * 2;
			if (needed > width) width = needed;
		}
		return width.ceilToDouble() + gutter;
	}

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
