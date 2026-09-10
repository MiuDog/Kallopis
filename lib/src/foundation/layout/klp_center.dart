import 'package:flutter/widgets.dart';

/// 置中排版原語。取代 Center。
class KlpCenter extends StatelessWidget {
  const KlpCenter({
    super.key,
    this.widthFactor,
    this.heightFactor,
    required this.child,
  });

  final double? widthFactor;
  final double? heightFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}
