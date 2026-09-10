/// 方向感知定位原語的幾何介面。
class KlpDirectionalPosition {
  const KlpDirectionalPosition({
    this.start,
    this.top,
    this.end,
    this.bottom,
    this.width,
    this.height,
  });

  const KlpDirectionalPosition.fill()
    : start = 0,
      top = 0,
      end = 0,
      bottom = 0,
      width = null,
      height = null;

  const KlpDirectionalPosition.below({required this.top})
    : start = 0,
      end = 0,
      bottom = 0,
      width = null,
      height = null;

  const KlpDirectionalPosition.atTop({required this.height})
    : start = 0,
      top = 0,
      end = 0,
      bottom = null,
      width = null;

  final double? start;
  final double? top;
  final double? end;
  final double? bottom;
  final double? width;
  final double? height;
}
