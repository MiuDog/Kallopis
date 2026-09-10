import 'package:flutter/material.dart';

import '../../../foundation/layout/klp_box_insets.dart';
import '../../../styling/legacy_theme/klp_theme.dart';

/// 透明 modal chrome 的基礎呈現原語；內容尺寸與產品語意由呼叫端提供。
class KlpModalFrame extends StatelessWidget {
  const KlpModalFrame({super.key, required this.insets, required this.child});

  final KlpBoxInsets insets;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = context.klp.color.clear;
    return Dialog(
      backgroundColor: color,
      shadowColor: color,
      elevation: 0,
      insetPadding: insets.edgeInsets.resolve(Directionality.of(context)),
      child: child,
    );
  }
}
