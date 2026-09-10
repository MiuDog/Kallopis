import 'package:flutter/widgets.dart';

import 'klp_fit_mode.dart';

/// 依型別化縮放策略調整子元件尺寸的排版原語。
class KlpFit extends StatelessWidget {
  const KlpFit({super.key, required this.mode, required this.child});

  final KlpFitMode mode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: switch (mode) {
        KlpFitMode.contain => BoxFit.contain,
        KlpFitMode.cover => BoxFit.cover,
        KlpFitMode.fill => BoxFit.fill,
        KlpFitMode.scaleDown => BoxFit.scaleDown,
        KlpFitMode.fitWidth => BoxFit.fitWidth,
        KlpFitMode.fitHeight => BoxFit.fitHeight,
        KlpFitMode.none => BoxFit.none,
      },
      child: child,
    );
  }
}
