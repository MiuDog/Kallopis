import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_drop_preview.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_editing_command_sequence.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_block_control_session.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_delta.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_input_session.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_plan.dart';

KlpEditingStamp _stamp(int revision) => KlpEditingStamp(
	documentId: 'document', pageId: 'page', generation: 0,
	projectionRevision: revision, contentRevision: revision,
	compositionRevision: 0, layoutRevision: 1,
	environmentId: 'environment',
);

KlpEditingProjection _text(int revision, String text, int caret) {
	final stamp = _stamp(revision);
	final endpoint = KlpEditingEndpoint('a', caret, KlpEditingAffinity.downstream);
	return KlpEditingProjection(
		stamp: stamp,
		anchor: endpoint,
		focus: endpoint,
		blockSelection: false,
		window: KlpEditingTextWindow(
			stamp: stamp, blockId: 'a', sourceStartUtf8: 0, text: text,
			anchorUtf8: caret, focusUtf8: caret,
		),
	);
}

KlpEditingProjection _viewportFrame(int projectionRevision, int layoutRevision) {
	final stamp = KlpEditingStamp(
		documentId: 'document', pageId: 'page', generation: 0,
		projectionRevision: projectionRevision, contentRevision: 1,
		compositionRevision: 0, layoutRevision: layoutRevision,
		environmentId: 'environment',
	);
	final endpoint = KlpEditingEndpoint('a', 0, KlpEditingAffinity.downstream);
	return KlpEditingProjection(
		stamp: stamp,
		anchor: endpoint,
		focus: endpoint,
		blockSelection: true,
		window: null,
	);
}

KlpEditingDrawing _blocks(KlpEditingProjection projection, {bool bBefore = true, bool bAfter = true, bool bSelected = true, KlpBlockKind bKind = KlpBlockKind.paragraph, bool? taskChecked, bool? toggleCollapsed}) => KlpEditingDrawing(
	projection: projection,
	width: 640,
	height: 480,
	blocks: KlpBlockProjection(
		stamp: projection.stamp,
		width: 640,
		height: 480,
		canUndo: true,
		canRedo: false,
		blocks: [
			_block('a', selected: false, before: false, after: true, y: 0),
			_block('b', selected: bSelected, before: bBefore, after: bAfter, y: 24, kind: bKind, taskChecked: taskChecked, toggleCollapsed: toggleCollapsed),
			_block('c', selected: false, before: true, after: true, y: 48),
			_block('d', selected: false, before: true, after: false, y: 72),
		],
	),
	commands: const [],
);

KlpBlockItem _block(String id, {required bool selected, required bool before, required bool after, required double y, KlpBlockKind kind = KlpBlockKind.paragraph, bool? taskChecked, bool? toggleCollapsed, int? nestingDepth, int? listOrdinal, bool canIndent = false, bool canOutdent = false}) => KlpBlockItem(
	id: id,
	kind: kind,
	textKind: kind == KlpBlockKind.paragraph ? KlpBlockTextKind.paragraph : null,
	taskChecked: taskChecked,
	toggleCollapsed: toggleCollapsed,
	nestingDepth: nestingDepth,
	listOrdinal: listOrdinal,
	canIndent: canIndent,
	canOutdent: canOutdent,
	selected: selected,
	canMoveBefore: before,
	canMoveAfter: after,
	hitRect: (x: 0, y: y, width: 640, height: 24),
	visualRect: (x: 8, y: y + 4, width: 32, height: 16),
);

KlpEditingDrawing _rangeBlocks(KlpEditingProjection projection) => KlpEditingDrawing(
	projection: projection,
	width: 640,
	height: 480,
	blocks: KlpBlockProjection(
		stamp: projection.stamp,
		width: 640,
		height: 480,
		canUndo: true,
		canRedo: false,
		blocks: [
			_block('a', selected: false, before: false, after: true, y: 0),
			KlpBlockItem(id: 'b', kind: KlpBlockKind.paragraph, textKind: KlpBlockTextKind.paragraph, selected: true, selectionAnchor: true, selectionFocus: false, canMoveBefore: true, canMoveAfter: true, hitRect: (x: 0, y: 24, width: 640, height: 24), visualRect: (x: 8, y: 28, width: 32, height: 16)),
			KlpBlockItem(id: 'c', kind: KlpBlockKind.paragraph, textKind: KlpBlockTextKind.paragraph, selected: true, selectionAnchor: false, selectionFocus: true, canMoveBefore: true, canMoveAfter: true, hitRect: (x: 0, y: 48, width: 640, height: 24), visualRect: (x: 8, y: 52, width: 32, height: 16)),
			_block('d', selected: false, before: true, after: false, y: 72),
		],
	),
	commands: const [],
);

