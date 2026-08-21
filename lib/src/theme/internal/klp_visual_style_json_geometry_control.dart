import '../klp_control_geometry.dart';
import 'klp_visual_style_json_helpers.dart';
import 'klp_visual_style_json_validation.dart';

const _keys = {
  'fieldHeight',
  'selectionControl',
  'selectionIndicatorInset',
  'selectionIcon',
  'toggleWidth',
  'toggleHeight',
  'toggleThumb',
  'toggleInset',
  'segmentedDenseHeight',
  'segmentedDenseInset',
  'segmentedDenseItemHeight',
  'scrollbarThickness',
  'sliderTrackHeight',
  'textFieldIndicatorHeightFactor',
  'textFieldLineHeightFactor',
  'textFieldMinLines',
  'textFieldMaxLines',
  'fileExplorerRowHeightAdjustment',
};

KlpControlGeometry decodeControlGeometry(
  KlpJsonMap json,
  KlpControlGeometry base,
) {
  const path = 'geometry.control';
  rejectUnknown(json, _keys, path);
  double read(String key, double fallback) =>
      readNonNegativeDouble(json, key, path, fallback);
  return KlpControlGeometry(
    fieldHeight: read('fieldHeight', base.fieldHeight),
    selectionControl: read('selectionControl', base.selectionControl),
    selectionIndicatorInset: read(
      'selectionIndicatorInset',
      base.selectionIndicatorInset,
    ),
    selectionIcon: read('selectionIcon', base.selectionIcon),
    toggleWidth: read('toggleWidth', base.toggleWidth),
    toggleHeight: read('toggleHeight', base.toggleHeight),
    toggleThumb: read('toggleThumb', base.toggleThumb),
    toggleInset: read('toggleInset', base.toggleInset),
    segmentedDenseHeight: read(
      'segmentedDenseHeight',
      base.segmentedDenseHeight,
    ),
    segmentedDenseInset: read('segmentedDenseInset', base.segmentedDenseInset),
    segmentedDenseItemHeight: read(
      'segmentedDenseItemHeight',
      base.segmentedDenseItemHeight,
    ),
    scrollbarThickness: read('scrollbarThickness', base.scrollbarThickness),
    sliderTrackHeight: read('sliderTrackHeight', base.sliderTrackHeight),
    textFieldIndicatorHeightFactor: read(
      'textFieldIndicatorHeightFactor',
      base.textFieldIndicatorHeightFactor,
    ),
    textFieldLineHeightFactor: read(
      'textFieldLineHeightFactor',
      base.textFieldLineHeightFactor,
    ),
    textFieldMinLines: readPositiveInt(
      json,
      'textFieldMinLines',
      path,
      base.textFieldMinLines,
    ),
    textFieldMaxLines: readPositiveInt(
      json,
      'textFieldMaxLines',
      path,
      base.textFieldMaxLines,
    ),
    fileExplorerRowHeightAdjustment: read(
      'fileExplorerRowHeightAdjustment',
      base.fileExplorerRowHeightAdjustment,
    ),
  );
}
