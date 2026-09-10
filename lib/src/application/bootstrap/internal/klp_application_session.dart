part of '../../structure/klp_application.dart';

/// 唯一應用擁有端；來源更新與導覽提交共用同一樹與 FIFO。
final class _KlpApplicationSession {
  final void Function() onChanged;
  final void Function(Object, StackTrace) onAsyncError;
  final void Function(Uri, bool) onRouteInformationChanged;
  final KlpTreeRuntime _runtime = KlpTreeRuntime();
  final List<KlpApplication> _queue = [];
  KlpNavigationMachine? _machine;
  KlpApplication? _application;
  _KlpApplicationEpoch? _epoch;
  Completer<void>? _startupCancellation;
  int _startupGeneration = 0;
  bool _starting = false;
  bool _completingStartup = false;
  bool _terminal = false;
  bool _processing = false;
  bool _projecting = false;
  bool _scheduled = false;
  bool _disposed = false;
  Object? _startupError;

  _KlpApplicationSession({
    required this.onChanged,
    required this.onAsyncError,
    required this.onRouteInformationChanged,
  });

  KlpRuntimeFrame? get frame => _runtime.frame;
  String get title => _application?.title ?? '';
  bool get isPending => _starting || (_machine?.isBusy ?? false);
  Object? get startupError => _startupError;

  void accept(KlpApplication application) {
    if (_disposed || _terminal) {
      throw StateError('Application session is no longer usable.');
    }
    _queue.add(application);
    if (_processing || _projecting || (_machine?.isCommitting ?? false)) {
      _schedule();
      return;
    }
    _drain();
  }

  void _drain() {
    if (_disposed || _processing || _projecting || _completingStartup) {
      return;
    }
    _processing = true;
    Object? firstError;
    StackTrace? firstStack;
    try {
      while (_queue.isNotEmpty && !_disposed) {
        final next = _queue.removeAt(0);
        try {
          if (_machine == null) {
            _start(next);
          } else {
            _refresh(next);
          }
        } catch (error, stack) {
          firstError ??= error;
          firstStack ??= stack;
        }
      }
    } finally {
      _processing = false;
    }
    if (firstError != null) {
      Error.throwWithStackTrace(firstError, firstStack!);
    }
  }

  void _schedule() {
    if (_scheduled || _disposed) {
      return;
    }
    _scheduled = true;
    scheduleMicrotask(() {
      _scheduled = false;
      if (_disposed || _queue.isEmpty) {
        return;
      }
      try {
        _drain();
      } catch (error, stack) {
        onAsyncError(error, stack);
      }
    });
  }

  void _start(KlpApplication application) {
    _startupCancellation?.complete();
    final cancellation = Completer<void>();
    _startupCancellation = cancellation;
    final generation = ++_startupGeneration;
    _starting = true;
    _startupError = null;
    final result = KlpNavigationMachine.start(
      policies: application.router.routes.map((route) => route._policy),
      initial: application.router.initial,
      restored: application.router._initialStack,
      commit: (snapshot, {required replaceRouteInformation}) => _commit(
        _application ?? application,
        snapshot,
        replaceRouteInformation: replaceRouteInformation,
      ),
      cancellation: KlpNavigationCancellation(
        cancellation.future,
        () => cancellation.isCompleted,
      ),
    );
    if (result is Future<KlpNavigationStart>) {
      unawaited(
        result.then(
          (value) {
            try {
              _finishStart(value, generation);
            } catch (error, stack) {
              onAsyncError(error, stack);
            }
          },
          onError: (Object error, StackTrace stack) {
            if (_disposed || generation != _startupGeneration) {
              return;
            }
            _starting = false;
            _startupError = error;
            onChanged();
            onAsyncError(error, stack);
          },
        ),
      );
    } else {
      _finishStart(result, generation);
    }
  }

  void _finishStart(KlpNavigationStart result, int generation) {
    if (_disposed || generation != _startupGeneration) {
      result.machine?.dispose();
      return;
    }
    _starting = false;
    _completingStartup = false;
    _machine = result.machine;
    final outcome = result.decision.outcome;
    if (!result.decision.committed || frame == null) {
      _startupError = outcome;
      _machine?.dispose();
      _machine = null;
    }
    onChanged();
    _schedule();
    // 啟動內容失敗可以由下一份來源修正；同步與非同步都保留訂閱並報告。
    if (outcome case KlpNavigationFailed<void>()) {
      onAsyncError(outcome.error, outcome.stackTrace);
    }
  }

  Future<bool> handleBack() async {
    if (_disposed) {
      return false;
    }
    if (_terminal) {
      return true;
    }
    if (isPending) {
      return true;
    }
    final machine = _machine;
    if (machine == null || !machine.state.value.canPop) {
      return false;
    }
    try {
      final decision = await machine.pop();
      if (decision.outcome case KlpNavigationFailed<void> failure) {
        onAsyncError(failure.error, failure.stackTrace);
      }
    } catch (error, stack) {
      onAsyncError(error, stack);
    }
    return true;
  }

  Future<bool> restore(KlpNavigationRestoration restoration) async {
    if (_disposed || _terminal || isPending) {
      return false;
    }
    final application = _application;
    final machine = _machine;
    if (application == null || machine == null) {
      return false;
    }
    try {
      final decision = await machine.restore(application.router._restore(restoration));
      if (decision.outcome case KlpNavigationFailed<void> failure) {
        onAsyncError(failure.error, failure.stackTrace);
      }
      return decision.committed;
    } catch (error, stack) {
      onAsyncError(error, stack);
      return false;
    }
  }

  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _startupGeneration++;
    _startupCancellation?.complete();
    _queue.clear();
    _epoch = null;
    klpRunLifecycleActions([() => _machine?.dispose(), _runtime.dispose]);
  }
}
