import 'dart:io';

/// 回傳某個 compilation unit 所屬 library 的 owner 與全部 part。
List<File> ownedLibrarySources(File unit) {
  final source = unit.readAsStringSync();
  final partOf = RegExp(
    r'''^part of\s+['"]([^'"]+)['"]\s*;''',
    multiLine: true,
  ).firstMatch(source);
  final owner = partOf == null
      ? unit
      : File.fromUri(unit.absolute.uri.resolve(partOf.group(1)!));
  final result = <File>[owner];
  final parts = RegExp(r'''^part\s+['"]([^'"]+)['"]\s*;''', multiLine: true);
  for (final directive in parts.allMatches(owner.readAsStringSync())) {
    final file = File.fromUri(owner.absolute.uri.resolve(directive.group(1)!));
    if (file.existsSync()) result.add(file);
  }
  return result;
}
