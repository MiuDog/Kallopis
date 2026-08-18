import 'package:flutter/material.dart';

import '../tokens/klp_scale.dart';

/// Layer 2：motion 的 semantic token。
///
/// 每個欄位描述**一種過場的角色**，不是某個元件的動畫。元件要動畫時讀這裡的角色，
/// 不自己寫 `Duration(milliseconds: 140)`——寫死的 duration 是風格不對齊最難察覺的來源，
/// 因為它不會出錯，只會讓兩個看起來一樣的元件動得不一樣快。
@immutable
class KlpMotionTheme extends ThemeExtension<KlpMotionTheme> {
  const KlpMotionTheme({
    required this.themeTransition,
    required this.styleTransition,
    required this.stateTransition,
    required this.overlayEnter,
    required this.overlayExit,
    required this.toastDwell,
    required this.tooltipDelay,
    required this.longPressThreshold,
    required this.standard,
    required this.emphasized,
  });

  /// 明暗主題切換。預設瞬間完成——整個畫面漸變會讓切換感覺遲鈍。
  final Duration themeTransition;

  /// 強調色等樣式變更。
  final Duration styleTransition;

  /// hover／focus／pressed 等互動狀態變化。這是使用者最常看到的過場。
  final Duration stateTransition;

  /// 選單、彈出層、對話框進場。
  final Duration overlayEnter;

  /// 同上，退場。退場比進場快是通用慣例——使用者已經決定要關掉了。
  final Duration overlayExit;

  /// Toast 停留時間。
  final Duration toastDwell;

  /// 游標停留多久才顯示 tooltip。
  final Duration tooltipDelay;

  /// 長按判定門檻。這不是動畫，但同屬「時間」這個維度，而且**是無障礙參數**——
  /// 行動不便的使用者需要更長的門檻。放進 theme 才能整體調整。
  final Duration longPressThreshold;

  final Curve standard;
  final Curve emphasized;

  static const KlpMotionTheme standardMotion = KlpMotionTheme(
    themeTransition: KlpScale.duration0,
    styleTransition: KlpScale.duration0,
    stateTransition: KlpScale.duration150,
    overlayEnter: KlpScale.duration150,
    overlayExit: KlpScale.duration100,
    toastDwell: KlpScale.duration500,
    tooltipDelay: KlpScale.duration400,
    longPressThreshold: KlpScale.duration500,
    standard: KlpScale.easeStandard,
    emphasized: KlpScale.easeEmphasized,
  );

  /// 尊重系統的「減少動態效果」設定。無障礙規則屬於庫的責任，不該由每個消費者各自實作
  /// ——那必然會有人漏掉。
  KlpMotionTheme reduced() => copyWith(
    stateTransition: Duration.zero,
    overlayEnter: Duration.zero,
    overlayExit: Duration.zero,
  );

  @override
  KlpMotionTheme copyWith({
    Duration? themeTransition,
    Duration? styleTransition,
    Duration? stateTransition,
    Duration? overlayEnter,
    Duration? overlayExit,
    Duration? toastDwell,
    Duration? tooltipDelay,
    Duration? longPressThreshold,
    Curve? standard,
    Curve? emphasized,
  }) {
    return KlpMotionTheme(
      themeTransition: themeTransition ?? this.themeTransition,
      styleTransition: styleTransition ?? this.styleTransition,
      stateTransition: stateTransition ?? this.stateTransition,
      overlayEnter: overlayEnter ?? this.overlayEnter,
      overlayExit: overlayExit ?? this.overlayExit,
      toastDwell: toastDwell ?? this.toastDwell,
      tooltipDelay: tooltipDelay ?? this.tooltipDelay,
      longPressThreshold: longPressThreshold ?? this.longPressThreshold,
      standard: standard ?? this.standard,
      emphasized: emphasized ?? this.emphasized,
    );
  }

  @override
  KlpMotionTheme lerp(covariant KlpMotionTheme? other, double t) {
    if (other == null) return this;
    // duration 與 curve 沒有有意義的中間值：動畫進行中改變自身時長會造成跳動，
    // 因此在中點直接切換，而不是內插。
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpMotionTheme &&
          themeTransition == other.themeTransition &&
          styleTransition == other.styleTransition &&
          stateTransition == other.stateTransition &&
          overlayEnter == other.overlayEnter &&
          overlayExit == other.overlayExit &&
          toastDwell == other.toastDwell &&
          tooltipDelay == other.tooltipDelay &&
          longPressThreshold == other.longPressThreshold &&
          standard == other.standard &&
          emphasized == other.emphasized;

  @override
  int get hashCode => Object.hashAll([
    themeTransition,
    styleTransition,
    stateTransition,
    overlayEnter,
    overlayExit,
    toastDwell,
    tooltipDelay,
    longPressThreshold,
    standard,
    emphasized,
  ]);
}
