import 'package:flutter/material.dart';

import 'klp_component_theme.dart';
import 'klp_data_visualization_theme.dart';
import 'klp_geometry_theme.dart';
import 'klp_motion_theme.dart';
import 'klp_shape_theme.dart';
import 'klp_spacing_theme.dart';
import 'klp_surface_theme.dart';
import 'klp_theme.dart';
import 'klp_typography_theme.dart';

/// 一整套視覺風格。
///
/// 這個型別存在的理由是**讓「換一套視覺風格」成為單一動作**。若風格散落在多個
/// `ThemeExtension` 各自設定，消費者遲早會只換其中三個——換出一個圓角是方的、動畫卻還在
/// 的半套風格。把它們綁成一個必須整組給定的物件，那種狀態就無法表達。
///
/// 消費者要微調，是取一個現成風格再 [copyWith] 單一層，而不是自己拼所有 extension。
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
    this.dataVisualization = KlpDataVisualizationTheme.light,
    this.geometry = KlpGeometryTheme.standard,
  });

  final String name;
  final KlpThemeData colors;
  final KlpTypographyTheme typography;
  final KlpSpacingTheme spacing;
  final KlpShapeTheme shape;
  final KlpMotionTheme motion;
  final KlpSurfaceTheme surface;
  final KlpComponentTheme components;
  final KlpDataVisualizationTheme dataVisualization;
  final KlpGeometryTheme geometry;

  /// 預設風格：比例字體、圓角、陰影分層、寬鬆密度、有過場動畫。
  static const KlpVisualStyle defaultStyle = KlpVisualStyle(
    name: 'default',
    colors: KlpThemeData.light,
    typography: KlpTypographyTheme.proportional,
    spacing: KlpSpacingTheme.comfortableDensity,
    shape: KlpShapeTheme.standardShape,
    motion: KlpMotionTheme.standardMotion,
    surface: KlpSurfaceTheme.elevated,
    components: KlpComponentTheme.inherited,
    dataVisualization: KlpDataVisualizationTheme.light,
    geometry: KlpGeometryTheme.standard,
  );

  /// 舊名稱別名，相容於既有程式碼。
  static const KlpVisualStyle modern = defaultStyle;

  /// 取得預設風格在指定明暗模式下的完整色彩組合。
  ///
  /// 這不是第二套視覺 preset；字體、間距、形狀、動態與元件 token 都沿用
  /// [defaultStyle]，只有本來就隨明暗切換的色彩層與資料視覺化色盤成組切換。
  static KlpVisualStyle forBrightness(Brightness brightness) {
    return defaultStyle.copyWith(
      colors: brightness == Brightness.dark
          ? KlpThemeData.dark
          : KlpThemeData.light,
      dataVisualization: brightness == Brightness.dark
          ? KlpDataVisualizationTheme.dark
          : KlpDataVisualizationTheme.light,
    );
  }

  // Kallopis 只出貨 `default` 這一套，各層也只有一個 preset。
  //
  // 消費者要別的外觀，是用 [copyWith] 換掉某一層，並自己以該層的建構子給值：
  //
  // ```dart
  // KlpVisualStyle.modern.copyWith(
  //   name: 'dense',
  //   shape: KlpShapeTheme.standardShape.copyWith(control: 0, card: 0, panel: 0),
  // )
  // ```
  //
  // **庫不預先替任何產品組好第二套外觀**——那會變成在替產品做風格決定。
  //
  // 只有一套 preset 的代價是：沒有現成的對照組可以驗證「token 真的抵達畫面」。
  // 因此 `test/style_fixture.dart` 用各層的建構子就地組出一套極端值作為
  // **架構的驗收條件**——切換到它若需要改動任何元件程式碼，就代表該元件還在硬編碼。

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
    dataVisualization,
    geometry,
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
    KlpDataVisualizationTheme? dataVisualization,
    KlpGeometryTheme? geometry,
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
      dataVisualization: dataVisualization ?? this.dataVisualization,
      geometry: geometry ?? this.geometry,
    );
  }

  /// 套用系統的「減少動態效果」設定。無障礙規則由庫負責，不交給每個消費者各自實作。
  KlpVisualStyle withReducedMotion(bool reduce) =>
      reduce ? copyWith(motion: motion.reduced()) : this;
}
