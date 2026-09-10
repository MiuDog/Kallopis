import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../styling/legacy_theme/klp_theme.dart';

part 'klp_geometric_spinner_painter.dart';
part 'klp_geometric_spinner_state.dart';

/// 幾何圖案載入動畫。
///
/// 由四個對稱的小方塊圍繞中心旋轉，並伴隨對比色進行平滑色彩動畫，
/// 適合用於載入狀態、資料請求或背景處理中指示。
class KlpGeometricSpinner extends StatefulWidget {
  const KlpGeometricSpinner({
    super.key,
    this.size,
    this.color,
    this.contrastColor,
    this.duration,
  });

  /// 動畫尺寸（寬高等長）。預設為 `context.klp.space.iconLarge` (24px)。
  final double? size;

  /// 主幾何填色。預設為 `context.klpColors.text`。
  final Color? color;

  /// 對比幾何填色。預設為 `context.klpColors.accent`。
  final Color? contrastColor;

  /// 單次循環週期時長。
  final Duration? duration;

  @override
  State<KlpGeometricSpinner> createState() => _KlpGeometricSpinnerState();
}
