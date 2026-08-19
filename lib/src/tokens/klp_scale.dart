import 'package:flutter/widgets.dart';

/// Layer 1：primitive token（原始階梯）。
///
/// 這一層只有數值，**沒有語意**——`space400` 不知道自己會被用在哪裡。任何「這個位置該用
/// 多少」的判斷都屬於 layer 2（semantic）或 layer 3（component）。
///
/// primitive 刻意維持 `static const` 且**不可被消費者覆寫**：它是設計語言的字彙表，不是
/// 設定項。消費者要調整外觀，覆寫的是 semantic 或 component token（兩者都是
/// `ThemeExtension`），而不是重新定義「4 是多少」。
///
/// 命名採數值階梯而非 t-shirt size，因為 t-shirt size 本身就是一種語意宣稱
/// （「md 是預設」），那屬於 layer 2。
abstract final class KlpScale {
  // 間距：4 為基準格，2 為半格。刻意不是等比級數——UI 密度在小尺寸需要更細的解析度。
  static const double space0 = 0;
  static const double space50 = 2;
  static const double space100 = 4;
  static const double space200 = 8;
  static const double space250 = 10;
  static const double space300 = 12;
  static const double space400 = 16;
  static const double space600 = 24;
  static const double space800 = 32;
  static const double space1000 = 40;
  static const double space1200 = 48;
  static const double space1600 = 64;
  static const double space2400 = 96;

  // 圓角
  static const double radius0 = 0;
  static const double radius50 = 2;
  static const double radius100 = 4;
  static const double radius150 = 6;
  static const double radius200 = 8;
  static const double radius250 = 10;
  static const double radius300 = 12;
  static const double radius400 = 16;
  static const double radiusFull = 9999;

  // 線寬
  static const double stroke0 = 0;
  static const double stroke100 = 1;
  static const double stroke200 = 2;

  // 字級
  static const double font100 = 10;
  static const double font200 = 12;
  static const double font300 = 14;
  static const double font400 = 16;
  static const double font500 = 18;
  static const double font600 = 22;
  static const double font700 = 28;
  static const double font800 = 36;
  static const double font900 = 48;
  static const double font1000 = 64;

  // 行高倍率
  static const double leading100 = 1.125;
  static const double leading116 = 1.166;
  static const double leading120 = 1.200;
  static const double leading122 = 1.222;
  static const double leading127 = 1.272;
  static const double leading128 = 1.285;
  static const double leading133 = 1.333;
  static const double leading142 = 1.428;
  static const double leading150 = 1.500;
  static const double leading155 = 1.555;
  static const double leading150Legacy = 1.2;
  static const double leading200 = 1.25;
  static const double leading300 = 1.3;
  static const double leading350 = 1.35;
  static const double leading400 = 1.4;
  static const double leading450 = 1.45;
  static const double leading500 = 1.5;
  static const double leading550 = 1.55;
  static const double leading650 = 1.65;

  // 字距
  static const double tracking0 = 0;
  static const double trackingTight = -0.5;
  static const double trackingWide = 1.2;
  static const double trackingWider = 1.32;

  // 字重
  static const FontWeight weight400 = FontWeight.w400;
  static const FontWeight weight500 = FontWeight.w500;
  static const FontWeight weight600 = FontWeight.w600;
  static const FontWeight weight700 = FontWeight.w700;
  static const FontWeight weight800 = FontWeight.w800;

  // 時長。duration0 不是「沒有動畫」的同義詞，而是「這個過場刻意瞬間完成」，
  // 例如切換主題時不希望整個畫面漸變。
  static const Duration duration0 = Duration.zero;
  static const Duration duration100 = Duration(milliseconds: 120);
  static const Duration duration150 = Duration(milliseconds: 140);
  static const Duration duration400 = Duration(milliseconds: 450);
  static const Duration duration500 = Duration(milliseconds: 500);

  // 緩動
  static const Curve easeStandard = Curves.easeOutCubic;
  static const Curve easeEmphasized = Curves.easeInOutCubic;

  // 不透明度
  static const double opacity100 = 0.10;
  static const double opacity120 = 0.12;
  static const double opacity140 = 0.14;
  static const double opacity160 = 0.16;
  static const double opacity180 = 0.18;
  static const double opacity220 = 0.22;
  static const double opacity280 = 0.28;
  static const double opacity320 = 0.32;
  static const double opacity440 = 0.44;
  static const double opacity480 = 0.48;
  static const double opacity550 = 0.55;
  static const double opacity620 = 0.62;
  static const double opacity720 = 0.72;
  static const double opacity780 = 0.78;
  static const double opacity820 = 0.82;
}
