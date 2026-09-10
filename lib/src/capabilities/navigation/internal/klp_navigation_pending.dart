part of 'klp_navigation_machine.dart';

final class _NavigationPending {

	final KlpNavigationSnapshot candidate;
	final Completer<KlpNavigationDecision> decision;
	final void Function(KlpNavigationOutcome<void>) onRejected;
	final List<KlpRoutePolicy> beforeEnter;
	final bool replaceRouteInformation;
	final Completer<void> cancellation = Completer<void>();
	late final KlpNavigationCancellation signal = KlpNavigationCancellation(cancellation.future, () => cancellation.isCompleted);
	void Function()? onCommitted;

	_NavigationPending(
		this.candidate,
		this.decision,
		this.onRejected, {
		Iterable<KlpRoutePolicy>? beforeEnter,
		this.replaceRouteInformation = false,
	}) : beforeEnter = List.unmodifiable(beforeEnter ?? const []);
}
