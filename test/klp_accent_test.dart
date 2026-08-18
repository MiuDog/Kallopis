import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// 強調色的**行為**，不是它的色值。
///
/// 這個檔案刻意不再斷言具體色碼。原本的版本把六組共十二個 hex 寫死在測試裡，於是
/// 每次調色都要跟著改測試——那不是驗證，只是追認現況。真正要守住的是「解析得出來」
/// 與「對比夠」，而對比由 `color_discipline_test.dart` 統一把關（門檻 4.6，留有餘裕）。
void main() {
  test('ink 強調色取自色梯的兩端', () {
    // ink 是預設強調色，必須是純中性的——它一旦偏色，所有沒指定強調色的產品都會
    // 跟著帶上那個偏色。
    expect(KlpAccent.ink.resolve(Brightness.light), KlpPalette.ink900);
    expect(KlpAccent.ink.resolve(Brightness.dark), KlpPalette.ink50);
  });

  test('每個強調色在明暗兩態下都是不同的值', () {
    for (final accent in KlpAccent.values) {
      expect(
        accent.resolve(Brightness.light),
        isNot(accent.resolve(Brightness.dark)),
        reason: '${accent.name} 在兩態下用同一個值，其中一態必然對比不足',
      );
    }
  });

  test('parse 只接受既有的強調色名', () {
    expect(KlpAccent.parse('terracotta'), KlpAccent.terracotta);
    expect(
      KlpAccent.parse('not-an-accent'),
      KlpAccent.ink,
      reason:
          '未知名稱回退到中性的 ink 而不是拋錯——它來自設定檔，'
          '使用者打錯字不該讓 app 起不來。',
    );
    expect(KlpAccent.parse(null), KlpAccent.ink);
  });

  test('theme builders only accept a curated accent', () {
    final light = buildKlpThemeVariant(
      KlpThemeVariant.light,
      accent: KlpAccent.terracotta,
    ).extension<KlpThemeData>()!;
    final dark = buildKlpThemeVariant(
      KlpThemeVariant.dark,
      accent: KlpAccent.terracotta,
    ).extension<KlpThemeData>()!;

    expect(light.interaction, KlpAccent.terracotta.light);
    expect(dark.interaction, KlpAccent.terracotta.dark);
    expect(light.selection, KlpThemeData.light.selection);
    expect(dark.selection, KlpThemeData.dark.selection);
  });

  test('all accents resolve across the four appearance variants', () {
    for (final accent in KlpAccent.values) {
      for (final variant in KlpThemeVariant.values) {
        final tokens = buildKlpThemeVariant(
          variant,
          accent: accent,
        ).extension<KlpThemeData>()!;
        final brightness = variant == KlpThemeVariant.light
            ? Brightness.light
            : Brightness.dark;

        expect(
          tokens.interaction,
          accent.resolve(brightness),
          reason: '${accent.name} ${variant.name}',
        );
        expect(
          tokens.selection,
          variant == KlpThemeVariant.light
              ? KlpThemeData.light.selection
              : KlpThemeData.dark.selection,
          reason: '${accent.name} ${variant.name} selection',
        );
      }
    }
  });
}
