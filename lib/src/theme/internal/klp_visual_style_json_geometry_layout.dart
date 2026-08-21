import '../klp_layout_geometry.dart';
import '../klp_optical_geometry.dart';
import 'klp_visual_style_json_helpers.dart';
import 'klp_visual_style_json_validation.dart';

const _layoutKeys = {
  'primaryPaneWidth',
  'secondaryPaneWidth',
  'primaryPaneBreakpoint',
  'primaryPaneContentBreakpoint',
  'secondaryPaneBreakpoint',
  'menuWidth',
  'menuHeaderHeight',
  'menuItemHeight',
  'dialogMaximumWidth',
  'toastMaximumWidth',
  'inlineNoticeBreakpoint',
  'statusBarBreakpoint',
  'windowToolbarHeight',
  'windowControlButtonSize',
  'windowToolbarPaddingStart',
  'windowToolbarPaddingEnd',
  'windowAppIconSize',
  'windowIdentityGap',
};
const _opticalKeys = {
  'menuIconOffsetY',
  'railBadgeInset',
  'statusIconOffsetY',
  'monoBaselineOffsetY',
  'uiBaselineOffsetY',
};

KlpLayoutGeometry decodeLayoutGeometry(
  KlpJsonMap json,
  KlpLayoutGeometry base,
) {
  const path = 'geometry.layout';
  rejectUnknown(json, _layoutKeys, path);
  double read(String key, double fallback) =>
      readNonNegativeDouble(json, key, path, fallback);
  return KlpLayoutGeometry(
    primaryPaneWidth: read('primaryPaneWidth', base.primaryPaneWidth),
    secondaryPaneWidth: read('secondaryPaneWidth', base.secondaryPaneWidth),
    primaryPaneBreakpoint: read(
      'primaryPaneBreakpoint',
      base.primaryPaneBreakpoint,
    ),
    primaryPaneContentBreakpoint: read(
      'primaryPaneContentBreakpoint',
      base.primaryPaneContentBreakpoint,
    ),
    secondaryPaneBreakpoint: read(
      'secondaryPaneBreakpoint',
      base.secondaryPaneBreakpoint,
    ),
    menuWidth: read('menuWidth', base.menuWidth),
    menuHeaderHeight: read('menuHeaderHeight', base.menuHeaderHeight),
    menuItemHeight: read('menuItemHeight', base.menuItemHeight),
    dialogMaximumWidth: read('dialogMaximumWidth', base.dialogMaximumWidth),
    toastMaximumWidth: read('toastMaximumWidth', base.toastMaximumWidth),
    inlineNoticeBreakpoint: read(
      'inlineNoticeBreakpoint',
      base.inlineNoticeBreakpoint,
    ),
    statusBarBreakpoint: read('statusBarBreakpoint', base.statusBarBreakpoint),
    windowToolbarHeight: read('windowToolbarHeight', base.windowToolbarHeight),
    windowControlButtonSize: read(
      'windowControlButtonSize',
      base.windowControlButtonSize,
    ),
    windowToolbarPaddingStart: read(
      'windowToolbarPaddingStart',
      base.windowToolbarPaddingStart,
    ),
    windowToolbarPaddingEnd: read(
      'windowToolbarPaddingEnd',
      base.windowToolbarPaddingEnd,
    ),
    windowAppIconSize: read('windowAppIconSize', base.windowAppIconSize),
    windowIdentityGap: read('windowIdentityGap', base.windowIdentityGap),
  );
}

KlpOpticalGeometry decodeOpticalGeometry(
  KlpJsonMap json,
  KlpOpticalGeometry base,
) {
  const path = 'geometry.optical';
  rejectUnknown(json, _opticalKeys, path);
  return KlpOpticalGeometry(
    menuIconOffsetY: readDouble(
      json,
      'menuIconOffsetY',
      path,
      base.menuIconOffsetY,
    ),
    railBadgeInset: readNonNegativeDouble(
      json,
      'railBadgeInset',
      path,
      base.railBadgeInset,
    ),
    statusIconOffsetY: readDouble(
      json,
      'statusIconOffsetY',
      path,
      base.statusIconOffsetY,
    ),
    monoBaselineOffsetY: readDouble(
      json,
      'monoBaselineOffsetY',
      path,
      base.monoBaselineOffsetY,
    ),
    uiBaselineOffsetY: readDouble(
      json,
      'uiBaselineOffsetY',
      path,
      base.uiBaselineOffsetY,
    ),
  );
}
