import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/kallopis_editing_provider.dart';
import 'package:kallopis/src/features/editing/adapters/klp_anchored_commands_adapter.dart';
import 'package:kallopis/src/features/editing/adapters/klp_editing_adapter.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';

KlpEditingDrawing _drawing() {
	final stamp = KlpEditingStamp(
		documentId: 'document', pageId: 'page', generation: 0,
		projectionRevision: 1, contentRevision: 1,
		compositionRevision: 0, layoutRevision: 1, environmentId: 'environment',
	);
	final endpoint = KlpEditingEndpoint('a', 0, KlpEditingAffinity.downstream);
	final projection = KlpEditingProjection(stamp: stamp, anchor: endpoint, focus: endpoint, blockSelection: false);
	return KlpEditingDrawing(
		projection: projection,
		width: 640,
		height: 480,
		anchoredCommands: KlpCommandProjection(
			stamp: stamp,
			revision: 1,
			anchor: KlpCaretCommandAnchor(stamp: stamp, viewportWidth: 640, viewportHeight: 480, rect: (x: 20, y: 20, width: 1, height: 24), endpoint: endpoint),
			emptyLabel: 'Empty',
			items: const [],
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

final class _CommandSource extends _ReadonlySource implements KlpAnchoredCommandSource {
	KlpCommandRequest? request;
	int _sequence = 0;
	_CommandSource(super.drawing);
	@override
	int issueCommandSequence() => ++_sequence;
	@override
	KlpCommandReply submitAnchoredCommand(KlpCommandRequest request, {required int committedAtMs}) {
		this.request = request;
		return KlpCommandReply(KlpEditingDecision.accepted, drawing.projection);
	}
}

KlpTreeRuntime _install(KlpEditingSource source) {
	final runtime = KlpTreeRuntime();
	runtime.update(
		root: KlpEditingContent(
			id: KlpId.parse('editing'),
			source: source,
			anchoredCommands: KlpAnchoredCommands(id: KlpId.parse('commands')),
		),
		adapters: [KlpEditingAdapter(), KlpAnchoredCommandsAdapter()],
		primitives: KlpWorkspacePreset.light(),
	);
	return runtime;
}

void main() {
	test('anchored commands inherit only the enclosing editing source', () async {
		final source = _CommandSource(_drawing());
		final runtime = _install(source);
		final editing = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundEditing;
		expect(editing.anchoredCommands!.id, 'commands');
		expect(editing.anchoredCommands!.actions.issueCommandSequence(), 1);
		runtime.dispose();
		await source.close();
	});

	test('missing capability and orphan command slots are rejected', () async {
		final readonly = _ReadonlySource(_drawing());
		expect(() => _install(readonly), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'missing_anchored_command_capability')));
		await readonly.close();

		final runtime = KlpTreeRuntime();
		expect(
			() => runtime.update(
				root: KlpAnchoredCommands(id: KlpId.parse('commands')),
				adapters: [KlpAnchoredCommandsAdapter()], primitives: KlpWorkspacePreset.light(),
			),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'orphan_anchored_commands')),
		);
	});
}
