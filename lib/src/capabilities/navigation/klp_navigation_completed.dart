part of 'klp_navigation_outcome.dart';

final class KlpNavigationCompleted<R> extends KlpNavigationOutcome<R> {
  final R value;

  const KlpNavigationCompleted(this.value);
}
