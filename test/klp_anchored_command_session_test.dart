import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_anchored_command_session.dart';

KlpEditingDrawing _drawing(int revision, List<(String, bool)> candidates, {String blockId = 'a', bool blockAnchor = false}) {
	final stamp = KlpEditingStamp(
		documentId: 'document', pageId: 'page', generation: 0,
		projectionRevision: revision, contentRevision: revision,
		compositionRevision: 0, layoutRevision: revision, environmentId: 'environment',
	);
	final endpoint = KlpEditingEndpoint(blockId, 0, KlpEditingAffinity.downstream);
	final projection = KlpEditingProjection(stamp: stamp, anchor: endpoint, focus: endpoint, blockSelection: blockAnchor);
	final anchor = blockAnchor
		? KlpBlockCommandAnchor(stamp: stamp, viewportWidth: 640, viewportHeight: 480, rect: (x: 20, y: 20, width: 40, height: 24), blockId: blockId)
		: KlpCaretCommandAnchor(stamp: stamp, viewportWidth: 640, viewportHeight: 480, rect: (x: 20, y: 20, width: 1, height: 24), endpoint: endpoint);
	return KlpEditingDrawing(
		projection: projection,
		width: 640,
		height: 480,
		anchoredCommands: KlpCommandProjection(
			stamp: stamp,
			revision: revision,
			anchor: anchor,
			emptyLabel: 'Empty',
			items: candidates.map((candidate) => KlpCommandItem(
				id: candidate.$1, label: candidate.$1,
				availability: candidate.$2 ? KlpCommandAvailability.enabled : KlpCommandAvailability.disabled,
				disabledReason: candidate.$2 ? null : 'Unavailable', selected: false, tone: KlpCommandTone.neutral,
			)),
		),
		commands: const [],
	);
}

final class _Actions implements KlpBoundAnchoredCommandActions {
	final List<KlpCommandRequest> requests = [];
	KlpEditingDrawing drawing;
	Completer<KlpCommandReply>? pending;
	Object? failure;
	int sequence = 0;
	_Actions(this.drawing);
	@override
	int issueCommandSequence() => ++sequence;
	@override
	Future<KlpCommandReply> submitAnchoredCommand(KlpCommandRequest request, {required int committedAtMs}) {
		requests.add(request);
		if (failure case final error?) return Future.error(error);
		return pending?.future ?? Future.value(KlpCommandReply(KlpEditingDecision.accepted, drawing.projection));
	}
}

void main() {
	test('open interrupts once then adopts current candidates and local navigation', () async {
		var drawing = _drawing(1, [('old', true)]);
		var interruptions = 0;
		final actions = _Actions(drawing);
		final session = KlpAnchoredCommandSession(KlpBoundAnchoredCommands('commands', actions), () => drawing, () async {
			interruptions++;
			drawing = _drawing(2, [('disabled', false), ('next', true)]);
			actions.drawing = drawing;
		});
		expect(await session.open(), isTrue);
		expect((interruptions, session.highlightedId), (1, 'next'));
		session.next();
		session.previous();
		session.close();
		expect(interruptions, 1);
	});

	test('confirm never substitutes a stale candidate and sends once while pending', () async {
		var drawing = _drawing(1, [('first', true), ('second', true)]);
		final actions = _Actions(drawing);
		final session = KlpAnchoredCommandSession(KlpBoundAnchoredCommands('commands', actions), () => drawing, () async {});
		await session.open();
		drawing = _drawing(2, [('second', true)]);
		actions.drawing = drawing;
		await expectLater(session.confirm(), throwsStateError);
		expect(actions.requests, isEmpty);

		session.close();
		await session.open();
		final pending = Completer<KlpCommandReply>();
		actions.pending = pending;
		final first = session.confirm();
		await expectLater(session.confirm(), throwsStateError);
		expect(actions.requests, hasLength(1));
		pending.complete(KlpCommandReply(KlpEditingDecision.accepted, drawing.projection));
		await first;
		expect(session.opened, isFalse);
	});

	test('confirm rejects the same command id after its anchor target changes', () async {
		var drawing = _drawing(1, [('move', true)], blockId: 'a', blockAnchor: true);
		final actions = _Actions(drawing);
		final session = KlpAnchoredCommandSession(KlpBoundAnchoredCommands('commands', actions), () => drawing, () async {});
		await session.open();
		drawing = _drawing(2, [('move', true)], blockId: 'b', blockAnchor: true);
		actions.drawing = drawing;
		await expectLater(session.confirm(), throwsStateError);
		expect(actions.requests, isEmpty);
	});

	test('close during open and unknown confirmation cannot dispatch late or retry', () async {
		final drawing = _drawing(1, [('first', true)]);
		final actions = _Actions(drawing);
		final interruption = Completer<void>();
		final opening = KlpAnchoredCommandSession(KlpBoundAnchoredCommands('commands', actions), () => drawing, () => interruption.future);
		final opened = opening.open();
		opening.close();
		interruption.complete();
		expect(await opened, isFalse);
		expect(actions.requests, isEmpty);

		final unknown = KlpAnchoredCommandSession(KlpBoundAnchoredCommands('commands', actions), () => drawing, () async {});
		await unknown.open();
		actions.failure = StateError('unknown result');
		await expectLater(unknown.confirm(), throwsStateError);
		expect(unknown.requiresResync, isTrue);
		await expectLater(unknown.confirm(), throwsStateError);
		expect(actions.requests, hasLength(1));
	});

	test('close while confirmation is pending preserves an unknown outcome', () async {
		final drawing = _drawing(1, [('first', true)]);
		final actions = _Actions(drawing);
		final pending = Completer<KlpCommandReply>();
		actions.pending = pending;
		final session = KlpAnchoredCommandSession(KlpBoundAnchoredCommands('commands', actions), () => drawing, () async {});
		await session.open();
		final confirmation = session.confirm();
		session.close();
		pending.completeError(StateError('unknown result'));
		await expectLater(confirmation, throwsStateError);
		expect(session.requiresResync, isTrue);
		await expectLater(session.open(), throwsStateError);
		expect(actions.requests, hasLength(1));
	});

	test('empty and disabled candidates have no highlight', () async {
		for (final drawing in [_drawing(1, const []), _drawing(1, [('disabled', false)])]) {
			final actions = _Actions(drawing);
			final session = KlpAnchoredCommandSession(KlpBoundAnchoredCommands('commands', actions), () => drawing, () async {});
			await session.open();
			expect(session.highlightedId, isNull);
			await expectLater(session.confirm(), throwsStateError);
			expect(actions.requests, isEmpty);
		}
	});
}
