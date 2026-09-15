import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';

KlpEditingDrawing _drawing(int revision) {
	final stamp = KlpEditingStamp(
		documentId: 'document', pageId: 'page', generation: 1,
		projectionRevision: revision, contentRevision: 1,
		compositionRevision: 0, layoutRevision: revision, environmentId: 'environment',
	);
	final endpoint = KlpEditingEndpoint('block', 0, KlpEditingAffinity.downstream);
	return KlpEditingDrawing(
		projection: KlpEditingProjection(stamp: stamp, anchor: endpoint, focus: endpoint, blockSelection: false),
		width: 640, height: 480, commands: const [],
	);
}

KlpEditingDrawCommand _inkCommand() => KlpEditingDrawPath(
	KlpEditingPath([
		KlpEditingPathCommand(KlpEditingPathOperation.move, const [1, 1]),
		KlpEditingPathCommand(KlpEditingPathOperation.line, const [2, 2]),
	]),
	KlpEditingPaintRole.ink,
);

KlpHandwritingState _state({
	required KlpEditingDrawing drawing,
	required int generation,
	required KlpHandwritingPhase phase,
	int sequence = 0,
	int previewRevision = 0,
	int buffered = 0,
	int capacity = 8,
	Iterable<KlpEditingDrawCommand> commands = const [],
}) => KlpHandwritingState(
	drawing: drawing,
	capture: KlpHandwritingCaptureIdentity(generation: generation, id: 'capture-$generation'),
	phase: phase,
	acceptedBatchSequence: sequence,
	previewRevision: previewRevision,
	sampleCapacity: capacity,
	bufferedSampleCount: buffered,
	remainingSampleCapacity: phase == KlpHandwritingPhase.committed || phase == KlpHandwritingPhase.canceled ? null : capacity - buffered,
	previewCommands: commands,
);

final class _Source implements KlpHandwritingStateSource {
	@override
	KlpEditingDrawing drawing;
	final StreamController<KlpEditingDrawing> _drawings = StreamController<KlpEditingDrawing>.broadcast(sync: false);
	late final KlpHandwritingStatePublisher publisher = KlpHandwritingStatePublisher(() => drawing);

	_Source(this.drawing);

	@override
	Stream<KlpEditingDrawing> get drawings => _drawings.stream;
	@override
	KlpHandwritingState? get inkState => publisher.state;
	@override
	Stream<KlpHandwritingState?> get inkStates => publisher.states;

	Future<void> close() async {
		await publisher.close();
		await _drawings.close();
	}
}

