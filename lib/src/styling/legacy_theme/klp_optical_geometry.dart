import 'package:flutter/foundation.dart';

/// 不改變配置語意、只校正視覺重心的幾何值。
@immutable
class KlpOpticalGeometry {
  const KlpOpticalGeometry({
    required this.menuIconOffsetY,
    required this.railBadgeInset,
    required this.statusIconOffsetY,
    required this.monoBaselineOffsetY,
    required this.uiBaselineOffsetY,
  });

  final double menuIconOffsetY;
  final double railBadgeInset;
  final double statusIconOffsetY;
  final double monoBaselineOffsetY;
  final double uiBaselineOffsetY;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpOpticalGeometry &&
          menuIconOffsetY == other.menuIconOffsetY &&
          railBadgeInset == other.railBadgeInset &&
          statusIconOffsetY == other.statusIconOffsetY &&
          monoBaselineOffsetY == other.monoBaselineOffsetY &&
          uiBaselineOffsetY == other.uiBaselineOffsetY;

  @override
  int get hashCode => Object.hash(
    menuIconOffsetY,
    railBadgeInset,
    statusIconOffsetY,
    monoBaselineOffsetY,
    uiBaselineOffsetY,
  );
}
