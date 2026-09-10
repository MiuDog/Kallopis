import 'package:flutter/widgets.dart';

import 'klp_directional_position.dart';

/// 依文字方向解析 start／end 的定位排版原語。
class KlpDirectionalPositioned extends StatelessWidget {
  const KlpDirectionalPositioned({
    super.key,
    required this.position,
    required this.child,
  });

  final KlpDirectionalPosition position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: position.start,
      top: position.top,
      end: position.end,
      bottom: position.bottom,
      width: position.width,
      height: position.height,
      child: child,
    );
  }
}
