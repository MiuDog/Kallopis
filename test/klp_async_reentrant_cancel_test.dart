import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
  test(
    'cancel in queued replacement loading notification prevents operation',
    () async {
      final owner = KlpAsyncData<int>();
      addTearDown(owner.dispose);
      final events = <String>[];
      var loadingCount = 0;
      late Future<void> replacement;
      owner.state.subscribe((state) {
        if (state is! KlpDataLoading<int>) return;

        loadingCount++;
        events.add('loading:$loadingCount');
        if (loadingCount == 1) {
          replacement = owner.load(() async {
            events.add('replacement:started');
            return 2;
          });
        } else {
          events.add('replacement:cancel');
          owner.cancel();
        }
      });

      await owner.load(() async {
        events.add('original:started');
        return 1;
      });
      await replacement;
      // 被載入通知取消的重入請求，不應先啟動底層操作。
      expect(events, ['loading:1', 'loading:2', 'replacement:cancel']);
      expect(owner.state.value, isA<KlpDataIdle<int>>());
    },
  );

  test('replacement loading error belongs to replacement future', () async {
    final owner = KlpAsyncData<int>();
    addTearDown(owner.dispose);
    final error = StateError('replacement loading failed');
    final trace = StackTrace.fromString('replacement notification trace');
    var notifications = 0;
    var calls = 0;
    late Future<void> replacementCheck;
    owner.state.subscribe((state) {
      if (state is! KlpDataLoading<int>) return;

      notifications++;
      if (notifications == 1) {
        replacementCheck = expectLater(
          owner.load(() async => ++calls),
          throwsA(same(error)),
        );
      } else {
        Error.throwWithStackTrace(error, trace);
      }
    });

    // 原請求正常完成，只有新請求承擔自己的載入通知錯誤。
    await owner.load(() async => ++calls);
    await replacementCheck;
    expect(calls, 0);
    expect(owner.state.value, isA<KlpDataIdle<int>>());
  });

  test(
    'cancel nested publication preserves later listener replacement safety',
    () async {
      final owner = KlpAsyncData<int>();
      addTearDown(owner.dispose);
      var notifications = 0;
      var calls = 0;
      var replaced = false;
      late Future<void> replacement;
      owner.state.subscribe((state) {
        if (state is! KlpDataLoading<int>) return;

        notifications++;
        owner.cancel();
      });
      owner.state.subscribe((state) {
        if (state is! KlpDataLoading<int> || replaced) return;

        replaced = true;
        replacement = owner.load(() async => ++calls);
      });

      // 第一個訂閱取消後，後續訂閱發起的新請求仍須等待自身通知。
      await owner.load(() async => ++calls);
      await replacement;
      expect(notifications, 2);
      expect(calls, 0);
      expect(owner.state.value, isA<KlpDataIdle<int>>());
    },
  );

  for (final fails in [false, true]) {
    test(
      'replacement from completed state waits for loading cancellation fails=$fails',
      () async {
        final owner = KlpAsyncData<int>();
        addTearDown(owner.dispose);
        var loadingCount = 0;
        var replacementCalls = 0;
        late Future<void> replacement;
        owner.state.subscribe((state) {
          if (state is KlpDataLoading<int>) {
            loadingCount++;
            if (loadingCount == 2) owner.cancel();
          }
          if (state is KlpDataValue<int> || state is KlpDataFailure<int>) {
            replacement = owner.load(() async => ++replacementCalls);
          }
        });

        // 成功與失敗通知也屬於可重入的發布階段。
        await owner.load(() async {
          if (fails) throw StateError('operation failed');

          return 1;
        });
        await replacement;
        expect(loadingCount, 2);
        expect(replacementCalls, 0);
        expect(owner.state.value, isA<KlpDataIdle<int>>());
      },
    );
  }
}
