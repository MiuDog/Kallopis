import 'package:flutter/services.dart';

import 'klp_flutter_text_delta.dart';
import 'klp_flutter_text_input_result.dart';
import 'klp_flutter_text_input_session.dart';
import 'klp_flutter_text_plan.dart';

/// 單一平台 callback 的 delta 序列；每步等待權威並改用最新 window。
final class KlpFlutterTextInputBatch {
	final KlpFlutterTextInputSession _session;
	bool _busy = false;

	KlpFlutterTextInputBatch(this._session);

	Future<KlpFlutterTextInputResult?> submit(
		List<TextEditingDelta> deltas, {
		required bool Function() interrupted,
		void Function(KlpFlutterTextInputResult result)? onStep,
	}) async {
		if (_busy) throw StateError('Platform delta batch is already running');

		_busy = true;
		KlpFlutterTextInputResult? last;
		try {
			for (final delta in deltas) {
				if (interrupted()) return last;
				final before = _session.projection.window;
				if (before == null) throw StateError('Editable source has no text window');
				final decoded = KlpFlutterTextDelta.decode(before, delta);
				final resolution = before.composingStartUtf8 != null && decoded.composingStartUtf8 == null ? KlpCompositionResolution.commit : null;
				last = await _session.submit(KlpFlutterTextPlan.fromDelta(decoded, resolution: resolution));
				onStep?.call(last);
				if (!last.synchronized) return last;
			}
			return last;
		}
		finally { _busy = false; }
	}
}
