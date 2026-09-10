part of '../klp_list_tile.dart';

class _KlpListTileFrameState extends State<_KlpListTileFrame> {
	bool _hovered = false;
	bool _focused = false;

	@override
	Widget build(BuildContext context) {
		final style = widget.style;
		final background = _hovered || _focused
				? Color.alphaBlend(style.highlight, style.background)
				: style.background;

		return Semantics(
			button: widget.onPressed != null,
			// 沒有 onPressed 時完全不回應互動，不投影虛假的 disabled 狀態。
			enabled: widget.onPressed != null ? true : null,
			selected: widget.selected,
			child: Material(
				color: background,
				borderRadius: BorderRadius.circular(style.radius),
				child: InkWell(
					onTap: widget.onPressed,
					onHover: (value) => setState(() => _hovered = value),
					onFocusChange: (value) => setState(() => _focused = value),
					overlayColor: WidgetStatePropertyAll(style.clear),
					borderRadius: BorderRadius.circular(style.radius),
					child: SizedBox(
						height: style.height,
						child: Padding(
							padding: style.padding,
							child: widget.child,
						),
					),
				),
			),
		);
	}
}
