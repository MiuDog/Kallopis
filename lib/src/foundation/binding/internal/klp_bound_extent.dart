part of 'klp_bound_template.dart';

/// 固定單一方向的語意尺寸；另一方向仍服從父層限制。
final class KlpBoundExtent extends KlpBoundTemplate {

	final KlpAxis axis;
	final KlpDistance extent;
	final KlpBoundTemplate child;

	const KlpBoundExtent(this.axis, this.extent, this.child);
}
