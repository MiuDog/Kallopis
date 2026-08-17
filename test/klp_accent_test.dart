import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test('curated accents resolve the accepted light and dark colors', () {
    expect(KlpAccent.ink.resolve(Brightness.light), const Color(0xFF1C1C1C));
    expect(KlpAccent.ink.resolve(Brightness.dark), const Color(0xFFF5F2EC));
    expect(
      KlpAccent.terracotta.resolve(Brightness.light),
      const Color(0xFF9E5D41),
    );
    expect(
      KlpAccent.terracotta.resolve(Brightness.dark),
      const Color(0xFFBE7D60),
    );
    expect(KlpAccent.ochre.resolve(Brightness.light), const Color(0xFF876833));
    expect(KlpAccent.ochre.resolve(Brightness.dark), const Color(0xFFA98850));
    expect(KlpAccent.olive.resolve(Brightness.light), const Color(0xFF66733E));
    expect(KlpAccent.olive.resolve(Brightness.dark), const Color(0xFF859359));
    expect(KlpAccent.slate.resolve(Brightness.light), const Color(0xFF546F95));
    expect(KlpAccent.slate.resolve(Brightness.dark), const Color(0xFF778FB0));
    expect(
      KlpAccent.crimson.resolve(Brightness.light),
      const Color(0xFFAB5160),
    );
    expect(KlpAccent.crimson.resolve(Brightness.dark), const Color(0xFFC07984));
  });

  test('every curated accent preserves AA contrast in each brightness', () {
    final lightBackground = KlpThemeData.light.surface;
    final darkBackground = KlpThemeData.dark.surface;

    for (final accent in KlpAccent.values) {
      expect(
        _contrastRatio(accent.resolve(Brightness.light), lightBackground),
        greaterThanOrEqualTo(4.5),
        reason: '${accent.name} light contrast',
      );
      expect(
        _contrastRatio(accent.resolve(Brightness.dark), darkBackground),
        greaterThanOrEqualTo(4.5),
        reason: '${accent.name} dark contrast',
      );
    }
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

    expect(light.interaction, const Color(0xFF9E5D41));
    expect(dark.interaction, const Color(0xFFBE7D60));
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

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}
