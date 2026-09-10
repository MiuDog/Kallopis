import 'package:flutter/widgets.dart';

/// 彈性調整排版原語。取代 Flexible。
class KlpFlexible extends StatelessWidget {
  const KlpFlexible({
    super.key,
    this.flex = 1,
    this.fit = FlexFit.loose,
    required this.child,
  });

  final int flex;
  final FlexFit fit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: child,
    );
  }
}
