import '../klp_data_visualization_theme.dart';
import 'klp_visual_style_json_helpers.dart';

const _keys = <String>{
  'series',
  'seriesWash',
  'axis',
  'grid',
  'gridStrong',
  'label',
  'value',
  'plotBackground',
  'crosshair',
  'marketUp',
  'marketUpWash',
  'marketDown',
  'marketDownWash',
  'marketFlat',
};

KlpDataVisualizationTheme decodeDataVisualization(
  KlpJsonMap json,
  KlpDataVisualizationTheme base,
) {
  const path = 'dataVisualization';
  rejectUnknown(json, _keys, path);
  return base.copyWith(
    series: readColors(json, 'series', path, base.series),
    seriesWash: readColors(json, 'seriesWash', path, base.seriesWash),
    axis: readColor(json, 'axis', path, base.axis),
    grid: readColor(json, 'grid', path, base.grid),
    gridStrong: readColor(json, 'gridStrong', path, base.gridStrong),
    label: readColor(json, 'label', path, base.label),
    value: readColor(json, 'value', path, base.value),
    plotBackground: readColor(
      json,
      'plotBackground',
      path,
      base.plotBackground,
    ),
    crosshair: readColor(json, 'crosshair', path, base.crosshair),
    marketUp: readColor(json, 'marketUp', path, base.marketUp),
    marketUpWash: readColor(json, 'marketUpWash', path, base.marketUpWash),
    marketDown: readColor(json, 'marketDown', path, base.marketDown),
    marketDownWash: readColor(
      json,
      'marketDownWash',
      path,
      base.marketDownWash,
    ),
    marketFlat: readColor(json, 'marketFlat', path, base.marketFlat),
  );
}

KlpJsonMap encodeDataVisualization(KlpDataVisualizationTheme v) =>
    <String, Object?>{
      'series': v.series.map(encodeColor).toList(),
      'seriesWash': v.seriesWash.map(encodeColor).toList(),
      'axis': encodeColor(v.axis),
      'grid': encodeColor(v.grid),
      'gridStrong': encodeColor(v.gridStrong),
      'label': encodeColor(v.label),
      'value': encodeColor(v.value),
      'plotBackground': encodeColor(v.plotBackground),
      'crosshair': encodeColor(v.crosshair),
      'marketUp': encodeColor(v.marketUp),
      'marketUpWash': encodeColor(v.marketUpWash),
      'marketDown': encodeColor(v.marketDown),
      'marketDownWash': encodeColor(v.marketDownWash),
      'marketFlat': encodeColor(v.marketFlat),
    };
