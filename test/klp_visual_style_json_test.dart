import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
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
      expect((encoded['colors'] as Map).length, 32);
      expect((encoded['typography'] as Map).length, 44);
      expect((encoded['spacing'] as Map).length, 65);
      expect((encoded['shape'] as Map).length, 13);
      expect((encoded['motion'] as Map).length, 12);
      expect((encoded['surface'] as Map).length, 28);
      expect((encoded['components'] as Map).length, 16);
      expect((encoded['dataVisualization'] as Map).length, 14);
      final geometry = encoded['geometry'] as Map;
      expect(geometry.keys, <String>{'control', 'data', 'layout', 'optical'});
      expect((geometry['control'] as Map).length, 18);
      expect((geometry['data'] as Map).length, 21);
      expect((geometry['layout'] as Map).length, 22);
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
          'layout': <String, Object?>{'menuWidth': 240},
        },
      });
      expect(result.geometry.layout.menuWidth, 240);
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

    test('schemaVersion 省略視為 1，其他值被拒絕', () {
      expect(
        KlpVisualStyleJson.decode(const <String, Object?>{}).name,
        'default',
      );
      for (final value in <Object?>[1.0, 2, '1']) {
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
