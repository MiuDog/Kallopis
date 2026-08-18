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
    'ink200': KlpPalette.ink200,
    'ink300': KlpPalette.ink300,
    'ink400': KlpPalette.ink400,
    'ink500': KlpPalette.ink500,
    'ink600': KlpPalette.ink600,
    'ink700': KlpPalette.ink700,
    'ink800': KlpPalette.ink800,
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
    // 元件只能透過 context.klp 取色。KlpPalette.transparent 是例外——
    // 「沒有顏色」不是顏色，而且它沒有可以走樣的值。
    const allowedMembers = {'transparent'};
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
        contrast(accent.dark, KlpThemeData.dark.surface),
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
        contrast(t.textFaint, t.surface),
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
        t.surface.toARGB32(),
        isNot(t.surfaceMuted.toARGB32()),
        reason: '${entry.key} 的 surface 與 surfaceMuted 相同，選取狀態會看不出來',
      );
      expect(
        t.stageSurface.toARGB32(),
        isNot(t.surface.toARGB32()),
        reason:
            '${entry.key} 的 stageSurface 與 surface 相同，舞台讀不出是獨立的一層。'
            '（ultraDark 的 stage 與 app 相同是刻意的——OLED 全暗就是那個用途。）',
      );
    }
  });
}
