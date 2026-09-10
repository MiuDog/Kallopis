import 'package:flutter/widgets.dart';

/// 浮層容器掛載點。
class KlpOverlayHost extends StatelessWidget {
  const KlpOverlayHost({super.key, required this.child, this.overlay});

  final Widget child;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        if (overlay != null) Positioned.fill(child: overlay!),
      ],
    );
  }
}
