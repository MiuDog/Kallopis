part of '../klp_metrics.dart';

/// 舊版 static const 圓角階梯；新元件必須改讀 context.klp.shape。
abstract final class KlpRadius {
  static const double none = 0;
  static const double sm = 2;
  static const double md = 8;
  static const double lg = 16;
  static const double full = 9999;
  static const double control = md;
  static const double card = md;
  static const double panel = lg;
  static const double pill = full;
}
