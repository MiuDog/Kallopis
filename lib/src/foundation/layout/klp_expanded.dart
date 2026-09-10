import 'package:flutter/widgets.dart';

/// 彈性延伸排版原語。取代 Expanded。
class KlpExpanded extends StatelessWidget {
  const KlpExpanded({super.key, this.flex = 1, required this.child});

  final int flex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: child);
  }
}
