import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';

KlpEditingStamp _stamp(int revision) => KlpEditingStamp(
	documentId: 'document', pageId: 'page', generation: 0,
	projectionRevision: revision, contentRevision: revision,
	compositionRevision: 0, layoutRevision: 1, environmentId: 'environment',
);

KlpCommandAnchor _anchor(KlpEditingStamp stamp) => KlpCaretCommandAnchor(
	stamp: stamp,
	viewportWidth: 640,
	viewportHeight: 480,
	rect: (x: 20, y: 20, width: 1, height: 24),
	endpoint: KlpEditingEndpoint('a', 0, KlpEditingAffinity.downstream),
);

KlpCommandItem _item(String id, {bool enabled = true}) => KlpCommandItem(
	id: id,
	label: id,
	availability: enabled ? KlpCommandAvailability.enabled : KlpCommandAvailability.disabled,
	disabledReason: enabled ? null : 'Unavailable',
	selected: false,
	tone: KlpCommandTone.neutral,
);

void main() {
	test('command projection accepts empty and all-disabled candidate sets', () {
		final stamp = _stamp(1);
		expect(KlpCommandProjection(stamp: stamp, revision: 1, anchor: _anchor(stamp), emptyLabel: 'Empty', items: const []).items, isEmpty);
		expect(KlpCommandProjection(stamp: stamp, revision: 2, anchor: _anchor(stamp), emptyLabel: 'Empty', items: [_item('disabled', enabled: false)]).items.single.enabled, isFalse);
	});

	test('command projection rejects duplicate ids and mixed frame identity', () {
		final stamp = _stamp(1);
		expect(() => KlpCommandProjection(stamp: stamp, revision: 1, anchor: _anchor(stamp), emptyLabel: 'Empty', items: [_item('same'), _item('same')]), throwsArgumentError);
		expect(() => KlpCommandProjection(stamp: _stamp(2), revision: 1, anchor: _anchor(stamp), emptyLabel: 'Empty', items: const []), throwsStateError);
	});

	test('typed anchors reject overflowing geometry', () {
		final stamp = _stamp(1);
		expect(
			() => KlpBlockCommandAnchor(
				stamp: stamp, viewportWidth: 640, viewportHeight: 480,
				rect: (x: double.maxFinite, y: 0, width: double.maxFinite, height: 1), blockId: 'a',
			),
			throwsArgumentError,
		);
	});
}
