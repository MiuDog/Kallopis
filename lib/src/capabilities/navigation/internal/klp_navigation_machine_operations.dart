part of 'klp_navigation_machine.dart';

extension _NavigationOperations on KlpNavigationMachine {
  KlpNavigationTicket<R> _push<R>(KlpLocation<R> location) {
    final result = Completer<KlpNavigationOutcome<R>>();
    final decision = Completer<KlpNavigationDecision>();
    if (_disposed || isBusy) {
      final reason = _disposed ? 'disposed' : 'busy';
      decision.complete(
        KlpNavigationDecision(false, KlpNavigationRejected(reason)),
      );
      result.complete(KlpNavigationRejected(reason));
      return KlpNavigationTicket(decision.future, result.future, () {});
    }

    try {
      _validateLocation(location, _policies);
    } catch (error, stack) {
      decision.complete(
        KlpNavigationDecision(false, KlpNavigationFailed(error, stack)),
      );
      result.complete(KlpNavigationFailed(error, stack));
      return KlpNavigationTicket(decision.future, result.future, () {});
    }

    final entry = _entry(location);
    final next = KlpNavigationSnapshot(_state.value.revision + 1, [
      ..._state.value.entries,
      entry,
    ]);
    final pending = _NavigationPending(next, decision, (outcome) {
      if (result.isCompleted) return;

      switch (outcome) {
        case KlpNavigationCancelled<void>():
          result.complete(KlpNavigationCancelled(outcome.reason));
        case KlpNavigationRejected<void>():
          result.complete(KlpNavigationRejected(outcome.reason));
        case KlpNavigationFailed<void>():
          result.complete(
            KlpNavigationFailed(outcome.error, outcome.stackTrace),
          );
        case KlpNavigationCompleted<void>():
          break;
      }
    });
    pending.onCommitted = () {
      _results[entry.id] = (value, completed, reason) {
        if (result.isCompleted) return;

        result.complete(
          completed
              ? KlpNavigationCompleted<R>(value as R)
              : KlpNavigationCancelled<R>(reason),
        );
      };
    };
    _pending = pending;
    unawaited(_execute(pending));
    return KlpNavigationTicket(
      decision.future,
      result.future,
      () => _cancel(pending, 'cancelled'),
    );
  }

  Future<KlpNavigationDecision> _remove(
    KlpDestination<Object?, Object?>? destination,
    Object? result,
    bool completed,
  ) {
    if (_disposed || isBusy) {
      return Future.value(
        KlpNavigationDecision(
          false,
          KlpNavigationRejected(_disposed ? 'disposed' : 'busy'),
        ),
      );
    }
    if (!_state.value.canPop) {
      return Future.value(
        const KlpNavigationDecision(false, KlpNavigationRejected('root')),
      );
    }

    final current = _state.value.current;
    if (completed &&
        (!identical(destination, current.location.destination) ||
            !current.location.destination.acceptsResult(result))) {
      return Future.value(
        const KlpNavigationDecision(
          false,
          KlpNavigationRejected('invalidResult'),
        ),
      );
    }

    final decision = Completer<KlpNavigationDecision>();
    final next = KlpNavigationSnapshot(
      _state.value.revision + 1,
      _state.value.entries.take(_state.value.entries.length - 1),
    );
    final pending = _NavigationPending(next, decision, (_) {});
    pending.onCommitted = () =>
        _results.remove(current.id)?.call(result, completed, 'back');
    _pending = pending;
    unawaited(_execute(pending));
    return decision.future;
  }

  Future<KlpNavigationDecision> _restore(
    Iterable<KlpLocation<Object?>> locations,
  ) {
    if (_disposed || isBusy) {
      return Future.value(
        KlpNavigationDecision(
          false,
          KlpNavigationRejected(_disposed ? 'disposed' : 'busy'),
        ),
      );
    }
    final values = List<KlpLocation<Object?>>.unmodifiable(locations);
    if (values.isEmpty) {
      return Future.value(
        const KlpNavigationDecision(
          false,
          KlpNavigationRejected('emptyRestoration'),
        ),
      );
    }
    try {
      for (final location in values) {
        _validateLocation(location, _policies);
      }
    } catch (error, stack) {
      return Future.value(
        KlpNavigationDecision(false, KlpNavigationFailed(error, stack)),
      );
    }

    final decision = Completer<KlpNavigationDecision>();
    final next = KlpNavigationSnapshot(
      _state.value.revision + 1,
      values.map(_entry),
    );
    final pending = _NavigationPending(
      next,
      decision,
      (_) {},
      beforeEnter: values.map((location) => _policies[location.destination]!),
      replaceRouteInformation: true,
    );
    pending.onCommitted = () {
      final results = _results.values.toList();
      _results.clear();
      for (final result in results) {
        result(null, false, 'restored');
      }
    };
    _pending = pending;
    unawaited(_execute(pending));
    return decision.future;
  }
}
