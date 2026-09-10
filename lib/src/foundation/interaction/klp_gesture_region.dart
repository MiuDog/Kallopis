import 'package:flutter/widgets.dart';

/// 將產品事件接線隔離於 Kallopis 互動邊界內。
class KlpGestureRegion extends StatelessWidget {
  const KlpGestureRegion({
    super.key,
    this.behavior,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    required this.child,
  });

  final HitTestBehavior? behavior;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureTapCallback? onSecondaryTap;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
      onSecondaryTapDown: onSecondaryTapDown,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: child,
    );
  }
}
