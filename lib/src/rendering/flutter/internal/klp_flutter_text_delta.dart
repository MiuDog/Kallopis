import 'package:flutter/services.dart';

import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart';

typedef KlpInputReplacement = ({int startUtf8, int endUtf8, String text});

/// 平台要求的更新，並非權威投影；所有結果位移均相對更新後的視窗文字。
/// 不從組字範圍消失推定提交、取消或保存。
final class KlpFlutterTextDelta {

	final KlpEditingTextWindow before;
	final KlpInputReplacement? replacement;
	final KlpTextOffsets requested;
	final int? anchorUtf8;
	final int? focusUtf8;
	final int? composingStartUtf8;
	final int? composingEndUtf8;

	KlpFlutterTextDelta._({
		required this.before,
		required this.replacement,
		required this.requested,
		required this.anchorUtf8,
		required this.focusUtf8,
		required this.composingStartUtf8,
		required this.composingEndUtf8,
	});

	factory KlpFlutterTextDelta.decode(KlpEditingTextWindow before, TextEditingDelta delta) {
		// 先核對平台鏡像；不能沿用 Flutter 的最後寫入覆蓋策略修改另一版本。
		if (delta.oldText != before.text) throw StateError('Platform text delta is stale');

		final (range, inserted) = switch (delta) {
			TextEditingDeltaInsertion value => (TextRange.collapsed(value.insertionOffset), value.textInserted),
			TextEditingDeltaDeletion value => (value.deletedRange, ''),
			TextEditingDeltaReplacement value => (value.replacedRange, value.replacementText),
			TextEditingDeltaNonTextUpdate() => (null, ''),
			_ => throw UnsupportedError('Unsupported platform text delta'),
		};
		KlpInputReplacement? replacement;
		if (range != null) {
			if (range.start > range.end) throw ArgumentError('Platform replacement range is reversed');

			replacement = (startUtf8: before.offsets.toUtf8(range.start), endUtf8: before.offsets.toUtf8(range.end), text: inserted);
			KlpTextOffsets(inserted);
		}

		// 此副本只用於驗證平台要求，不發布新的內容版本或自行套用文件交易。
		final text = range == null ? before.text : before.text.replaceRange(range.start, range.end, inserted);
		final requested = KlpTextOffsets(text);
		final selection = delta.selection;
		int? anchor;
		int? focus;
		if (selection.baseOffset != -1 || selection.extentOffset != -1) {
			anchor = requested.toUtf8(selection.baseOffset);
			focus = requested.toUtf8(selection.extentOffset);
		}
		final composing = delta.composing;
		int? composingStart;
		int? composingEnd;
		if (composing.start != -1 || composing.end != -1) {
			if (composing.start > composing.end) throw ArgumentError('Platform composition range is reversed');

			composingStart = requested.toUtf8(composing.start);
			composingEnd = requested.toUtf8(composing.end);
			if (anchor == null) throw ArgumentError('Platform composition requires a selection');
		}

		return KlpFlutterTextDelta._(
			before: before,
			replacement: replacement,
			requested: requested,
			anchorUtf8: anchor,
			focusUtf8: focus,
			composingStartUtf8: composingStart,
			composingEndUtf8: composingEnd,
		);
	}
}
