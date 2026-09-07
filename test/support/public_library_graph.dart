import 'dart:io';

/// 驗證公開來源可經完整 export 到達；part 必須由可達的擁有者納入。
List<String> publicLibraryViolations(File entry, Directory sources) {
	final reached = <Uri>{};
	final issues = <String>[];
	final exports = RegExp(r'''^export\s+['"]([^'"]+)['"]\s*;''', multiLine: true);
	final parts = RegExp(r'''^part\s+['"]([^'"]+)['"]\s*;''', multiLine: true);
	final partOf = RegExp(r'''^part of\s+['"]([^'"]+)['"]\s*;''', multiLine: true);
	void visit(File file) {
		final uri = file.absolute.uri.normalizePath();
		if (!file.existsSync()) {
			issues.add('Missing export: ${file.path}');
			return;
		}
		final source = file.readAsStringSync();
		if (partOf.hasMatch(source)) {
			issues.add('Part exported directly: ${file.path}');
			return;
		}
		if (!reached.add(uri)) return;
		for (final match in exports.allMatches(source)) {
			final target = uri.resolve(match.group(1)!);
			if (target.scheme == 'file') visit(File.fromUri(target));
		}
		for (final match in parts.allMatches(source)) {
			final target = uri.resolve(match.group(1)!).normalizePath();
			final unit = File.fromUri(target);
			if (!unit.existsSync()) {
				issues.add('Missing part: ${unit.path}');
				continue;
			}
			final declaration = partOf.firstMatch(unit.readAsStringSync());
			if (declaration == null || target.resolve(declaration.group(1)!).normalizePath() != uri) {
				issues.add('Part owner mismatch: ${unit.path}');
				continue;
			}
			reached.add(target);
		}
	}
	visit(entry);
	for (final file in sources.listSync(recursive: true).whereType<File>()) {
		final path = file.path.replaceAll(r'\', '/');
		if (!path.endsWith('.dart') || path.contains('/internal/')) continue;
		if (!reached.contains(file.absolute.uri.normalizePath())) issues.add('Not exported: $path');
	}
	return issues;
}
