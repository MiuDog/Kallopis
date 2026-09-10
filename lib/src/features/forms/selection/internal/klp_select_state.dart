part of '../klp_select.dart';

class _KlpSelectState extends State<KlpSelect> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final style = _KlpSelectStyle.resolve(context.klp, enabled: widget.enabled);
    final field = KlpStrokeFrame(
      role: KlpStrokeRole.field,
      state: _strokeState,
      radius: style.radius,
      child: _KlpSelectActionFrame(
        onPressed: widget.enabled ? widget.onPressed : null,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        style: style,
        child: KlpRow(
          children: [
            KlpExpanded(
              child: KlpText(
                widget.value,
                tone: widget.enabled ? KlpTextTone.primary : KlpTextTone.faint,
              ),
            ),
            KlpIcon(
              KlpIcons.chevronDown,
              size: context.klp.space.iconSmall,
              color: style.iconColor,
            ),
          ],
        ),
      ),
    );
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(widget.label, role: KlpTextRole.caption),
        const KlpGap.heightSize(KlpSpaceSize.tight),
        field,
      ],
    );
  }

  KlpStrokeState get _strokeState {
    if (!widget.enabled) return KlpStrokeState.disabled;
    if (_focused) return KlpStrokeState.focused;
    if (_hovered) return KlpStrokeState.hovered;
    return KlpStrokeState.rest;
  }
}
