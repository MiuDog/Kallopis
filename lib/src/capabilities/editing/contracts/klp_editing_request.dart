import 'klp_editing_intent.dart';
import 'klp_editing_stamp.dart';

/// 事件序號與原投影綁定；重送必須沿用原請求物件。
final class KlpEditingRequest {

	final int sequence;
	final KlpEditingStamp expected;
	final String blockId;
	final KlpEditingIntent intent;

	KlpEditingRequest({required this.sequence, required this.expected, required this.blockId, required this.intent}) {
		if (sequence < 1) throw ArgumentError.value(sequence, 'sequence');
		if (blockId.trim().isEmpty) throw ArgumentError('Editing request requires a block identity');
	}
}
