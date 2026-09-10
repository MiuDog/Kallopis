part of '../klp_oklch_color_picker.dart';

class _KlpOklchPlaneFrame extends StatelessWidget {
  const _KlpOklchPlaneFrame({
    required this.focusNode,
    required this.enabled,
    required this.style,
    required this.onFocusChange,
    required this.onKeyEvent,
    required this.onTapDown,
    required this.onPanDown,
    required this.onPanUpdate,
    required this.painter,
  });

  final FocusNode focusNode;
  final bool enabled;
  final _KlpOklchPlaneStyle style;
  final ValueChanged<bool> onFocusChange;
  final FocusOnKeyEventCallback onKeyEvent;
  final GestureTapDownCallback? onTapDown;
  final GestureDragDownCallback? onPanDown;
  final GestureDragUpdateCallback? onPanUpdate;
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      onKeyEvent: onKeyEvent,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(style.radius),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: onTapDown,
            onPanDown: onPanDown,
            onPanUpdate: onPanUpdate,
            child: CustomPaint(painter: painter),
          ),
        ),
      ),
    );
  }
}
