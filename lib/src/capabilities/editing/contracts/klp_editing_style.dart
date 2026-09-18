/// 舊正文標記的呈現格式；不在 Kallopis 建立清單資料權威。
enum KlpEditingMarkerFormat { bulletAndDecimal }

/// Kallopis 已完整解析的核心排版值；提供者只能核對支援能力後整套採用。
final class KlpEditingStyle {
	final String fontFamily;
	final List<String> fontFallbacks;
	final int fontWeight;
	final double fontSize;
	final double lineHeight;
	final double letterSpacing;
	final double horizontalPadding;
	final double verticalPadding;
	final double blockSpacing;
	final double overscan;
	final int textRgba;
	final int inkRgba;
	final int caretRgba;
	final double listIndent;
	final double markerGap;
	final double minimumBodyEm;
	final int markerRgba;
	final KlpEditingMarkerFormat markerFormat;

	KlpEditingStyle({
		required this.fontFamily,
		Iterable<String> fontFallbacks = const [],
		required this.fontWeight,
		required this.fontSize,
		required this.lineHeight,
		required this.letterSpacing,
		required this.horizontalPadding,
		required this.verticalPadding,
		required this.blockSpacing,
		required this.overscan,
		required this.textRgba,
		required this.inkRgba,
		required this.caretRgba,
		required this.listIndent,
		required this.markerGap,
		required this.minimumBodyEm,
		required this.markerRgba,
		required this.markerFormat,
	}) : fontFallbacks = List.unmodifiable(fontFallbacks) {
		if (fontFamily.trim().isEmpty || fontFamily != fontFamily.trim()) throw ArgumentError('Invalid editing font family');
		if (this.fontFallbacks.any((value) => value.trim().isEmpty || value != value.trim())) throw ArgumentError('Invalid editing font fallback');
		if (fontWeight < 1 || fontWeight > 1000) throw ArgumentError('Invalid editing font weight');
		if (![fontSize, lineHeight].every((value) => value.isFinite && value > 0)) throw ArgumentError('Invalid editing type metrics');
		if (!letterSpacing.isFinite) throw ArgumentError('Invalid editing letter spacing');
		if (![horizontalPadding, verticalPadding, blockSpacing, overscan].every((value) => value.isFinite && value >= 0)) throw ArgumentError('Invalid editing geometry');
		if (![listIndent, markerGap].every((value) => value.isFinite && value >= 0) || !minimumBodyEm.isFinite || minimumBodyEm <= 0) throw ArgumentError('Invalid editing list geometry');
		if (![textRgba, inkRgba, caretRgba, markerRgba].every((value) => value >= 0 && value <= 0xffffffff)) throw ArgumentError('Invalid editing color');
	}

	@override
	bool operator ==(Object other) => other is KlpEditingStyle
		&& fontFamily == other.fontFamily && _sameList(fontFallbacks, other.fontFallbacks) && fontWeight == other.fontWeight && fontSize == other.fontSize
		&& lineHeight == other.lineHeight && letterSpacing == other.letterSpacing
		&& horizontalPadding == other.horizontalPadding && verticalPadding == other.verticalPadding
		&& blockSpacing == other.blockSpacing && overscan == other.overscan
		&& textRgba == other.textRgba && inkRgba == other.inkRgba && caretRgba == other.caretRgba
		&& listIndent == other.listIndent && markerGap == other.markerGap && minimumBodyEm == other.minimumBodyEm
		&& markerRgba == other.markerRgba && markerFormat == other.markerFormat;
	@override
	int get hashCode => Object.hash(fontFamily, Object.hashAll(fontFallbacks), fontWeight, fontSize, lineHeight, letterSpacing, horizontalPadding, verticalPadding, blockSpacing, overscan, textRgba, inkRgba, caretRgba, listIndent, markerGap, minimumBodyEm, markerRgba, markerFormat);

	bool _sameList(List<String> left, List<String> right) {
		if (left.length != right.length) return false;
		for (var index = 0; index < left.length; index++) {
			if (left[index] != right[index]) return false;
		}
		return true;
	}
}
