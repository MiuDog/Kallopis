part of 'klp_editing_intent.dart';

/// 明確指定組字取代範圍，後續預覽交由權威更新。
final class KlpBeginCompositionIntent extends KlpEditingIntent {

	final int startUtf8;
	final int endUtf8;
	final KlpCompositionText provisional;

	KlpBeginCompositionIntent(this.startUtf8, this.endUtf8, this.provisional) {
		if (startUtf8 < 0 || endUtf8 < startUtf8) throw ArgumentError('Composition replacement must be ordered and nonnegative');
	}
}
