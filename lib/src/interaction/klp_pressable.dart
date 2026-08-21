import 'package:flutter/material.dart';

import 'klp_interaction_settings.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_motion_theme.dart';
import '../theme/klp_theme.dart';

class KlpPressable extends StatefulWidget {
  const KlpPressable({
    super.key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.longPressProgressColor,
    this.borderRadius,
    this.onHover,
    this.onFocusChange,
    this.showHoverBorder = true,
    this.hoverBorderColor,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? longPressProgressColor;
  final BorderRadius? borderRadius;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final bool showHoverBorder;
  final Color? hoverBorderColor;

  @override
  State<KlpPressable> createState() => _KlpPressableState();
}

class _KlpPressableState extends State<KlpPressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _longPressController;
  bool _longPressTriggered = false;
  bool _isHovered = false;
  bool _isFocused = false;

  bool get _enabled => widget.onPressed != null || widget.onLongPress != null;

  @override
  void initState() {
    super.initState();
    _longPressController = AnimationController(
      vsync: this,
      duration: KlpMotionTheme.standardMotion.longPressThreshold,
    )..addStatusListener(_handleAnimationStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _longPressController.duration = context.klpLongPressThreshold;
  }

  @override
  void didUpdateWidget(KlpPressable oldWidget) {
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

  void _handleHover(bool hovered) {
    if (_isHovered != hovered) {
      setState(() => _isHovered = hovered);
    }
    widget.onHover?.call(hovered);
  }

  void _handleFocusChange(bool focused) {
    if (_isFocused != focused) {
      setState(() => _isFocused = focused);
    }
    widget.onFocusChange?.call(focused);
  }

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final active =
        _enabled && (_isHovered || _isFocused) && widget.showHoverBorder;

    Widget content = widget.child;
    if (active) {
      content = KlpDashedBorder(
        color: widget.hoverBorderColor ?? klp.hoverBorder,
        radius: widget.borderRadius?.topLeft.x ?? klp.shape.control,
        child: content,
      );
    }

    return Listener(
      onPointerDown: widget.onLongPress == null ? null : _handlePointerDown,
      onPointerCancel: widget.onLongPress == null
          ? null
          : (_) => _resetLongPress(),
      child: InkWell(
        onTap: _enabled ? _handleTap : null,
        onTapCancel: widget.onLongPress == null ? null : _resetLongPress,
        onHover: _handleHover,
        onFocusChange: _handleFocusChange,
        splashFactory: NoSplash.splashFactory,
        splashColor: klp.color.clear,
        highlightColor: klp.color.clear,
        overlayColor: WidgetStatePropertyAll(klp.color.clear),
        borderRadius: widget.borderRadius,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            content,
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
                        color: widget.longPressProgressColor ?? klp.color.clear,
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
