/// 約束排版原語使用的型別化幾何介面。
class KlpBoxConstraints {
	const KlpBoxConstraints({
		this.minWidth = 0,
		this.maxWidth = double.infinity,
		this.minHeight = 0,
		this.maxHeight = double.infinity,
	});

	final double minWidth;
	final double maxWidth;
	final double minHeight;
	final double maxHeight;
}
