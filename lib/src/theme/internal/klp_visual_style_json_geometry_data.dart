import '../klp_data_geometry.dart';
import 'klp_visual_style_json_helpers.dart';
import 'klp_visual_style_json_validation.dart';

const _keys = {
  'codeActionButtonSize',
  'codeHeaderHeight',
  'codeTerminalDot',
  'codeTerminalDotGap',
  'codeHeaderPaddingX',
  'codeBodyPaddingX',
  'codeLineNumberWidth',
  'codeWrappedLineWidth',
  'codeMaximumHeight',
  'codeCollapsedHeight',
  'codeDisclosureSize',
  'placeholderMinimumHeight',
  'placeholderContentPaddingY',
  'placeholderActionPaddingY',
  'placeholderHatchBand',
  'placeholderHatchGap',
  'placeholderLabelTracking',
  'placeholderDetailMaximumWidth',
  'spinnerSquareFactor',
  'spinnerOrbitFactor',
  'spinnerCornerFactor',
};

KlpDataGeometry decodeDataGeometry(KlpJsonMap json, KlpDataGeometry base) {
  const path = 'geometry.data';
  rejectUnknown(json, _keys, path);
  double read(String key, double fallback) =>
      readNonNegativeDouble(json, key, path, fallback);
  return KlpDataGeometry(
    codeActionButtonSize: read(
      'codeActionButtonSize',
      base.codeActionButtonSize,
    ),
    codeHeaderHeight: read('codeHeaderHeight', base.codeHeaderHeight),
    codeTerminalDot: read('codeTerminalDot', base.codeTerminalDot),
    codeTerminalDotGap: read('codeTerminalDotGap', base.codeTerminalDotGap),
    codeHeaderPaddingX: read('codeHeaderPaddingX', base.codeHeaderPaddingX),
    codeBodyPaddingX: read('codeBodyPaddingX', base.codeBodyPaddingX),
    codeLineNumberWidth: read('codeLineNumberWidth', base.codeLineNumberWidth),
    codeWrappedLineWidth: read(
      'codeWrappedLineWidth',
      base.codeWrappedLineWidth,
    ),
    codeMaximumHeight: read('codeMaximumHeight', base.codeMaximumHeight),
    codeCollapsedHeight: read('codeCollapsedHeight', base.codeCollapsedHeight),
    codeDisclosureSize: read('codeDisclosureSize', base.codeDisclosureSize),
    placeholderMinimumHeight: read(
      'placeholderMinimumHeight',
      base.placeholderMinimumHeight,
    ),
    placeholderContentPaddingY: read(
      'placeholderContentPaddingY',
      base.placeholderContentPaddingY,
    ),
    placeholderActionPaddingY: read(
      'placeholderActionPaddingY',
      base.placeholderActionPaddingY,
    ),
    placeholderHatchBand: read(
      'placeholderHatchBand',
      base.placeholderHatchBand,
    ),
    placeholderHatchGap: read('placeholderHatchGap', base.placeholderHatchGap),
    placeholderLabelTracking: read(
      'placeholderLabelTracking',
      base.placeholderLabelTracking,
    ),
    placeholderDetailMaximumWidth: read(
      'placeholderDetailMaximumWidth',
      base.placeholderDetailMaximumWidth,
    ),
    spinnerSquareFactor: read('spinnerSquareFactor', base.spinnerSquareFactor),
    spinnerOrbitFactor: read('spinnerOrbitFactor', base.spinnerOrbitFactor),
    spinnerCornerFactor: read('spinnerCornerFactor', base.spinnerCornerFactor),
  );
}
