part of '../klp_icon_button.dart';

class _KlpIconButtonState extends State<KlpIconButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final style = _KlpIconButtonStyle.resolve(
      klp: context.klp,
      tone: widget.tone,
      size: widget.size,
      enabled: widget.onPressed != null,
      selected: widget.selected,
      active: _hovered || _focused,
    );
    return KlpTooltip(
      message: widget.label,
      child: _KlpIconButtonFrame(
        label: widget.label,
        selected: widget.selected,
        onPressed: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        quarterTurns: widget.quarterTurns,
        style: style,
        child: KlpIcon(
          widget.icon,
          size: context.klp.space.iconBase,
          color: style.foreground,
        ),
      ),
    );
  }
}
