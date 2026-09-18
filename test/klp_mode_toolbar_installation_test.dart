import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/kallopis_editing_provider.dart';
import 'package:kallopis/src/features/editing/adapters/klp_editing_adapter.dart';
import 'package:kallopis/src/features/editing/adapters/klp_mode_toolbar_adapter.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';

KlpEditingDrawing _drawing({int revision = 1, int? modeRevision, KlpEditorInputPurpose purpose = KlpEditorInputPurpose.navigation}) {
	final stamp = KlpEditingStamp(
		documentId: 'document', pageId: 'page', generation: 0,
		projectionRevision: revision, contentRevision: 1,
		compositionRevision: 0, layoutRevision: revision, environmentId: 'environment',
	);
	final endpoint = KlpEditingEndpoint('a', 0, KlpEditingAffinity.downstream);
	return KlpEditingDrawing(
		projection: KlpEditingProjection(stamp: stamp, anchor: endpoint, focus: endpoint, blockSelection: false),
		width: 640, height: 480,
		editorModes: KlpEditorModeProjection(
			stamp: stamp, revision: modeRevision ?? revision, activeModeId: purpose.name, activeToolId: '${purpose.name}-tool', transition: KlpEditorModeTransition.ready,
			modes: [KlpEditorModeItem(id: purpose.name, label: purpose.name, purpose: purpose, availability: KlpEditorModeAvailability.enabled)],
			tools: [KlpEditorToolItem(
				id: '${purpose.name}-tool', label: purpose.name, modeId: purpose.name, availability: KlpEditorModeAvailability.enabled,
				pointerKinds: const {KlpEditorPointerKind.mouse},
				acceptsTextInput: purpose == KlpEditorInputPurpose.text,
				controlsViewport: purpose == KlpEditorInputPurpose.navigation,
				commitsInk: purpose == KlpEditorInputPurpose.handwriting,
			)],
			viewport: KlpEditorViewportProjection(stamp: stamp, width: 640, height: 480, contentExtent: 480, scrollY: 0),
		),
		commands: const [],
	);
}

class _ReadonlySource implements KlpEditingSource {
	KlpEditingDrawing _drawing;
	final StreamController<KlpEditingDrawing> _drawings = StreamController<KlpEditingDrawing>.broadcast();
	_ReadonlySource(this._drawing);
	@override
	KlpEditingDrawing get drawing => _drawing;
	@override
	Stream<KlpEditingDrawing> get drawings => _drawings.stream;
	void publish(KlpEditingDrawing drawing) {
		_drawing = drawing;
		_drawings.add(drawing);
	}
	Future<void> close() => _drawings.close();
}

final class _ModeSource extends _ReadonlySource implements KlpEditorModeSource {
	int sequence = 0;
	_ModeSource(super.drawing);
	@override
	int issueCommandSequence() => ++sequence;
	@override
	KlpEditorModeReply submitEditorMode(KlpEditorModeRequest request, {required int committedAtMs}) => KlpEditorModeReply(KlpEditingDecision.rejected, drawing.projection, drawing.editorModes!);
	@override
	KlpEditorModeReply submitEditorViewport(KlpEditorViewportRequest request, {required int committedAtMs}) => KlpEditorModeReply(KlpEditingDecision.rejected, drawing.projection, drawing.editorModes!);
}

KlpTreeRuntime _install(KlpEditingSource source) {
	final runtime = KlpTreeRuntime();
	runtime.update(
		root: KlpEditingContent(
			id: KlpId.parse('editing'),
			source: source,
			modeToolbar: KlpModeToolbar(id: KlpId.parse('modes')),
		),
		adapters: [KlpEditingAdapter(), KlpModeToolbarAdapter()], primitives: KlpWorkspacePreset.light(),
	);
	return runtime;
}

void main() {
	test('mode tool slot qualification is available from declarative entry', () {
		final KlpModeToolSlotChild child = KlpModeToolbar(id: KlpId.parse('modes'));
		expect(child, isA<KlpModeToolbar>());
	});

	test('mode toolbar inherits only its enclosing editor source', () async {
		final source = _ModeSource(_drawing());
		final runtime = _install(source);
		final editing = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundEditing;
		expect((editing.modeToolbar!.id, editing.modeToolbar!.actions.issueCommandSequence()), ('modes', 1));
		runtime.dispose();
		await source.close();
	});

	test('missing capability and orphan mode toolbar are rejected', () async {
		final readonly = _ReadonlySource(_drawing());
		expect(() => _install(readonly), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'missing_editor_mode_capability')));
		await readonly.close();
		final runtime = KlpTreeRuntime();
		expect(
			() => runtime.update(root: KlpModeToolbar(id: KlpId.parse('modes')), adapters: [KlpModeToolbarAdapter()], primitives: KlpWorkspacePreset.light()),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'orphan_mode_toolbar')),
		);
	});

	test('text and handwriting tools require their installed handlers', () async {
		final text = _ModeSource(_drawing(purpose: KlpEditorInputPurpose.text));
		expect(() => _install(text), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'missing_text_mode_capability')));
		await text.close();
		final handwriting = _ModeSource(_drawing(purpose: KlpEditorInputPurpose.handwriting));
		expect(() => _install(handwriting), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'missing_handwriting_capability')));
		await handwriting.close();
	});

	test('later publication cannot enable a missing text handler', () async {
		late _ModeSource source;
		late KlpTreeRuntime runtime;
		late KlpBoundEditing editing;
		final errors = <Object>[];
		await runZonedGuarded(() async {
			source = _ModeSource(_drawing());
			runtime = _install(source);
			editing = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundEditing;
			source.publish(_drawing(revision: 2, purpose: KlpEditorInputPurpose.text));
			await Future<void>.delayed(Duration.zero);
		}, (error, stack) => errors.add(error));
		expect(errors, hasLength(1));
		expect(errors.single, isA<KlpContractError>().having((error) => error.code, 'code', 'missing_text_mode_capability'));
		expect(editing.drawing.value.editorModes!.activePurpose, KlpEditorInputPurpose.navigation);
		runtime.dispose();
		await source.close();
	});

	test('later publication cannot reuse an older mode revision', () async {
		late _ModeSource source;
		late KlpTreeRuntime runtime;
		final errors = <Object>[];
		await runZonedGuarded(() async {
			source = _ModeSource(_drawing());
			runtime = _install(source);
			source.publish(_drawing(revision: 2, modeRevision: 1));
			await Future<void>.delayed(Duration.zero);
		}, (error, stack) => errors.add(error));
		expect(errors.single, isA<KlpContractError>().having((error) => error.code, 'code', 'editor_mode_revision_regression'));
		runtime.dispose();
		await source.close();
	});
}
