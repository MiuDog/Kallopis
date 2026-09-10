part of 'klp_prepared_template.dart';

/// 靜態模板排列保留準備節點，直到所有子放置完成後才展開。
final class KlpPreparedLinear extends KlpPreparedTemplate {
  final KlpAxis axis;
  final KlpDistance gap;
  final List<KlpPreparedTemplate> content;

  KlpPreparedLinear(this.axis, this.gap, Iterable<KlpPreparedTemplate> content)
    : content = List.unmodifiable(content);

  @override
  KlpBoundTemplate materialize(List<KlpBoundTemplate> children) =>
      KlpBoundLinear(
        axis,
        gap,
        content.map((entry) => entry.materialize(children)),
      );
}
