import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test(
    'semantic spacing and exact geometry copy independently and round trip',
    () {
      final base = KlpVisualStyle.defaultStyle;
      final original = KlpVisualStyleJson.encode(base);
      final spacingCases = <(String, KlpSpacingTheme)>[
        ('contentInlineGap', base.spacing.copyWith(contentInlineGap: 37)),
        ('contentStackGap', base.spacing.copyWith(contentStackGap: 37)),
        ('contentInset', base.spacing.copyWith(contentInset: 37)),
        ('controlContentGap', base.spacing.copyWith(controlContentGap: 37)),
        ('controlInset', base.spacing.copyWith(controlInset: 37)),
        ('actionGap', base.spacing.copyWith(actionGap: 37)),
        ('chromeGap', base.spacing.copyWith(chromeGap: 37)),
        ('chromePanelInset', base.spacing.copyWith(chromePanelInset: 37)),
        ('chromeToolbarGap', base.spacing.copyWith(chromeToolbarGap: 37)),
        ('navigationItemInset', base.spacing.copyWith(navigationItemInset: 37)),
        ('navigationRailInset', base.spacing.copyWith(navigationRailInset: 37)),
        (
          'navigationRailItemGap',
          base.spacing.copyWith(navigationRailItemGap: 37),
        ),
        ('overlayContentInset', base.spacing.copyWith(overlayContentInset: 37)),
        ('overlayHeadingGap', base.spacing.copyWith(overlayHeadingGap: 37)),
        ('overlayItemGap', base.spacing.copyWith(overlayItemGap: 37)),
        (
          'navigationSectionGap',
          base.spacing.copyWith(navigationSectionGap: 37),
        ),
        ('appFrameInset', base.spacing.copyWith(appFrameInset: 37)),
        (
          'workbenchContentInset',
          base.spacing.copyWith(workbenchContentInset: 37),
        ),
        ('windowHeaderMargin', base.spacing.copyWith(windowHeaderMargin: 37)),
        ('dockMargin', base.spacing.copyWith(dockMargin: 37)),
      ];
      for (final (key, value) in spacingCases) {
        final style = base.copyWith(spacing: value);
        final encoded = KlpVisualStyleJson.encode(style);
        final expected = <Object?, Object?>{
          ...original['spacing'] as Map,
          key: 37.0,
        };
        expect(encoded['spacing'], expected, reason: key);
        expect(value, isNot(base.spacing), reason: key);
        expect(value.copyWith(), value);
        expect(value.copyWith().hashCode, value.hashCode);
        expect(
          KlpVisualStyleJson.encode(KlpVisualStyleJson.decode(encoded)),
          encoded,
        );
      }
      final controlCases = <(String, KlpControlGeometry)>[
        (
          'pageBackgroundHitRadius',
          base.geometry.control.copyWith(pageBackgroundHitRadius: 37),
        ),
        (
          'presenceMarkerExtent',
          base.geometry.control.copyWith(presenceMarkerExtent: 37),
        ),
        (
          'colorPickerCursorRadius',
          base.geometry.control.copyWith(colorPickerCursorRadius: 37),
        ),
        ('swatchExtent', base.geometry.control.copyWith(swatchExtent: 37)),
        (
          'segmentedProgressHeight',
          base.geometry.control.copyWith(segmentedProgressHeight: 37),
        ),
      ];
      for (final (key, value) in controlCases) {
        final style = base.copyWith(
          geometry: base.geometry.copyWith(control: value),
        );
        final encoded = KlpVisualStyleJson.encode(style);
        final expected = <Object?, Object?>{
          ...(original['geometry'] as Map)['control'] as Map,
          key: 37.0,
        };
        expect((encoded['geometry'] as Map)['control'], expected, reason: key);
        expect(value, isNot(base.geometry.control), reason: key);
        expect(value.copyWith(), value);
        expect(value.copyWith().hashCode, value.hashCode);
        expect(
          KlpVisualStyleJson.encode(KlpVisualStyleJson.decode(encoded)),
          encoded,
        );
      }
      final layoutCases = <(String, KlpLayoutGeometry)>[
        (
          'resizeHandleExtent',
          base.geometry.layout.copyWith(resizeHandleExtent: 37),
        ),
        (
          'overlayViewportInset',
          base.geometry.layout.copyWith(overlayViewportInset: 37),
        ),
        (
          'railDropTargetExtent',
          base.geometry.layout.copyWith(railDropTargetExtent: 37),
        ),
        (
          'disclosureIconSize',
          base.geometry.layout.copyWith(disclosureIconSize: 37),
        ),
        ('treeLeadingGap', base.geometry.layout.copyWith(treeLeadingGap: 37)),
        ('tooltipOffsetX', base.geometry.layout.copyWith(tooltipOffsetX: 37)),
      ];
      for (final (key, value) in layoutCases) {
        final style = base.copyWith(
          geometry: base.geometry.copyWith(layout: value),
        );
        final encoded = KlpVisualStyleJson.encode(style);
        final expected = <Object?, Object?>{
          ...(original['geometry'] as Map)['layout'] as Map,
          key: 37.0,
        };
        expect((encoded['geometry'] as Map)['layout'], expected, reason: key);
        expect(value, isNot(base.geometry.layout), reason: key);
        expect(value.copyWith(), value);
        expect(value.copyWith().hashCode, value.hashCode);
        expect(
          KlpVisualStyleJson.encode(KlpVisualStyleJson.decode(encoded)),
          encoded,
        );
      }
    },
  );

  test(
    'legacy compact migrates across spacing and geometry without mutating input',
    () {
      for (final version in <int?>[null, 1]) {
        final input = <String, Object?>{
          'spacing': <String, Object?>{'compact': 12.0, 'hairline': 3.0},
        };
        if (version != null) input['schemaVersion'] = version;
        final result = KlpVisualStyleJson.decode(input);
        final encoded = KlpVisualStyleJson.encode(result);
        final spacing = encoded['spacing'] as Map;
        for (final key in <String>[
          'contentInlineGap',
          'contentStackGap',
          'contentInset',
          'controlContentGap',
          'controlInset',
          'actionGap',
          'chromeGap',
          'chromePanelInset',
          'chromeToolbarGap',
          'navigationItemInset',
          'navigationRailInset',
          'navigationRailItemGap',
          'overlayContentInset',
          'overlayHeadingGap',
          'overlayItemGap',
        ]) {
          expect(spacing[key], 12.0, reason: key);
        }
        for (final key in <String>[
          'appFrameInset',
          'workbenchContentInset',
          'windowHeaderMargin',
          'dockMargin',
        ]) {
          expect(spacing[key], 6.0, reason: key);
        }
        expect(spacing['navigationSectionGap'], 9.0);
        for (final key in <String>[
          'pageBackgroundHitRadius',
          'presenceMarkerExtent',
          'colorPickerCursorRadius',
          'swatchExtent',
          'segmentedProgressHeight',
        ]) {
          expect(
            ((encoded['geometry'] as Map)['control'] as Map)[key],
            12.0,
            reason: key,
          );
        }
        for (final key in <String>[
          'resizeHandleExtent',
          'overlayViewportInset',
          'railDropTargetExtent',
          'disclosureIconSize',
          'treeLeadingGap',
          'tooltipOffsetX',
        ]) {
          expect(
            ((encoded['geometry'] as Map)['layout'] as Map)[key],
            12.0,
            reason: key,
          );
        }
        expect(encoded['schemaVersion'], 3);
        expect(spacing.containsKey('compact'), isFalse);
        expect((input['spacing'] as Map)['compact'], 12.0);
        expect((input['spacing'] as Map).length, 2);
        expect(input.containsKey('geometry'), isFalse);
      }
    },
  );

  test(
    'explicit semantic fields win over legacy migration and preserve custom base',
    () {
      final base = KlpVisualStyle.defaultStyle.copyWith(
        spacing: KlpVisualStyle.defaultStyle.spacing.copyWith(actionGap: 29),
      );
      final result = KlpVisualStyleJson.decode({
        'spacing': {
          'compact': 12,
          'controlContentGap': 17,
          'appFrameInset': 11,
        },
        'geometry': {
          'control': {'pageBackgroundHitRadius': 19},
          'layout': {'overlayViewportInset': 23},
        },
      }, base: base);
      expect(result.spacing.controlContentGap, 17);
      expect(result.spacing.appFrameInset, 11);
      expect(result.geometry.control.pageBackgroundHitRadius, 19);
      expect(result.geometry.layout.overlayViewportInset, 23);
      expect(
        KlpVisualStyleJson.decode({
          'schemaVersion': 2,
          'spacing': {'contentInlineGap': 13},
        }, base: base).spacing.actionGap,
        29,
      );
      expect(
        KlpVisualStyleJson.decode({
          'schemaVersion': 1,
        }, base: base).spacing.actionGap,
        29,
      );
    },
  );

  test(
    'legacy hairline recomputes navigation gap and narrow compact remains loadable',
    () {
      final hairlineOnly = KlpVisualStyleJson.decode({
        'schemaVersion': 1,
        'spacing': {'hairline': 3},
      });
      final narrowCompact = KlpVisualStyleJson.decode({
        'schemaVersion': 1,
        'spacing': {'compact': 1},
      });

      expect(hairlineOnly.spacing.navigationSectionGap, 5);
      expect(narrowCompact.spacing.navigationSectionGap, 0);
    },
  );

  test(
    'v2 rejects compact and validates independently injected semantic fields',
    () {
      expect(
        () => KlpVisualStyleJson.decode({
          'schemaVersion': 2,
          'spacing': {'compact': 8},
        }),
        throwsA(_formatExceptionContaining('spacing.compact')),
      );
      expect(
        () => KlpVisualStyleJson.decode({
          'spacing': {'compact': 'wide'},
        }),
        throwsA(_formatExceptionContaining('spacing.compact')),
      );
      expect(
        () => KlpVisualStyleJson.decode({
          'schemaVersion': 2,
          'spacing': {'actionGap': -1},
        }),
        throwsA(_formatExceptionContaining('spacing.actionGap')),
      );
      expect(
        () => KlpVisualStyleJson.decode({
          'schemaVersion': 2,
          'geometry': {
            'control': {'presenceMarkerExtent': -1},
          },
        }),
        throwsA(
          _formatExceptionContaining('geometry.control.presenceMarkerExtent'),
        ),
      );
      expect(
        () => KlpVisualStyleJson.decode({
          'schemaVersion': 2,
          'geometry': {
            'layout': {'resizeHandleExtent': 'wide'},
          },
        }),
        throwsA(
          _formatExceptionContaining('geometry.layout.resizeHandleExtent'),
        ),
      );
    },
  );

  group('KlpVisualStyleJson', () {
    test('新增 token 不破壞既有 constructor 呼叫', () {
      final base = KlpVisualStyle.defaultStyle;
      final legacyStyle = KlpVisualStyle(
        name: 'legacy',
        colors: base.colors,
        typography: base.typography,
        spacing: base.spacing,
        shape: base.shape,
        motion: base.motion,
        surface: base.surface,
        components: base.components,
      );
      final legacyTheme = KlpTheme(
        color: base.colors,
        type: base.typography,
        space: base.spacing,
        shape: base.shape,
        motion: base.motion,
        surface: base.surface,
        component: base.components,
      );

      expect(legacyStyle.dataVisualization, KlpDataVisualizationTheme.light);
      expect(legacyStyle.geometry, KlpGeometryTheme.standard);
      expect(legacyTheme.dataVisualization, KlpDataVisualizationTheme.light);
      expect(legacyTheme.geometry, KlpGeometryTheme.standard);
      expect(base.colors.clear, KlpPalette.transparent);
    });

    test('完整 schema 可穩定 round-trip', () {
      final encoded = KlpVisualStyleJson.encode(KlpVisualStyle.defaultStyle);
      final decoded = KlpVisualStyleJson.decode(encoded);

      expect(KlpVisualStyleJson.encode(decoded), equals(encoded));
      expect(encoded.keys, <String>{
        'schemaVersion',
        'name',
        'colors',
        'typography',
        'spacing',
        'shape',
        'motion',
        'surface',
        'components',
        'dataVisualization',
        'geometry',
      });
      expect((encoded['colors'] as Map).length, 33);
      expect((encoded['typography'] as Map).length, 44);
      expect((encoded['spacing'] as Map).length, 78);
      expect((encoded['spacing'] as Map)['iconGlyph'], 18);
      expect((encoded['spacing'] as Map)['gridTileWidth'], 170);
      expect((encoded['shape'] as Map).length, 13);
      expect((encoded['motion'] as Map).length, 12);
      expect((encoded['surface'] as Map).length, 30);
      expect(
        (encoded['surface'] as Map)['dragSourceOpacity'],
        KlpScale.opacity350,
      );
      expect(
        (encoded['surface'] as Map)['themePreviewDisabledOpacity'],
        KlpScale.opacity620,
      );
      expect((encoded['components'] as Map).length, 16);
      expect((encoded['dataVisualization'] as Map).length, 14);
      final geometry = encoded['geometry'] as Map;
      expect(geometry.keys, <String>{'control', 'data', 'layout', 'optical'});
      expect((geometry['control'] as Map).length, 37);
      expect((geometry['data'] as Map).length, 31);
      expect((geometry['data'] as Map)['filePreviewHeight'], 220);
      expect((geometry['data'] as Map)['previewCardCompactHeight'], 64);
      expect((geometry['data'] as Map)['previewCardStandardHeight'], 96);
      expect((geometry['data'] as Map)['previewCardLargeHeight'], 192);
      expect((geometry['data'] as Map)['dateGridCellHeight'], 128);
      expect((geometry['data'] as Map)['keyValueLabelWidthCompact'], 96);
      expect((geometry['data'] as Map)['keyValueLabelWidthStandard'], 112);
      expect((geometry['data'] as Map)['stepperMarkerSize'], 24);
      expect((geometry['data'] as Map)['stepperLabelWidth'], 60);
      expect((geometry['data'] as Map)['progressIndeterminateFraction'], 0.35);
      expect((geometry['layout'] as Map).length, 34);
      expect((geometry['layout'] as Map)['responsivePaneBreakpoint'], 960);
      expect((geometry['optical'] as Map).length, 5);
    });

    test('單欄位 overlay 沿用指定 dark base', () {
      final base = KlpVisualStyle.forBrightness(Brightness.dark);
      final result = KlpVisualStyleJson.decode(<String, Object?>{
        'colors': <String, Object?>{'accent': '#123456'},
      }, base: base);

      expect(result.colors.accent, const Color(0xFF123456));
      expect(result.colors.surface, base.colors.surface);
      expect(result.typography, same(base.typography));
      expect(result.dataVisualization, same(base.dataVisualization));
    });

    test('網格欄寬可由 JSON 覆寫並保留在 copyWith', () {
      final result = KlpVisualStyleJson.decode(<String, Object?>{
        'spacing': <String, Object?>{'gridTileWidth': 196},
      });

      expect(result.spacing.gridTileWidth, 196);
      expect(result.spacing.copyWith().gridTileWidth, 196);
    });

    test('圖示字形可由 JSON 覆寫並保留在 copyWith', () {
      final result = KlpVisualStyleJson.decode(<String, Object?>{
        'spacing': <String, Object?>{'iconGlyph': 17},
      });

      expect(result.spacing.iconGlyph, 17);
      expect(result.spacing.copyWith().iconGlyph, 17);
    });

    test('顏色接受 RGB 與 ARGB 並固定輸出 ARGB', () {
      final result = KlpVisualStyleJson.decode(<String, Object?>{
        'colors': <String, Object?>{
          'accent': '#123456',
          'accentSoft': '#80123456',
        },
      });
      final colors = KlpVisualStyleJson.encode(result)['colors'] as Map;

      expect(colors['accent'], '#FF123456');
      expect(colors['accentSoft'], '#80123456');
    });

    test('頁面圖樣色可由 JSON 改寫', () {
      final style = KlpVisualStyleJson.decode(<String, Object?>{
        'colors': <String, Object?>{'pagePattern': '#123456'},
      });

      expect(style.colors.pagePattern, const Color(0xFF123456));
    });

    test('前景 semantic colors 可由 JSON 改寫', () {
      final colors = KlpVisualStyleJson.decode(<String, Object?>{
        'colors': <String, Object?>{
          'interaction': '#000000',
          'onDarkBackground': '#ABCDEF',
          'mutedOnDarkBackground': '#123456',
          'faintOnBackground': '#654321',
        },
      }).colors;
      final onBlack = colors.onBackground(const Color(0xFF000000));

      expect(colors.onInteraction, const Color(0xFFABCDEF));
      expect(onBlack.text, const Color(0xFFABCDEF));
      expect(onBlack.textMuted, const Color(0xFF123456));
      expect(onBlack.textFaint, const Color(0xFF654321));
    });

    test('nullable component token 的 JSON null 表示 inherited', () {
      final base = KlpVisualStyle.defaultStyle.copyWith(
        components: const KlpComponentTheme(buttonRadius: 7),
      );
      final result = KlpVisualStyleJson.decode(<String, Object?>{
        'components': <String, Object?>{'buttonRadius': null},
      }, base: base);

      expect(result.components.buttonRadius, isNull);
    });

    test('duration、font weight 與 cubic 可 round-trip', () {
      final result = KlpVisualStyleJson.decode(<String, Object?>{
        'motion': <String, Object?>{
          'stateTransition': 275,
          'standard': <Object?>[0.1, 0.2, 0.3, 0.4],
        },
        'typography': <String, Object?>{'strong': 450},
      });
      final encoded = KlpVisualStyleJson.encode(result);

      expect((encoded['motion'] as Map)['stateTransition'], 275);
      expect((encoded['motion'] as Map)['standard'], <double>[
        0.1,
        0.2,
        0.3,
        0.4,
      ]);
      expect((encoded['typography'] as Map)['strong'], 450);
    });

    test('拒絕未知欄位並包含完整 path', () {
      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'colors': <String, Object?>{'acccent': '#FFFFFF'},
        }),
        throwsA(_formatExceptionContaining('colors.acccent')),
      );
    });

    test('型別與範圍錯誤包含完整 path', () {
      final cases = <Map<String, Object?>>[
        <String, Object?>{
          'colors': <String, Object?>{'accent': 42},
        },
        <String, Object?>{
          'motion': <String, Object?>{'stateTransition': -1},
        },
        <String, Object?>{
          'typography': <String, Object?>{'strong': 99},
        },
        <String, Object?>{
          'motion': <String, Object?>{
            'standard': <Object?>[0, 1, 2],
          },
        },
      ];
      final paths = <String>[
        'colors.accent',
        'motion.stateTransition',
        'typography.strong',
        'motion.standard',
      ];

      for (var index = 0; index < cases.length; index++) {
        expect(
          () => KlpVisualStyleJson.decode(cases[index]),
          throwsA(_formatExceptionContaining(paths[index])),
        );
      }
    });

    test('geometry overlay、未知欄位與數值範圍都有完整 path', () {
      final result = KlpVisualStyleJson.decode(<String, Object?>{
        'geometry': <String, Object?>{
          'layout': <String, Object?>{
            'menuWidth': 240,
            'commandMenuWidth': 360,
          },
        },
      });
      expect(result.geometry.layout.menuWidth, 240);
      expect(result.geometry.layout.commandMenuWidth, 360);
      expect(
        result.geometry.layout.menuItemHeight,
        KlpGeometryTheme.standard.layout.menuItemHeight,
      );

      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'geometry': <String, Object?>{
            'control': <String, Object?>{'unknownSize': 1},
          },
        }),
        throwsA(_formatExceptionContaining('geometry.control.unknownSize')),
      );
      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'geometry': <String, Object?>{
            'layout': <String, Object?>{'menuWidth': -1},
          },
        }),
        throwsA(_formatExceptionContaining('geometry.layout.menuWidth')),
      );
      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'geometry': <String, Object?>{
            'layout': <String, Object?>{'commandMenuWidth': -1},
          },
        }),
        throwsA(_formatExceptionContaining('geometry.layout.commandMenuWidth')),
      );
      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'surface': <String, Object?>{'dragOpacity': 1.1},
        }),
        throwsA(_formatExceptionContaining('surface.dragOpacity')),
      );
      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'components': <String, Object?>{'buttonRadius': -1},
        }),
        throwsA(_formatExceptionContaining('components.buttonRadius')),
      );
      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'motion': <String, Object?>{
            'standard': <Object?>[1.1, 0, 0.5, 1],
          },
        }),
        throwsA(_formatExceptionContaining('motion.standard[0]')),
      );
      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'typography': <String, Object?>{'body': -1},
        }),
        throwsA(_formatExceptionContaining('typography.body')),
      );
      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'typography': <String, Object?>{'bodyLeading': 0},
        }),
        throwsA(_formatExceptionContaining('typography.bodyLeading')),
      );
      expect(
        () => KlpVisualStyleJson.decode(<String, Object?>{
          'geometry': <String, Object?>{
            'control': <String, Object?>{
              'textFieldMinLines': 9,
              'textFieldMaxLines': 4,
            },
          },
        }),
        throwsA(
          _formatExceptionContaining('geometry.control.textFieldMaxLines'),
        ),
      );
    });

    test('encode 拒絕非整數毫秒與非 cubic curve 並包含 path', () {
      final fractionalDuration = KlpVisualStyle.defaultStyle.copyWith(
        motion: KlpVisualStyle.defaultStyle.motion.copyWith(
          stateTransition: const Duration(microseconds: 1),
        ),
      );
      expect(
        () => KlpVisualStyleJson.encode(fractionalDuration),
        throwsA(_formatExceptionContaining('motion.stateTransition')),
      );

      final unsupportedCurve = KlpVisualStyle.defaultStyle.copyWith(
        motion: KlpVisualStyle.defaultStyle.motion.copyWith(
          standard: Curves.linear,
        ),
      );
      expect(
        () => KlpVisualStyleJson.encode(unsupportedCurve),
        throwsA(_formatExceptionContaining('motion.standard')),
      );
    });

    test('schemaVersion accepts legacy and current versions', () {
      expect(
        KlpVisualStyleJson.decode(const <String, Object?>{}).name,
        'default',
      );
      for (final value in <Object?>[1.0, 4, '1']) {
        expect(
          () => KlpVisualStyleJson.decode(<String, Object?>{
            'schemaVersion': value,
          }),
          throwsA(_formatExceptionContaining('schemaVersion')),
        );
      }
    });

    test('dark 預設與自訂資料視覺化色盤不互相覆寫', () {
      final dark = buildKlpTheme(Brightness.dark);
      expect(dark.extension<KlpThemeData>(), KlpThemeData.dark);
      expect(
        dark.extension<KlpDataVisualizationTheme>(),
        KlpDataVisualizationTheme.dark,
      );

      final customData = KlpDataVisualizationTheme.light.copyWith(
        axis: const Color(0xFF123456),
      );
      final customStyle = KlpVisualStyle.forBrightness(
        Brightness.dark,
      ).copyWith(dataVisualization: customData);
      final custom = buildKlpTheme(Brightness.dark, style: customStyle);

      expect(custom.extension<KlpDataVisualizationTheme>(), customData);
    });
  });
}

Matcher _formatExceptionContaining(String path) {
  return isA<FormatException>().having(
    (error) => error.message,
    'message',
    contains(path),
  );
}
