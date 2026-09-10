import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'support/klp_test_primitives.dart';

void main() {
  group('KlpPrimitiveSet', () {
    final source = klpTestPrimitives();
    final cases = <(KlpStyleKind<KlpStyleValue>, List<KlpStyleValue>, String)>[
      (KlpStyleKind.color, source.colors, 'colors'),
      (KlpStyleKind.distance, source.distances, 'distances'),
      (KlpStyleKind.radius, source.radii, 'radii'),
      (KlpStyleKind.strokeWidth, source.strokeWidths, 'strokeWidths'),
      (KlpStyleKind.fontSize, source.fontSizes, 'fontSizes'),
      (KlpStyleKind.fontWeight, source.fontWeights, 'fontWeights'),
      (KlpStyleKind.lineHeight, source.lineHeights, 'lineHeights'),
      (KlpStyleKind.letterSpacing, source.letterSpacings, 'letterSpacings'),
      (KlpStyleKind.duration, source.durations, 'durations'),
      (KlpStyleKind.fontFamily, source.fontFamilies, 'fontFamilies'),
      (KlpStyleKind.curve, source.curves, 'curves'),
    ];
    for (final (kind, values, field) in cases) {
      test('$field supports every fixed index with matching type only', () {
        for (final index in KlpPrimitiveIndex.values) {
          expect(source.read(kind, index), same(values[index.index]));
          expect(kind.accepts(values[index.index]), isTrue);
        }
        for (final (other, otherValues, _) in cases) {
          expect(kind.accepts(otherValues.first), identical(kind, other));
        }
        expect(() => values.clear(), throwsUnsupportedError);
      });
      test('$field rejects missing and excess slots', () {
        for (final length in [7, 9]) {
          final changed = List.generate(length, (_) => values.first);
          expect(
            () => _withSlots(source, field, changed),
            throwsA(
              isA<KlpContractError>().having(
                (error) => error.message,
                'path',
                contains('primitives.$field'),
              ),
            ),
          );
        }
      });
    }

    test('all source collections are copied before ownership transfer', () {
      for (final (_, values, field) in cases) {
        final mutable = List<KlpStyleValue>.of(values);
        final copy = _withSlots(source, field, mutable);
        mutable.clear();
        final kind = cases.firstWhere((entry) => entry.$3 == field).$1;
        expect(copy.read(kind, KlpPrimitiveIndex.i7), same(values.last));
      }
    });

    test('validates the captured slots when source length changes on read', () {
      final changing = _ChangingColorList(source.colors);
      // 惡意或失效的清單也不能產生七槽的已驗證集合；複製本身可先拒絕。
      final rejectedSource = anyOf(
        isA<KlpContractError>(),
        isA<ConcurrentModificationError>(),
        isA<RangeError>(),
      );
      expect(() => _withColors(source, changing), throwsA(rejectedSource));
    });

    test('alternate fixture varies every physical quantity', () {
      final alternate = klpTestPrimitives(alternate: true);
      expect(alternate.colors[1].red, isNot(source.colors[1].red));
      expect(alternate.distances[1].value, isNot(source.distances[1].value));
      expect(alternate.radii[1].value, isNot(source.radii[1].value));
      expect(
        alternate.strokeWidths[1].value,
        isNot(source.strokeWidths[1].value),
      );
      expect(alternate.fontSizes[1].value, isNot(source.fontSizes[1].value));
      expect(
        alternate.fontWeights[1].value,
        isNot(source.fontWeights[1].value),
      );
      expect(
        alternate.lineHeights[1].value,
        isNot(source.lineHeights[1].value),
      );
      expect(
        alternate.letterSpacings[1].value,
        isNot(source.letterSpacings[1].value),
      );
      expect(
        alternate.durations[1].milliseconds,
        isNot(source.durations[1].milliseconds),
      );
      expect(
        alternate.fontFamilies[1].family,
        isNot(source.fontFamilies[1].family),
      );
      expect(alternate.curves[1].y1, isNot(source.curves[1].y1));
    });
  });

  group('KlpStyleValue', () {
    test('rejects non finite physical values', () {
      for (final value in [
        double.nan,
        double.infinity,
        double.negativeInfinity,
      ]) {
        final constructors = <KlpStyleValue Function()>[
          () => KlpDistance(value),
          () => KlpRadius(value),
          () => KlpStrokeWidth(value),
          () => KlpFontSize(value),
          () => KlpLineHeight(value),
          () => KlpLetterSpacing(value),
          () => KlpCurve(value, 0, 1, 1),
          () => KlpCurve(0, value, 1, 1),
          () => KlpCurve(0, 0, value, 1),
          () => KlpCurve(0, 0, 1, value),
        ];
        for (final create in constructors) {
          expect(create, throwsA(isA<KlpContractError>()));
        }
      }
    });

    test('rejects domain violations including every color channel', () {
      final invalid = <KlpStyleValue Function()>[
        () => KlpDistance(-1),
        () => KlpRadius(-1),
        () => KlpStrokeWidth(-1),
        () => KlpFontSize(0),
        () => KlpFontSize(-1),
        () => KlpLineHeight(0),
        () => KlpLineHeight(-1),
        () => KlpFontWeight(0),
        () => KlpFontWeight(1001),
        () => KlpDuration(-1),
        () => KlpCurve(-0.1, 0, 1, 1),
        () => KlpCurve(0, 0, 1.1, 1),
        () => KlpColor(-1, 0, 0),
        () => KlpColor(0, -1, 0),
        () => KlpColor(0, 0, -1),
        () => KlpColor(256, 0, 0),
        () => KlpColor(0, 256, 0),
        () => KlpColor(0, 0, 256),
        () => KlpColor(0, 0, 0, alpha: -1),
        () => KlpColor(0, 0, 0, alpha: 256),
      ];
      for (final create in invalid) {
        expect(create, throwsA(isA<KlpContractError>()));
      }
    });

    test('allows boundary values and signed spacing and overshoot', () {
      expect(KlpColor(0, 255, 0, alpha: 0).alpha, 0);
      expect(KlpColor(0, 0, 0).alpha, 255);
      expect(KlpDistance(0).value, 0);
      expect(KlpRadius(0).value, 0);
      expect(KlpStrokeWidth(0).value, 0);
      expect(KlpFontWeight(1).value, 1);
      expect(KlpFontWeight(1000).value, 1000);
      expect(KlpDuration(0).milliseconds, 0);
      expect(KlpLetterSpacing(-2).value, -2);
      expect(KlpCurve(0, -1, 1, 2).y2, 2);
    });

    test('validates and snapshots font names and fallback order', () {
      for (final name in ['', ' ', ' Font', 'Font ']) {
        expect(() => KlpFontFamily(name), throwsA(isA<KlpContractError>()));
        expect(
          () => KlpFontFamily('Font', fallback: [name]),
          throwsA(
            isA<KlpContractError>().having(
              (error) => error.message,
              'path',
              contains('fallback[0]'),
            ),
          ),
        );
      }
      final fallback = ['First', 'Second'];
      final font = KlpFontFamily('Font', fallback: fallback);
      fallback.clear();
      expect(font.fallback, ['First', 'Second']);
      expect(() => font.fallback.clear(), throwsUnsupportedError);
    });
  });
}

