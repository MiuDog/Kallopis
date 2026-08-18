import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  KlpRoute route(String id) => KlpRoute(
    id: id,
    builder: (_) => Text(id, textDirection: TextDirection.ltr),
  );

  KlpRouter router() =>
      KlpRouter(routes: [route('a'), route('b'), route('c')], initialId: 'a');

  group('登記與切換', () {
    test('起點必填且必須已註冊', () {
      expect(router().currentId, 'a');
      expect(
        () => KlpRouter(routes: [route('a')], initialId: 'missing'),
        throwsA(isA<KlpRouteNotFound>()),
      );
    });

    test('重複的 id 在建構時就拋錯', () {
      expect(
        () => KlpRouter(routes: [route('a'), route('a')], initialId: 'a'),
        throwsArgumentError,
      );
    });

    test('切到未註冊的目的地拋錯，而不是靜默停在原地', () {
      final r = router();
      expect(() => r.go('nope'), throwsA(isA<KlpRouteNotFound>()));
      expect(r.currentId, 'a', reason: '拋錯後不應該改變位置');
    });

    test('錯誤訊息列出已註冊的 id', () {
      try {
        router().go('nope');
        fail('應該要拋錯');
      } on KlpRouteNotFound catch (e) {
        expect(e.toString(), contains('nope'));
        expect(e.toString(), contains('a'));
      }
    });

    test('切換會通知監聽者', () {
      final r = router();
      var notified = 0;
      r.addListener(() => notified++);
      r.go('b');
      expect(r.currentId, 'b');
      expect(notified, 1);
    });

    test('切到目前所在是 no-op，不堆歷史也不通知', () {
      final r = router();
      var notified = 0;
      r.addListener(() => notified++);
      r.go('a');
      expect(notified, 0);
      expect(r.canGoBack, isFalse);
    });
  });

  group('歷史', () {
    test('goBack 逐步回退', () {
      final r = router()
        ..go('b')
        ..go('c');
      expect(r.currentId, 'c');
      expect(r.goBack(), isTrue);
      expect(r.currentId, 'b');
      expect(r.goBack(), isTrue);
      expect(r.currentId, 'a');
    });

    test('在起點 goBack 回傳 false 而不是拋錯', () {
      final r = router();
      expect(r.canGoBack, isFalse);
      expect(r.goBack(), isFalse);
      expect(r.currentId, 'a');
    });

    test('reset 清空歷史', () {
      final r = router()
        ..go('b')
        ..go('c');
      r.reset('a');
      expect(r.currentId, 'a');
      expect(r.canGoBack, isFalse);
    });
  });

  group('動態註冊', () {
    test('可以在執行期加入目的地', () {
      final r = router()..register(route('d'));
      r.go('d');
      expect(r.currentId, 'd');
    });

    test('重複註冊拋錯而不是覆蓋', () {
      expect(() => router().register(route('a')), throwsArgumentError);
    });

    test('不能移除仍在歷史中的目的地', () {
      final r = router()..go('b');
      expect(() => r.unregister('a'), throwsStateError);
      expect(() => r.unregister('b'), throwsStateError);
      expect(() => r.unregister('c'), returnsNormally);
    });
  });

  group('widget 整合', () {
    testWidgets('outlet 渲染目前的目的地並隨切換更新', (tester) async {
      final r = router();
      await tester.pumpWidget(
        KlpRouterScope(
          router: r,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: KlpRouterOutlet(),
          ),
        ),
      );
      expect(find.text('a'), findsOneWidget);

      r.go('b');
      await tester.pump();
      expect(find.text('b'), findsOneWidget);
      expect(find.text('a'), findsNothing);
    });

    testWidgets('沒有 scope 時拋出可讀的錯誤，而不是回退到某個預設頁', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: KlpRouterOutlet(),
        ),
      );
      final error = tester.takeException();
      expect(error, isA<StateError>());
      expect(error.toString(), contains('KlpRouterScope'));
    });

    testWidgets('maybeOf 在沒有 scope 時回傳 null', (tester) async {
      KlpRouter? found = router();
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            found = KlpRouterScope.maybeOf(context);
            return const SizedBox();
          },
        ),
      );
      expect(found, isNull);
    });
  });

  test('庫內不得出現任何具名路由', () {
    // router 是**機制**，不是導覽決策。庫一旦內建 'home'／'settings' 這類 id，
    // 就開始替產品決定有哪些頁——那正是拒絕清單擋的東西。
    final source = File('lib/src/routing/klp_router.dart').readAsStringSync();

    // 只看實際程式碼，不看文件註解裡的範例。
    final code = const LineSplitter()
        .convert(source)
        .where((line) => !line.trimLeft().startsWith('///'))
        .join('\n');

    for (final suspect in const [
      'home',
      'settings',
      'dashboard',
      'profile',
      'login',
      'index',
      'main',
      'root',
    ]) {
      expect(
        code.contains("'$suspect'"),
        isFalse,
        reason: '庫內出現了具名路由 "$suspect"。目的地是產品的決定。',
      );
    }
  });
}
