import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart' as public_api;
import 'package:kallopis/src/foundation/klp_palette.dart' as decorative;
import 'package:kallopis/src/styling/legacy_tokens/primitive_token.dart'
    as primitive;

void main() {
  // 來源歸屬必須是同一個 library 直接定義，不能由相容轉匯出冒充完成。
  test(
    'primitive library owns scale and palette definitions through single-definition parts',
    () {
      final source = File(
        'lib/src/styling/legacy_tokens/primitive_token.dart',
      ).readAsStringSync();
      final palette = File(
        'lib/src/styling/legacy_tokens/internal/klp_palette.dart',
      ).readAsStringSync();
      expect(
        RegExp(r'abstract final class KlpScale\s*\{').allMatches(source),
        hasLength(1),
      );
      expect(source, contains("part 'internal/klp_palette.dart';"));
      expect(palette, contains("part of '../primitive_token.dart';"));
      expect(
        RegExp(r'abstract final class KlpPalette\s*\{').allMatches(palette),
        hasLength(1),
      );
      expect(source, isNot(contains('export ')));
      expect(source, contains("part 'internal/klp_accent.dart';"));
      final files = Directory('lib/src/styling/legacy_tokens')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .map((file) => file.uri.pathSegments.last)
          .toSet();
      expect(files, {'primitive_token.dart'});
    },
  );

  test('accent shares the primitive library and decoration stays separate', () {
    final accent = File(
      'lib/src/styling/legacy_tokens/internal/klp_accent.dart',
    ).readAsStringSync();
    final foundation = File(
      'lib/src/foundation/klp_palette.dart',
    ).readAsStringSync();
    expect(accent, contains("part of '../primitive_token.dart';"));
    expect(foundation, contains('abstract final class KlpDecorativePalette'));
    expect(foundation, isNot(contains('class KlpPalette')));
    expect(foundation, isNot(contains("part '")));
    expect(
      File('lib/src/foundation/internal/klp_accent.dart').existsSync(),
      isFalse,
    );
    expect(public_api.KlpScale.stroke200, primitive.KlpScale.stroke200);
    expect(public_api.KlpPalette.ink900, primitive.KlpPalette.ink900);
    expect(public_api.KlpAccent.ink, primitive.KlpAccent.ink);
    expect(
      public_api.KlpDecorativePalette.previewWallpaper,
      same(decorative.KlpDecorativePalette.previewWallpaper),
    );
  });
}
