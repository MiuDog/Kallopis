import 'package:flutter/widgets.dart';

/// 對齊排版原語。取代產品端直接使用 Align。
class KlpAlign extends StatelessWidget {
  const KlpAlign({
    super.key,
    this.alignment = Alignment.center,
    this.shrinkWidth = false,
    required this.child,
  });

  final AlignmentGeometry alignment;
  final bool shrinkWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      widthFactor: shrinkWidth ? 1 : null,
      child: child,
    );
  }
}
