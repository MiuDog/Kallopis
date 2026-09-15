import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_drop_preview.dart';
import 'package:kallopis/src/capabilities/editing/klp_block_drop_target.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_item.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart';

KlpEditingStamp _stamp() => KlpEditingStamp(documentId: 'document', pageId: 'page', generation: 0, projectionRevision: 1, contentRevision: 1, compositionRevision: 0, layoutRevision: 1, environmentId: 'environment');

KlpBlockItem _block(String id, double y, {bool before = true, bool after = true}) => KlpBlockItem(
	id: id,
	kind: KlpBlockKind.paragraph,
	textKind: KlpBlockTextKind.paragraph,
	selected: id == 'b',
	canMoveBefore: before,
	canMoveAfter: after,
	hitRect: (x: 0, y: y, width: 200, height: 20),
	visualRect: (x: 10, y: y, width: 180, height: 18),
);

void main() {
	test('drop preview carries stable identities and an explicit landing side', () {
		final preview = KlpBlockDropPreview(expected: _stamp(), blockId: 'source', targetId: 'target', placement: KlpBlockDropPlacement.after);
		expect(preview.blockId, 'source');
		expect(preview.targetId, 'target');
		expect(preview.placement, KlpBlockDropPlacement.after);
	});

	test('drop preview rejects missing and self identities', () {
		expect(() => KlpBlockDropPreview(expected: _stamp(), blockId: '', targetId: 'target', placement: KlpBlockDropPlacement.before), throwsArgumentError);
		expect(() => KlpBlockDropPreview(expected: _stamp(), blockId: 'same', targetId: 'same', placement: KlpBlockDropPlacement.before), throwsArgumentError);
	});

	test('drop target uses hit halves and rejects adjacent no-op', () {
		final blocks = [_block('a', 0), _block('b', 20), _block('c', 40), _block('d', 60)];
		expect(klpResolveBlockDropTarget(blocks: blocks, sourceId: 'b', pointerY: 61, viewportHeight: 100)?.targetId, 'd');
		expect(klpResolveBlockDropTarget(blocks: blocks, sourceId: 'b', pointerY: 61, viewportHeight: 100)?.placement, KlpBlockDropPlacement.before);
		expect(klpResolveBlockDropTarget(blocks: blocks, sourceId: 'b', pointerY: 19, viewportHeight: 100), isNull);
	});

	test('drop target ignores offscreen blocks and immovable sources', () {
		final blocks = [_block('a', -40), _block('b', 20, before: false, after: false), _block('c', 40), _block('d', 80)];
		expect(klpResolveBlockDropTarget(blocks: blocks, sourceId: 'b', pointerY: 95, viewportHeight: 100), isNull);
		expect(() => klpResolveBlockDropTarget(blocks: blocks, sourceId: 'missing', pointerY: 20, viewportHeight: 100), throwsStateError);
		expect(() => klpResolveBlockDropTarget(blocks: blocks, sourceId: 'b', pointerY: double.nan, viewportHeight: 100), throwsArgumentError);
	});

	test('drop target allows edge blocks to cross the list', () {
		final first = [_block('a', 0, before: false), _block('b', 20), _block('c', 40), _block('d', 60)];
		expect(klpResolveBlockDropTarget(blocks: first, sourceId: 'a', pointerY: 61, viewportHeight: 100)?.placement, KlpBlockDropPlacement.before);
		final last = [_block('a', 0), _block('b', 20), _block('c', 40), _block('d', 60, after: false)];
		expect(klpResolveBlockDropTarget(blocks: last, sourceId: 'd', pointerY: 19, viewportHeight: 100)?.placement, KlpBlockDropPlacement.after);
	});

	test('keyboard targets cover every changed insertion index in order', () {
		final blocks = [_block('a', 0), _block('b', 20), _block('c', 40), _block('d', 60)];
		final targets = klpBlockDropTargets(blocks, 'b');
		expect(targets.map((target) => target.destinationIndex), [0, 2, 3]);
		expect(targets.map((target) => '${target.targetId}:${target.placement.name}'), ['a:before', 'd:before', 'd:after']);
	});

	test('range targets remove the complete contiguous source', () {
		final blocks = [_block('a', 0), _block('b', 20), _block('c', 40), _block('d', 60)];
		final targets = klpBlockDropTargets(blocks, 'b', sourceEndId: 'c');
		expect(targets.map((target) => target.destinationIndex), [0, 2]);
		expect(targets.map((target) => '${target.targetId}:${target.placement.name}'), ['a:before', 'd:after']);
		expect(klpResolveBlockDropTarget(blocks: blocks, sourceId: 'b', sourceEndId: 'c', pointerY: 41, viewportHeight: 100), isNull);
	});
}
