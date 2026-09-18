import 'klp_text_offsets.dart';
import 'klp_composition_segment.dart';

/// 暫定文字及相對選取；允許空預覽，位移不指向已提交文件。
final class KlpCompositionText {

	final String text;
	final int anchorUtf8;
	final int focusUtf8;
	final List<KlpCompositionSegment> segments;

	KlpCompositionText(
		this.text,
		this.anchorUtf8,
		this.focusUtf8, {
		Iterable<KlpCompositionSegment> segments = const [],
	}) : segments = List.unmodifiable(segments) {
		final offsets = KlpTextOffsets(text);
		offsets.toUtf16(anchorUtf8);
		offsets.toUtf16(focusUtf8);

		// 保留核心允許的空範圍與未標註間隙，但拒絕重疊、逆序或截斷字碼。
		var priorEnd = 0;
		for (final segment in this.segments) {
			if (segment.startUtf8 < priorEnd) throw ArgumentError('Composition segments overlap or are unordered');

			offsets.toUtf16(segment.startUtf8);
			offsets.toUtf16(segment.endUtf8);
			priorEnd = segment.endUtf8;
		}
	}
}
