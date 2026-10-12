import 'package:flutter/widgets.dart';

/// 具備主題捲軸樣式的單向捲動容器。
class KlpScrollViewport extends StatelessWidget {
  const KlpScrollViewport({
    super.key,
    required this.child,
    this.controller,
    this.padding,
  });

  final Widget child;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      padding: padding,
      child: child,
    );
  }
}
