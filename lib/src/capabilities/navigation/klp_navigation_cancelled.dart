part of 'klp_navigation_outcome.dart';

final class KlpNavigationCancelled<R> extends KlpNavigationOutcome<R> {
  final String reason;

  const KlpNavigationCancelled(this.reason);
}
