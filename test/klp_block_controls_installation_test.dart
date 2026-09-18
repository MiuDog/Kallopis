import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/kallopis_editing_provider.dart';
import 'package:kallopis/src/features/editing/adapters/klp_block_controls_adapter.dart';
import 'package:kallopis/src/features/editing/adapters/klp_editing_adapter.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';

KlpEditingDrawing _drawing() {
	final stamp = KlpEditingStamp(
		documentId: 'document', pageId: 'page', generation: 0,
		projectionRevision: 1, contentRevision: 1,
		compositionRevision: 0, layoutRevision: 1,
		environmentId: 'environment',
	);
	final endpoint = KlpEditingEndpoint('b', 0, KlpEditingAffinity.downstream);
	return KlpEditingDrawing(
		projection: KlpEditingProjection(stamp: stamp, anchor: endpoint, focus: endpoint, blockSelection: true),
		width: 640,
		height: 480,
		blocks: KlpBlockProjection(
			stamp: stamp,
			width: 640,
			height: 480,
			canUndo: true,
			canRedo: false,
			blocks: [
				KlpBlockItem(
					id: 'b', kind: KlpBlockKind.paragraph, textKind: KlpBlockTextKind.paragraph, selected: true,
					canMoveBefore: true, canMoveAfter: false,
					hitRect: (x: 0, y: 0, width: 640, height: 24),
					visualRect: (x: 8, y: 4, width: 32, height: 16),
				),
			],
		),
		commands: const [],
	);
}

class _ReadonlySource implements KlpEditingSource {
	@override
	final KlpEditingDrawing drawing;
	final StreamController<KlpEditingDrawing> _drawings = StreamController<KlpEditingDrawing>.broadcast();

	_ReadonlySource(this.drawing);

	@override
	Stream<KlpEditingDrawing> get drawings => _drawings.stream;
	Future<void> close() => _drawings.close();
}

final class _BlockSource extends _ReadonlySource implements KlpBlockControlSource {
	KlpBlockRequest? request;

	_BlockSource(super.drawing);
	int _sequence = 0;

	@override
	int issueCommandSequence() => ++_sequence;

	@override
	KlpEditingReply submitBlock(KlpBlockRequest request, {required int committedAtMs}) {
		this.request = request;
		return KlpEditingReply(KlpEditingDecision.accepted, drawing.projection);
	}

	@override
	KlpEditingReply submitBlockViewport(KlpBlockViewportRequest request, {required int committedAtMs}) => KlpEditingReply(KlpEditingDecision.rejected, drawing.projection);
}

KlpTreeRuntime _install(KlpEditingSource source, {bool controls = true}) {
	final runtime = KlpTreeRuntime();
	runtime.update(
		root: KlpEditingContent(
			id: KlpId.parse('editing'),
			source: source,
			blockControls: controls ? KlpBlockControls(id: KlpId.parse('controls')) : null,
		),
		adapters: [KlpEditingAdapter(), KlpBlockControlsAdapter()],
		primitives: KlpWorkspacePreset.light(),
	);
	return runtime;
}

