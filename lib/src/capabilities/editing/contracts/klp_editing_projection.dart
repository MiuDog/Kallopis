import 'klp_editing_endpoint.dart';
import 'klp_editing_stamp.dart';
import 'klp_editing_text_window.dart';

/// 完整選取投影；沒有單段輸入視窗時仍保留穩定雙端與選取模式。
final class KlpEditingProjection {

	final KlpEditingStamp stamp;
	final KlpEditingEndpoint anchor;
	final KlpEditingEndpoint focus;
	final bool blockSelection;
	final KlpEditingTextWindow? window;

	KlpEditingProjection({
		required this.stamp,
		required this.anchor,
		required this.focus,
		required this.blockSelection,
		this.window,
	}) {
		final input = window;
		if (input == null) return;

		input.stamp.requireExact(stamp);
		if (blockSelection || anchor.blockId != focus.blockId || input.blockId != anchor.blockId) throw ArgumentError('Input window does not belong to a single text selection');
	}

	bool samePayload(KlpEditingProjection other) {
		if (anchor != other.anchor || focus != other.focus || blockSelection != other.blockSelection) return false;

		final left = window;
		final right = other.window;
		if (left == null || right == null) return left == right;

		return left.blockId == right.blockId && left.sourceStartUtf8 == right.sourceStartUtf8 && left.text == right.text
			&& left.anchorUtf8 == right.anchorUtf8 && left.focusUtf8 == right.focusUtf8
			&& left.composingStartUtf8 == right.composingStartUtf8 && left.composingEndUtf8 == right.composingEndUtf8;
	}
}
