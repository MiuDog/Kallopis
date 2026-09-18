import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';

KlpEditingStamp _stamp(int contentRevision) => KlpEditingStamp(
	documentId: 'document', pageId: 'page', generation: 1,
	projectionRevision: contentRevision, contentRevision: contentRevision,
	compositionRevision: 0, layoutRevision: 1, environmentId: 'environment',
);

KlpEditingSaveProjection _state({
	required int stateRevision,
	required int jobId,
	required int requested,
	required KlpEditingSavePhase phase,
	int? confirmed,
	KlpEditingSaveError? error,
	bool outcomeKnown = true,
	bool retryAllowed = false,
}) => KlpEditingSaveProjection(
	documentId: 'document', pageId: 'page', sessionId: 'session', generation: 1,
	stateRevision: stateRevision, jobId: jobId,
	requestedContentRevision: requested, confirmedSavedContentRevision: confirmed,
	phase: phase, error: error, outcomeKnown: outcomeKnown, retryAllowed: retryAllowed,
);

void main() {
	test('save and retry requests require disjoint retry authority', () {
		expect(
			() => KlpEditingSaveRequest(sequence: 1, expected: _stamp(1), intent: KlpEditingSaveIntent.save, failedJobId: 1),
			throwsArgumentError,
		);
		expect(
			() => KlpEditingSaveRequest(sequence: 1, expected: _stamp(1), intent: KlpEditingSaveIntent.retry, expectedStateRevision: 1),
			throwsArgumentError,
		);
		expect(
			KlpEditingSaveRequest(sequence: 1, expected: _stamp(1), intent: KlpEditingSaveIntent.retry, expectedStateRevision: 2, failedJobId: 1).failedJobId,
			1,
		);
	});

	test('projection rejects impossible initial and confirmation states', () {
		expect(() => _state(stateRevision: 0, jobId: 0, requested: 1, phase: KlpEditingSavePhase.saved, confirmed: 1), throwsArgumentError);
		expect(() => _state(stateRevision: 1, jobId: 1, requested: 1, phase: KlpEditingSavePhase.saved, confirmed: 2), throwsArgumentError);
		expect(() => _state(stateRevision: 1, jobId: 1, requested: 1, phase: KlpEditingSavePhase.failed, error: KlpEditingSaveError.ioFailure, outcomeKnown: false, retryAllowed: true), throwsArgumentError);
		expect(() => _state(stateRevision: 1, jobId: 1, requested: 1, phase: KlpEditingSavePhase.failed, error: KlpEditingSaveError.unknown, retryAllowed: true), throwsArgumentError);
		expect(() => _state(stateRevision: 1, jobId: 1, requested: 1, phase: KlpEditingSavePhase.failed, error: KlpEditingSaveError.conflict, outcomeKnown: false), throwsArgumentError);
	});

	test('publisher requires a saving job to settle and retains confirmation', () {
		final publisher = KlpEditingSaveStatePublisher(_state(stateRevision: 0, jobId: 0, requested: 1, phase: KlpEditingSavePhase.idle));
		final saving = _state(stateRevision: 1, jobId: 1, requested: 1, phase: KlpEditingSavePhase.saving, outcomeKnown: false);
		publisher.publish(saving);
		expect(() => publisher.publish(_state(stateRevision: 2, jobId: 1, requested: 1, phase: KlpEditingSavePhase.idle)), throwsStateError);
		final saved = _state(stateRevision: 2, jobId: 1, requested: 1, phase: KlpEditingSavePhase.saved, confirmed: 1);
		publisher.publish(saved);
		expect(() => publisher.publish(_state(stateRevision: 3, jobId: 1, requested: 2, phase: KlpEditingSavePhase.idle)), throwsStateError);
		publisher.publish(_state(stateRevision: 3, jobId: 1, requested: 2, phase: KlpEditingSavePhase.idle, confirmed: 1));
		expect(publisher.value.confirmedSavedContentRevision, 1);
		publisher.close();
	});

	test('unknown result cannot be cleared or replaced by another job', () {
		final publisher = KlpEditingSaveStatePublisher(_state(stateRevision: 0, jobId: 0, requested: 1, phase: KlpEditingSavePhase.idle));
		publisher.publish(_state(stateRevision: 1, jobId: 1, requested: 1, phase: KlpEditingSavePhase.saving, outcomeKnown: false));
		final unknown = _state(
			stateRevision: 2, jobId: 1, requested: 1, phase: KlpEditingSavePhase.failed,
			error: KlpEditingSaveError.unknown, outcomeKnown: false,
		);
		publisher.publish(unknown);
		expect(() => publisher.publish(_state(stateRevision: 3, jobId: 1, requested: 2, phase: KlpEditingSavePhase.idle)), throwsStateError);
		expect(() => publisher.publish(_state(stateRevision: 3, jobId: 2, requested: 1, phase: KlpEditingSavePhase.saving, outcomeKnown: false)), throwsStateError);
		expect(identical(publisher.value, unknown), isTrue);
		publisher.close();
	});
}
