import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_editor_mode_session.dart';

KlpEditingDrawing _drawing(int revision, KlpEditorInputPurpose purpose, {double scrollY = 0, bool navigationEnabled = true}) {
	final stamp = KlpEditingStamp(
		documentId: 'document', pageId: 'page', generation: 0,
		projectionRevision: revision, contentRevision: 1,
		compositionRevision: 0, layoutRevision: revision, environmentId: 'environment',
	);
	final endpoint = KlpEditingEndpoint('a', 0, KlpEditingAffinity.downstream);
	final text = KlpEditorModeItem(id: 'text', label: 'Text', purpose: KlpEditorInputPurpose.text, availability: KlpEditorModeAvailability.enabled);
	final navigation = KlpEditorModeItem(
		id: 'navigation', label: 'Navigation', purpose: KlpEditorInputPurpose.navigation,
		availability: navigationEnabled ? KlpEditorModeAvailability.enabled : KlpEditorModeAvailability.disabled,
		disabledReason: navigationEnabled ? null : 'Unavailable',
	);
	final handwriting = KlpEditorModeItem(id: 'handwriting', label: 'Handwriting', purpose: KlpEditorInputPurpose.handwriting, availability: KlpEditorModeAvailability.disabled, disabledReason: 'Unavailable');
	KlpEditorToolItem tool(String id, String mode, KlpEditorInputPurpose channel, {bool enabled = true}) => KlpEditorToolItem(
		id: id, label: id, modeId: mode,
		availability: enabled ? KlpEditorModeAvailability.enabled : KlpEditorModeAvailability.disabled,
		disabledReason: enabled ? null : 'Unavailable', pointerKinds: const {KlpEditorPointerKind.mouse},
		acceptsTextInput: channel == KlpEditorInputPurpose.text,
		controlsViewport: channel == KlpEditorInputPurpose.navigation,
		commitsInk: channel == KlpEditorInputPurpose.handwriting,
	);
	final activeMode = purpose.name;
	final activeTool = '$activeMode-tool';
	final projection = KlpEditingProjection(stamp: stamp, anchor: endpoint, focus: endpoint, blockSelection: false);
	return KlpEditingDrawing(
		projection: projection, width: 640, height: 100,
		editorModes: KlpEditorModeProjection(
			stamp: stamp, revision: revision, activeModeId: activeMode, activeToolId: activeTool, transition: KlpEditorModeTransition.ready,
			modes: [text, navigation, handwriting],
			tools: [
				tool('text-tool', 'text', KlpEditorInputPurpose.text),
				tool('navigation-tool', 'navigation', KlpEditorInputPurpose.navigation, enabled: navigationEnabled),
				tool('handwriting-tool', 'handwriting', KlpEditorInputPurpose.handwriting, enabled: false),
			],
			viewport: KlpEditorViewportProjection(stamp: stamp, width: 640, height: 100, contentExtent: 500, scrollY: scrollY),
		),
		commands: const [],
	);
}

final class _Actions implements KlpBoundEditorModeActions {
	KlpEditingDrawing drawing;
	final List<Object> requests = [];
	Completer<KlpEditorModeReply>? pending;
	Object? failure;
	KlpEditingDecision decision = KlpEditingDecision.accepted;
	int sequence = 0;
	_Actions(this.drawing);
	@override
	int issueCommandSequence() => ++sequence;
	@override
	Future<KlpEditorModeReply> submitEditorMode(KlpEditorModeRequest request, {required int committedAtMs}) => _submit(request, KlpEditorInputPurpose.navigation);
	@override
	Future<KlpEditorModeReply> submitEditorViewport(KlpEditorViewportRequest request, {required int committedAtMs}) => _submit(request, KlpEditorInputPurpose.navigation, scrollY: drawing.editorModes!.viewport.scrollY + request.deltaY);
	Future<KlpEditorModeReply> _submit(Object request, KlpEditorInputPurpose purpose, {double scrollY = 0}) {
		requests.add(request);
		if (failure case final error?) return Future.error(error);
		if (pending case final completer?) return completer.future;
		if (decision == KlpEditingDecision.rejected) return Future.value(KlpEditorModeReply(decision, drawing.projection, drawing.editorModes!));
		drawing = _drawing(drawing.projection.stamp.projectionRevision + 1, purpose, scrollY: scrollY);
		return Future.value(KlpEditorModeReply(KlpEditingDecision.accepted, drawing.projection, drawing.editorModes!));
	}
}

