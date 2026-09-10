import 'dart:async';

import '../../state/klp_mutable_state.dart';
import '../../state/klp_state.dart';
import '../klp_destination.dart';
import '../klp_location.dart';
import '../klp_navigation_cancellation.dart';
import '../klp_navigation_decision.dart';
import '../klp_navigation_entry.dart';
import '../klp_navigation_outcome.dart';
import '../klp_navigation_snapshot.dart';
import '../klp_navigation_ticket.dart';
import '../klp_navigation_transition.dart';
import '../klp_route_policy.dart';
import 'klp_navigation_commit_exception.dart';
import 'klp_navigation_commit_contract_exception.dart';

part 'klp_navigation_machine_operations.dart';
part 'klp_navigation_machine_transaction.dart';
part 'klp_navigation_pending.dart';
part 'klp_navigation_machine_start.dart';
part 'klp_navigation_start.dart';

/// 非視覺導覽引擎；只有提交埠能將候選堆疊交給唯一樹安裝流程。
final class KlpNavigationMachine {
  final void Function(
    KlpNavigationSnapshot, {
    required bool replaceRouteInformation,
  })
  commit;
  late final KlpMutableState<KlpNavigationSnapshot> _state;
  late Map<KlpDestination<Object?, Object?>, KlpRoutePolicy> _policies;
  final Map<String, void Function(Object?, bool, String)> _results = {};
  _NavigationPending? _pending;
  int _entrySequence = 0;
  bool _disposed = false;
  bool _committing = false;
  late final KlpNavigationDecision initialDecision;

  /// 尚未發布的候選機器，只能經過 start 完成守衛後交給應用擁有端。
  KlpNavigationMachine._({
    required Iterable<KlpRoutePolicy> policies,
    required KlpLocation<Object?> initial,
    Iterable<KlpLocation<Object?>>? restored,
    required this.commit,
  }) {
    _policies = _validatedPolicies(policies);
    final locations = List<KlpLocation<Object?>>.unmodifiable(
      restored ?? [initial],
    );
    if (locations.isEmpty) {
      throw ArgumentError.value(
        restored,
        'restored',
        'Restoration stack cannot be empty.',
      );
    }
    for (final location in locations) {
      _validateLocation(location, _policies);
    }
    final snapshot = KlpNavigationSnapshot(0, locations.map(_entry));
    _state = KlpMutableState(snapshot);
  }

  /// 初始政策與來源世代都有效才提交；同步政策保持同步完成。
  static FutureOr<KlpNavigationStart> start({
    required Iterable<KlpRoutePolicy> policies,
    required KlpLocation<Object?> initial,
    Iterable<KlpLocation<Object?>>? restored,
    required void Function(
      KlpNavigationSnapshot, {
      required bool replaceRouteInformation,
    })
    commit,
    required KlpNavigationCancellation cancellation,
  }) => _startNavigation(policies, initial, restored, commit, cancellation);

  KlpState<KlpNavigationSnapshot> get state => _state.readOnly;
  bool get isDisposed => _disposed;
  bool get isBusy => _pending != null || _committing;
  bool get isCommitting => _committing;

  KlpNavigationTicket<R> push<R>(KlpLocation<R> location) => _push(location);
  Future<KlpNavigationDecision> pop() => _remove(null, null, false);
  Future<KlpNavigationDecision> complete<R>(
    KlpDestination<Object?, R> destination,
    R result,
  ) => _remove(destination, result, true);

  /// 平台還原只可經由應用 session 換入完整候選堆疊，不能取得導覽控制器。
  Future<KlpNavigationDecision> restore(
    Iterable<KlpLocation<Object?>> locations,
  ) => _restore(locations);

  /// 先完整驗證，拒絕以來源更新偷偷移除仍在堆疊中的畫面。
  void replacePolicies(Iterable<KlpRoutePolicy> policies) {
    _requireMutable();
    final next = _validatedPolicies(policies);
    for (final entry in _state.value.entries) {
      _validateLocation(entry.location, next);
    }
    invalidatePending('sourceUpdated');
    _policies = next;
  }

  void invalidatePending([String reason = 'sourceUpdated']) {
    _requireMutable();
    final pending = _pending;
    if (pending != null) {
      _cancel(pending, reason);
    }
  }

  void dispose() {
    if (_disposed) {
      return;
    }

    _requireMutable();
    invalidatePending('disposed');
    _disposed = true;
    final results = _results.values.toList();
    _results.clear();
    for (final result in results) {
      result(null, false, 'disposed');
    }
    _state.dispose();
  }

  KlpNavigationEntry _entry(KlpLocation<Object?> location) =>
      KlpNavigationEntry('route-${++_entrySequence}', location);

  Map<KlpDestination<Object?, Object?>, KlpRoutePolicy> _validatedPolicies(
    Iterable<KlpRoutePolicy> policies,
  ) {
    final result = <KlpDestination<Object?, Object?>, KlpRoutePolicy>{};
    final ids = <String>{};
    for (final policy in policies) {
      if (!ids.add(policy.destination.id)) {
        throw ArgumentError('Duplicate destination: ${policy.destination.id}.');
      }

      result[policy.destination] = policy;
    }
    return Map.unmodifiable(result);
  }

  void _validateLocation(
    KlpLocation<Object?> location,
    Map<KlpDestination<Object?, Object?>, KlpRoutePolicy> policies,
  ) {
    if (!policies.containsKey(location.destination)) {
      throw ArgumentError(
        'Unregistered destination: ${location.destination.id}.',
      );
    }
    if (!location.destination.acceptsParameters(location.parameters)) {
      throw ArgumentError('Invalid destination parameters.');
    }
  }

  void _requireMutable() {
    if (_disposed) {
      throw StateError('Navigation machine has been disposed.');
    }
    if (_committing) {
      throw StateError('Navigation mutation cannot reenter a commit.');
    }
  }
}
