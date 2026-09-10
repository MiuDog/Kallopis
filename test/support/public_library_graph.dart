import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// 驗證公開來源完整可達且各入口隔離；part 必須由可達的擁有者納入。
List<String> publicLibraryViolations(File entry, Directory sources, {Iterable<File> isolatedEntries = const []}) {
	final reached = <Uri>{};
	final allReached = <Uri>{};
	final issues = <String>[];

	CompilationUnit parse(File file) {
		final result = parseString(content: file.readAsStringSync(), path: file.path, throwIfDiagnostics: false);
		if (result.errors.isNotEmpty) issues.add('Invalid Dart source: ${file.path}');
		return result.unit;
	}

	Uri? resolve(Uri owner, String? value) {
		if (value == null) {
			issues.add('Invalid directive URI: $owner');
			return null;
		}
		final reference = Uri.tryParse(value);
		if (reference == null || reference.hasScheme || reference.hasAuthority) {
			// 本檢查只接受本機相對路徑；同套件與外部 package 均明確拒絕。
			issues.add('Unsupported directive URI: $value from $owner');
			return null;
		}
		return owner.resolveUri(reference).normalizePath();
	}

	void visit(File file) {
		final uri = file.absolute.uri.normalizePath();
		if (!file.existsSync()) {
			issues.add('Missing export: ${file.path}');
			return;
		}
		final source = parse(file);
		if (source.directives.whereType<PartOfDirective>().isNotEmpty) {
			issues.add('Part exported directly: ${file.path}');
			return;
		}
		if (!reached.add(uri)) return;
		for (final directive in source.directives.whereType<ExportDirective>()) {
			if (directive.combinators.isNotEmpty) {
				issues.add('Restricted export cannot prove full source coverage: ${file.path}');
			}
			final references = [directive.uri, ...directive.configurations.map((configuration) => configuration.uri)];
			for (final reference in references) {
				final target = resolve(uri, reference.stringValue);
				if (target != null) visit(File.fromUri(target));
			}
		}
		for (final directive in source.directives.whereType<PartDirective>()) {
			final target = resolve(uri, directive.uri.stringValue);
			if (target == null) continue;
			final unit = File.fromUri(target);
			if (!unit.existsSync()) {
				issues.add('Missing part: ${unit.path}');
				continue;
			}
			final declarations = parse(unit).directives.whereType<PartOfDirective>().toList();
			final libraries = source.directives.whereType<LibraryDirective>().toList();
			final declaration = declarations.length == 1 ? declarations.single : null;
			final uriMatches = declaration?.uri != null && resolve(target, declaration!.uri!.stringValue) == uri;
			final nameMatches = declaration?.libraryName != null && libraries.length == 1 && declaration!.libraryName!.toSource() == libraries.single.name?.toSource();
			if (!uriMatches && !nameMatches) {
				issues.add('Part owner mismatch: ${unit.path}');
				continue;
			}
			reached.add(target);
		}
	}
	for (final root in [entry, ...isolatedEntries]) {
		reached.clear();
		visit(root);
		for (final overlap in reached.intersection(allReached)) {
			issues.add('Shared source across isolated entries: ${File.fromUri(overlap).path}');
		}
		allReached.addAll(reached);
	}
	for (final file in sources.listSync(recursive: true).whereType<File>()) {
		final path = file.path.replaceAll(r'\', '/');
		if (!path.endsWith('.dart') || path.contains('/internal/')) continue;
		if (!allReached.contains(file.absolute.uri.normalizePath())) issues.add('Not exported: $path');
	}
	return issues;
}
