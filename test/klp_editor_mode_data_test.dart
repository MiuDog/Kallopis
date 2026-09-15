import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';

KlpEditingStamp _stamp(int revision) => KlpEditingStamp(
	documentId: 'document', pageId: 'page', generation: 0,
	projectionRevision: revision, contentRevision: 1,
	compositionRevision: 0, layoutRevision: revision, environmentId: 'environment',
);

KlpEditorModeItem _mode(String id, KlpEditorInputPurpose purpose, {bool enabled = true}) => KlpEditorModeItem(
	id: id, label: id, purpose: purpose,
	availability: enabled ? KlpEditorModeAvailability.enabled : KlpEditorModeAvailability.disabled,
	disabledReason: enabled ? null : 'Unavailable',
);

KlpEditorToolItem _tool(String id, String modeId, KlpEditorInputPurpose purpose, {bool enabled = true}) => KlpEditorToolItem(
	id: id, label: id, modeId: modeId,
	availability: enabled ? KlpEditorModeAvailability.enabled : KlpEditorModeAvailability.disabled,
	disabledReason: enabled ? null : 'Unavailable',
	pointerKinds: const {KlpEditorPointerKind.mouse},
	acceptsTextInput: purpose == KlpEditorInputPurpose.text,
	controlsViewport: purpose == KlpEditorInputPurpose.navigation,
	commitsInk: purpose == KlpEditorInputPurpose.handwriting,
);

void main() {
	test('mode projection rejects duplicate ids and mismatched handler purpose', () {
		final stamp = _stamp(1);
		final viewport = KlpEditorViewportProjection(stamp: stamp, width: 640, height: 480, contentExtent: 800, scrollY: 0);
		expect(
			() => KlpEditorModeProjection(
				stamp: stamp, revision: 1, activeModeId: 'text', activeToolId: 'tool', transition: KlpEditorModeTransition.ready,
				modes: [_mode('text', KlpEditorInputPurpose.text), _mode('text', KlpEditorInputPurpose.text)],
				tools: [_tool('tool', 'text', KlpEditorInputPurpose.text)], viewport: viewport,
			),
			throwsArgumentError,
		);
		expect(
			() => KlpEditorModeProjection(
				stamp: stamp, revision: 1, activeModeId: 'text', activeToolId: 'tool', transition: KlpEditorModeTransition.ready,
				modes: [_mode('text', KlpEditorInputPurpose.text)],
				tools: [_tool('tool', 'text', KlpEditorInputPurpose.navigation)], viewport: viewport,
			),
			throwsArgumentError,
		);
	});

	test('suspended authority may retain a registered disabled active tool', () {
		final stamp = _stamp(1);
		final projection = KlpEditorModeProjection(
			stamp: stamp, revision: 1, activeModeId: 'ink', activeToolId: 'pen', transition: KlpEditorModeTransition.suspended,
			modes: [_mode('ink', KlpEditorInputPurpose.handwriting, enabled: false)],
			tools: [_tool('pen', 'ink', KlpEditorInputPurpose.handwriting, enabled: false)],
			viewport: KlpEditorViewportProjection(stamp: stamp, width: 640, height: 480, contentExtent: 200, scrollY: 0),
		);
		expect(projection.activePurpose, KlpEditorInputPurpose.handwriting);
	});

	test('viewport rejects scroll outside the core extent', () {
		final stamp = _stamp(1);
		expect(() => KlpEditorViewportProjection(stamp: stamp, width: 640, height: 480, contentExtent: 500, scrollY: 21), throwsArgumentError);
	});
}
