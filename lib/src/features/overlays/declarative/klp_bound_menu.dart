import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'klp_menu_item.dart';

/// 選單已解析的呈現資料；事件僅在目前 frame 有效。
final class KlpBoundMenu extends KlpBoundTemplate {

	final KlpBoundMenuStyle style;
	final List<KlpMenuItem> items;
	final String label;
	final String? triggerLabel;
	final bool autofocus;
	final void Function()? onEscape;

	KlpBoundMenu({
		required this.style,
		required List<KlpMenuItem> items,
		required this.label,
		required this.autofocus,
		this.onEscape,
		this.triggerLabel,
	}) : items = List.unmodifiable(items);
}

/// 唯一語意解析產生的純 Dart 選單樣式，renderer 不提供預設值。
final class KlpBoundMenuStyle {

	final KlpColor surface, foreground, muted, interaction, destructive, shadow, toggleOffTrack;
	final double width, rowExtent, headerExtent, padding, inset, gap, itemGap, iconExtent, iconOffset;
	final double panelRadius, itemRadius, stroke, dashLength, dashGap, shadowBlur, shadowOffset;
	final double toggleWidth, toggleHeight, toggleThumb, toggleInset, toggleTrackRadius, toggleThumbRadius;
	final KlpBoundTextStyle text;

	const KlpBoundMenuStyle({
		required this.surface,
		required this.foreground,
		required this.muted,
		required this.interaction,
		required this.destructive,
		required this.shadow,
		required this.toggleOffTrack,
		required this.width,
		required this.rowExtent,
		required this.headerExtent,
		required this.padding,
		required this.inset,
		required this.gap,
		required this.itemGap,
		required this.iconExtent,
		required this.iconOffset,
		required this.panelRadius,
		required this.itemRadius,
		required this.stroke,
		required this.dashLength,
		required this.dashGap,
		required this.shadowBlur,
		required this.shadowOffset,
		required this.toggleWidth,
		required this.toggleHeight,
		required this.toggleThumb,
		required this.toggleInset,
		required this.toggleTrackRadius,
		required this.toggleThumbRadius,
		required this.text,
	});
}
