import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/verify_declarative_consumer.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('klp-consumer-boundary-');
  });

  tearDown(() {
    if (root.existsSync()) root.deleteSync(recursive: true);
  });

  test('accepts the sole declarative package entry and local composition', () {
    _write(
      root,
      'main.dart',
      "import 'package:kallopis/kallopis_declarative.dart';\nimport 'feature.dart';\nKlpNode? node;\n",
    );
    _write(root, 'feature.dart', "export 'nested/field.dart';\n");
    _write(
      root,
      'nested/field.dart',
      "import 'package:kallopis/kallopis_declarative.dart';\nKlpAction? action;\n",
    );
    expect(verifyKlpDeclarativeConsumer(root), isEmpty);
  });

  test(
    'rejects Flutter, dart ui, private Kallopis and compatibility entry imports',
    () {
      _write(root, 'flutter.dart', "import 'package:flutter/widgets.dart';\n");
      _write(root, 'ui.dart', "export 'dart:ui';\n");
      _write(
        root,
        'private.dart',
        "import 'package:kallopis/src/runtime/compilation/internal/klp_tree_runtime.dart';\n",
      );
      _write(
        root,
        'compatibility.dart',
        "export 'package:kallopis/kallopis.dart';\n",
      );
      final violations = verifyKlpDeclarativeConsumer(root);
      expect(violations, hasLength(4));
      expect(
        violations.join('\n'),
        allOf(
          contains('package:flutter/widgets.dart'),
          contains('dart:ui'),
          contains(
            'package:kallopis/src/runtime/compilation/internal/klp_tree_runtime.dart',
          ),
          contains('package:kallopis/kallopis.dart'),
        ),
      );
    },
  );
}

void _write(Directory root, String relative, String source) {
  final file = File.fromUri(root.uri.resolve(relative));
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(source);
}
