import 'klp_visual_style.dart';
import 'internal/klp_visual_style_json_colors.dart';
import 'internal/klp_visual_style_json_components.dart';
import 'internal/klp_visual_style_json_data_visualization.dart';
import 'internal/klp_visual_style_json_effects.dart';
import 'internal/klp_visual_style_json_geometry.dart';
import 'internal/klp_visual_style_json_geometry_encode.dart';
import 'internal/klp_visual_style_json_helpers.dart';
import 'internal/klp_visual_style_json_spacing.dart';
import 'internal/klp_visual_style_json_spacing_encode.dart';
import 'internal/klp_visual_style_json_surface.dart';
import 'internal/klp_visual_style_json_typography.dart';

/// [KlpVisualStyle] 唯一的 JSON 編解碼邊界。
///
/// JSON 的 curve 契約只支援四點 cubic；公開 model 仍可使用任意 `Curve`，但非
/// `Cubic` 無法無損序列化，encode 會以完整欄位路徑拋出 [FormatException]。
abstract final class KlpVisualStyleJson {
  static const int schemaVersion = 1;

  static const _keys = <String>{
    'schemaVersion',
    'name',
    'colors',
    'typography',
    'spacing',
    'shape',
    'motion',
    'surface',
    'components',
    'dataVisualization',
    'geometry',
  };

  /// 輸出完整且順序穩定的 JSON object。
  static KlpJsonMap encode(KlpVisualStyle style) => <String, Object?>{
    'schemaVersion': schemaVersion,
    'name': style.name,
    'colors': encodeColors(style.colors),
    'typography': encodeTypography(style.typography),
    'spacing': encodeSpacing(style.spacing),
    'shape': encodeShape(style.shape),
    'motion': encodeMotion(style.motion),
    'surface': encodeSurface(style.surface),
    'components': encodeComponents(style.components),
    'dataVisualization': encodeDataVisualization(style.dataVisualization),
    'geometry': encodeGeometry(style.geometry),
  };

  /// 將局部 JSON 疊加到 [base]；缺少的欄位完整沿用 base。
  static KlpVisualStyle decode(
    Map<String, Object?> json, {
    KlpVisualStyle base = KlpVisualStyle.defaultStyle,
  }) {
    rejectUnknown(json, _keys, '');
    _validateSchemaVersion(json);

    final colors = readMap(json, 'colors', '');
    final typography = readMap(json, 'typography', '');
    final spacing = readMap(json, 'spacing', '');
    final shape = readMap(json, 'shape', '');
    final motion = readMap(json, 'motion', '');
    final surface = readMap(json, 'surface', '');
    final components = readMap(json, 'components', '');
    final dataVisualization = readMap(json, 'dataVisualization', '');
    final geometry = readMap(json, 'geometry', '');

    return KlpVisualStyle(
      name: readString(json, 'name', '', base.name),
      colors: colors == null ? base.colors : decodeColors(colors, base.colors),
      typography: typography == null
          ? base.typography
          : decodeTypography(typography, base.typography),
      spacing: spacing == null
          ? base.spacing
          : decodeSpacing(spacing, base.spacing),
      shape: shape == null ? base.shape : decodeShape(shape, base.shape),
      motion: motion == null ? base.motion : decodeMotion(motion, base.motion),
      surface: surface == null
          ? base.surface
          : decodeSurface(surface, base.surface),
      components: components == null
          ? base.components
          : decodeComponents(components, base.components),
      dataVisualization: dataVisualization == null
          ? base.dataVisualization
          : decodeDataVisualization(dataVisualization, base.dataVisualization),
      geometry: geometry == null
          ? base.geometry
          : decodeGeometry(geometry, base.geometry),
    );
  }

  static void _validateSchemaVersion(KlpJsonMap json) {
    if (!json.containsKey('schemaVersion')) return;
    final value = json['schemaVersion'];
    if (value is! int || value != schemaVersion) {
      jsonError('schemaVersion', 'must be integer $schemaVersion');
    }
  }
}
