part of 'klp_editing_intent.dart';

/// 選取保留 anchor／focus 方向，不能由大小排序取代。
final class KlpSelectTextIntent extends KlpEditingIntent {

	final int anchorUtf8;
	final int focusUtf8;

	KlpSelectTextIntent(this.anchorUtf8, this.focusUtf8) {
		if (anchorUtf8 < 0 || focusUtf8 < 0) throw ArgumentError('Selection offsets must be nonnegative');
	}
}
