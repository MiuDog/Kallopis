import 'package:flutter/widgets.dart';

/// 絕對/相對定位排版原語。取代 Positioned。
class KlpPositioned extends StatelessWidget {
  const KlpPositioned({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  }) : fill = false;

  const KlpPositioned.fill({super.key, required this.child})
    : left = 0,
      top = 0,
      right = 0,
      bottom = 0,
      width = null,
      height = null,
      fill = true;

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final bool fill;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (fill) {
      return Positioned.fill(child: child);
    }
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }
}
