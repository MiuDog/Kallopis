import '../klp_motion_theme.dart';
import '../klp_shape_theme.dart';
import 'klp_visual_style_json_helpers.dart';
import 'klp_visual_style_json_validation.dart';

const _shapeKeys = {
  'none',
  'sm',
  'control',
  'controlInner',
  'toggleTrack',
  'card',
  'panel',
  'pill',
  'hairline',
  'stroke',
  'dashedLength',
  'dashedGap',
  'dashedOpacity',
};
const _motionKeys = {
  'themeTransition',
  'styleTransition',
  'stateTransition',
  'overlayEnter',
  'overlayExit',
  'toastDwell',
  'tooltipDelay',
  'tooltipDwell',
  'spinnerCycle',
  'longPressThreshold',
  'standard',
  'emphasized',
};

KlpShapeTheme decodeShape(KlpJsonMap json, KlpShapeTheme base) {
  const path = 'shape';
  rejectUnknown(json, _shapeKeys, path);
  double read(String key, double fallback) =>
      readNonNegativeDouble(json, key, path, fallback);
  return base.copyWith(
    none: read('none', base.none),
    sm: read('sm', base.sm),
    control: read('control', base.control),
    controlInner: read('controlInner', base.controlInner),
    toggleTrack: read('toggleTrack', base.toggleTrack),
    card: read('card', base.card),
    panel: read('panel', base.panel),
    pill: read('pill', base.pill),
    hairline: read('hairline', base.hairline),
    stroke: read('stroke', base.stroke),
    dashedLength: read('dashedLength', base.dashedLength),
    dashedGap: read('dashedGap', base.dashedGap),
    dashedOpacity: readOpacity(json, 'dashedOpacity', path, base.dashedOpacity),
  );
}

KlpJsonMap encodeShape(KlpShapeTheme v) => <String, Object?>{
  'none': v.none,
  'sm': v.sm,
  'control': v.control,
  'controlInner': v.controlInner,
  'toggleTrack': v.toggleTrack,
  'card': v.card,
  'panel': v.panel,
  'pill': v.pill,
  'hairline': v.hairline,
  'stroke': v.stroke,
  'dashedLength': v.dashedLength,
  'dashedGap': v.dashedGap,
  'dashedOpacity': v.dashedOpacity,
};

KlpMotionTheme decodeMotion(KlpJsonMap json, KlpMotionTheme base) {
  const path = 'motion';
  rejectUnknown(json, _motionKeys, path);
  return base.copyWith(
    themeTransition: readDuration(
      json,
      'themeTransition',
      path,
      base.themeTransition,
    ),
    styleTransition: readDuration(
      json,
      'styleTransition',
      path,
      base.styleTransition,
    ),
    stateTransition: readDuration(
      json,
      'stateTransition',
      path,
      base.stateTransition,
    ),
    overlayEnter: readDuration(json, 'overlayEnter', path, base.overlayEnter),
    overlayExit: readDuration(json, 'overlayExit', path, base.overlayExit),
    toastDwell: readDuration(json, 'toastDwell', path, base.toastDwell),
    tooltipDelay: readDuration(json, 'tooltipDelay', path, base.tooltipDelay),
    tooltipDwell: readDuration(json, 'tooltipDwell', path, base.tooltipDwell),
    spinnerCycle: readDuration(json, 'spinnerCycle', path, base.spinnerCycle),
    longPressThreshold: readDuration(
      json,
      'longPressThreshold',
      path,
      base.longPressThreshold,
    ),
    standard: readCurve(json, 'standard', path, base.standard),
    emphasized: readCurve(json, 'emphasized', path, base.emphasized),
  );
}

KlpJsonMap encodeMotion(KlpMotionTheme v) => <String, Object?>{
  'themeTransition': encodeDuration(
    v.themeTransition,
    'motion.themeTransition',
  ),
  'styleTransition': encodeDuration(
    v.styleTransition,
    'motion.styleTransition',
  ),
  'stateTransition': encodeDuration(
    v.stateTransition,
    'motion.stateTransition',
  ),
  'overlayEnter': encodeDuration(v.overlayEnter, 'motion.overlayEnter'),
  'overlayExit': encodeDuration(v.overlayExit, 'motion.overlayExit'),
  'toastDwell': encodeDuration(v.toastDwell, 'motion.toastDwell'),
  'tooltipDelay': encodeDuration(v.tooltipDelay, 'motion.tooltipDelay'),
  'tooltipDwell': encodeDuration(v.tooltipDwell, 'motion.tooltipDwell'),
  'spinnerCycle': encodeDuration(v.spinnerCycle, 'motion.spinnerCycle'),
  'longPressThreshold': encodeDuration(
    v.longPressThreshold,
    'motion.longPressThreshold',
  ),
  'standard': encodeCurve(v.standard, 'motion.standard'),
  'emphasized': encodeCurve(v.emphasized, 'motion.emphasized'),
};
