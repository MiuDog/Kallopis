import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_block_note_web_session_loader.dart';

void main() {
	test('initial failure can retry once without replaying a successfully opened document', () async {
		var attempts = 0;
		final retryCompleted = Completer<void>();
		final reports = <(Object, StackTrace)>[];
		final initialError = StateError('bridge readiness timeout');
		final loader = KlpBlockNoteWebSessionLoader(() async {
			if (++attempts == 1) throw initialError;
			await retryCompleted.future;
		}, onFailure: (error, stack) => reports.add((error, stack)));
		await loader.open();
		expect(loader.error, same(initialError));
		expect(reports.single.$1, same(initialError));
		expect((loader.opening, loader.canRetry), (false, true));

		// 重複按下重試不得重送 open；完成後清除首次載入錯誤。
		final firstRetry = loader.retry();
		final duplicateRetry = loader.retry();
		expect(attempts, 2);
		expect(loader.opening, isTrue);
		retryCompleted.complete();
		await Future.wait([firstRetry, duplicateRetry]);
		expect((loader.error, loader.opening, loader.canRetry), (null, false, false));

		// 首次 open 已成功後，runtime 故障不能藉重試覆蓋仍在 WebView 的正文。
		final runtimeError = StateError('web runtime interrupted after editing');
		loader.reportFailure(runtimeError);
		expect(loader.error, same(runtimeError));
		expect(loader.canRetry, isFalse);
		await loader.retry();
		expect(attempts, 2);
		expect(loader.error, same(runtimeError));
	});

	test('opened checkpoint survives later attempt failure and reports exact error and stack once', () async {
		final error = StateError('flush after accepted open');
		final stack = StackTrace.fromString('original flush stack');
		final reports = <(Object, StackTrace)>[];
		var attempts = 0;
		late KlpBlockNoteWebSessionLoader loader;
		loader = KlpBlockNoteWebSessionLoader(() async {
			attempts++;
			loader.markOpened();
			loader.markOpened();
			Error.throwWithStackTrace(error, stack);
		}, onFailure: (error, stack) => reports.add((error, stack)));
		await loader.open();
		expect(loader.error, same(error));
		expect((loader.opening, loader.canRetry), (false, false));
		expect(reports, hasLength(1));
		expect(reports.single.$1, same(error));
		expect(reports.single.$2, same(stack));
		await loader.open();
		await loader.retry();
		loader.reportFailure(error);
		expect(attempts, 1);
		expect(reports, hasLength(1), reason: 'UI state updates do not own a second failure report');
	});

	test('simultaneous initial attempts share one original failure and permit explicit retry', () async {
		final gate = Completer<void>();
		final error = StateError('initial open rejected');
		final stack = StackTrace.fromString('original initial stack');
		final reports = <(Object, StackTrace)>[];
		var attempts = 0;
		final loader = KlpBlockNoteWebSessionLoader(() async {
			attempts++;
			if (attempts == 1) await gate.future;
		}, onFailure: (error, stack) => reports.add((error, stack)));
		final a = loader.open();
		final b = loader.open();
		final c = loader.retry();
		expect(attempts, 1);
		gate.completeError(error, stack);
		await Future.wait([a, b, c]);
		expect(reports, hasLength(1));
		expect(reports.single.$1, same(error));
		expect(reports.single.$2, same(stack));
		expect(loader.canRetry, isTrue);
		await loader.retry();
		expect(attempts, 2);
		expect(loader.canRetry, isFalse);
	});
}
