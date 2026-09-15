import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:flutter_test/flutter_test.dart';

const _owners = {
	'KlpLocalizations': 'lib/src/foundation/localization/klp_localizations.dart',
	'KlpLocalizationsDelegate': 'lib/src/foundation/localization/klp_localizations_delegate.dart',
	'_defaultSavedLabel': 'lib/src/foundation/localization/klp_default_saved_label.dart',
};

void main() {
	// 負控制涵蓋條件分支、相對 URI、公開桶狀匯出與雙向 part，避免純文字掃描漏網。
	test('guard catches every directive and public barrel bypass', () {
		const origin = 'lib/src/features/example.dart';
		const application = 'lib/src/application/hidden.dart';
		const directives = [
			"import '../application/hidden.dart';",
			"export '../application/hidden.dart';",
			"part '../application/hidden.dart';",
			"part of '../application/hidden.dart';",
			'part of application.hidden;',
			"import 'safe.dart' if (dart.library.io) '../application/hidden.dart';",
			"export 'safe.dart' if (dart.library.html) '../application/hidden.dart';",
			"import 'package:kallopis/src/application/hidden.dart';",
			"import 'package:kallopis/src/features/../application/hidden.dart';",
			"import '../../kallopis.dart';",
			"export 'package:kallopis/kallopis.dart';",
		];
		for (final directive in directives) {
			final sources = {
				origin: directive,
				application: 'library application.hidden; class ApplicationOwned {}',
				'lib/src/features/safe.dart': '',
				'lib/kallopis.dart': "export 'bridge.dart';",
				'lib/bridge.dart': "export 'safe.dart' if (dart.library.io) 'src/application/hidden.dart';",
				'lib/safe.dart': '',
			};
			expect(_applicationDependencies(sources)[origin], contains(application), reason: directive);
		}
		final rendering = {'lib/src/rendering/example.dart': "import '../application/hidden.dart';"};
		expect(_applicationDependencies(rendering).values.single, contains(application));
	});

	test('guard accepts downward imports and ignores comments and ordinary strings', () {
		const sources = {
			'lib/src/features/example.dart': "import '../foundation/value.dart'; // import '../application/hidden.dart';\nconst text = \"export '../application/hidden.dart';\";",
			'lib/src/foundation/value.dart': "export 'more.dart';",
			'lib/src/foundation/more.dart': 'class Value {}',
		};
		expect(_applicationDependencies(sources), isEmpty);
	});

	test('all features and rendering sources have no application dependency', () {
		final violations = _applicationDependencies(_readSources());
		expect(violations, isEmpty, reason: '完整 features/rendering 範圍不得直接或經匯出桶依賴 application：$violations');
	});

	test('localization has three physical foundation owners and no old shim or duplicate declaration', () {
		final violations = _ownershipViolations(_readSources());
		expect(violations, isEmpty, reason: '在地化只能由 foundation 的原三檔實體宣告：$violations');
	});

	test('ownership guard rejects duplicated classes helper and old forwarding shim', () {
		final sources = {
			_owners['KlpLocalizations']!: 'class KlpLocalizations {}',
			_owners['KlpLocalizationsDelegate']!: 'class KlpLocalizationsDelegate {}',
			_owners['_defaultSavedLabel']!: "String _defaultSavedLabel(String value) => value;",
		};
		expect(_ownershipViolations(sources), isEmpty);
		for (final declaration in ['class KlpLocalizations {}', 'class KlpLocalizationsDelegate {}', 'String _defaultSavedLabel(String value) => value;']) {
			final duplicate = {...sources, 'lib/src/features/duplicate.dart': declaration};
			expect(_ownershipViolations(duplicate), isNotEmpty, reason: declaration);
		}
		final shim = {...sources, 'lib/src/application/localization/klp_localizations.dart': "export '../../foundation/localization/klp_localizations.dart';"};
		expect(_ownershipViolations(shim), isNotEmpty);
	});
}

Map<String, String> _readSources() {
	// 讀取所有庫原始碼，讓任何未列於本次 path-map 的新檔案仍受到邊界保護。
	return {
		for (final file in Directory('lib').listSync(recursive: true).whereType<File>())
			if (file.path.endsWith('.dart')) file.path.replaceAll('\\', '/'): file.readAsStringSync(),
	};
}

