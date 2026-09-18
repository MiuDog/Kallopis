// 平台套件由正式 file_selector 相依提供，只用於測試平台替身。
// ignore: depend_on_referenced_packages
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_legacy_file_picker.dart';

import 'support/klp_file_selection_fixture.dart';

void _receive(String path) {}

void main() {
	late KlpFileSelectorProbe platform;
	setUp(() {
		final original = FileSelectorPlatform.instance;
		platform = KlpFileSelectorProbe();
		FileSelectorPlatform.instance = platform;
		addTearDown(() => FileSelectorPlatform.instance = original);
	});

	test('legacy const defaults remain available without mounting a host', () async {
		const picker = KlpLocalFilePicker(onPicked: _receive);
		expect(picker.acceptedExtensions, isEmpty);
		expect(picker.onPicked, same(_receive));
		final result = picker.pick();
		expect(platform.requests.single, isEmpty);
		platform.cancel(0);
		await result;
	});

	test('legacy selected and cancelled calls preserve filter and path behavior', () async {
		final picked = <String>[];
		final picker = KlpLocalFilePicker(acceptedExtensions: const ['png', 'svg'], onPicked: picked.add);
		final selected = picker.pick();
		expect(platform.requests.single.single.label, 'assets');
		expect(platform.requests.single.single.extensions, ['png', 'svg']);
		platform.select(0, r'C:\圖片\unchanged.svg');
		await selected;
		final cancelled = picker.pick();
		platform.cancel(1);
		await cancelled;
		expect(picked, [r'C:\圖片\unchanged.svg']);
		expect(platform.requests, hasLength(2));
	});

	for (final callbackFailure in [false, true]) {
		test('legacy ${callbackFailure ? 'callback' : 'platform'} failure propagates original error and stack without host reporting', () async {
			final error = StateError('legacy original');
			final stack = StackTrace.fromString('legacy original stack');
			final reports = <FlutterErrorDetails>[];
			final original = FlutterError.onError;
			FlutterError.onError = reports.add;
			addTearDown(() => FlutterError.onError = original);
			final picker = KlpLocalFilePicker(onPicked: (_) {
				if (callbackFailure) Error.throwWithStackTrace(error, stack);
			});
			final result = picker.pick();
			Object? caught;
			StackTrace? caughtStack;
			final observed = result.then<void>((_) => fail('failure must propagate'), onError: (Object value, StackTrace trace) {
				caught = value;
				caughtStack = trace;
			});
			if (callbackFailure) {
				platform.select(0, 'selected');
			}
			else {
				platform.fail(0, error, stack);
			}
			await observed;
			expect(caught, same(error));
			expect(caughtStack, same(stack));
			expect(reports, isEmpty);
		});
	}
}
