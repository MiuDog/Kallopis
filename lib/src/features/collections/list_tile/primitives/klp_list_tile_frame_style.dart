part of '../klp_list_tile.dart';

/// 已由 theme 解析的 ListTile 表面風格。
final class _KlpListTileFrameStyle {
	const _KlpListTileFrameStyle({
		required this.background,
		required this.highlight,
		required this.clear,
		required this.radius,
		required this.height,
		required this.padding,
	});

	factory _KlpListTileFrameStyle.resolve(
		BuildContext context, {
		required KlpFeedbackTone? tone,
		required bool selected,
		required bool compact,
	}) {
		final klp = context.klp;
		final colors = context.klpColors;
		final statusColor = switch (tone) {
			KlpFeedbackTone.warning => colors.warning,
			KlpFeedbackTone.info => colors.info,
			KlpFeedbackTone.success => colors.success,
			KlpFeedbackTone.danger => colors.danger,
			KlpFeedbackTone.neutral || null => null,
		};
		final background = statusColor != null
				? statusColor.withValues(
						alpha: selected
								? klp.surface.listStatusSelectedOpacity
								: klp.surface.listStatusOpacity,
					)
				: (selected ? colors.selectionBackground : colors.clear);

		return _KlpListTileFrameStyle(
			background: background,
			highlight: klp.selectionWash,
			clear: colors.clear,
			radius: klp.shape.control,
			height: compact ? klp.space.controlHeightSmall : null,
			padding: EdgeInsets.symmetric(
				horizontal: compact ? klp.space.tight : klp.space.controlInset,
				vertical: compact ? 0 : klp.space.controlInset,
			),
		);
	}

	final Color background;
	final Color highlight;
	final Color clear;
	final double radius;
	final double? height;
	final EdgeInsetsGeometry padding;
}
