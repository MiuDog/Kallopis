part of 'klp_input_frame.dart';

/// 持有輸入外框的 hover 與 focus 呈現狀態。
class _KlpInputFrameState extends State<KlpInputFrame> {
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;

    setState(() => _hovered = value);
  }

  void _setFocused(bool value) {
    if (_focused == value) return;

    setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(widget.label, role: KlpTextRole.caption),
        const KlpGap.heightSize(KlpSpaceSize.tight),
        _KlpInputFrameSurface(
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          hasError: widget.error != null,
          hovered: _hovered,
          focused: _focused,
          onHovered: _setHovered,
          onFocused: _setFocused,
          child: widget.child,
        ),
        if (widget.error != null) ...[
          const KlpGap.heightSize(KlpSpaceSize.tight),
          KlpText(
            widget.error!,
            role: KlpTextRole.caption,
            tone: KlpTextTone.danger,
          ),
        ],
      ],
    );
  }
}
