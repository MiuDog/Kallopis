part of '../klp_page_background_recipe.dart';

/// 頁面背景的不可變視覺 recipe。
@immutable
sealed class KlpPageBackgroundRecipe {
  const KlpPageBackgroundRecipe();
}

/// 只呈現目前 theme 頁面表面的背景。
final class KlpPlainPageBackgroundRecipe extends KlpPageBackgroundRecipe {
  const KlpPlainPageBackgroundRecipe();

  @override
  bool operator ==(Object other) => other is KlpPlainPageBackgroundRecipe;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// 等距橫線背景，不決定內容行高或文件排版。
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

/// 具有主軸與次軸週期的背景共用契約。
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

/// 以點徑呈現主次週期的背景。
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
  bool operator ==(Object other) =>
      other is KlpDotsPageBackgroundRecipe && equalsPeriodic(other);
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
  bool operator ==(Object other) =>
      other is KlpGridPageBackgroundRecipe && equalsPeriodic(other);
  @override
  int get hashCode => Object.hash(runtimeType, periodicHashCode);
}
