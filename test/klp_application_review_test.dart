import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/kernel/lifecycle/internal/klp_lifecycle_exception.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_choice.dart';

import 'support/klp_application_test_fixture.dart';
import 'support/klp_component_test_item.dart';

void main() {
  testWidgets(
    'style replacement retains focus when region scrolling mode changes',
    (tester) async {
      // 小視窗讓完整原料替換跨越區域捲動門檻，只驗證互動生命週期。
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 60);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final item = KlpComponentTestItem(
        id: 'a',
        label: 'A',
        action: KlpCallbackAction(() {}),
      );
      final source = KlpMutableState(klpApplicationTestFixture(items: [item]));
      addTearDown(source.dispose);
      runKlpApp(source.readOnly);
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byType(KlpFlutterChoice));
      await tester.pump();
      final focus = FocusManager.instance.primaryFocus;
      final selection = tester
          .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
          .content
          .selection;
      expect(focus, isNotNull);
      expect(
        selection.value,
        KlpPlacementId(scope: ['fixture.router', 'route-1'], localId: 'a'),
      );

      // 同一放置的焦點與選取不應隨呈現策略切換被重建。
      source.value = klpApplicationTestFixture(items: [item], alternate: true);
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        tester
            .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
            .content
            .selection,
        same(selection),
      );
      expect(
        selection.value,
        KlpPlacementId(scope: ['fixture.router', 'route-1'], localId: 'a'),
      );
      expect(FocusManager.instance.primaryFocus, same(focus));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'throwing borrowed subscription cancellation still releases owned placements',
    (tester) async {
      // 外部來源的取消錯誤不可阻斷宿主所擁有資源的清理。
      final item = KlpComponentTestItem(
        id: 'a',
        label: 'A',
        action: KlpCallbackAction(() {}),
      );
      final source = _ThrowingCancelSource(
        klpApplicationTestFixture(items: [item]),
      );
      runKlpApp(source);
      await tester.pump();
      await tester.pump();
      final selection = tester
          .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
          .content
          .selection;
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isA<StateError>());
      expect(() => selection.value, throwsStateError);
    },
  );

  testWidgets(
    'throwing old cancellation still installs replacement source and ignores stale events',
    (tester) async {
      // 取消失敗的舊來源仍可能派送事件；世代隔離必須守住新來源權威。
      final first = _ThrowingCancelSource(
        klpApplicationTestFixture(title: 'First'),
      );
      final second = KlpMutableState(
        klpApplicationTestFixture(title: 'Second'),
      );
      addTearDown(second.dispose);
      runKlpApp(first);
      await tester.pump();
      await tester.pump();
      runKlpApp(second.readOnly);
      await tester.pump();
      await tester.pump();
      expect(tester.takeException(), isA<StateError>());
      second.value = klpApplicationTestFixture(title: 'Current source');
      await tester.pump();
      expect(
        tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title,
        'Current source',
      );
      first.emit(klpApplicationTestFixture(title: 'Stale source'));
      await tester.pump();
      expect(
        tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title,
        'Current source',
      );
      await tester.pumpWidget(const SizedBox.shrink());
      expect(second.isDisposed, isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'initial source read failure preserves both read and cancellation causes',
    (tester) async {
      // 初始化失敗與外部取消失敗都應可追查，不互相掩蓋。
      final source = _ThrowingCancelSource(
        klpApplicationTestFixture(),
        throwOnRead: true,
      );
      runKlpApp(source);
      await tester.pump();
      await tester.pump();
      final error = tester.takeException();
      expect(error, isA<KlpLifecycleException>());
      final issues = (error as KlpLifecycleException).issues;
      expect(issues.map((issue) => issue.error), [
        isA<ArgumentError>().having(
          (error) => error.message,
          'message',
          'external read failed',
        ),
        isA<StateError>().having(
          (error) => error.message,
          'message',
          'external cancel failed',
        ),
      ]);
      expect(source.subscription!.isCancelled, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}

final class _ThrowingCancelSource implements KlpState<KlpApplication> {
  final KlpApplication _value;
  final bool throwOnRead;
  void Function(KlpApplication)? _listener;
  KlpSubscription? subscription;

  _ThrowingCancelSource(this._value, {this.throwOnRead = false});

  @override
  KlpApplication get value {
    if (throwOnRead) throw ArgumentError('external read failed');
    return _value;
  }

  @override
  KlpSubscription subscribe(void Function(KlpApplication) listener) {
    _listener = listener;
    return subscription = KlpSubscription(
      () => throw StateError('external cancel failed'),
    );
  }

  void emit(KlpApplication application) => _listener?.call(application);
}
