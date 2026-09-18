import 'klp_composition_attribute.dart';

/// 相對暫定文字的 UTF-8 範圍；完整文字邊界由組字封包驗證。
final class KlpCompositionSegment {
	final int startUtf8;
	final int endUtf8;
	final KlpCompositionAttribute attribute;

	KlpCompositionSegment(this.startUtf8, this.endUtf8, this.attribute) {
		if (startUtf8 < 0 || endUtf8 < startUtf8) throw ArgumentError('Invalid composition segment range');
	}
}
