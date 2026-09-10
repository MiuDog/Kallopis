import 'package:analyzer/error/error.dart';
import 'package:flutter_test/flutter_test.dart';

import 'klp_external_compile_fixture.dart';

/// 從獨立消費端套件確認三區插槽的編譯期型別邊界。
void registerKlpRailCompileCases() {
  group('external rail slot compile contract', () {
    late KlpExternalCompileFixture fixture;
    const imports =
        "import 'package:kallopis/kallopis_declarative.dart';\nimport 'package:flutter/widgets.dart';\n";
    final sources = <String, String>{
      'positive': "final rail = KlpRail(id: 'rail');",
    };
    for (final group in ['top', 'center', 'bottom']) {
      sources['widget_$group'] =
          "final rail = KlpRail(id: 'rail', $group: [const SizedBox()]);";
      sources['node_$group'] =
          "KlpRail invalid(KlpNode node) => KlpRail(id: 'rail', $group: [node]);";
    }

    setUpAll(() async {
      fixture = await KlpExternalCompileFixture.create({
        for (final entry in sources.entries)
          entry.key: '$imports${entry.value}\n',
      });
      addTearDown(fixture.dispose);
    });

    for (final entry in sources.entries) {
      test(entry.key, () async {
        final unit = await fixture.resolve(entry.key);
        final errors = unit.diagnostics.where(
          (diagnostic) =>
              diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR,
        );
        if (entry.key == 'positive') {
          expect(errors, isEmpty, reason: unit.diagnostics.join('\n'));
        } else {
          expect(
            errors.where(
              (error) => unit.lineInfo.getLocation(error.offset).lineNumber < 3,
            ),
            isEmpty,
          );
          final mismatch = errors.where(
            (error) =>
                error.diagnosticCode.lowerCaseUniqueName ==
                    'list_element_type_not_assignable' &&
                unit.lineInfo.getLocation(error.offset).lineNumber == 3,
          );
          expect(mismatch, isNotEmpty, reason: unit.diagnostics.join('\n'));
        }
      });
    }
  });
}
