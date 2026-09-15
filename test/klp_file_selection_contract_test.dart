import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/capabilities/files/klp_file_selection.dart';

void _receive(String path) {}

void main() {
	test('public action is a const declarative intent with unchanged callback identity', () {
		const action = KlpPickFileAction(onPicked: _receive);
		expect(action, isA<KlpAction>());
		expect(action.acceptedExtensions, isEmpty);
		expect(action.onPicked, same(_receive));
		const filtered = KlpPickFileAction(acceptedExtensions: ['png', 'svg'], onPicked: _receive);
		expect(filtered.acceptedExtensions, ['png', 'svg']);
	});

	test('request snapshots extensions and rejects mutation', () {
		final extensions = ['png', 'svg'];
		final request = KlpFileSelectionRequest(acceptedExtensions: extensions);
		extensions[0] = 'txt';
		expect(request.acceptedExtensions, ['png', 'svg']);
		expect(() => request.acceptedExtensions.add('jpg'), throwsUnsupportedError);
		expect(KlpFileSelectionRequest().acceptedExtensions, isEmpty);
	});

	test('sealed results preserve exact path and original failure objects', () {
		final selected = KlpFileSelected(r'C:\原始 路徑\asset.svg');
		final cancelled = KlpFileSelectionCancelled();
		final error = StateError('original');
		final stack = StackTrace.fromString('original stack');
		final failed = KlpFileSelectionFailed(error, stack);
		String kind(KlpFileSelectionResult result) => switch (result) {
			KlpFileSelected() => 'selected',
			KlpFileSelectionCancelled() => 'cancelled',
			KlpFileSelectionFailed() => 'failed',
		};
		expect([kind(selected), kind(cancelled), kind(failed)], ['selected', 'cancelled', 'failed']);
		expect(selected.path, r'C:\原始 路徑\asset.svg');
		expect(failed.error, same(error));
		expect(failed.stackTrace, same(stack));
	});
}
