import '../klp_component_theme.dart';
import 'klp_visual_style_json_helpers.dart';
import 'klp_visual_style_json_validation.dart';

const _keys = <String>{
  'buttonRadius',
  'buttonPaddingX',
  'buttonPaddingY',
  'buttonHeight',
  'buttonBorderWidth',
  'fieldRadius',
  'fieldPaddingX',
  'fieldHeight',
  'fieldBorderWidth',
  'menuRadius',
  'menuPadding',
  'menuItemHeight',
  'cardRadius',
  'cardPadding',
  'badgeRadius',
  'badgePaddingX',
};

KlpComponentTheme decodeComponents(KlpJsonMap json, KlpComponentTheme base) {
  const path = 'components';
  rejectUnknown(json, _keys, path);
  double? read(String key, double? fallback) =>
      readNullableNonNegativeDouble(json, key, path, fallback);
  return KlpComponentTheme(
    buttonRadius: read('buttonRadius', base.buttonRadius),
    buttonPaddingX: read('buttonPaddingX', base.buttonPaddingX),
    buttonPaddingY: read('buttonPaddingY', base.buttonPaddingY),
    buttonHeight: read('buttonHeight', base.buttonHeight),
    buttonBorderWidth: read('buttonBorderWidth', base.buttonBorderWidth),
    fieldRadius: read('fieldRadius', base.fieldRadius),
    fieldPaddingX: read('fieldPaddingX', base.fieldPaddingX),
    fieldHeight: read('fieldHeight', base.fieldHeight),
    fieldBorderWidth: read('fieldBorderWidth', base.fieldBorderWidth),
    menuRadius: read('menuRadius', base.menuRadius),
    menuPadding: read('menuPadding', base.menuPadding),
    menuItemHeight: read('menuItemHeight', base.menuItemHeight),
    cardRadius: read('cardRadius', base.cardRadius),
    cardPadding: read('cardPadding', base.cardPadding),
    badgeRadius: read('badgeRadius', base.badgeRadius),
    badgePaddingX: read('badgePaddingX', base.badgePaddingX),
  );
}

KlpJsonMap encodeComponents(KlpComponentTheme v) => <String, Object?>{
  'buttonRadius': v.buttonRadius,
  'buttonPaddingX': v.buttonPaddingX,
  'buttonPaddingY': v.buttonPaddingY,
  'buttonHeight': v.buttonHeight,
  'buttonBorderWidth': v.buttonBorderWidth,
  'fieldRadius': v.fieldRadius,
  'fieldPaddingX': v.fieldPaddingX,
  'fieldHeight': v.fieldHeight,
  'fieldBorderWidth': v.fieldBorderWidth,
  'menuRadius': v.menuRadius,
  'menuPadding': v.menuPadding,
  'menuItemHeight': v.menuItemHeight,
  'cardRadius': v.cardRadius,
  'cardPadding': v.cardPadding,
  'badgeRadius': v.badgeRadius,
  'badgePaddingX': v.badgePaddingX,
};