KlpEditingDrawing _listRange(KlpEditingProjection projection) => KlpEditingDrawing(
	projection: projection,
	width: 640,
	height: 480,
	blocks: KlpBlockProjection(
		stamp: projection.stamp, width: 640, height: 480, canUndo: true, canRedo: false,
		blocks: [
			_block('a', selected: false, before: false, after: true, y: 0, kind: KlpBlockKind.orderedListItem, nestingDepth: 0, listOrdinal: 1),
			KlpBlockItem(id: 'b', kind: KlpBlockKind.orderedListItem, textKind: null, nestingDepth: 0, listOrdinal: 2, canIndent: true, selected: true, selectionAnchor: true, selectionFocus: false, canMoveBefore: true, canMoveAfter: true, hitRect: (x: 0, y: 24, width: 640, height: 24), visualRect: (x: 8, y: 28, width: 32, height: 16)),
			KlpBlockItem(id: 'c', kind: KlpBlockKind.orderedListItem, textKind: null, nestingDepth: 0, listOrdinal: 3, canIndent: true, selected: true, selectionAnchor: false, selectionFocus: true, canMoveBefore: true, canMoveAfter: true, hitRect: (x: 0, y: 48, width: 640, height: 24), visualRect: (x: 8, y: 52, width: 32, height: 16)),
		],
	),
	commands: const [],
);

final class _Actions implements KlpBoundBlockActions {
	final List<KlpBlockRequest> requests = [];
	final List<KlpBlockViewportRequest> viewportRequests = [];
	final KlpEditingProjection projection;
	KlpEditingReply Function(KlpBlockViewportRequest request)? viewportReply;
	Completer<KlpEditingReply>? pending;
	Object? failure;
	int sequence = 0;

	_Actions(this.projection);

	@override
	int issueCommandSequence() => ++sequence;

	@override
	Future<KlpEditingReply> submitBlock(KlpBlockRequest request, {required int committedAtMs}) {
		requests.add(request);
		if (failure case final error?) return Future.error(error);
		final wait = pending;
		return wait?.future ?? Future.value(KlpEditingReply(KlpEditingDecision.accepted, projection));
	}

	@override
	Future<KlpEditingReply> submitBlockViewport(KlpBlockViewportRequest request, {required int committedAtMs}) async {
		viewportRequests.add(request);
		return viewportReply?.call(request) ?? KlpEditingReply(KlpEditingDecision.rejected, projection);
	}
}

