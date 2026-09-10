import 'package:flutter/widgets.dart';

/// 寬度可調節面板容器。
class KlpResizablePane extends StatelessWidget {
  const KlpResizablePane({super.key, required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}
