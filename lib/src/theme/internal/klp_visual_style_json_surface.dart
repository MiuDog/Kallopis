import '../klp_surface_theme.dart';
import 'klp_visual_style_json_helpers.dart';
import 'klp_visual_style_json_validation.dart';

const _keys = {
  'separation',
  'overlayBlur',
  'overlaySpread',
  'overlayOffsetY',
  'overlayShadowOpacity',
  'scrimOpacity',
  'selectionWashOpacity',
  'statusFillOpacity',
  'pressProgressOpacity',
  'diffFillOpacity',
  'gridLineOpacity',
  'veilOpacity',
  'statusRowOpacity',
  'statusRowSelectedOpacity',
  'statusRowOpacityDark',
  'statusRowSelectedOpacityDark',
  'frostedOpacity',
  'frostedVeilOpacity',
  'backdropBlurSigma',
  'dragOpacity',
  'listStatusOpacity',
  'listStatusSelectedOpacity',
  'accentSoftOpacityLight',
  'accentSoftOpacityDark',
  'windowPaneOpacityLight',
  'windowPaneOpacityDark',
  'invalidFillOpacity',
};

KlpSurfaceTheme decodeSurface(KlpJsonMap json, KlpSurfaceTheme base) {
  const path = 'surface';
  rejectUnknown(json, _keys, path);
  double size(String key, double fallback) =>
      readNonNegativeDouble(json, key, path, fallback);
  double alpha(String key, double fallback) =>
      readOpacity(json, key, path, fallback);
  return base.copyWith(
    separation: readEnum(
      json,
      'separation',
      path,
      base.separation,
      KlpSurfaceSeparation.values,
    ),
    overlayBlur: size('overlayBlur', base.overlayBlur),
    overlaySpread: size('overlaySpread', base.overlaySpread),
    overlayOffsetY: readDouble(
      json,
      'overlayOffsetY',
      path,
      base.overlayOffsetY,
    ),
    overlayShadowOpacity: alpha(
      'overlayShadowOpacity',
      base.overlayShadowOpacity,
    ),
    scrimOpacity: alpha('scrimOpacity', base.scrimOpacity),
    selectionWashOpacity: alpha(
      'selectionWashOpacity',
      base.selectionWashOpacity,
    ),
    statusFillOpacity: alpha('statusFillOpacity', base.statusFillOpacity),
    pressProgressOpacity: alpha(
      'pressProgressOpacity',
      base.pressProgressOpacity,
    ),
    diffFillOpacity: alpha('diffFillOpacity', base.diffFillOpacity),
    gridLineOpacity: alpha('gridLineOpacity', base.gridLineOpacity),
    veilOpacity: alpha('veilOpacity', base.veilOpacity),
    statusRowOpacity: alpha('statusRowOpacity', base.statusRowOpacity),
    statusRowSelectedOpacity: alpha(
      'statusRowSelectedOpacity',
      base.statusRowSelectedOpacity,
    ),
    statusRowOpacityDark: alpha(
      'statusRowOpacityDark',
      base.statusRowOpacityDark,
    ),
    statusRowSelectedOpacityDark: alpha(
      'statusRowSelectedOpacityDark',
      base.statusRowSelectedOpacityDark,
    ),
    frostedOpacity: alpha('frostedOpacity', base.frostedOpacity),
    frostedVeilOpacity: alpha('frostedVeilOpacity', base.frostedVeilOpacity),
    backdropBlurSigma: size('backdropBlurSigma', base.backdropBlurSigma),
    dragOpacity: alpha('dragOpacity', base.dragOpacity),
    listStatusOpacity: alpha('listStatusOpacity', base.listStatusOpacity),
    listStatusSelectedOpacity: alpha(
      'listStatusSelectedOpacity',
      base.listStatusSelectedOpacity,
    ),
    accentSoftOpacityLight: alpha(
      'accentSoftOpacityLight',
      base.accentSoftOpacityLight,
    ),
    accentSoftOpacityDark: alpha(
      'accentSoftOpacityDark',
      base.accentSoftOpacityDark,
    ),
    windowPaneOpacityLight: alpha(
      'windowPaneOpacityLight',
      base.windowPaneOpacityLight,
    ),
    windowPaneOpacityDark: alpha(
      'windowPaneOpacityDark',
      base.windowPaneOpacityDark,
    ),
    invalidFillOpacity: alpha('invalidFillOpacity', base.invalidFillOpacity),
  );
}

KlpJsonMap encodeSurface(KlpSurfaceTheme v) => <String, Object?>{
  'separation': v.separation.name,
  'overlayBlur': v.overlayBlur,
  'overlaySpread': v.overlaySpread,
  'overlayOffsetY': v.overlayOffsetY,
  'overlayShadowOpacity': v.overlayShadowOpacity,
  'scrimOpacity': v.scrimOpacity,
  'selectionWashOpacity': v.selectionWashOpacity,
  'statusFillOpacity': v.statusFillOpacity,
  'pressProgressOpacity': v.pressProgressOpacity,
  'diffFillOpacity': v.diffFillOpacity,
  'gridLineOpacity': v.gridLineOpacity,
  'veilOpacity': v.veilOpacity,
  'statusRowOpacity': v.statusRowOpacity,
  'statusRowSelectedOpacity': v.statusRowSelectedOpacity,
  'statusRowOpacityDark': v.statusRowOpacityDark,
  'statusRowSelectedOpacityDark': v.statusRowSelectedOpacityDark,
  'frostedOpacity': v.frostedOpacity,
  'frostedVeilOpacity': v.frostedVeilOpacity,
  'backdropBlurSigma': v.backdropBlurSigma,
  'dragOpacity': v.dragOpacity,
  'listStatusOpacity': v.listStatusOpacity,
  'listStatusSelectedOpacity': v.listStatusSelectedOpacity,
  'accentSoftOpacityLight': v.accentSoftOpacityLight,
  'accentSoftOpacityDark': v.accentSoftOpacityDark,
  'windowPaneOpacityLight': v.windowPaneOpacityLight,
  'windowPaneOpacityDark': v.windowPaneOpacityDark,
  'invalidFillOpacity': v.invalidFillOpacity,
};
