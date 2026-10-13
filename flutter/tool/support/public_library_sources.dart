import 'dart:io';

/// 回傳從公開入口經 export 與 owner part 可達的所有 Dart 來源。
List<File> publicLibrarySources(File entry) {
  final reached = <Uri, File>{};
  final exports = RegExp(
    r'''^export\s+['"]([^'"]+)['"]\s*;''',
    multiLine: true,
  );
  final parts = RegExp(r'''^part\s+['"]([^'"]+)['"]\s*;''', multiLine: true);

  void visit(File file) {
    if (!file.existsSync()) return;
    final uri = file.absolute.uri.normalizePath();
    if (reached.containsKey(uri)) return;
    reached[uri] = file;
    final source = file.readAsStringSync();
    for (final directive in exports.allMatches(source)) {
      final target = uri.resolve(directive.group(1)!).normalizePath();
      if (target.scheme == 'file') visit(File.fromUri(target));
    }
    for (final directive in parts.allMatches(source)) {
      final target = uri.resolve(directive.group(1)!).normalizePath();
      if (target.scheme == 'file') visit(File.fromUri(target));
    }
  }

  visit(entry);
  return reached.values.toList()
    ..sort((left, right) => left.path.compareTo(right.path));
}
