import 'package:flutter/material.dart';

import 'pln_interaction_settings.dart';

class PlnPressable extends StatefulWidget {
  const PlnPressable({
    super.key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.longPressProgressColor = const Color(0x00000000),
    this.borderRadius,
    this.onHover,
    this.onFocusChange,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color longPressProgressColor;
  final BorderRadius? borderRadius;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;

  @override
  State<PlnPressable> createState() => _PlnPressableState();
}

class _PlnPressableState extends State<PlnPressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _longPressController;
  bool _longPressTriggered = false;

  bool get _enabled => widget.onPressed != null || widget.onLongPress != null;

  @override
  void initState() {
    super.initState();
    _longPressController = AnimationController(
      vsync: this,
      duration: PlnInteractionSettings.defaultThreshold,
    )..addStatusListener(_handleAnimationStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _longPressController.duration = context.plnLongPressThreshold;
  }

  @override
  void didUpdateWidget(PlnPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onLongPress == null) _resetLongPress();
  }

  @override
  void dispose() {
    _longPressController
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    super.dispose();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || widget.onLongPress == null) {
      return;
    }

    _longPressTriggered = true;
    widget.onLongPress!();
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.onLongPress == null) return;

    _longPressTriggered = false;
    _longPressController.forward(from: 0);
  }

  void _handleTap() {
    final handledByLongPress = _longPressTriggered;
    _resetLongPress();
    if (!handledByLongPress) widget.onPressed?.call();
  }

  void _resetLongPress() {
    _longPressTriggered = false;
    _longPressController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: widget.onLongPress == null ? null : _handlePointerDown,
      onPointerCancel: widget.onLongPress == null
          ? null
          : (_) => _resetLongPress(),
      child: InkWell(
        onTap: _enabled ? _handleTap : null,
        onTapCancel: widget.onLongPress == null ? null : _resetLongPress,
        onHover: widget.onHover,
        onFocusChange: widget.onFocusChange,
        splashFactory: NoSplash.splashFactory,
        splashColor: const Color(0x00000000),
        highlightColor: const Color(0x00000000),
        overlayColor: const WidgetStatePropertyAll(Color(0x00000000)),
        borderRadius: widget.borderRadius,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            widget.child,
            if (widget.onLongPress != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: widget.borderRadius ?? BorderRadius.zero,
                    child: AnimatedBuilder(
                      animation: _longPressController,
                      builder: (context, child) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _longPressController.value,
                          child: child,
                        );
                      },
                      child: ColoredBox(
                        key: const ValueKey('pln-long-press-progress'),
                        color: widget.longPressProgressColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
