import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

void main() {
  test('app title, header, and status use the mono family', () {
    const type = KlpTypographyTheme.proportional;
    final expectations = {
      KlpTextRole.appTitle: (type.sub, FontWeight.w500),
      KlpTextRole.header: (type.body, type.semiBold),
      KlpTextRole.status: (type.sub, FontWeight.w500),
    };

    for (final entry in expectations.entries) {
      final definition = KlpTextStyles.definitionOf(entry.key, type);

      expect(definition.family, KlpFontRole.mono);
      expect(definition.fontSize, entry.value.$1);
      expect(definition.fontWeight, entry.value.$2);
      expect(definition.toTextStyle(type).fontFamily, type.monoFamily);
      expect(
        definition.toTextStyle(type).fontFamilyFallback,
        contains(type.sansFamily),
      );
    }
  });

  test('chrome components declare their responsibility-specific text role', () {
    const contracts = {
      'lib/src/features/workspace/shell/window/klp_window_header.dart':
          'KlpTextRole.appTitle',
      'lib/src/features/workspace/shell/window/klp_workbench_window_header.dart':
          'KlpTextRole.appTitle',
      'lib/src/features/workspace/shell/composition/window_header/klp_app_window_header.dart':
          'KlpTextRole.appTitle',
      'lib/src/features/workspace/shell/panel/klp_panel_header.dart':
          'KlpTextRole.header',
      'lib/src/features/navigation/widgets/sidebar/klp_sidebar_identity_header.dart':
          'KlpTextRole.header',
      'lib/src/features/workspace/shell/stage/klp_stage_header.dart':
          'KlpTextRole.header',
      'lib/src/features/workspace/shell/stage/klp_stage_tab.dart':
          'KlpTextRole.header',
      'lib/src/features/workspace/shell/status/klp_status_bar.dart':
          'KlpTextRole.status',
      'lib/src/features/feedback/klp_status_indicator.dart':
          'KlpTextRole.status',
    };

    for (final entry in contracts.entries) {
      expect(
        File(entry.key).readAsStringSync(),
        contains(entry.value),
        reason: '${entry.key} 必須使用 ${entry.value}',
      );
    }
  });
}
