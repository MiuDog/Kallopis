part of 'klp_prepared_template.dart';

/// 範圍只引用已驗證的直接子放置，每個子項恰好嵌入一次。
final class KlpPreparedChildren extends KlpPreparedTemplate {
  final KlpAxis axis;
  final KlpDistance gap;
  final int start;
  final int end;

  const KlpPreparedChildren({
    required this.axis,
    required this.gap,
    required this.start,
    required this.end,
  });

  @override
  KlpBoundTemplate materialize(List<KlpBoundTemplate> children) =>
      KlpBoundLinear(axis, gap, children.getRange(start, end));
}
