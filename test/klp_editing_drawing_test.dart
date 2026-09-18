import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';

void main() {
	final stamp = KlpEditingStamp(documentId: 'd', pageId: 'p', generation: 0, projectionRevision: 1, contentRevision: 0, compositionRevision: 0, layoutRevision: 1, environmentId: 'e');
	final endpoint = KlpEditingEndpoint('a', 0, KlpEditingAffinity.downstream);
	final projection = KlpEditingProjection(stamp: stamp, anchor: endpoint, focus: endpoint, blockSelection: false);
	KlpEditingDrawing drawing(Iterable<KlpEditingDrawCommand> commands) => KlpEditingDrawing(projection: projection, width: 800, height: 600, commands: commands);
	final rect = (x: 1.0, y: 2.0, width: 3.0, height: 4.0);

	test('drawing rejects mismatched and unclosed canvas scopes before rendering', () {
		expect(() => drawing([const KlpEditingPopClip()]), throwsArgumentError);
		expect(() => drawing([const KlpEditingPopTransform()]), throwsArgumentError);
		expect(() => drawing([KlpEditingPushClip(rect)]), throwsArgumentError);
		expect(() => drawing([KlpEditingPushClip(rect), const KlpEditingPopTransform()]), throwsArgumentError);
		expect(() => drawing([KlpEditingPushTransform([1, 0, 0, 1, 0, 0]), const KlpEditingPopClip()]), throwsArgumentError);
		final valid = drawing([
			KlpEditingPushClip(rect),
			KlpEditingPushTransform([1, 0, 0, -1, 0, 0]),
			KlpEditingDrawRect(rect, KlpEditingPaintRole.caret),
			const KlpEditingPopTransform(),
			const KlpEditingPopClip(),
		]);
		expect(valid.projection, same(projection));
	});

	test('provider geometry rejects nonfinite and malformed inputs', () {
		for (final bad in [double.nan, double.infinity, double.negativeInfinity]) {
			expect(() => KlpEditingDrawRect((x: bad, y: 0, width: 1, height: 1), KlpEditingPaintRole.caret), throwsArgumentError);
			expect(() => KlpEditingPushTransform([1, 0, 0, 1, bad, 0]), throwsArgumentError);
			expect(() => KlpEditingPathCommand(KlpEditingPathOperation.move, [0, bad]), throwsArgumentError);
			expect(() => KlpEditingDrawing(projection: projection, width: bad, height: 1, commands: []), throwsArgumentError);
		}
		expect(() => KlpEditingPushClip((x: 0, y: 0, width: -1, height: 1)), throwsArgumentError);
		expect(() => KlpEditingPushTransform([1, 0, 0, 1]), throwsArgumentError);
		expect(() => KlpEditingPathCommand(KlpEditingPathOperation.cubic, [0, 0]), throwsArgumentError);
		expect(() => KlpEditingPath([KlpEditingPathCommand(KlpEditingPathOperation.line, [1, 1])]), throwsArgumentError);
	});

	test('published geometry owns immutable input snapshots', () {
		final coordinates = <double>[1, 2];
		final move = KlpEditingPathCommand(KlpEditingPathOperation.move, coordinates);
		final contour = <KlpEditingPathCommand>[move];
		final path = KlpEditingPath(contour);
		final commands = <KlpEditingDrawCommand>[KlpEditingDrawPath(path, KlpEditingPaintRole.text)];
		final snapshot = drawing(commands);
		coordinates[0] = 99;
		contour.clear();
		commands.clear();
		expect(move.values, [1, 2]);
		expect(path.commands, [move]);
		expect(snapshot.commands, hasLength(1));
		expect(() => snapshot.commands.clear(), throwsUnsupportedError);
		expect(() => path.commands.clear(), throwsUnsupportedError);
		expect(() => move.values.clear(), throwsUnsupportedError);
	});
}
