part of 'klp_editing_intent.dart';

/// 相對目前輸入視窗的替換範圍，由提交閘門驗證文字邊界。
final class KlpReplaceTextIntent extends KlpEditingIntent {

	final int startUtf8;
	final int endUtf8;
	final String text;

	KlpReplaceTextIntent(this.startUtf8, this.endUtf8, this.text) {
		if (startUtf8 < 0 || endUtf8 < startUtf8) throw ArgumentError('Replacement range must be ordered and nonnegative');

		// 拒絕非法文字，而不是讓平台編碼器替換成另一份內容。
		KlpTextOffsets(text);
	}
}