void main() {
	test('viewport handler requires the current drawing size', () {
		final drawing = _drawing(1, KlpEditorInputPurpose.navigation);
		expect(klpCanRouteEditorViewport(drawing, const KlpEditingViewport(width: 640, height: 100), pending: false), isTrue);
		expect(klpCanRouteEditorViewport(drawing, const KlpEditingViewport(width: 641, height: 100), pending: false), isFalse);
		expect(klpCanRouteEditorViewport(drawing, const KlpEditingViewport(width: 640, height: 100), pending: true), isFalse);
	});

	test('mode switch waits for interruption and submits the fresh stamp', () async {
		var drawing = _drawing(1, KlpEditorInputPurpose.text);
		final actions = _Actions(drawing);
		late KlpEditorModeSession session;
		bool? callbackPending;
		session = KlpEditorModeSession(KlpBoundModeToolbar('modes', actions), () => actions.drawing, () async {
			drawing = _drawing(2, KlpEditorInputPurpose.text);
			actions.drawing = drawing;
		}, () {
			drawing = actions.drawing;
			callbackPending = session.pending;
		});
		final reply = await session.switchTo('navigation', 'navigation-tool');
		expect(reply.decision, KlpEditingDecision.accepted);
		expect((actions.requests.single as KlpEditorModeRequest).expected, _drawing(2, KlpEditorInputPurpose.text).projection.stamp);
		expect(callbackPending, isFalse);
	});

	test('known failed switches restore input while unknown authority remains blocked', () async {
		final rejectedDrawing = _drawing(1, KlpEditorInputPurpose.text);
		final rejectedActions = _Actions(rejectedDrawing)..decision = KlpEditingDecision.rejected;
		var rejectedSettled = 0;
		final rejected = KlpEditorModeSession(KlpBoundModeToolbar('modes', rejectedActions), () => rejectedActions.drawing, () async {}, () { rejectedSettled++; });
		expect((await rejected.switchTo('navigation', 'navigation-tool')).decision, KlpEditingDecision.rejected);
		expect((rejectedSettled, rejected.requiresResync), (1, false));

		final revokedActions = _Actions(_drawing(1, KlpEditorInputPurpose.text));
		var revokedSettled = 0;
		final revoked = KlpEditorModeSession(KlpBoundModeToolbar('modes', revokedActions), () => revokedActions.drawing, () async {
			revokedActions.drawing = _drawing(2, KlpEditorInputPurpose.text, navigationEnabled: false);
		}, () { revokedSettled++; });
		await expectLater(revoked.switchTo('navigation', 'navigation-tool'), throwsStateError);
		expect((revokedSettled, revokedActions.requests.length, revoked.requiresResync), (1, 0, false));

		final unknownActions = _Actions(_drawing(1, KlpEditorInputPurpose.text))..failure = StateError('unknown');
		var unknownSettled = 0;
		final unknown = KlpEditorModeSession(KlpBoundModeToolbar('modes', unknownActions), () => unknownActions.drawing, () async {}, () { unknownSettled++; });
		await expectLater(unknown.switchTo('navigation', 'navigation-tool'), throwsStateError);
		expect((unknownSettled, unknown.requiresResync), (0, true));
	});

	test('navigation uses one handler and one in-flight viewport request', () async {
		var drawing = _drawing(1, KlpEditorInputPurpose.navigation);
		final actions = _Actions(drawing);
		final pending = Completer<KlpEditorModeReply>();
		actions.pending = pending;
		final session = KlpEditorModeSession(KlpBoundModeToolbar('modes', actions), () => drawing, () async {}, () {});
		final first = session.navigateBy(40);
		await expectLater(session.navigateBy(10), throwsStateError);
		expect(actions.requests, hasLength(1));
		drawing = _drawing(2, KlpEditorInputPurpose.navigation, scrollY: 40);
		actions.drawing = drawing;
		pending.complete(KlpEditorModeReply(KlpEditingDecision.accepted, drawing.projection, drawing.editorModes!));
		await first;
	});

	test('disabled mode is known unavailable while unknown result blocks retry', () async {
		final drawing = _drawing(1, KlpEditorInputPurpose.text);
		final actions = _Actions(drawing);
		final session = KlpEditorModeSession(KlpBoundModeToolbar('modes', actions), () => drawing, () async {}, () {});
		await expectLater(session.switchTo('handwriting', 'handwriting-tool'), throwsStateError);
		expect(actions.requests, isEmpty);
		expect(session.requiresResync, isFalse);
		actions.failure = StateError('unknown');
		await expectLater(session.switchTo('navigation', 'navigation-tool'), throwsStateError);
		expect(session.requiresResync, isTrue);
		await expectLater(session.switchTo('navigation', 'navigation-tool'), throwsStateError);
		expect(actions.requests, hasLength(1));
	});

	test('close during interruption prevents late mode dispatch', () async {
		final drawing = _drawing(1, KlpEditorInputPurpose.text);
		final actions = _Actions(drawing);
		final interrupted = Completer<void>();
		final session = KlpEditorModeSession(KlpBoundModeToolbar('modes', actions), () => drawing, () => interrupted.future, () {});
		final switching = session.switchTo('navigation', 'navigation-tool');
		session.close();
		interrupted.complete();
		await expectLater(switching, throwsStateError);
		expect(actions.requests, isEmpty);
	});

	test('close while provider is pending isolates the late result', () async {
		final drawing = _drawing(1, KlpEditorInputPurpose.text);
		final actions = _Actions(drawing);
		final pending = Completer<KlpEditorModeReply>();
		actions.pending = pending;
		var callbacks = 0;
		final session = KlpEditorModeSession(KlpBoundModeToolbar('modes', actions), () => actions.drawing, () async {}, () { callbacks++; });
		final switching = session.switchTo('navigation', 'navigation-tool');
		await Future<void>.delayed(Duration.zero);
		session.close();
		actions.drawing = _drawing(2, KlpEditorInputPurpose.navigation);
		pending.complete(KlpEditorModeReply(KlpEditingDecision.accepted, actions.drawing.projection, actions.drawing.editorModes!));
		expect((await switching).decision, KlpEditingDecision.accepted);
		expect((callbacks, actions.requests.length), (0, 1));
	});
}
