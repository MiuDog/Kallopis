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
    required this.control,
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

  /// 按鈕、輸入框、切換器等可操作元件。
  final double control;

  /// 卡片、清單項目等內容容器。
  final double card;

  /// 面板、對話框等大面積容器。
  final double panel;

  /// 膠囊形（標籤、徽章）。
  final double pill;

  /// 分隔線與邊框的細線寬度。
  final double hairline;

  /// 需要強調的邊框（focus ring、選取框）。
  final double stroke;

  /// 虛線描邊的節奏。不同風格的虛線疏密不同，因此屬於風格而非常數。
  final double dashedLength;
  final double dashedGap;
  final double dashedOpacity;

  static const KlpShapeTheme standardShape = KlpShapeTheme(
    none: KlpScale.radius0,
    control: KlpScale.radius100,
    card: KlpScale.radius150,
    panel: KlpScale.radius250,
    pill: KlpScale.radiusFull,
    hairline: KlpScale.stroke100,
    stroke: KlpScale.stroke200,
    dashedLength: 3,
    dashedGap: 2,
    dashedOpacity: KlpScale.opacity780,
  );

  BorderRadius get controlRadius => BorderRadius.circular(control);
  BorderRadius get cardRadius => BorderRadius.circular(card);
  BorderRadius get panelRadius => BorderRadius.circular(panel);
  BorderRadius get pillRadius => BorderRadius.circular(pill);

  @override
  KlpShapeTheme copyWith({
    double? none,
    double? control,
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
      control: control ?? this.control,
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

  @override
  KlpShapeTheme lerp(covariant KlpShapeTheme? other, double t) {
    if (other == null) return this;
    return KlpShapeTheme(
      none: lerpDouble(none, other.none, t),
      control: lerpDouble(control, other.control, t),
      card: lerpDouble(card, other.card, t),
      panel: lerpDouble(panel, other.panel, t),
      pill: lerpDouble(pill, other.pill, t),
      hairline: lerpDouble(hairline, other.hairline, t),
      stroke: lerpDouble(stroke, other.stroke, t),
      dashedLength: lerpDouble(dashedLength, other.dashedLength, t),
      dashedGap: lerpDouble(dashedGap, other.dashedGap, t),
      dashedOpacity: lerpDouble(dashedOpacity, other.dashedOpacity, t),
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpShapeTheme &&
          none == other.none &&
          control == other.control &&
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
    control,
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
