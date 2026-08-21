import 'dart:ui';

import 'package:flutter/foundation.dart';

/// 背景線寬與點徑是否跟著 viewport 縮放。
enum KlpPageBackgroundStrokeBehavior { fixed, scaled }

/// 背景編輯器目前使用的工具。
enum KlpPageBackgroundEditorTool { connect, select, delete }

/// 可被選取的背景圖元種類。
enum KlpPageBackgroundElementKind { point, line }

/// 背景編輯器的單一選取結果；選取狀態不會寫入 recipe。
@immutable
class KlpPageBackgroundSelection {
  const KlpPageBackgroundSelection.point(this.id)
    : kind = KlpPageBackgroundElementKind.point;

  const KlpPageBackgroundSelection.line(this.id)
    : kind = KlpPageBackgroundElementKind.line;

  final KlpPageBackgroundElementKind kind;
  final int id;

  @override
  bool operator ==(Object other) {
    return other is KlpPageBackgroundSelection &&
        other.kind == kind &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(kind, id);
}

/// 頁面座標與 viewport 座標之間的單一轉換來源。
@immutable
class KlpPageBackgroundViewport {
  KlpPageBackgroundViewport({this.origin = Offset.zero, this.scale = 1}) {
    if (!_isFiniteOffset(origin)) {
      throw ArgumentError.value(origin, 'origin', 'must be finite');
    }
    _requirePositiveFinite(scale, 'scale');
  }

  final Offset origin;
  final double scale;

  Offset pageToViewport(Offset position) => (position - origin) * scale;

  Offset viewportToPage(Offset position) => position / scale + origin;

  @override
  bool operator ==(Object other) {
    return other is KlpPageBackgroundViewport &&
        other.origin == origin &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(origin, scale);
}

/// 主軸、次軸、線或點的執行期外觀。
///
/// `null` 代表沿用目前 Kallopis semantic theme。
@immutable
class KlpPageBackgroundAxisStyle {
  KlpPageBackgroundAxisStyle({this.color, this.width}) {
    final resolvedWidth = width;
    if (resolvedWidth != null) {
      _requirePositiveFinite(resolvedWidth, 'width');
    }
  }

  final Color? color;
  final double? width;

  KlpPageBackgroundAxisStyle copyWith({Color? color, double? width}) {
    return KlpPageBackgroundAxisStyle(
      color: color ?? this.color,
      width: width ?? this.width,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KlpPageBackgroundAxisStyle &&
        other.color == color &&
        other.width == width;
  }

  @override
  int get hashCode => Object.hash(color, width);
}

/// 頁面背景的不可變視覺 recipe。
@immutable
sealed class KlpPageBackgroundRecipe {
  const KlpPageBackgroundRecipe();
}

/// 只呈現目前 theme 頁面表面的背景，不包含任何圖樣。
final class KlpPlainPageBackgroundRecipe extends KlpPageBackgroundRecipe {
  const KlpPlainPageBackgroundRecipe();

  @override
  bool operator ==(Object other) => other is KlpPlainPageBackgroundRecipe;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// 等距橫線背景；只保存視覺幾何，不決定文字行高或文件排版。
final class KlpRuledPageBackgroundRecipe extends KlpPageBackgroundRecipe {
  KlpRuledPageBackgroundRecipe({
    KlpPageBackgroundAxisStyle? axis,
    this.spacing,
    this.strokeBehavior = KlpPageBackgroundStrokeBehavior.fixed,
  }) : axis = axis ?? KlpPageBackgroundAxisStyle() {
    final resolvedSpacing = spacing;
    if (resolvedSpacing != null) {
      _requirePositiveFinite(resolvedSpacing, 'spacing');
    }
  }

  final KlpPageBackgroundAxisStyle axis;
  final double? spacing;
  final KlpPageBackgroundStrokeBehavior strokeBehavior;

  KlpRuledPageBackgroundRecipe copyWith({
    KlpPageBackgroundAxisStyle? axis,
    double? spacing,
    KlpPageBackgroundStrokeBehavior? strokeBehavior,
  }) {
    return KlpRuledPageBackgroundRecipe(
      axis: axis ?? this.axis,
      spacing: spacing ?? this.spacing,
      strokeBehavior: strokeBehavior ?? this.strokeBehavior,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KlpRuledPageBackgroundRecipe &&
        other.axis == axis &&
        other.spacing == spacing &&
        other.strokeBehavior == strokeBehavior;
  }

  @override
  int get hashCode => Object.hash(axis, spacing, strokeBehavior);
}

/// 具有主軸與次軸週期的背景 recipe 共用契約。
///
/// 這個型別只定義週期幾何，不決定圖樣要以點或線呈現。
sealed class KlpPeriodicPageBackgroundRecipe extends KlpPageBackgroundRecipe {
  KlpPeriodicPageBackgroundRecipe({
    KlpPageBackgroundAxisStyle? minorAxis,
    KlpPageBackgroundAxisStyle? majorAxis,
    this.majorSpacing,
    this.minorAxisCount = 0,
    this.strokeBehavior = KlpPageBackgroundStrokeBehavior.fixed,
  }) : minorAxis = minorAxis ?? KlpPageBackgroundAxisStyle(),
       majorAxis = majorAxis ?? KlpPageBackgroundAxisStyle() {
    final resolvedSpacing = majorSpacing;
    if (resolvedSpacing != null) {
      _requirePositiveFinite(resolvedSpacing, 'majorSpacing');
    }
    if (minorAxisCount < 0) {
      throw ArgumentError.value(
        minorAxisCount,
        'minorAxisCount',
        'must not be negative',
      );
    }
  }

