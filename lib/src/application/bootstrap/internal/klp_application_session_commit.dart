part of '../../structure/klp_application.dart';

extension _KlpApplicationSessionCommit on _KlpApplicationSession {
  void _refresh(KlpApplication next) {
    final previous = _application!;
    if (next.router.id != previous.router.id) {
      throw ArgumentError('Router identity cannot change during a session.');
    }
    final initial = next.router.initial;
    final oldInitial = previous.router.initial;
    if (!identical(initial.destination, oldInitial.destination) ||
        initial.parameters != oldInitial.parameters) {
      throw ArgumentError('Initial location cannot change during a session.');
    }
    final machine = _machine!;
    final snapshot = machine.state.value;
    final registered = {
      for (final route in next.router.routes) route.destination,
    };
    for (final entry in snapshot.entries) {
      if (!registered.contains(entry.location.destination)) {
        throw ArgumentError('Retained destination cannot be removed.');
      }
    }
    machine.invalidatePending();
    try {
      _commit(next, snapshot, replaceRouteInformation: false);
    } on KlpNavigationCommitException catch (error) {
      if (error.committed && frame != null) {
        machine.replacePolicies(
          next.router.routes.map((route) => route._policy),
        );
      }
      Error.throwWithStackTrace(error.cause, error.stackTrace);
    }
    machine.replacePolicies(next.router.routes.map((route) => route._policy));
  }

  void _commit(
    KlpApplication application,
    KlpNavigationSnapshot snapshot, {
    required bool replaceRouteInformation,
  }) {
    final previous = frame;
    _projecting = true;
    if (_machine == null) {
      _completingStartup = true;
    }
    try {
      // 全部保留 entry 一同投影；新操作只有在整樹提交後才能使用。
      final epoch = _KlpApplicationEpoch();
      final routes = {
        for (final route in application.router.routes) route.destination: route,
      };
      final screens = <String, KlpScreen>{};
      for (final entry in snapshot.entries) {
        final route = routes[entry.location.destination];
        if (route == null) {
          throw ArgumentError('Retained destination is not registered.');
        }
        screens[entry.id] = route._project(
          entry,
          _KlpSessionRouteActions(this, epoch, entry),
        );
      }
      final root = KlpScopeBoundary(
        id: application.router.id,
        child: KlpRetainedScreens(
          id: 'retained',
          activeEntry: snapshot.current.id,
          screens: screens,
        ),
      );
      try {
        _runtime.update(
          root: root,
          adapters: klpApplicationAdapters(application),
          components: application.components,
          primitives: application.primitives,
          actionHandler: _KlpApplicationActionHandler(this),
        );
      } finally {
        if (frame != null && !identical(frame, previous)) {
          _application = application;
          _epoch = epoch;
          epoch.committed = true;
          _publishRestoration(application, snapshot);
          _publishRouteInformation(
            application,
            snapshot,
            replace: replaceRouteInformation,
          );
          onChanged();
        }
      }
    } catch (error, stack) {
      final committed =
          !identical(previous, frame) ||
          (error is KlpInstallationException && error.committed);
      if (committed && frame == null) {
        // 資源提交後失去呈現不能冒充回滾，停止後續操作並延後清理導覽核心。
        _epoch = null;
        _terminal = true;
        _queue.clear();
        _startupError = error;
        scheduleMicrotask(() {
          if (_disposed) {
            return;
          }
          _machine?.dispose();
          _machine = null;
          onChanged();
        });
      }
      throw KlpNavigationCommitException(committed, error, stack);
    } finally {
      _projecting = false;
      _schedule();
    }
  }

  void _publishRestoration(
    KlpApplication application,
    KlpNavigationSnapshot snapshot,
  ) {
    final callback = application.onNavigationRestorationChanged;
    if (callback == null) {
      return;
    }
    try {
      callback(
        KlpNavigationRestoration.fromSnapshot(application.router.id, snapshot),
      );
    } catch (error, stack) {
      onAsyncError(error, stack);
    }
  }

  void _publishRouteInformation(
    KlpApplication application,
    KlpNavigationSnapshot snapshot, {
    required bool replace,
  }) {
    if (!application.router.supportsRestoration) {
      return;
    }
    try {
      final restoration = KlpNavigationRestoration.fromSnapshot(
        application.router.id,
        snapshot,
      );
      onRouteInformationChanged(
        KlpRouteUri.encodeRestoration(restoration),
        replace,
      );
    } catch (error, stack) {
      onAsyncError(error, stack);
    }
  }
}
