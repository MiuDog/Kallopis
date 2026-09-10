part of '../../legacy_theme/klp_motion_theme.dart';

/// 此分類的預設風格 recipe；schema 的公開 static 成員保留相同值與 const 契約。

const KlpMotionTheme _defaultMotion = KlpMotionTheme(
  themeTransition: KlpScale.duration0,
  styleTransition: KlpScale.duration0,
  stateTransition: KlpScale.duration150,
  overlayEnter: KlpScale.duration150,
  overlayExit: KlpScale.duration100,
  toastDwell: KlpScale.duration500,
  tooltipDelay: KlpScale.duration400,
  longPressThreshold: KlpScale.duration500,
  standard: KlpScale.easeStandard,
  emphasized: KlpScale.easeEmphasized,
);
