import 'package:flutter/material.dart';

import 'klp_interaction_settings.dart';
import '../theme/klp_motion_theme.dart';
import '../theme/klp_theme.dart';

/// 可按壓表面的 hover／focus 視覺。
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
    this.selected = false,
    this.hoverHighlight = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? longPressProgressColor;
  final BorderRadius? borderRadius;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;

  /// 受控選取狀態；視覺完全由目前的 Kallopis theme 決定。
  final bool selected;

  /// 是否由 [KlpPressable] 自己畫 hover／focus 的高亮。
  ///
  /// 設為 `false` 的場合是「外層已經畫了狀態」——例如 [KlpButton] 本身就有底色，
  /// 再疊一層高亮只會讓它看起來髒掉。這不是關掉狀態表達，是把它交給外層。
  final bool hoverHighlight;

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
        _enabled && (_isHovered || _isFocused) && widget.hoverHighlight;

    Widget content = widget.child;
    // hover／focus 一律以高亮色表達，不畫邊框。先前這裡還有一條虛線框分支，
    // 但沒有任何呼叫端選用它——兩套語彙並存只會讓同一個狀態在不同元件長得不一樣。
    final showHighlight = widget.selected || active;
    if (showHighlight) {
      content = Stack(
        fit: StackFit.passthrough,
        children: [
          content,
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                key: const ValueKey('klp-pressable-state-highlight'),
                decoration: BoxDecoration(
                  color: widget.selected ? klp.selectedWash : klp.selectionWash,
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
          ),
        ],
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
