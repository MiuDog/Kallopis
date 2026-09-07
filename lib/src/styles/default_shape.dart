part of '../theme/klp_shape_theme.dart';

/// 此分類的預設風格 recipe；schema 的公開 static 成員保留相同值與 const 契約。

const KlpShapeTheme _defaultShape = KlpShapeTheme(
	none: KlpScale.radius0,
	sm: KlpScale.radius50, // 2px
	control: KlpScale.radius200, // 8px
	card: KlpScale.radius200, // 8px
	panel: KlpScale.radius400, // 16px
	pill: KlpScale.radiusFull, // 9999px
	hairline: KlpScale.stroke100,
	stroke: KlpScale.stroke200,
	dashedLength: 3,
	dashedGap: 2,
	dashedOpacity: KlpScale.opacity780,
);