void main() {
	test('state accepts only immutable closed ink preview geometry', () {
		final drawing = _drawing(1);
		final command = _inkCommand();
		final state = _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.capturing, sequence: 1, previewRevision: 1, buffered: 2, commands: [command]);
		expect(state.previewCommands, [same(command)]);
		expect(() => state.previewCommands.clear(), throwsUnsupportedError);
		expect(
			() => _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.capturing, previewRevision: 1, commands: [KlpEditingDrawRect((x: 0, y: 0, width: 1, height: 1), KlpEditingPaintRole.selection)]),
			throwsArgumentError,
		);
		expect(
			() => _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.capturing, previewRevision: 1, commands: [KlpEditingPushClip((x: 0, y: 0, width: 1, height: 1))]),
			throwsArgumentError,
		);
		expect(() => _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.canceled, previewRevision: 1, commands: [command]), throwsArgumentError);
	});

	test('publisher exposes current state before asynchronous delivery', () async {
		final drawing = _drawing(1);
		final source = _Source(drawing);
		final observed = <KlpHandwritingState?>[];
		final subscription = source.inkStates.listen((state) {
			expect(identical(source.inkState, state), isTrue);
			observed.add(state);
		});
		expect(source.inkStates.isBroadcast, isTrue);
		final first = _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.capturing);
		source.publisher.publish(first);
		expect(observed, isEmpty);
		await Future<void>.delayed(Duration.zero);
		expect(observed, [same(first)]);
		await subscription.cancel();
		await source.close();
	});

	test('invalid updates preserve current state and publish no event', () async {
		final drawing = _drawing(1);
		final source = _Source(drawing);
		var events = 0;
		final subscription = source.inkStates.listen((_) { events++; });
		expect(
			() => source.publisher.publish(_state(drawing: _drawing(1), generation: 1, phase: KlpHandwritingPhase.capturing)),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'invalid_handwriting_capture')),
		);
		final command = _inkCommand();
		final first = _state(drawing: drawing, generation: 2, phase: KlpHandwritingPhase.capturing, sequence: 1, previewRevision: 1, buffered: 1, commands: [command]);
		source.publisher.publish(first);
		await Future<void>.delayed(Duration.zero);
		expect(
			() => source.publisher.publish(_state(drawing: drawing, generation: 2, phase: KlpHandwritingPhase.capturing, sequence: 0, previewRevision: 1, commands: [command])),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'handwriting_state_regression')),
		);
		expect(identical(source.inkState, first), isTrue);
		await Future<void>.delayed(Duration.zero);
		expect(events, 1);
		await subscription.cancel();
		await source.close();
	});

	test('publisher retains frozen drawing and rejects retired capture events', () async {
		final drawing = _drawing(1);
		final source = _Source(drawing);
		final first = _state(drawing: drawing, generation: 3, phase: KlpHandwritingPhase.capturing);
		source.publisher.publish(first);
		source.drawing = _drawing(2);
		final terminal = _state(drawing: drawing, generation: 3, phase: KlpHandwritingPhase.canceled);
		source.publisher.publish(terminal);
		source.publisher.clear(terminal.capture);
		final next = _state(drawing: source.drawing, generation: 4, phase: KlpHandwritingPhase.capturing);
		source.publisher.publish(next);
		expect(
			() => source.publisher.publish(_state(drawing: drawing, generation: 3, phase: KlpHandwritingPhase.unknown)),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'handwriting_capture_mismatch')),
		);
		expect(identical(source.inkState, next), isTrue);
		await source.close();
		expect(() => source.publisher.publish(next), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'closed_handwriting_publisher')));
	});

	test('unknown state cannot be cleared as a confirmed terminal result', () async {
		final drawing = _drawing(1);
		final source = _Source(drawing);
		final capturing = _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.capturing);
		source.publisher.publish(capturing);
		final unknown = _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.unknown);
		source.publisher.publish(unknown);
		expect(() => source.publisher.clear(unknown.capture), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'invalid_handwriting_clear')));
		expect(source.inkState!.phase, KlpHandwritingPhase.unknown);
		await source.close();
	});

	test('capacity and known overload authority cannot regress through unknown', () async {
		final drawing = _drawing(1);
		final source = _Source(drawing);
		final command = _inkCommand();
		final capturing = _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.capturing, sequence: 1, previewRevision: 1, buffered: 4, commands: [command]);
		source.publisher.publish(capturing);
		expect(
			() => source.publisher.publish(_state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.capturing, sequence: 2, previewRevision: 2, buffered: 4, capacity: 9, commands: [command])),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'handwriting_capacity_mismatch')),
		);
		expect(
			() => source.publisher.publish(_state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.capturing, sequence: 2, previewRevision: 2, buffered: 3, commands: [command])),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'handwriting_sample_regression')),
		);
		final overloaded = _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.overloaded, sequence: 1, previewRevision: 1, buffered: 4, commands: [command]);
		source.publisher.publish(overloaded);
		final unknown = _state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.unknown, sequence: 1, previewRevision: 1, buffered: 4, commands: [command]);
		source.publisher.publish(unknown);
		expect(
			() => source.publisher.publish(_state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.committed, sequence: 1, previewRevision: 1)),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'invalid_handwriting_transition')),
		);
		expect(
			() => source.publisher.publish(_state(drawing: drawing, generation: 1, phase: KlpHandwritingPhase.unknown, sequence: 2, previewRevision: 1, buffered: 4, commands: [command])),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'invalid_handwriting_unknown')),
		);
		expect(identical(source.inkState, unknown), isTrue);
		await source.close();
	});
}
