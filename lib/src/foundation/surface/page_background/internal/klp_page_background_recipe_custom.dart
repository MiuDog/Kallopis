part of '../klp_page_background_recipe.dart';

/// 自訂背景在頁面座標中的單一節點。
@immutable
class KlpPageBackgroundPoint {
  const KlpPageBackgroundPoint({required this.id, required this.position});
  final int id;
  final Offset position;

  @override
  bool operator ==(Object other) =>
      other is KlpPageBackgroundPoint &&
      other.id == id &&
      other.position == position;
  @override
  int get hashCode => Object.hash(id, position);
}

/// 以兩個 point id 表示端點的直線。
@immutable
class KlpPageBackgroundLine {
  const KlpPageBackgroundLine({
    required this.id,
    required this.startPointId,
    required this.endPointId,
  });
  final int id;
  final int startPointId;
  final int endPointId;

  @override
  bool operator ==(Object other) {
    return other is KlpPageBackgroundLine &&
        other.id == id &&
        other.startPointId == startPointId &&
        other.endPointId == endPointId;
  }

  @override
  int get hashCode => Object.hash(id, startPointId, endPointId);
}

/// 只允許 point 與 line 的自訂背景資料，不保存產品狀態。
final class KlpCustomPageBackgroundRecipe extends KlpPageBackgroundRecipe {
  KlpCustomPageBackgroundRecipe({
    List<KlpPageBackgroundPoint> points = const [],
    List<KlpPageBackgroundLine> lines = const [],
    KlpPageBackgroundAxisStyle? pointStyle,
    KlpPageBackgroundAxisStyle? lineStyle,
    this.snapSpacing,
    this.strokeBehavior = KlpPageBackgroundStrokeBehavior.fixed,
  }) : points = List.unmodifiable(points),
       lines = List.unmodifiable(lines),
       pointStyle = pointStyle ?? KlpPageBackgroundAxisStyle(),
       lineStyle = lineStyle ?? KlpPageBackgroundAxisStyle() {
    final resolvedSnapSpacing = snapSpacing;
    if (resolvedSnapSpacing != null) {
      _requirePositiveFinite(resolvedSnapSpacing, 'snapSpacing');
    }
    _validateElements(this.points, this.lines);
  }

  final List<KlpPageBackgroundPoint> points;
  final List<KlpPageBackgroundLine> lines;
  final KlpPageBackgroundAxisStyle pointStyle;
  final KlpPageBackgroundAxisStyle lineStyle;
  final double? snapSpacing;
  final KlpPageBackgroundStrokeBehavior strokeBehavior;

  int get nextPointId => _nextId(points.map((point) => point.id));
  int get nextLineId => _nextId(lines.map((line) => line.id));

  KlpPageBackgroundPoint? pointById(int id) {
    for (final point in points) {
      if (point.id == id) return point;
    }
    return null;
  }

  KlpCustomPageBackgroundRecipe copyWith({
    List<KlpPageBackgroundPoint>? points,
    List<KlpPageBackgroundLine>? lines,
    KlpPageBackgroundAxisStyle? pointStyle,
    KlpPageBackgroundAxisStyle? lineStyle,
    double? snapSpacing,
    KlpPageBackgroundStrokeBehavior? strokeBehavior,
  }) {
    return KlpCustomPageBackgroundRecipe(
      points: points ?? this.points,
      lines: lines ?? this.lines,
      pointStyle: pointStyle ?? this.pointStyle,
      lineStyle: lineStyle ?? this.lineStyle,
      snapSpacing: snapSpacing ?? this.snapSpacing,
      strokeBehavior: strokeBehavior ?? this.strokeBehavior,
    );
  }

  KlpCustomPageBackgroundRecipe removePoint(int id) {
    return copyWith(
      points: [
        for (final point in points)
          if (point.id != id) point,
      ],
      lines: [
        for (final line in lines)
          if (line.startPointId != id && line.endPointId != id) line,
      ],
    );
  }

  KlpCustomPageBackgroundRecipe removeLine(int id) {
    return copyWith(
      lines: [
        for (final line in lines)
          if (line.id != id) line,
      ],
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KlpCustomPageBackgroundRecipe &&
        listEquals(other.points, points) &&
        listEquals(other.lines, lines) &&
        other.pointStyle == pointStyle &&
        other.lineStyle == lineStyle &&
        other.snapSpacing == snapSpacing &&
        other.strokeBehavior == strokeBehavior;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(points),
    Object.hashAll(lines),
    pointStyle,
    lineStyle,
    snapSpacing,
    strokeBehavior,
  );
}

void _validateElements(
  List<KlpPageBackgroundPoint> points,
  List<KlpPageBackgroundLine> lines,
) {
  final pointIds = <int>{};
  for (final point in points) {
    if (point.id < 0 || !pointIds.add(point.id)) {
      throw ArgumentError.value(point.id, 'points', 'ids must be unique');
    }
    if (!_isFiniteOffset(point.position)) {
      throw ArgumentError.value(
        point.position,
        'points',
        'positions must be finite',
      );
    }
  }

  final lineIds = <int>{};
  for (final line in lines) {
    if (line.id < 0 || !lineIds.add(line.id)) {
      throw ArgumentError.value(line.id, 'lines', 'ids must be unique');
    }
    if (line.startPointId == line.endPointId ||
        !pointIds.contains(line.startPointId) ||
        !pointIds.contains(line.endPointId)) {
      throw ArgumentError.value(line, 'lines', 'endpoints must exist');
    }
  }
}

int _nextId(Iterable<int> ids) {
  var next = 0;
  for (final id in ids) {
    if (id >= next) next = id + 1;
  }
  return next;
}

bool _isFiniteOffset(Offset value) => value.dx.isFinite && value.dy.isFinite;

void _requirePositiveFinite(double value, String name) {
  if (!value.isFinite || value <= 0) {
    throw ArgumentError.value(value, name, 'must be finite and positive');
  }
}
