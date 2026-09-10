part of '../klp_page_background_recipe.dart';

/// 線寬固定於 viewport，或隨 viewport scale 一起縮放。
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

/// 主軸、次軸、線或點的執行期外觀；null 代表沿用 semantic theme。
@immutable
class KlpPageBackgroundAxisStyle {
  KlpPageBackgroundAxisStyle({this.color, this.width}) {
    final resolvedWidth = width;
    if (resolvedWidth != null) _requirePositiveFinite(resolvedWidth, 'width');
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