void main() {
	test('text and block commands share one issuer after confirmed interruption', () async {
		final textRequests = <KlpEditingRequest>[];
		final actions = _Actions(_text(2, 'a中', 0));
		final text = KlpFlutterTextInputSession(_text(0, '中', 0), (request) {
			textRequests.add(request);
			final next = textRequests.length == 1 ? _text(1, 'a中', 1) : _text(2, 'a中', 0);
			return KlpEditingReply(KlpEditingDecision.accepted, next);
		}, sequence: KlpEditingCommandSequence(actions.issueCommandSequence));
		final plan = KlpFlutterTextPlan.fromDelta(KlpFlutterTextDelta.decode(text.projection.window!, const TextEditingDeltaInsertion(
			oldText: '中', textInserted: 'a', insertionOffset: 0,
			selection: TextSelection.collapsed(offset: 0), composing: TextRange.empty,
		)));
		expect((await text.submit(plan)).synchronized, isTrue);

		var interruptions = 0;
		final blocks = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(actions.issueCommandSequence), () => _blocks(text.projection), () async { interruptions++; });
		await blocks.select('b');
		expect(textRequests.map((request) => request.sequence), [1, 2]);
		expect(actions.requests.single.sequence, 3);
		expect(interruptions, 1);
	});

	test('failed interruption and pending command do not dispatch another block command', () async {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		final failed = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => _blocks(projection), () => Future.error(StateError('unknown interruption')));
		await expectLater(failed.select('b'), throwsStateError);
		expect(actions.requests, isEmpty);

		final authority = Completer<KlpEditingReply>();
		actions.pending = authority;
		final active = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => _blocks(projection), () async {});
		final first = active.moveBefore('b');
		await expectLater(active.moveAfter('b'), throwsStateError);
		expect(actions.requests, hasLength(1));
		authority.complete(KlpEditingReply(KlpEditingDecision.accepted, projection));
		await first;

		final interruption = Completer<void>();
		final closingActions = _Actions(projection);
		final closing = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', closingActions), KlpEditingCommandSequence(), () => _blocks(projection), () => interruption.future);
		final late = closing.select('b');
		closing.close();
		interruption.complete();
		await expectLater(late, throwsStateError);
		expect(closingActions.requests, isEmpty);
	});

	test('movement uses only the selected adjacent stable id', () async {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		final session = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => _blocks(projection), () async {});
		await session.moveBefore('b');
		expect(actions.requests.single.targetId, 'a');
		await expectLater(session.moveBefore('a'), throwsStateError);
		expect(actions.requests, hasLength(1));
	});

	test('range selection and movement carry stable endpoints', () async {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		var drawing = _blocks(projection);
		final session = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => drawing, () async {});
		await session.selectRange('b', 'c');
		expect(actions.requests.single.blockId, 'b');
		expect(actions.requests.single.rangeEndId, 'c');
		drawing = _rangeBlocks(projection);
		await session.moveAfter('c');
		expect(actions.requests.last.blockId, 'b');
		expect(actions.requests.last.rangeEndId, 'c');
		expect(actions.requests.last.targetId, 'd');

		session.beginDrop('c');
		final preview = session.previewDrop('a', KlpBlockDropPlacement.before);
		expect(preview.blockId, 'b');
		expect(preview.rangeEndId, 'c');
		await session.commitDrop();
		expect(actions.requests.last.blockId, 'b');
		expect(actions.requests.last.rangeEndId, 'c');
	});

	test('drop preview is local and commits one non-adjacent stable request', () async {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		final session = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => _blocks(projection), () async {});
		session.beginDrop('b');
		final preview = session.previewDrop('d', KlpBlockDropPlacement.after);
		expect(actions.requests, isEmpty);
		expect(preview.blockId, 'b');
		expect(preview.targetId, 'd');
		expect(preview.placement, KlpBlockDropPlacement.after);
		session.clearDropPreview();
		expect(session.dropPreview, isNull);
		final restored = session.previewDrop('d', KlpBlockDropPlacement.after);
		expect(restored.targetId, 'd');
		await session.commitDrop();
		expect(actions.requests, hasLength(1));
		expect(actions.requests.single.intent, KlpBlockIntent.moveAfter);
		expect(actions.requests.single.targetId, 'd');
		expect(session.dropPreview, isNull);
	});

	test('drop cancellation and stale or invalid sources never submit', () async {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		var drawing = _blocks(projection);
		final session = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => drawing, () async {});
		session.beginDrop('b');
		session.previewDrop('a', KlpBlockDropPlacement.before);
		session.cancelDrop();
		await expectLater(session.commitDrop(), throwsStateError);
		expect(actions.requests, isEmpty);

		session.beginDrop('b');
		session.previewDrop('a', KlpBlockDropPlacement.before);
		drawing = _blocks(_text(2, 'A', 0));
		expect(session.dropPreview, isNull);
		await expectLater(session.commitDrop(), throwsStateError);
		expect(actions.requests, isEmpty);
		expect(session.dropPreview, isNull);

		final invalid = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => _blocks(projection), () async {});
		await expectLater(Future<void>.sync(() => invalid.beginDrop('a')), throwsStateError);
		invalid.beginDrop('b');
		await expectLater(Future<void>.sync(() => invalid.previewDrop('b', KlpBlockDropPlacement.before)), throwsStateError);
		expect(invalid.dropPreview, isNull);
		invalid.beginDrop('b');
		await expectLater(Future<void>.sync(() => invalid.previewDrop('missing', KlpBlockDropPlacement.before)), throwsStateError);
		expect(invalid.dropPreview, isNull);

		final unavailable = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => _blocks(projection, bBefore: false, bAfter: false), () async {});
		await expectLater(Future<void>.sync(() => unavailable.beginDrop('b')), throwsStateError);
		expect(actions.requests, isEmpty);

		final exclusive = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => _blocks(projection), () async {});
		exclusive.beginDrop('b');
		await expectLater(exclusive.select('b'), throwsStateError);
		exclusive.cancelDrop();
	});

	test('drop viewport rebase preserves source and clears stale preview', () async {
		final initial = _viewportFrame(1, 1);
		var drawing = _blocks(initial);
		final actions = _Actions(initial);
		actions.viewportReply = (request) {
			drawing = _blocks(_viewportFrame(2, 2));
			return KlpEditingReply(KlpEditingDecision.accepted, drawing.projection);
		};
		final session = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => drawing, () async {});
		session.beginDrop('b');
		session.previewDrop('d', KlpBlockDropPlacement.after);
		expect(await session.scrollDropViewport(8), isTrue);
		expect(session.dropPreview, isNull);
		expect(actions.viewportRequests.single.blockId, 'b');
		expect(actions.viewportRequests.single.expected.layoutRevision, 1);
		final preview = session.previewDrop('d', KlpBlockDropPlacement.after);
		expect(preview.expected.layoutRevision, 2);
	});

	test('conversion carries one closed text semantic for the selected block', () async {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		final session = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => _blocks(projection), () async {});
		await session.convert('b', KlpBlockTextKind.heading2);
		final request = actions.requests.single;
		expect(request.intent, KlpBlockIntent.convert);
		expect(request.blockId, 'b');
		expect(request.targetId, isNull);
		expect(request.conversion, KlpBlockTextKind.heading2);
		expect(
			() => KlpBlockRequest(sequence: 2, expected: projection.stamp, blockId: 'b', intent: KlpBlockIntent.convert),
			throwsArgumentError,
		);
	});

	test('list operations carry the current stable range', () async {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		final drawing = _listRange(projection);
		final session = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => drawing, () async {});
		await session.convertSelectionToUnorderedList();
		await session.indentSelection();
		expect(actions.requests[0].intent, KlpBlockIntent.convertToUnorderedList);
		expect(actions.requests[0].blockId, 'b');
		expect(actions.requests[0].rangeEndId, 'c');
		expect(actions.requests[1].intent, KlpBlockIntent.indentList);
		expect(actions.requests[1].blockId, 'b');
		expect(actions.requests[1].rangeEndId, 'c');
		expect(
			() => KlpBlockRequest(sequence: 3, expected: projection.stamp, blockId: 'b', rangeEndId: 'c', intent: KlpBlockIntent.undo),
			throwsArgumentError,
		);
	});

	test('root list outdent is rejected without interrupting text input', () {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		var interrupted = false;
		final session = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => _listRange(projection), () async { interrupted = true; });
		expect(session.outdentSelection, throwsStateError);
		expect(interrupted, isFalse);
		expect(actions.requests, isEmpty);
	});

	test('list operation rejects a changed selection after input interruption', () async {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		var drawing = _listRange(projection);
		final session = KlpFlutterBlockControlSession(KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(), () => drawing, () async { drawing = _blocks(projection); });
		await expectLater(session.indentSelection(), throwsStateError);
		expect(actions.requests, isEmpty);
	});

	test('task and toggle state commands target matching blocks without selection choreography', () async {
		final projection = _text(1, 'A', 0);
		final actions = _Actions(projection);
		final task = KlpFlutterBlockControlSession(
			KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(),
			() => _blocks(projection, bSelected: false, bKind: KlpBlockKind.taskListItem, taskChecked: false), () async {},
		);
		await task.toggleTaskChecked('b');
		final request = actions.requests.single;
		expect(request.intent, KlpBlockIntent.toggleTaskChecked);
		expect(request.targetId, isNull);
		expect(request.conversion, isNull);
		await expectLater(task.toggleCollapsed('b'), throwsStateError);

		final toggle = KlpFlutterBlockControlSession(
			KlpBoundBlockControls('controls', actions), KlpEditingCommandSequence(),
			() => _blocks(projection, bSelected: false, bKind: KlpBlockKind.toggleListItem, toggleCollapsed: false), () async {},
		);
		await toggle.toggleCollapsed('b');
		expect(actions.requests.last.intent, KlpBlockIntent.toggleCollapsed);
		expect(
			() => KlpBlockRequest(sequence: 3, expected: projection.stamp, blockId: 'b', intent: KlpBlockIntent.toggleTaskChecked, targetId: 'a'),
			throwsArgumentError,
		);
	});
}
