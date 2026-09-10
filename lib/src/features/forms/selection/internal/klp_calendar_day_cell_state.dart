part of '../klp_calendar.dart';

class _KlpCalendarDayCellState extends State<_KlpCalendarDayCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final interactive = !widget.disabled && widget.onTap != null;
    final label = KlpText(
      widget.label,
      role: KlpTextRole.caption,
      tone: widget.disabled ? KlpTextTone.faint : KlpTextTone.automatic,
      color: widget.selected ? tokens.text : null,
    );
    final hasContent = widget.content != null;
    final content = hasContent
        ? KlpColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              label,
              KlpBox(height: context.klp.space.hairline),
              KlpExpanded(child: widget.content!),
            ],
          )
        : label;

    Widget cell = _KlpCalendarDayFrame(
      hasContent: hasContent,
      inRange: widget.inRange,
      isToday: widget.isToday,
      selected: widget.selected,
      child: content,
    );

    cell = KlpStateHighlight(
      state: widget.selected
          ? KlpHighlightState.selected
          : (_hovered && interactive
                ? KlpHighlightState.hover
                : KlpHighlightState.none),
      child: cell,
    );

    return _KlpCalendarDayInteraction(
      enabled: interactive,
      selected: widget.selected,
      onHoverChanged: (value) => setState(() => _hovered = value),
      onTap: widget.onTap,
      child: cell,
    );
  }
}
