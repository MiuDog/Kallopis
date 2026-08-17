import 'package:flutter/material.dart';

import 'klp_component_theme.dart';
import 'klp_motion_theme.dart';
import 'klp_shape_theme.dart';
import 'klp_spacing_theme.dart';
import 'klp_surface_theme.dart';
import 'klp_theme.dart';
import 'klp_typography_theme.dart';

/// 一整套視覺風格。
///
/// 這個型別存在的理由是**讓「換一套視覺風格」成為單一動作**。若風格散落在六個
/// `ThemeExtension` 各自設定，消費者遲早會只換其中三個——換出一個圓角是方的、動畫卻還在
/// 的半套風格。把它們綁成一個必須整組給定的物件，那種狀態就無法表達。
///
/// 消費者要微調，是取一個現成風格再 [copyWith] 單一層，而不是自己拼六個。
@immutable
class KlpVisualStyle {
  const KlpVisualStyle({
    required this.name,
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.shape,
    required this.motion,
    required this.surface,
    required this.components,
  });

  final String name;
  final KlpThemeData colors;
  final KlpTypographyTheme typography;
  final KlpSpacingTheme spacing;
  final KlpShapeTheme shape;
  final KlpMotionTheme motion;
  final KlpSurfaceTheme surface;
  final KlpComponentTheme components;

  /// 現代風：比例字體、圓角、陰影分層、寬鬆密度、有過場動畫。
  static const KlpVisualStyle modern = KlpVisualStyle(
    name: 'modern',
    colors: KlpThemeData.light,
    typography: KlpTypographyTheme.proportional,
    spacing: KlpSpacingTheme.comfortableDensity,
    shape: KlpShapeTheme.standardShape,
    motion: KlpMotionTheme.standardMotion,
    surface: KlpSurfaceTheme.elevated,
    components: KlpComponentTheme.inherited,
  );

  /// 終端機風：全域等寬、直角、實線框分層、高密度、無過場動畫。
  ///
  /// 這套風格的用途不只是提供一個選項，更是**架構的驗收條件**：如果切換到它需要改動
  /// 任何元件的程式碼，就代表該元件還在硬編碼風格。
  static const KlpVisualStyle terminal = KlpVisualStyle(
    name: 'terminal',
    colors: KlpThemeData.ultraDark,
    typography: KlpTypographyTheme.monospaced,
    spacing: KlpSpacingTheme.denseDensity,
    shape: KlpShapeTheme.squaredShape,
    motion: KlpMotionTheme.instantMotion,
    surface: KlpSurfaceTheme.outlined,
    components: KlpComponentTheme.squared,
  );

  /// 交給 `ThemeData.extensions` 的完整清單。少放任何一項，該層就會退回預設值而不會
  /// 報錯——因此這裡刻意不提供「部分產生」的版本。
  List<ThemeExtension<dynamic>> get extensions => <ThemeExtension<dynamic>>[
    colors,
    typography,
    spacing,
    shape,
    motion,
    surface,
    components,
  ];

  KlpVisualStyle copyWith({
    String? name,
    KlpThemeData? colors,
    KlpTypographyTheme? typography,
    KlpSpacingTheme? spacing,
    KlpShapeTheme? shape,
    KlpMotionTheme? motion,
    KlpSurfaceTheme? surface,
    KlpComponentTheme? components,
  }) {
    return KlpVisualStyle(
      name: name ?? this.name,
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      shape: shape ?? this.shape,
      motion: motion ?? this.motion,
      surface: surface ?? this.surface,
      components: components ?? this.components,
    );
  }

  /// 套用系統的「減少動態效果」設定。無障礙規則由庫負責，不交給每個消費者各自實作。
  KlpVisualStyle withReducedMotion(bool reduce) =>
      reduce ? copyWith(motion: motion.reduced()) : this;
}
