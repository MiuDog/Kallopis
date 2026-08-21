import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// 色彩紀律的閘門。
///
/// 顏色是這個庫裡最容易靜默走樣的東西：寫死一個色碼不會出錯、不會被 analyze 抓到、
/// 換主題時也不會拋例外——它只是不跟著變。因此每一條規則都必須是機械檢查。
void main() {
  /// ink 色梯。所有表面、文字與線條都必須落在這裡面。
  const ramp = <String, Color>{
    'ink50': KlpPalette.ink50,
    'ink100': KlpPalette.ink100,
    'ink150': KlpPalette.ink150,
    'ink200': KlpPalette.ink200,
    'ink250': KlpPalette.ink250,
    'ink300': KlpPalette.ink300,
    'ink350': KlpPalette.ink350,
    'ink400': KlpPalette.ink400,
    'ink450': KlpPalette.ink450,
    'ink500': KlpPalette.ink500,
    'ink550': KlpPalette.ink550,
    'ink600': KlpPalette.ink600,
    'ink650': KlpPalette.ink650,
    'ink700': KlpPalette.ink700,
    'ink750': KlpPalette.ink750,
    'ink800': KlpPalette.ink800,
    'ink850': KlpPalette.ink850,
    'ink900': KlpPalette.ink900,
    'ink950': KlpPalette.ink950,
  };

  /// 語意色與結構值，刻意不在梯上。
  const offRamp = <String, Color>{
    'scrim': KlpPalette.scrim,
    'line': KlpPalette.line,
    'lightSuccess': KlpPalette.lightSuccess,
    'lightWarning': KlpPalette.lightWarning,
    'lightDanger': KlpPalette.lightDanger,
    'lightInfo': KlpPalette.lightInfo,
    'darkSuccess': KlpPalette.darkSuccess,
    'darkWarning': KlpPalette.darkWarning,
    'darkDanger': KlpPalette.darkDanger,
    'darkInfo': KlpPalette.darkInfo,
  };

  bool onRamp(Color c) => ramp.values.any((r) => r.toARGB32() == c.toARGB32());
  bool allowedOffRamp(Color c) =>
      offRamp.values.any((r) => r.toARGB32() == c.toARGB32());

  group('每個中性欄位都落在 ink 色梯上', () {
    const presets = <String, KlpThemeData>{
      'light': KlpThemeData.light,
      'dark': KlpThemeData.dark,
      'ultraDark': KlpThemeData.ultraDark,
    };

    /// 這些欄位承載語意，不是中性色。
    const semanticFields = {'success', 'warning', 'danger', 'info'};

    presets.forEach((name, tokens) {
      test(name, () {
        final fields = <String, Color>{
          'app': tokens.app,
          'surface': tokens.surface,
          'surfaceInset': tokens.surfaceInset,
          'surfaceMuted': tokens.surfaceMuted,
          'component': tokens.component,
          'stageSurface': tokens.stageSurface,
          'overlay': tokens.overlay,
          'surfaceRaised': tokens.surfaceRaised,
          'guide': tokens.guide,
          'divider': tokens.divider,
          'pagePattern': tokens.pagePattern,
          'text': tokens.text,
          'textMuted': tokens.textMuted,
          'textFaint': tokens.textFaint,
          'accent': tokens.accent,
          'accentSoft': tokens.accentSoft,
          'interaction': tokens.interaction,
          'interactionSoft': tokens.interactionSoft,
          'modalScrim': tokens.modalScrim,
          'border': tokens.border,
          'borderStrong': tokens.borderStrong,
          'success': tokens.success,
          'warning': tokens.warning,
          'danger': tokens.danger,
          'info': tokens.info,
        };

        final offRampFields = <String>[];
        fields.forEach((field, color) {
          if (semanticFields.contains(field)) return;
          if (onRamp(color) || allowedOffRamp(color)) return;
          offRampFields.add(field);
        });

        expect(
          offRampFields,
          isEmpty,
          reason:
              '$name 的這些欄位用了 ink 色梯以外的顏色：${offRampFields.join('、')}\n'
              '梯外的欄位在調整色梯時不會跟著變，畫面上只會顯示為「某一塊怪怪的」。',
        );
      });
    });
  });

  test('元件不得直接取用具體顏色', () {
    // 元件只能透過 context.klp 取色，不保留任何 palette 例外。
    const allowedMembers = <String>{};
    const decorativeOnly = {'lib/src/shell/klp_theme_preview_tile.dart'};

    final reference = RegExp(r'KlpPalette\.([a-zA-Z0-9]+)');
    final violations = <String>[];

    for (final file
        in Directory('lib/src')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      final path = file.path.replaceAll(r'\', '/');
      // token 與 theme 層本來就負責定義與組裝色彩。
      if (path.startsWith('lib/src/theme/') ||
          path == 'lib/src/foundation/klp_palette.dart') {
        continue;
      }

      final source = file.readAsStringSync();
      for (final match in reference.allMatches(source)) {
        final member = match.group(1)!;
        if (allowedMembers.contains(member)) continue;
        violations.add('$path → KlpPalette.$member');
      }

      if (source.contains('KlpDecorativePalette') &&
          !decorativeOnly.contains(path)) {
        violations.add('$path → KlpDecorativePalette');
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          '這些元件直接取用了具體顏色，繞過 theme：\n${violations.join('\n')}\n'
          '元件一律用 context.klp——直接取 palette 的值不會出錯，只是換主題時不會變。',
    );
  });

  test('強調色在兩態下都留有 AA 的餘裕', () {
    // 原本的強調色全部卡在 4.5 邊緣，色梯一換就五個全數掉出 AA，而且沒有任何徵兆。
    // 這裡要求 4.6 的餘裕，讓下一次調整色梯不會立刻踩線。
    double luminance(Color c) => c.computeLuminance();
    double contrast(Color a, Color b) {
      final la = luminance(a);
      final lb = luminance(b);
      final hi = la > lb ? la : lb;
      final lo = la > lb ? lb : la;
      return (hi + 0.05) / (lo + 0.05);
    }

    for (final accent in KlpAccent.values) {
      expect(
        contrast(accent.light, KlpThemeData.light.surface),
        greaterThanOrEqualTo(4.6),
        reason: '${accent.name} 在亮態表面上的對比不足',
      );
      expect(
        contrast(accent.dark, KlpThemeData.dark.stageSurface),
        greaterThanOrEqualTo(4.6),
        reason: '${accent.name} 在暗態表面上的對比不足',
      );
    }
  });

  test('ink 色梯的明度嚴格遞減', () {
    // 梯上任兩階的順序必須穩定——順序一亂，所有「比它深一階」的推導都會失效。
    final steps = ramp.entries.toList();
    for (var i = 1; i < steps.length; i++) {
      expect(
        steps[i].value.computeLuminance(),
        lessThan(steps[i - 1].value.computeLuminance()),
        reason: '${steps[i].key} 沒有比 ${steps[i - 1].key} 更暗',
      );
    }
  });

  test('文字三階在兩態下都與其表面拉開足夠對比', () {
    double contrast(Color a, Color b) {
      final la = a.computeLuminance();
      final lb = b.computeLuminance();
      final hi = la > lb ? la : lb;
      final lo = la > lb ? lb : la;
      return (hi + 0.05) / (lo + 0.05);
    }

    for (final entry in const {
      'light': KlpThemeData.light,
      'dark': KlpThemeData.dark,
      'ultraDark': KlpThemeData.ultraDark,
    }.entries) {
      final t = entry.value;
      expect(
        contrast(t.text, t.surface),
        greaterThanOrEqualTo(7.0),
        reason: '${entry.key} 的主要文字未達 AAA',
      );
      expect(
        contrast(t.textMuted, t.surface),
        greaterThanOrEqualTo(4.5),
        reason: '${entry.key} 的次要文字未達 AA',
      );
      expect(
        contrast(t.textFaint, t.stageSurface),
        greaterThanOrEqualTo(3.0),
        reason:
            '${entry.key} 的輔助文字未達 3:1。它承載的是非必要資訊，'
            '但低於 3:1 在一般螢幕上會近乎不可見。',
      );
    }
  });

  test('相鄰的表面階層彼此可分辨', () {
    for (final entry in const {
      'light': KlpThemeData.light,
      'dark': KlpThemeData.dark,
      'ultraDark': KlpThemeData.ultraDark,
    }.entries) {
      final t = entry.value;
      expect(
        t.stageSurface.toARGB32(),
        isNot(t.surfaceInset.toARGB32()),
        reason: '${entry.key} 的 stageSurface 與 surfaceInset 相同，舞台與內部元件對比會讀不出來',
      );
    }
  });

  test('token 疊層在主題切換時原子性翻轉，不出現混合狀態', () {
    // 各層若各自內插，過場中途會有「某幾層換了、某幾層還沒」的狀態——那正是切換
    // 深淺色時看起來「有些元件沒跟著變」的原因：它們不是沒變，是停在中間值上。
    const a = KlpThemeData.light;
    const b = KlpThemeData.dark;

    for (final t in [0.0, 0.25, 0.49]) {
      expect(a.lerp(b, t), a, reason: 't=$t 應該仍是完整的起始主題');
    }
    for (final t in [0.5, 0.75, 1.0]) {
      expect(a.lerp(b, t), b, reason: 't=$t 應該已是完整的目標主題');
    }

    // 其餘各層同樣不得內插——只要有一層內插，混合狀態就會回來。
    final layers = <String, ThemeExtension<dynamic>>{
      'spacing': KlpSpacingTheme.comfortableDensity,
      'shape': KlpShapeTheme.standardShape,
      'surface': KlpSurfaceTheme.elevated,
      'component': KlpComponentTheme.inherited,
      'motion': KlpMotionTheme.standardMotion,
      'typography': KlpTypographyTheme.proportional,
    };

    layers.forEach((name, layer) {
      expect(
        identical(layer.lerp(layer, 0.3), layer),
        isTrue,
        reason: '$name 層在過場中途產生了新的實例，代表它在內插',
      );
    });
  });
}
