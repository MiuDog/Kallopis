part of '../klp_code_viewer.dart';

class _KlpCodeActionFrameState extends State<_KlpCodeActionFrame> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final active = enabled && (_hovered || _focused);
    final foreground = _resolveForeground(enabled);
    final content = _buildContent(context, foreground);
    final pressable = _buildPressable(context, content, active);
    if (widget.kind != _KlpCodeActionKind.icon) return pressable;

    return Semantics(
      button: true,
      enabled: enabled,
      selected: widget.selected,
      label: widget.label,
      child: pressable,
    );
  }

  Color _resolveForeground(bool enabled) {
    if (!enabled) return widget.style.textFaint;
    if (widget.kind == _KlpCodeActionKind.success ||
        widget.kind == _KlpCodeActionKind.danger) {
      return widget.style.onStatus;
    }
    if (widget.selected) return widget.style.selectionForeground;

    return widget.style.textMuted;
  }

  Widget _buildContent(BuildContext context, Color foreground) {
    final child = widget.builder(context, foreground);

    return switch (widget.kind) {
      _KlpCodeActionKind.icon => SizedBox.square(
        dimension: widget.style.actionButtonSize,
        child: child,
      ),
      _KlpCodeActionKind.language || _KlpCodeActionKind.headerText => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.style.microPaddingY * 2,
        ),
        child: child,
      ),
      _KlpCodeActionKind.success || _KlpCodeActionKind.danger => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.style.actionPaddingX,
          vertical: widget.style.microPaddingY,
        ),
        child: child,
      ),
    };
  }

  Widget _buildPressable(BuildContext context, Widget child, bool active) {
    final radius = BorderRadius.circular(widget.style.controlRadius);
    final background = switch (widget.kind) {
      _KlpCodeActionKind.icon when widget.selected =>
        widget.style.selectionBackground,
      _KlpCodeActionKind.icon ||
      _KlpCodeActionKind.language when active => widget.style.selectionWash,
      _KlpCodeActionKind.success => widget.style.success,
      _KlpCodeActionKind.danger => widget.style.danger,
      _ => widget.style.clear,
    };
    final ownsHighlight =
        widget.kind == _KlpCodeActionKind.icon ||
        widget.kind == _KlpCodeActionKind.language;
    final pressable = KlpPressable(
      onPressed: widget.onPressed == null
          ? null
          : () => widget.onPressed!(context),
      onHover: (value) => setState(() => _hovered = value),
      onFocusChange: (value) => setState(() => _focused = value),
      hoverHighlight: !ownsHighlight,
      borderRadius: widget.kind == _KlpCodeActionKind.headerText
          ? null
          : radius,
      child: child,
    );
    if (widget.kind == _KlpCodeActionKind.headerText) return pressable;

    return Material(color: background, borderRadius: radius, child: pressable);
  }
}