  final KlpPageBackgroundAxisStyle minorAxis;
  final KlpPageBackgroundAxisStyle majorAxis;
  final double? majorSpacing;
  final int minorAxisCount;
  final KlpPageBackgroundStrokeBehavior strokeBehavior;

  double? get minorSpacing {
    final spacing = majorSpacing;
    return spacing == null ? null : spacing / (minorAxisCount + 1);
  }

  bool equalsPeriodic(KlpPeriodicPageBackgroundRecipe other) {
    return other.minorAxis == minorAxis &&
        other.majorAxis == majorAxis &&
        other.majorSpacing == majorSpacing &&
        other.minorAxisCount == minorAxisCount &&
        other.strokeBehavior == strokeBehavior;
  }

  int get periodicHashCode => Object.hash(
    minorAxis,
    majorAxis,
    majorSpacing,
    minorAxisCount,
    strokeBehavior,
  );
}

/// 以點徑呈現主次週期的背景；`width` 在此代表點的直徑。
final class KlpDotsPageBackgroundRecipe
    extends KlpPeriodicPageBackgroundRecipe {
  KlpDotsPageBackgroundRecipe({
    super.minorAxis,
    super.majorAxis,
    super.majorSpacing,
    super.minorAxisCount,
    super.strokeBehavior,
  });

  KlpDotsPageBackgroundRecipe copyWith({
    KlpPageBackgroundAxisStyle? minorAxis,
    KlpPageBackgroundAxisStyle? majorAxis,
    double? majorSpacing,
    int? minorAxisCount,
    KlpPageBackgroundStrokeBehavior? strokeBehavior,
  }) {
    return KlpDotsPageBackgroundRecipe(
      minorAxis: minorAxis ?? this.minorAxis,
      majorAxis: majorAxis ?? this.majorAxis,
      majorSpacing: majorSpacing ?? this.majorSpacing,
      minorAxisCount: minorAxisCount ?? this.minorAxisCount,
      strokeBehavior: strokeBehavior ?? this.strokeBehavior,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KlpDotsPageBackgroundRecipe && equalsPeriodic(other);
  }

  @override
  int get hashCode => Object.hash(runtimeType, periodicHashCode);
}

/// 以水平與垂直線呈現主次週期的背景。
final class KlpGridPageBackgroundRecipe
    extends KlpPeriodicPageBackgroundRecipe {
  KlpGridPageBackgroundRecipe({
    super.minorAxis,
    super.majorAxis,
    super.majorSpacing,
    super.minorAxisCount,
    super.strokeBehavior,
  });

  KlpGridPageBackgroundRecipe copyWith({
    KlpPageBackgroundAxisStyle? minorAxis,
    KlpPageBackgroundAxisStyle? majorAxis,
    double? majorSpacing,
    int? minorAxisCount,
    KlpPageBackgroundStrokeBehavior? strokeBehavior,
  }) {
    return KlpGridPageBackgroundRecipe(
      minorAxis: minorAxis ?? this.minorAxis,
      majorAxis: majorAxis ?? this.majorAxis,
      majorSpacing: majorSpacing ?? this.majorSpacing,
      minorAxisCount: minorAxisCount ?? this.minorAxisCount,
      strokeBehavior: strokeBehavior ?? this.strokeBehavior,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KlpGridPageBackgroundRecipe && equalsPeriodic(other);
  }

  @override
  int get hashCode => Object.hash(runtimeType, periodicHashCode);
}

/// 自訂背景在頁面座標中的單一節點；不包含選取或 hover 狀態。
@immutable
class KlpPageBackgroundPoint {
  const KlpPageBackgroundPoint({required this.id, required this.position});

  final int id;
  final Offset position;

  @override
  bool operator ==(Object other) {
    return other is KlpPageBackgroundPoint &&
        other.id == id &&
        other.position == position;
  }

  @override
  int get hashCode => Object.hash(id, position);
}

/// 以兩個 point id 表示端點的直線；不保存重複的端點座標。
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

/// 只允許 point 與 line 的自訂背景資料。
///
/// 此 recipe 不負責產品保存、undo history 或 viewport 手勢。
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

bool _isFiniteOffset(Offset value) {
  return value.dx.isFinite && value.dy.isFinite;
}

void _requirePositiveFinite(double value, String name) {
  if (!value.isFinite || value <= 0) {
    throw ArgumentError.value(value, name, 'must be finite and positive');
  }
}
