import 'package:flutter/widgets.dart';

import '../../../../styling/legacy_theme/klp_theme.dart';

/// Panel 底部區域的共用配方。
///
/// 不繪製背景、邊框或圓角，完全繼承父 [KlpPanelFrame] 的 surface 與裁切；
/// 只統一 footer 內容的水平 inset。
class KlpPanelFooter extends StatelessWidget {
  const KlpPanelFooter({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(horizontal: context.klp.space.chromePanelInset),
      child: child,
    );
  }
}
