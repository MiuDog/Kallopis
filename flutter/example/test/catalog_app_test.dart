import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
	test('目錄由 consumer 擁有 MaterialApp 與畫面組合', () {
		final source = File('lib/main.dart').readAsStringSync();

		expect(source, contains('return MaterialApp('));
		expect(source, isNot(contains('return KlpApp(')));
	});
}
