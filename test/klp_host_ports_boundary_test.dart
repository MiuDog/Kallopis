import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';

import 'klp_lower_module_boundary_test.dart' show lowerUnits, lowerTargets;
import 'klp_prepared_module_boundary_test.dart' show preparedDartFiles, preparedPublicSymbols, preparedExportClosure, preparedUris;

const _action = 'lib/src/capabilities/actions/klp_pick_file_action.dart';
const _port = 'lib/src/capabilities/files/klp_file_selection.dart';
const _adapter = 'lib/src/application/environment/klp_file_selection_adapter.dart';
const _legacy = 'lib/src/application/legacy/klp_local_file_picker.dart';

void main() {
	test('current action and dedicated legacy root have distinct exact ownership', () {
		final current = preparedPublicSymbols('lib/kallopis_declarative.dart');
		expect(current['KlpPickFileAction'], _action);
		expect(current, isNot(contains('KlpLocalFilePicker')));
		expect(preparedPublicSymbols('lib/kallopis_legacy_file_picker.dart'), {'KlpLocalFilePicker': _legacy});
		expect(File('lib/src/features/workspace/components/klp_local_file_picker.dart').existsSync(), isFalse);
	});

	test('every public root hides port adapter results snapshot and plugin types', () {
		for (final root in preparedDartFiles('lib', recursive: false)) {
			final symbols = preparedPublicSymbols(root);
			final closure = preparedExportClosure(root);
			for (final path in [_port, _adapter, 'lib/src/capabilities/environment/klp_environment_snapshot.dart']) {
				expect(closure, isNot(contains(path)), reason: '$root -> $path');
			}
			for (final name in ['KlpFileSelectionPort', 'KlpFileSelectionRequest', 'KlpFileSelectionResult', 'KlpFileSelected', 'KlpFileSelectionCancelled', 'KlpFileSelectionFailed', 'KlpFileSelectionAdapter', 'KlpEnvironmentSnapshot', 'XFile', 'XTypeGroup', 'FileSelectorPlatform']) {
				expect(symbols, isNot(contains(name)), reason: '$root -> $name');
			}
		}
	});

	test('plugin dependency belongs solely to application adapter and lower contracts remain pure', () {
		final units = lowerUnits();
		final pluginOwners = <String>[];
		for (final entry in units.entries) {
			for (final uri in entry.value.directives.expand(preparedUris)) {
				if (uri.startsWith('package:file_selector/')) pluginOwners.add(entry.key);
			}
		}
		expect(pluginOwners, [_adapter]);
		for (final path in [_action, _port]) {
			final unit = units[path];
			expect(unit, isNotNull, reason: path);
			for (final directive in unit!.directives) {
				for (final uri in preparedUris(directive)) {
					expect(uri.startsWith('package:flutter') || uri.startsWith('package:file_selector') || uri == 'dart:ui' || uri == 'dart:io', isFalse, reason: '$path -> $uri');
				}
			}
		}
		for (final entry in units.entries.where((entry) => entry.key.startsWith('lib/src/capabilities/') || entry.key.startsWith('lib/src/features/'))) {
			for (final directive in entry.value.directives) {
				for (final target in lowerTargets(entry.key, directive, units)) {
					expect(target == _adapter || target == _legacy, isFalse, reason: '${entry.key} -> $target');
					if (entry.key == _action || entry.key == _port) expect(target.startsWith('lib/src/application/'), isFalse);
				}
			}
		}
	});

	test('environment observer adds only private declarations to application part closure', () {
		final units = lowerUnits();
		const observer = 'lib/src/application/environment/klp_application_environment_observer.dart';
		final unit = units[observer];
		expect(unit, isNotNull);
		expect(unit!.declarations.whereType<ClassDeclaration>().map((node) => node.namePart.typeName.lexeme), ['_KlpApplicationEnvironmentObserver']);
	});
}
