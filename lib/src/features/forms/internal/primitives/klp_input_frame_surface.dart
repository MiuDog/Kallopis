part of '../klp_input_frame.dart';

/// 將 Flutter hover、focus、語意與 surface 限制在輸入框 primitive。
class _KlpInputFrameSurface extends StatelessWidget {
  const _KlpInputFrameSurface({
    required this.enabled,
    required this.readOnly,
    required this.hasError,
    required this.hovered,
    required this.focused,
    required this.onHovered,
    required this.onFocused,
    required this.child,
  });

  final bool enabled;
  final bool readOnly;
  final bool hasError;
  final bool hovered;
  final bool focused;
  final ValueChanged<bool> onHovered;
  final ValueChanged<bool> onFocused;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final state = !enabled
        ? KlpFieldFillState.disabled
        : hasError
        ? KlpFieldFillState.error
        : focused
        ? KlpFieldFillState.focused
        : hovered
        ? KlpFieldFillState.hovered
        : KlpFieldFillState.rest;
    final fill = KlpFieldStyle.colorFor(klp.color, state, surface: klp.surface);

    return MouseRegion(
      onEnter: (_) => onHovered(true),
      onExit: (_) => onHovered(false),
      child: Focus(
        onFocusChange: onFocused,
        child: Semantics(
          enabled: enabled,
          readOnly: readOnly,
          child: Container(
            height: klp.fieldHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(klp.fieldRadius),
            ),
            child: Material(type: MaterialType.transparency, child: child),
          ),
        ),
      ),
    );
  }
}
