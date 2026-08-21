import 'package:flutter/material.dart';

import '../tokens/klp_scale.dart';

/// Layer 2：形狀（圓角與線寬）的 semantic token。
///
/// 欄位以**使用位置的角色**命名而非尺寸命名：`control` 而不是 `sm`。消費者調整
/// `control` 時，所有控制項一起改變，不需要知道哪些元件恰好用了 `sm`。
@immutable
class KlpShapeTheme extends ThemeExtension<KlpShapeTheme> {
  const KlpShapeTheme({
    required this.none,
    this.sm = KlpScale.radius50,
    required this.control,
    this.controlInner = 7,
    this.toggleTrack = 4,
    required this.card,
    required this.panel,
    required this.pill,
    required this.hairline,
    required this.stroke,
    required this.dashedLength,
    required this.dashedGap,
    required this.dashedOpacity,
  });

  final double none;

  /// Checkbox、極小標籤 (radius-sm: 2px)。
  final double sm;

  /// 按鈕、輸入框等標準操作元件 (radius-md: 6px~8px)。
  final double control;
  final double controlInner;
  final double toggleTrack;

  /// 卡片、清單項目等內容容器 (radius-md: 6px~8px)。
  final double card;

  /// 面板、對話框等大面積容器 (radius-lg: 12px~16px)。
  final double panel;

  /// 膠囊形、頭像、圓形標籤 (radius-full: 9999px)。
  final double pill;

  /// 分隔線與邊框的細線寬度。
  final double hairline;

  /// 需要強調的邊框（focus ring、選取框）。
  final double stroke;

  /// 虛線描邊的節奏。
  final double dashedLength;
  final double dashedGap;
  final double dashedOpacity;

  static const KlpShapeTheme standardShape = KlpShapeTheme(
    none: KlpScale.radius0,
    sm: KlpScale.radius50, // 2px
    control: KlpScale.radius200, // 8px
    card: KlpScale.radius200, // 8px
    panel: KlpScale.radius400, // 16px
    pill: KlpScale.radiusFull, // 9999px
    hairline: KlpScale.stroke100,
    stroke: KlpScale.stroke200,
    dashedLength: 3,
    dashedGap: 2,
    dashedOpacity: KlpScale.opacity780,
  );

  BorderRadius get smRadius => BorderRadius.circular(sm);
  BorderRadius get controlRadius => BorderRadius.circular(control);
  BorderRadius get cardRadius => BorderRadius.circular(card);
  BorderRadius get panelRadius => BorderRadius.circular(panel);
  BorderRadius get pillRadius => BorderRadius.circular(pill);

  @override
  KlpShapeTheme copyWith({
    double? none,
    double? sm,
    double? control,
    double? controlInner,
    double? toggleTrack,
    double? card,
    double? panel,
    double? pill,
    double? hairline,
    double? stroke,
    double? dashedLength,
    double? dashedGap,
    double? dashedOpacity,
  }) {
    return KlpShapeTheme(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      control: control ?? this.control,
      controlInner: controlInner ?? this.controlInner,
      toggleTrack: toggleTrack ?? this.toggleTrack,
      card: card ?? this.card,
      panel: panel ?? this.panel,
      pill: pill ?? this.pill,
      hairline: hairline ?? this.hairline,
      stroke: stroke ?? this.stroke,
      dashedLength: dashedLength ?? this.dashedLength,
      dashedGap: dashedGap ?? this.dashedGap,
      dashedOpacity: dashedOpacity ?? this.dashedOpacity,
    );
  }

  /// **不做內插。**
  ///
  /// `MaterialApp` 在 theme 變更時會跑一段過場並沿路呼叫 `lerp`。各層若各自內插，
  /// 中途會出現「某幾層已經換了、某幾層還沒」的混合狀態——那正是切換深淺色時看起來
  /// 「有些元件沒有跟著變」的原因：它們不是沒變，是停在中間值上。
  ///
  /// 因此整個 token 疊層一律在中點原子性地翻轉，任何時刻都只會是完整的其中一套。
  @override
  KlpShapeTheme lerp(covariant KlpShapeTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpShapeTheme &&
          none == other.none &&
          sm == other.sm &&
          control == other.control &&
          controlInner == other.controlInner &&
          toggleTrack == other.toggleTrack &&
          card == other.card &&
          panel == other.panel &&
          pill == other.pill &&
          hairline == other.hairline &&
          stroke == other.stroke &&
          dashedLength == other.dashedLength &&
          dashedGap == other.dashedGap &&
          dashedOpacity == other.dashedOpacity;

  @override
  int get hashCode => Object.hash(
    none,
    sm,
    control,
    controlInner,
    toggleTrack,
    card,
    panel,
    pill,
    hairline,
    stroke,
    dashedLength,
    dashedGap,
    dashedOpacity,
  );
}
