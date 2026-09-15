// 平台套件由正式 file_selector 相依提供，只用於測試平台替身。
// ignore: depend_on_referenced_packages
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'support/klp_file_selection_fixture.dart';

void main() {
	late KlpFileSelectorProbe platform;
	setUp(() {
		final original = FileSelectorPlatform.instance;
		platform = KlpFileSelectorProbe();
		FileSelectorPlatform.instance = platform;
		addTearDown(() => FileSelectorPlatform.instance = original);
	});

	testWidgets('real workspace activation selects once with a request snapshot and preserves path', (tester) async {
		final picked = <String>[];
		final extensions = ['png', 'svg'];
		final source = KlpMutableState(klpFileApplication(KlpPickFileAction(acceptedExtensions: extensions, onPicked: picked.add)));
		addTearDown(source.dispose);
		await klpMountFiles(tester, source);
		klpFileActivation(tester)();
		expect(platform.requests, hasLength(1));
		extensions[0] = 'txt';
		expect(platform.requests.single.single.label, 'assets');
		expect(platform.requests.single.single.extensions, ['png', 'svg']);
		expect(picked, isEmpty);
		platform.select(0, r'C:\圖片\original.svg');
		await tester.pump();
		expect(picked, [r'C:\圖片\original.svg']);
		await tester.pump();
		expect(picked, hasLength(1));
		await klpUnmountFiles(tester);
	});

	testWidgets('unrestricted cancel completes silently and independent requests are not deduplicated', (tester) async {
		final picked = <String>[];
		final source = KlpMutableState(klpFileApplication(KlpPickFileAction(onPicked: picked.add)));
		addTearDown(source.dispose);
		await klpMountFiles(tester, source);
		final activate = klpFileActivation(tester);
		activate();
		activate();
		expect(platform.requests, hasLength(2));
		expect(platform.requests.every((request) => request.isEmpty), isTrue);
		platform.select(1, 'second');
		platform.cancel(0);
		await tester.pump();
		expect(picked, ['second']);
		await klpUnmountFiles(tester);
	});

	testWidgets('different actions in one frame retain their own callback and request when results arrive out of order', (tester) async {
		final first = <String>[];
		final second = <String>[];
		final actionA = KlpPickFileAction(acceptedExtensions: ['png'], onPicked: first.add);
		final actionB = KlpPickFileAction(acceptedExtensions: ['svg'], onPicked: second.add);
		final source = KlpMutableState(klpFileApplication(actionA, secondAction: actionB));
		addTearDown(source.dispose);
		await klpMountFiles(tester, source);
		klpFileActivation(tester)();
		klpFileActivation(tester, title: 'Next')();
		expect(platform.requests, hasLength(2));
		expect(platform.requests[0].single.extensions, ['png']);
		expect(platform.requests[1].single.extensions, ['svg']);
		platform.select(1, 'second.svg');
		await tester.pump();
		expect(first, isEmpty);
		expect(second, ['second.svg']);
		platform.select(0, 'first.png');
		await tester.pump();
		expect(first, ['first.png']);
		expect(second, ['second.svg']);
		await klpUnmountFiles(tester);
	});

	for (final replacement in ['action', 'style', 'source', 'entry', 'dispose']) {
		testWidgets('$replacement change revokes pending delivery and old activation before picker', (tester) async {
			final first = <String>[];
			final second = <String>[];
			final action = KlpPickFileAction(onPicked: first.add);
			final source = KlpMutableState(klpFileApplication(action));
			addTearDown(source.dispose);
			await klpMountFiles(tester, source);
			final old = klpFileActivation(tester);
			old();
			expect(platform.requests, hasLength(1));
			switch (replacement) {
				case 'action':
					source.value = klpFileApplication(KlpPickFileAction(onPicked: second.add));
				case 'style':
					source.value = klpFileApplication(action, alternate: true);
				case 'source':
					final newer = KlpMutableState(klpFileApplication(KlpPickFileAction(onPicked: second.add)));
					addTearDown(newer.dispose);
					await klpMountFiles(tester, newer);
				case 'entry':
					klpFileActivation(tester, title: 'Next')();
				case 'dispose':
					await klpUnmountFiles(tester);
			}
			await tester.pump();
			old();
			expect(platform.requests, hasLength(1), reason: '已撤銷 activation 不可再開啟 dialog');
			platform.select(0, 'late');
			await tester.pump();
			expect(first, isEmpty);
			expect(second, isEmpty, reason: '不得把旧結果送往新 action callback');
			if (replacement != 'dispose') {
				klpFileActivation(tester)();
				expect(platform.requests, hasLength(2));
				platform.select(1, 'current');
				await tester.pump();
				expect([...first, ...second], ['current']);
				await klpUnmountFiles(tester);
			}
		});
	}

	testWidgets('first callback source update invalidates other independently pending results', (tester) async {
		final picked = <String>[];
		late KlpMutableState<KlpApplication> source;
		final action = KlpPickFileAction(onPicked: (path) {
			picked.add(path);
			source.value = klpFileApplication(KlpPickFileAction(onPicked: picked.add), alternate: true);
		});
		source = KlpMutableState(klpFileApplication(action));
		addTearDown(source.dispose);
		await klpMountFiles(tester, source);
		final activate = klpFileActivation(tester);
		activate();
		activate();
		platform.select(0, 'first');
		await tester.pump();
		platform.select(1, 'stale second');
		await tester.pump();
		expect(picked, ['first']);
		await klpUnmountFiles(tester);
	});

	for (final scenario in ['platform', 'stale platform', 'disposed platform', 'callback']) {
		testWidgets('$scenario failure reports original error and stack exactly once', (tester) async {
			final error = StateError('original $scenario');
			final stack = StackTrace.fromString('original $scenario stack');
			var calls = 0;
			final action = KlpPickFileAction(onPicked: (_) {
				calls++;
				if (scenario == 'callback') Error.throwWithStackTrace(error, stack);
			});
			final source = KlpMutableState(klpFileApplication(action));
			addTearDown(source.dispose);
			await klpMountFiles(tester, source);
			final reports = <FlutterErrorDetails>[];
			final original = FlutterError.onError;
			FlutterError.onError = reports.add;
			try {
				klpFileActivation(tester)();
				if (scenario == 'stale platform') source.value = klpFileApplication(action, alternate: true);
				if (scenario == 'disposed platform') await klpUnmountFiles(tester);

				if (scenario == 'callback') {
					platform.select(0, 'selected');
				}
				else {
					platform.fail(0, error, stack);
				}
				await tester.pump();
				await tester.pump();
				expect(reports, hasLength(1));
				expect(reports.single.exception, same(error));
				expect(reports.single.stack, same(stack));
				expect(reports.single.library, 'kallopis application');
				expect(calls, scenario == 'callback' ? 1 : 0);
			}
			finally {
				FlutterError.onError = original;
			}
			await klpUnmountFiles(tester);
		});
	}
}
