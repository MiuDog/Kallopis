import 'package:flutter/widgets.dart';

import '../../theme/klp_theme.dart';

/// 計算面板邊界往內、由所有區域共用的水平 padding。
///
/// Frame 只負責左右 compact；上下節奏由 header、content、footer 各自決定。
/// 這與固定為 compact / 2 的 inset 是不同幾何層。
EdgeInsets resolveKlpPanelPadding(
  BuildContext context, {
  EdgeInsetsGeometry? padding,
}) {
  return (padding ??
          EdgeInsets.symmetric(horizontal: context.klp.space.compact))
      .resolve(Directionality.of(context));
}