KlpBoundEditing _editing(KlpTreeRuntime runtime) => (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundEditing;

void main() {
	test('block geometry rejects overflowing endpoints', () {
		expect(
			() => KlpBlockItem(
				id: 'b', kind: KlpBlockKind.paragraph, textKind: KlpBlockTextKind.paragraph, selected: false,
				canMoveBefore: false, canMoveAfter: false,
				hitRect: (x: double.maxFinite, y: 0, width: double.maxFinite, height: 1),
				visualRect: (x: 0, y: 0, width: 1, height: 1),
			),
			throwsArgumentError,
		);
		expect(
			() => KlpBlockItem(
				id: 'paragraph', kind: KlpBlockKind.paragraph, textKind: null, selected: false,
				canMoveBefore: false, canMoveAfter: false,
				hitRect: (x: 0, y: 0, width: 1, height: 1),
				visualRect: (x: 0, y: 0, width: 1, height: 1),
			),
			throwsArgumentError,
		);
		expect(
			() => KlpBlockItem(
				id: 'task', kind: KlpBlockKind.taskListItem, textKind: null, selected: false,
				canMoveBefore: false, canMoveAfter: false,
				hitRect: (x: 0, y: 0, width: 1, height: 1),
				visualRect: (x: 0, y: 0, width: 1, height: 1),
			),
			throwsArgumentError,
		);
		expect(
			() => KlpBlockItem(
				id: 'toggle', kind: KlpBlockKind.toggleListItem, textKind: null, taskChecked: false, toggleCollapsed: false, selected: false,
				canMoveBefore: false, canMoveAfter: false,
				hitRect: (x: 0, y: 0, width: 1, height: 1),
				visualRect: (x: 0, y: 0, width: 1, height: 1),
			),
			throwsArgumentError,
		);
	});

	test('list information is closed by structural kind', () {
		final ordered = KlpBlockItem(
			id: 'ordered', kind: KlpBlockKind.orderedListItem, textKind: null,
			nestingDepth: 1, listOrdinal: 7, canIndent: true, canOutdent: true, selected: false,
			canMoveBefore: false, canMoveAfter: false,
			hitRect: (x: 0, y: 0, width: 1, height: 1), visualRect: (x: 0, y: 0, width: 1, height: 1),
		);
		expect(ordered.listOrdinal, 7);
		expect(
			() => KlpBlockItem(
				id: 'invalid', kind: KlpBlockKind.paragraph, textKind: KlpBlockTextKind.paragraph,
				nestingDepth: 0, selected: false, canMoveBefore: false, canMoveAfter: false,
				hitRect: (x: 0, y: 0, width: 1, height: 1), visualRect: (x: 0, y: 0, width: 1, height: 1),
			),
			throwsArgumentError,
		);
	});

	test('block controls inherit the enclosing editing source', () async {
		final source = _BlockSource(_drawing());
		final runtime = _install(source);
		final editing = _editing(runtime);
		final controls = editing.blockControls!;
		final request = KlpBlockRequest(sequence: 1, expected: editing.drawing.value.projection.stamp, blockId: 'b', intent: KlpBlockIntent.undo);

		final reply = await controls.actions.submitBlock(request, committedAtMs: 1);
		expect(controls.id, 'controls');
		expect(source.request, same(request));
		expect(reply.decision, KlpEditingDecision.accepted);

		runtime.dispose();
		await source.close();
	});

	test('block controls reject an enclosing source without the capability', () async {
		final source = _ReadonlySource(_drawing());
		expect(() => _install(source), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'missing_block_control_capability')));
		await source.close();
	});

	test('orphan block controls are rejected during preparation', () {
		final runtime = KlpTreeRuntime();
		expect(
			() => runtime.update(
				root: KlpBlockControls(id: KlpId.parse('controls')),
				adapters: [KlpBlockControlsAdapter()],
				primitives: KlpWorkspacePreset.light(),
			),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'orphan_block_controls')),
		);
	});

	test('reinstalled hosts continue the sequence owned by the same source', () async {
		final source = _BlockSource(_drawing());
		final first = _install(source);
		final firstActions = _editing(first).blockControls!.actions;
		final firstSequence = firstActions.issueCommandSequence();
		await firstActions.submitBlock(KlpBlockRequest(sequence: firstSequence, expected: source.drawing.projection.stamp, blockId: 'b', intent: KlpBlockIntent.undo), committedAtMs: 1);
		first.dispose();

		final second = _install(source);
		final secondActions = _editing(second).blockControls!.actions;
		final secondSequence = secondActions.issueCommandSequence();
		await secondActions.submitBlock(KlpBlockRequest(sequence: secondSequence, expected: source.drawing.projection.stamp, blockId: 'b', intent: KlpBlockIntent.undo), committedAtMs: 2);
		expect((firstSequence, secondSequence), (1, 2));

		second.dispose();
		await source.close();
	});
}
