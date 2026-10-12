import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart' as legacy;
import 'package:kallopis/src/styling/legacy_theme/klp_theme_data.dart'
    as schema;

void main() {
  test('Legacy color entry and schema preserve const identity', () {
    const legacy.KlpThemeData oldEntry = legacy.KlpThemeData.light;
    const schema.KlpThemeData newEntry = schema.KlpThemeData.light;
    expect(identical(oldEntry, newEntry), isTrue);
  });

  test('Default composition preserves public recipe values', () {
    const style = KlpVisualStyle.defaultStyle;
    const recipes = <Object>[
      KlpThemeData.light,
      KlpTypographyTheme.proportional,
      KlpShapeTheme.standardShape,
      KlpMotionTheme.standardMotion,
      KlpSurfaceTheme.elevated,
      KlpDataVisualizationTheme.light,
    ];
    final resolved = <Object>[
      style.colors,
      style.typography,
      style.shape,
      style.motion,
      style.surface,
      style.dataVisualization,
    ];
    for (var index = 0; index < recipes.length; index++) {
      expect(identical(resolved[index], recipes[index]), isTrue);
    }
  });

  test('Default recipe parts belong to their public schema libraries', () {
    const owners = {
      'colors': 'klp_theme_data',
      'typography': 'klp_typography_theme',
      'shape': 'klp_shape_theme',
      'motion': 'klp_motion_theme',
      'surface': 'klp_surface_theme',
      'data_visualization': 'klp_data_visualization_theme',
    };
    for (final entry in owners.entries) {
      final owner = File(
        'lib/src/styling/legacy_theme/${entry.value}.dart',
      ).readAsStringSync();
      final recipe = File(
        'lib/src/styling/presets/legacy/default_${entry.key}.dart',
      ).readAsStringSync();
      expect(
        owner,
        contains("part '../presets/legacy/default_${entry.key}.dart';"),
      );
      expect(
        recipe,
        startsWith("part of '../../legacy_theme/${entry.value}.dart';"),
      );
    }
  });

  test('Theme entry has no local import or export cycle', () {
    final visited = <Uri>{};
    final active = <Uri>[];
    final directive = RegExp(
      r'''^(?:import|export)\s+['"]([^'"]+)['"]''',
      multiLine: true,
    );
    void visit(Uri uri) {
      expect(
        active,
        isNot(contains(uri)),
        reason: 'Dependency cycle: ${[...active, uri].join(' -> ')}',
      );
      if (!visited.add(uri)) return;
      active.add(uri);
      for (final match in directive.allMatches(
        File.fromUri(uri).readAsStringSync(),
      )) {
        final target = uri.resolve(match.group(1)!).normalizePath();
        if (target.scheme == 'file') visit(target);
      }
      active.removeLast();
    }

    visit(
      File(
        'lib/src/styling/legacy_theme/klp_theme.dart',
      ).absolute.uri.normalizePath(),
    );
  });
}
