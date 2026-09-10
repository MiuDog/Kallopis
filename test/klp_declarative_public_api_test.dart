import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';

/// 宣告式入口的可達公開宣告不能把 Flutter 呈現控制權交回消費端。
void main() {
  test(
    'public declarative declarations do not expose Flutter presentation types',
    () {
      final forbidden = RegExp(
        r'\b(?:Widget|BuildContext|ThemeData|AnimationController|NavigatorState)\b',
      );
      final violations = <String>[];
      for (final file in _reachableSources(
        File('lib/kallopis_declarative.dart'),
      )) {
        final unit = parseString(
          content: file.readAsStringSync(),
          path: file.path,
          throwIfDiagnostics: false,
        ).unit;
        for (final declaration in unit.declarations) {
          final name = _nameOf(declaration);
          if (name == null || name.startsWith('_')) continue;
          final source = declaration.toSource();
          if (forbidden.hasMatch(source)) {
            violations.add('${file.path.replaceAll(r'\\', '/')}:$name');
          }
        }
      }
      expect(
        violations,
        isEmpty,
        reason: '宣告式公開契約洩漏 Flutter 呈現型別：\n${violations.join('\n')}',
      );
    },
  );
}

Set<File> _reachableSources(File entry) {
  final visited = <Uri>{};
  final files = <File>{};

  void visit(File file) {
    final uri = file.absolute.uri.normalizePath();
    if (!visited.add(uri)) return;
    final unit = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    ).unit;
    if (file.path.replaceAll(r'\\', '/').contains('/lib/src/') &&
        !file.path.replaceAll(r'\\', '/').contains('/internal/')) {
      files.add(file);
    }
    for (final directive in unit.directives) {
      final value = switch (directive) {
        ExportDirective(:final uri) => uri.stringValue,
        PartDirective(:final uri) => uri.stringValue,
        _ => null,
      };
      if (value == null) continue;
      final reference = Uri.tryParse(value);
      if (reference == null || reference.hasScheme || reference.hasAuthority) {
        continue;
      }
      final target = File.fromUri(uri.resolveUri(reference));
      if (target.existsSync()) visit(target);
    }
  }

  visit(entry);
  return files;
}

String? _nameOf(CompilationUnitMember declaration) => switch (declaration) {
  ClassDeclaration(:final namePart) => namePart.typeName.lexeme,
  EnumDeclaration(:final namePart) => namePart.typeName.lexeme,
  ExtensionDeclaration(:final name) => name?.lexeme,
  ExtensionTypeDeclaration(:final primaryConstructor) =>
    primaryConstructor.typeName.lexeme,
  FunctionDeclaration(:final name) => name.lexeme,
  MixinDeclaration(:final name) => name.lexeme,
  TopLevelVariableDeclaration(:final variables) =>
    variables.variables.firstOrNull?.name.lexeme,
  _ => null,
};
