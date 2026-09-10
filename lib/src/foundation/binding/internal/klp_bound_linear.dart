part of 'klp_bound_template.dart';

/// 已綁定的線性組合，位置由模板順序決定。
final class KlpBoundLinear extends KlpBoundTemplate {

	final KlpAxis axis;
	final KlpDistance gap;
	final List<KlpBoundTemplate> children;

	KlpBoundLinear(this.axis, this.gap, Iterable<KlpBoundTemplate> children) : children = List.unmodifiable(children);
}
