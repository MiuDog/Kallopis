part of '../klp_icon_button.dart';

/// 圖示按鈕的已解析風格；數值只來自目前 theme。
@immutable
class _KlpIconButtonStyle {
	const _KlpIconButtonStyle._({
		required this.dimension,
		required this.radius,
		required this.background,
		required this.foreground,
	});

	final double dimension;
	final double radius;
	final Color background;
	final Color foreground;

	factory _KlpIconButtonStyle.resolve({
		required KlpTheme klp,
		required KlpIconButtonTone tone,
		required KlpIconButtonSize size,
		required bool enabled,
		required bool selected,
		required bool active,
	}) {
		final colors = klp.color;
		final dimension = switch (size) {
			KlpIconButtonSize.standard => klp.space.iconButton,
			KlpIconButtonSize.window => klp.geometry.layout.windowHeaderControlSize,
		};
		final resting = switch (tone) {
			KlpIconButtonTone.standalone => colors.component,
			KlpIconButtonTone.inline => colors.clear,
		};
		final background = selected
				? colors.selectionBackground
				: active && enabled
						? Color.alphaBlend(klp.selectionWash, colors.component)
						: resting;
		return _KlpIconButtonStyle._(
			dimension: dimension,
			radius: klp.shape.control,
			background: background,
			foreground: enabled ? colors.text : colors.textFaint,
		);
	}
}
