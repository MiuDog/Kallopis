import 'package:kallopis/src/capabilities/editing/contracts/klp_composition_text.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart';
import 'klp_flutter_text_delta.dart';

enum KlpCompositionResolution { commit, cancel }

/// 單一平台事件所需的核心操作；每步都必須取得權威回覆才能繼續。
final class KlpFlutterTextPlan {

	final KlpFlutterTextDelta delta;
	final List<KlpEditingIntent> edits;

	KlpFlutterTextPlan._(this.delta, Iterable<KlpEditingIntent> edits) : edits = List.unmodifiable(edits);

	factory KlpFlutterTextPlan.fromDelta(KlpFlutterTextDelta delta, {KlpCompositionResolution? resolution}) {
		final before = delta.before;
		final wasComposing = before.composingStartUtf8 != null;
		final composing = delta.composingStartUtf8 != null;
		if (resolution != null && (!wasComposing || composing)) throw ArgumentError('Composition resolution requires a terminating platform update');

		if (!wasComposing && !composing) {
			final replacement = delta.replacement;
			return KlpFlutterTextPlan._(delta, [if (replacement != null) KlpReplaceTextIntent(replacement.startUtf8, replacement.endUtf8, replacement.text)]);
		}
		if (wasComposing && !composing) {
			if (resolution == null) throw StateError('Composition termination requires an explicit platform resolution');
			if (resolution == KlpCompositionResolution.cancel) return KlpFlutterTextPlan._(delta, [const KlpCancelCompositionIntent()]);

			// 最終文字仍可能包含選字結果；先更新暫定文字，再明確提交一次。
			final start = before.composingStartUtf16!;
			final suffixLength = before.text.length - before.composingEndUtf16!;
			final end = delta.requested.text.length - suffixLength;
			_validateSurroundings(delta, start, before.composingEndUtf16!, start, end);
			final text = delta.requested.text.substring(start, end);
			final preview = before.text.substring(start, before.composingEndUtf16!);
			final length = KlpTextOffsets(text).utf8Length;
			return KlpFlutterTextPlan._(delta, [
				if (preview != text) KlpUpdateCompositionIntent(KlpCompositionText(text, length, length)),
				const KlpCommitCompositionIntent(),
			]);
		}

		// 相同前後文才可將平台組字範圍映射為核心替換範圍。
		final start = delta.requested.toUtf16(delta.composingStartUtf8!);
		final end = delta.requested.toUtf16(delta.composingEndUtf8!);
		final oldStart = wasComposing ? before.composingStartUtf16! : start;
		final oldEnd = wasComposing ? before.composingEndUtf16! : before.text.length - (delta.requested.text.length - end);
		_validateSurroundings(delta, oldStart, oldEnd, start, end);
		final text = delta.requested.text.substring(start, end);
		final provisional = KlpCompositionText(text, delta.anchorUtf8! - delta.composingStartUtf8!, delta.focusUtf8! - delta.composingStartUtf8!);
		KlpEditingIntent intent;
		if (wasComposing) {
			intent = KlpUpdateCompositionIntent(provisional);
		}
		else {
			intent = KlpBeginCompositionIntent(before.offsets.toUtf8(oldStart), before.offsets.toUtf8(oldEnd), provisional);
		}
		return KlpFlutterTextPlan._(delta, [intent]);
	}

	static void _validateSurroundings(KlpFlutterTextDelta delta, int oldStart, int oldEnd, int start, int end) {
		if (oldStart > oldEnd || start > end) throw StateError('Composition update cannot preserve surrounding text');

		delta.before.offsets.toUtf8(oldStart);
		delta.before.offsets.toUtf8(oldEnd);
		delta.requested.toUtf8(start);
		delta.requested.toUtf8(end);
		if (delta.before.text.substring(0, oldStart) != delta.requested.text.substring(0, start)
			|| delta.before.text.substring(oldEnd) != delta.requested.text.substring(end)) {
			throw StateError('Composition update changes text outside its replacement');
		}
	}
}
