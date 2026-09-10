import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
  group('KlpAsyncData notification recovery', () {
    test(
      'initial notification failure restores idle without starting operation',
      () async {
        final owner = KlpAsyncData<int>();
        addTearDown(owner.dispose);
        final error = StateError('loading listener');
        var calls = 0;
        owner.state.subscribe((state) {
          if (state is KlpDataLoading<int>) throw error;
        });

        // 載入通知失敗後，不能留下沒有工作的載入狀態。
        await expectLater(
          owner.load(() async => ++calls),
          throwsA(same(error)),
        );
        expect(calls, 0);
        expect(owner.state.value, isA<KlpDataIdle<int>>());
      },
    );

    test(
      'recovery failure preserves both original errors and traces',
      () async {
        final owner = KlpAsyncData<int>();
        addTearDown(owner.dispose);
        final loadingError = StateError('loading listener');
        final recoveryError = StateError('idle listener');
        final loadingTrace = StackTrace.fromString('loading trace');
        final recoveryTrace = StackTrace.fromString('recovery trace');
        var calls = 0;
        owner.state.subscribe((state) {
          if (state is KlpDataLoading<int>) {
            Error.throwWithStackTrace(loadingError, loadingTrace);
          }
          if (state is KlpDataIdle<int>) {
            Error.throwWithStackTrace(recoveryError, recoveryTrace);
          }
        });

        // 復原通知再次失敗仍須提交待命狀態，並保留兩份診斷。
        await expectLater(
          owner.load(() async => ++calls),
          throwsA(
            isA<KlpDataNotificationException>()
                .having(
                  (error) => error.issues.map((issue) => issue.error).toList(),
                  'original errors',
                  [same(loadingError), same(recoveryError)],
                )
                .having(
                  (error) =>
                      error.issues.map((issue) => issue.stackTrace).toList(),
                  'original traces',
                  [same(loadingTrace), same(recoveryTrace)],
                ),
          ),
        );
        expect(calls, 0);
        expect(owner.state.value, isA<KlpDataIdle<int>>());
      },
    );

    test('reentrant load survives the original notification failure', () async {
      final owner = KlpAsyncData<int>();
      addTearDown(owner.dispose);
      final error = StateError('original loading listener');
      final result = Completer<int>();
      late Future<void> replacement;
      var replaced = false;
      var originalCalls = 0;
      owner.state.subscribe((state) {
        if (state is! KlpDataLoading<int> || replaced) return;

        replaced = true;
        replacement = owner.load(() => result.future);
        throw error;
      });

      // 舊通知的例外不能將新請求的載入與結果回滾。
      await expectLater(
        owner.load(() async => ++originalCalls),
        throwsA(same(error)),
      );
      expect(originalCalls, 0);
      expect(owner.state.value, isA<KlpDataLoading<int>>());
      result.complete(42);
      await replacement;
      expect((owner.state.value as KlpDataValue<int>).value, 42);
    });

    test(
      'cancel during a failing notification does not publish idle twice',
      () async {
        final owner = KlpAsyncData<int>();
        addTearDown(owner.dispose);
        final error = StateError('cancelled loading listener');
        var idleEvents = 0;
        var calls = 0;
        owner.state.subscribe((state) {
          if (state is KlpDataIdle<int>) idleEvents++;
          if (state is KlpDataLoading<int>) {
            owner.cancel();
            throw error;
          }
        });

        await expectLater(
          owner.load(() async => ++calls),
          throwsA(same(error)),
        );
        expect(calls, 0);
        expect(idleEvents, 1);
        expect(owner.state.value, isA<KlpDataIdle<int>>());
      },
    );

    test(
      'dispose during a failing notification preserves the listener error',
      () async {
        final owner = KlpAsyncData<int>();
        addTearDown(owner.dispose);
        final error = StateError('disposed loading listener');
        var calls = 0;
        final subscription = owner.state.subscribe((state) {
          owner.dispose();
          throw error;
        });

        // 已釋放來源不能被復原寫入，其錯誤也不能遮蔽通知原錯。
        await expectLater(
          owner.load(() async => ++calls),
          throwsA(same(error)),
        );
        expect(calls, 0);
        expect(owner.isDisposed, isTrue);
        expect(subscription.isCancelled, isTrue);
        expect(() => owner.state.value, throwsStateError);
      },
    );
  });
}
