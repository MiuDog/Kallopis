part of 'klp_navigation_machine.dart';

FutureOr<KlpNavigationStart> _startNavigation(
  Iterable<KlpRoutePolicy> policies,
  KlpLocation<Object?> initial,
  Iterable<KlpLocation<Object?>>? restored,
  void Function(KlpNavigationSnapshot, {required bool replaceRouteInformation})
  commit,
  KlpNavigationCancellation cancellation,
) {
  if (cancellation.isCancelled) {
    return const KlpNavigationStart._(
      null,
      KlpNavigationDecision(false, KlpNavigationCancelled('sourceUpdated')),
    );
  }

  // 步驟 1：來源列舉與初始候選只建立一次，尚不提交外部畫面資源。
  late final KlpNavigationMachine machine;
  try {
    machine = KlpNavigationMachine._(
      policies: policies,
      initial: initial,
      restored: restored,
      commit: commit,
    );
  } catch (error, stack) {
    return KlpNavigationStart._(
      null,
      KlpNavigationDecision(false, KlpNavigationFailed(error, stack)),
    );
  }
  if (cancellation.isCancelled) {
    return _rejectStart(machine, const KlpNavigationCancelled('sourceUpdated'));
  }

  // 步驟 2：同步政策不引入非同步空檔，非同步政策與取消訊號競速。
  return _runInitialGuards(machine, cancellation);
}

FutureOr<KlpNavigationStart> _runInitialGuards(
  KlpNavigationMachine machine,
  KlpNavigationCancellation cancellation, [
  int index = 0,
]) {
  final entries = machine._state.value.entries;
  for (var current = index; current < entries.length; current++) {
    final guard =
        machine._policies[entries[current].location.destination]!.beforeEnter;
    if (guard == null) {
      continue;
    }
    late final FutureOr<bool> allowed;
    try {
      allowed = guard(
        KlpNavigationTransition(null, machine._state.value, cancellation),
      );
    } catch (error, stack) {
      return _rejectStart(machine, KlpNavigationFailed(error, stack));
    }
    if (allowed is Future<bool>) {
      return _awaitInitialGuard(machine, cancellation, allowed, current);
    }
    if (cancellation.isCancelled) {
      return _rejectStart(
        machine,
        const KlpNavigationCancelled('sourceUpdated'),
      );
    }
    if (!allowed) {
      return _rejectStart(machine, const KlpNavigationRejected('guard'));
    }
  }
  return _commitStart(machine, cancellation);
}

Future<KlpNavigationStart> _awaitInitialGuard(
  KlpNavigationMachine machine,
  KlpNavigationCancellation cancellation,
  Future<bool> guard,
  int index,
) async {
  late final ({bool allowed, bool cancelled}) result;
  try {
    result = await Future.any<({bool allowed, bool cancelled})>([
      guard.then((allowed) => (allowed: allowed, cancelled: false)),
      cancellation.whenCancelled.then((_) => (allowed: false, cancelled: true)),
    ]);
  } catch (error, stack) {
    if (cancellation.isCancelled) {
      return _rejectStart(
        machine,
        const KlpNavigationCancelled('sourceUpdated'),
      );
    }

    return _rejectStart(machine, KlpNavigationFailed(error, stack));
  }
  if (result.cancelled || cancellation.isCancelled) {
    return _rejectStart(machine, const KlpNavigationCancelled('sourceUpdated'));
  }
  if (!result.allowed) {
    return _rejectStart(machine, const KlpNavigationRejected('guard'));
  }

  return await _runInitialGuards(machine, cancellation, index + 1);
}

KlpNavigationStart _commitStart(
  KlpNavigationMachine machine,
  KlpNavigationCancellation cancellation,
) {
  if (cancellation.isCancelled) {
    return _rejectStart(machine, const KlpNavigationCancelled('sourceUpdated'));
  }

  // 提交接點擁有外部資源；未知提交狀態不得偽裝為普通守衛失敗。
  var decision = const KlpNavigationDecision(
    true,
    KlpNavigationCompleted<void>(null),
  );
  try {
    machine.commit(machine._state.value, replaceRouteInformation: false);
  } on KlpNavigationCommitException catch (error) {
    if (!error.committed) {
      return _rejectStart(
        machine,
        KlpNavigationFailed(error.cause, error.stackTrace),
      );
    }

    decision = KlpNavigationDecision(
      true,
      KlpNavigationFailed(error.cause, error.stackTrace),
    );
  } catch (error, stack) {
    machine.dispose();
    throw KlpNavigationCommitContractException(error, stack);
  }
  machine.initialDecision = decision;
  return KlpNavigationStart._(machine, decision);
}

KlpNavigationStart _rejectStart(
  KlpNavigationMachine machine,
  KlpNavigationOutcome<void> outcome,
) {
  machine.dispose();
  return KlpNavigationStart._(null, KlpNavigationDecision(false, outcome));
}