KlpPrimitiveSet _withSlots(
  KlpPrimitiveSet source,
  String field,
  List<KlpStyleValue> values,
) => KlpPrimitiveSet(
  colors: field == 'colors' ? values.cast<KlpColor>() : source.colors,
  distances: field == 'distances'
      ? values.cast<KlpDistance>()
      : source.distances,
  radii: field == 'radii' ? values.cast<KlpRadius>() : source.radii,
  strokeWidths: field == 'strokeWidths'
      ? values.cast<KlpStrokeWidth>()
      : source.strokeWidths,
  fontSizes: field == 'fontSizes'
      ? values.cast<KlpFontSize>()
      : source.fontSizes,
  fontWeights: field == 'fontWeights'
      ? values.cast<KlpFontWeight>()
      : source.fontWeights,
  lineHeights: field == 'lineHeights'
      ? values.cast<KlpLineHeight>()
      : source.lineHeights,
  letterSpacings: field == 'letterSpacings'
      ? values.cast<KlpLetterSpacing>()
      : source.letterSpacings,
  durations: field == 'durations'
      ? values.cast<KlpDuration>()
      : source.durations,
  fontFamilies: field == 'fontFamilies'
      ? values.cast<KlpFontFamily>()
      : source.fontFamilies,
  curves: field == 'curves' ? values.cast<KlpCurve>() : source.curves,
);

KlpPrimitiveSet _withColors(KlpPrimitiveSet source, List<KlpColor> colors) =>
    KlpPrimitiveSet(
      colors: colors,
      distances: source.distances,
      radii: source.radii,
      strokeWidths: source.strokeWidths,
      fontSizes: source.fontSizes,
      fontWeights: source.fontWeights,
      lineHeights: source.lineHeights,
      letterSpacings: source.letterSpacings,
      durations: source.durations,
      fontFamilies: source.fontFamilies,
      curves: source.curves,
    );

/// 模擬清單在第一次讀取長度時失去一項，後續讀取維持七項。
final class _ChangingColorList extends ListBase<KlpColor> {
  final List<KlpColor> _values;
  bool _changed = false;

  _ChangingColorList(List<KlpColor> values) : _values = List.of(values);

  @override
  int get length {
    final before = _values.length;
    if (!_changed) {
      _changed = true;
      _values.removeLast();
    }
    return before;
  }

  @override
  set length(int value) => throw UnsupportedError('Cannot resize source.');

  @override
  KlpColor operator [](int index) => _values[index];

  @override
  void operator []=(int index, KlpColor value) => _values[index] = value;
}
