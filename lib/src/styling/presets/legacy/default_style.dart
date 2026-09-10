part of '../../legacy_theme/klp_visual_style.dart';

/// 預設風格的唯一組裝表；公開入口維持 `KlpVisualStyle.defaultStyle`。
/// 此檔共用風格模型的函式庫，避免模型與預設組裝產生雙向 import。
const KlpVisualStyle _defaultStyle = KlpVisualStyle(
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
