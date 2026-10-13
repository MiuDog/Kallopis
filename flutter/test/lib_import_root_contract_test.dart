import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
	test('lib cross-directory imports and exports use the package root', () {
		final violations = <String>[];
		final directive = RegExp(r'''^(?:import|export) ['"](?:\./|(?:\.\./)+)''', multiLine: true);

		for (final file in Directory('lib').listSync(recursive: true).whereType<File>()) {
			if (!file.path.endsWith('.dart')) continue;

			if (directive.hasMatch(file.readAsStringSync())) violations.add(file.path);
		}

		expect(violations, isEmpty, reason: 'Cross-directory lib directives must use package:kallopis/ root URIs.');
	});
}