CompilationUnit _parse(String path, String content) {
	// AST 保留所有條件分支；不執行平台選擇，也不讓註解和字串冒充指令。
	final result = parseString(content: content, path: path, throwIfDiagnostics: false);
	expect(result.errors, isEmpty, reason: '邊界檢查不能略過無法解析的原始碼：$path');
	return result.unit;
}

String? _resolve(String origin, String? reference) {
	if (reference == null) return null;
	if (reference.startsWith('package:kallopis/')) return Uri.parse('lib/${reference.substring('package:kallopis/'.length)}').normalizePath().toString();
	if (Uri.parse(reference).hasScheme) return null;

	return Uri.parse(origin).resolve(reference).normalizePath().toString();
}

Iterable<String> _targets(String path, CompilationUnit unit, {required bool includeImports}) sync* {
	for (final directive in unit.directives) {
		final references = <String?>[];
		if (directive is ImportDirective && includeImports) {
			references.add(directive.uri.stringValue);
			references.addAll(directive.configurations.map((config) => config.uri.stringValue));
		}
		else if (directive is ExportDirective) {
			references.add(directive.uri.stringValue);
			references.addAll(directive.configurations.map((config) => config.uri.stringValue));
		}
		else if (directive is PartDirective) {
			references.add(directive.uri.stringValue);
		}
		else if (directive is PartOfDirective) {
			references.add(directive.uri?.stringValue);
		}
		for (final reference in references) {
			final target = _resolve(path, reference);
			if (target != null) yield target;
		}
	}
}

Map<String, Set<String>> _applicationDependencies(Map<String, String> sources) {
	final units = {for (final entry in sources.entries) entry.key: _parse(entry.key, entry.value)};
	final namedLibraries = <String, Set<String>>{};
	for (final entry in units.entries) {
		for (final directive in entry.value.directives.whereType<LibraryDirective>()) {
			final name = directive.name?.name;
			if (name != null) namedLibraries.putIfAbsent(name, () => <String>{}).add(entry.key);
		}
	}
	Iterable<String> namedParts(CompilationUnit unit) sync* {
		for (final directive in unit.directives.whereType<PartOfDirective>()) {
			yield* namedLibraries[directive.libraryName?.name] ?? const <String>{};
		}
	}

	final violations = <String, Set<String>>{};
	for (final entry in units.entries) {
		final origin = entry.key;
		if (!origin.startsWith('lib/src/features/') && !origin.startsWith('lib/src/rendering/')) continue;

		final pending = _targets(origin, entry.value, includeImports: true).toList();
		pending.addAll(namedParts(entry.value));
		final visited = <String>{};
		while (pending.isNotEmpty) {
			final target = pending.removeLast();
			if (!visited.add(target)) continue;
			if (target.startsWith('lib/src/application/')) {
				violations.putIfAbsent(origin, () => <String>{}).add(target);
				continue;
			}
			final unit = units[target];
			if (unit != null) {
				pending.addAll(_targets(target, unit, includeImports: false));
				pending.addAll(namedParts(unit));
			}
		}
	}
	return violations;
}

List<String> _ownershipViolations(Map<String, String> sources) {
	final declarations = {for (final name in _owners.keys) name: <String>[]};
	final violations = <String>[];
	for (final entry in sources.entries) {
		if (entry.key.startsWith('lib/src/application/localization/')) violations.add('old localization path: ${entry.key}');
		final unit = _parse(entry.key, entry.value);
		for (final declaration in unit.declarations) {
			String? name;
			if (declaration is ClassDeclaration) name = declaration.name.lexeme;
			if (declaration is FunctionDeclaration) name = declaration.name.lexeme;
			if (declaration is GenericTypeAlias) name = declaration.name.lexeme;
			if (declaration is FunctionTypeAlias) name = declaration.name.lexeme;
			if (declaration is MixinDeclaration) name = declaration.name.lexeme;
			if (declaration is EnumDeclaration) name = declaration.name.lexeme;
			if (declaration is TopLevelVariableDeclaration) {
				for (final variable in declaration.variables.variables) {
					declarations[variable.name.lexeme]?.add(entry.key);
				}
			}
			declarations[name]?.add(entry.key);
		}
	}
	for (final owner in _owners.entries) {
		if (!sources.containsKey(owner.value)) violations.add('missing physical owner: ${owner.value}');
		final paths = declarations[owner.key]!;
		if (paths.length != 1 || paths.single != owner.value) violations.add('${owner.key}: $paths');
	}
	return violations;
}
