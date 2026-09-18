/// 編輯核心使用的邏輯像素 viewport；變更時必須重新排版。
final class KlpEditingViewport {
	final double width;
	final double height;

	const KlpEditingViewport({required this.width, required this.height});

	void validate() {
		if (!width.isFinite || !height.isFinite || width <= 0 || height <= 0) throw ArgumentError('Invalid editing viewport');
	}

	@override
	bool operator ==(Object other) => other is KlpEditingViewport && width == other.width && height == other.height;
	@override
	int get hashCode => Object.hash(width, height);
}
