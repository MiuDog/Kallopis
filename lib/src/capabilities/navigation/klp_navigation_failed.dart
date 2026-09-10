part of 'klp_navigation_outcome.dart';

final class KlpNavigationFailed<R> extends KlpNavigationOutcome<R> {
  final Object error;
  final StackTrace stackTrace;

  const KlpNavigationFailed(this.error, this.stackTrace);
}
