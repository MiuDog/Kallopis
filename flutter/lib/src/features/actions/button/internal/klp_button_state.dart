part of '../klp_button.dart';

class _KlpButtonState extends State<KlpButton> {
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) => setState(() => _hovered = value);

  void _setFocused(bool value) => setState(() => _focused = value);

  @override
  Widget build(BuildContext context) {
    // 每次建構依目前 scope 解析，保留主題切換與局部色彩覆寫的繼承。
    final style = KlpButtonStyle.resolve(
      klp: context.klp,
      tone: widget.tone,
      size:
          widget.size ??
          (widget.compact ? KlpControlSize.xs : KlpControlSize.sm),
      disabled: widget.onPressed == null,
      active: _hovered || _focused,
      selected: widget.selected,
    );

    Widget content = _KlpButtonFrame(
      style: style,
      selected: widget.selected,
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      onHover: _setHovered,
      onFocusChange: _setFocused,
      child: _KlpButtonContent(
        label: widget.label,
        leading: widget.leading,
        trailing: widget.trailing,
        style: style,
      ),
    );
    if (style.dashed) {
      content = KlpDashedBorder(radius: style.radius, child: content);
    }
    return content;
  }
}
