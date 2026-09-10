part of '../klp_segmented_control.dart';

class _KlpSegmentState extends State<_KlpSegment> {
	bool _hovered = false;

	@override
	Widget build(BuildContext context) {
		final style = _KlpSegmentStyle.resolve(
			context.klp,
			selected: widget.selected,
			hovered: _hovered,
			dense: widget.dense,
		);
		return _KlpSegmentFrame(
			label: widget.label,
			selected: widget.selected,
			onPressed: widget.onPressed,
			onHover: (value) => setState(() => _hovered = value),
			style: style,
			child: KlpRow(
				mainAxisSize: MainAxisSize.min,
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					if (widget.icon != null) ...[
						KlpIcon(
							widget.icon!,
							size: widget.dense ? context.klp.space.iconSmall : context.klp.space.icon,
							color: style.iconColor,
						),
						const KlpGap.widthSize(KlpSpaceSize.contentInline),
					],
					KlpFlexible(
						child: KlpText(
							widget.label,
							role: widget.dense ? KlpTextRole.caption : KlpTextRole.body,
							tone: widget.selected ? KlpTextTone.primary : KlpTextTone.muted,
							maxLines: 1,
							overflow: TextOverflow.ellipsis,
						),
					),
				],
			),
		);
	}
}
