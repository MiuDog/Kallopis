import '../klp_geometry_theme.dart';
import 'klp_visual_style_json_geometry_control.dart';
import 'klp_visual_style_json_geometry_data.dart';
import 'klp_visual_style_json_geometry_layout.dart';
import 'klp_visual_style_json_helpers.dart';

const _keys = {'control', 'data', 'layout', 'optical'};

KlpGeometryTheme decodeGeometry(KlpJsonMap json, KlpGeometryTheme base) {
  const path = 'geometry';
  rejectUnknown(json, _keys, path);
  final control = readMap(json, 'control', path);
  final data = readMap(json, 'data', path);
  final layout = readMap(json, 'layout', path);
  final optical = readMap(json, 'optical', path);
  return KlpGeometryTheme(
    control: control == null
        ? base.control
        : decodeControlGeometry(control, base.control),
    data: data == null ? base.data : decodeDataGeometry(data, base.data),
    layout: layout == null
        ? base.layout
        : decodeLayoutGeometry(layout, base.layout),
    optical: optical == null
        ? base.optical
        : decodeOpticalGeometry(optical, base.optical),
  );
}
