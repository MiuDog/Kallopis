import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
  group('KlpMutableState', () {
    test('read only source shares values and suppresses equal updates', () {
      final owner = KlpMutableState<int>(0);
      addTearDown(owner.dispose);
      final source = owner.readOnly;
      final values = <int>[];
      final subscription = source.subscribe(values.add);
      expect(values, isEmpty);
      expect(identical(source, owner.readOnly), isTrue);
      expect(source, isNot(isA<KlpMutableState<int>>()));
      owner.value = 1;
      owner.value = 1;
      expect(source.value, 1);
      expect(values, [1]);
      subscription.cancel();
      subscription.cancel();
      owner.value = 2;
      expect(values, [1]);
      expect(subscription.isCancelled, isTrue);
    });

    test('listeners can add remove and queue updates while notifying', () {
      final owner = KlpMutableState<int>(0);
      addTearDown(owner.dispose);
      final events = <String>[];
      late final KlpSubscription removed;
      owner.readOnly.subscribe((value) {
        events.add('first:$value');
        if (value == 1) {
          removed.cancel();
          owner.readOnly.subscribe((next) => events.add('new:$next'));
          owner.value = 2;
        }
      });
      removed = owner.readOnly.subscribe(
        (value) => events.add('removed:$value'),
      );
      owner.value = 1;
      expect(events, ['first:1', 'first:2', 'new:2']);
      expect(owner.value, 2);
    });

    test('listener failure does not prevent delivery or future updates', () {
      final owner = KlpMutableState<int>(0);
      addTearDown(owner.dispose);
      final values = <int>[];
      final failure = owner.readOnly.subscribe(
        (_) => throw StateError('failed'),
      );
      owner.readOnly.subscribe(values.add);
      expect(() => owner.value = 1, throwsStateError);
      expect(values, [1]);
      failure.cancel();
      owner.value = 2;
      expect(values, [1, 2]);
    });

    test('disposing during notification cancels pending delivery', () {
      final owner = KlpMutableState<int>(0);
      final values = <int>[];
      owner.readOnly.subscribe((_) {
        owner.value = 2;
        owner.dispose();
      });
      final later = owner.readOnly.subscribe(values.add);
      owner.value = 1;
      expect(values, isEmpty);
      expect(later.isCancelled, isTrue);
      expect(owner.isDisposed, isTrue);
    });

    test('disposed source rejects reading writing and new subscriptions', () {
      final owner = KlpMutableState<int>(0);
      final source = owner.readOnly;
      final subscription = source.subscribe((_) {});
      owner.dispose();
      owner.dispose();
      subscription.cancel();
      expect(() => source.value, throwsStateError);
      expect(() => owner.value = 0, throwsStateError);
      expect(() => source.subscribe((_) {}), throwsStateError);
      expect(subscription.isCancelled, isTrue);
    });
  });

  group('KlpStateController', () {
    test('borrows source without copying state or owning its disposal', () {
      final owner = KlpMutableState<int>(0);
      addTearDown(owner.dispose);
      final controller = KlpStateController<int>();
      controller.attach(owner.readOnly);
      expect(identical(controller.state, owner.readOnly), isTrue);
      owner.value = 1;
      expect(controller.state.value, 1);
      controller.detach();
      expect(controller.isAttached, isFalse);
      controller.attach(owner.readOnly);
      controller.dispose();
      controller.dispose();
      owner.value = 2;
      expect(owner.isDisposed, isFalse);
      expect(owner.readOnly.value, 2);
    });

    test('rejects invalid attachment and disposed operations', () {
      final owner = KlpMutableState<int>(0);
      addTearDown(owner.dispose);
      final controller = KlpStateController<int>();
      expect(() => controller.state, throwsStateError);
      expect(controller.detach, throwsStateError);
      controller.attach(owner.readOnly);
      expect(() => controller.attach(owner.readOnly), throwsStateError);
      controller.dispose();
      expect(controller.isDisposed, isTrue);
      expect(controller.isAttached, isFalse);
      expect(() => controller.state, throwsStateError);
      expect(controller.detach, throwsStateError);
      expect(() => controller.attach(owner.readOnly), throwsStateError);
    });
  });
}
