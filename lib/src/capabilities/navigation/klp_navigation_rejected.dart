part of 'klp_navigation_outcome.dart';

final class KlpNavigationRejected<R> extends KlpNavigationOutcome<R> {
  final String reason;

  const KlpNavigationRejected(this.reason);
}
