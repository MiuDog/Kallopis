import '../../kernel/diagnostics/klp_contract_error.dart';
import 'klp_primitive_index.dart';
import 'klp_style_kind.dart';
import 'klp_style_value.dart';

/// 固定種類各八槽的完整原料試作，尚未承諾穩定 schema。
///
/// 每一欄都必須完整提供，沒有局部覆寫或未知種類的輸入出口。
final class KlpPrimitiveSet {
  final List<KlpColor> colors;
  final List<KlpDistance> distances;
  final List<KlpRadius> radii;
  final List<KlpStrokeWidth> strokeWidths;
  final List<KlpFontSize> fontSizes;
  final List<KlpFontWeight> fontWeights;
  final List<KlpLineHeight> lineHeights;
  final List<KlpLetterSpacing> letterSpacings;
  final List<KlpDuration> durations;
  final List<KlpFontFamily> fontFamilies;
  final List<KlpCurve> curves;

  KlpPrimitiveSet({
    required List<KlpColor> colors,
    required List<KlpDistance> distances,
    required List<KlpRadius> radii,
    required List<KlpStrokeWidth> strokeWidths,
    required List<KlpFontSize> fontSizes,
    required List<KlpFontWeight> fontWeights,
    required List<KlpLineHeight> lineHeights,
    required List<KlpLetterSpacing> letterSpacings,
    required List<KlpDuration> durations,
    required List<KlpFontFamily> fontFamilies,
    required List<KlpCurve> curves,
  }) : colors = _copySlots(colors, 'colors'),
       distances = _copySlots(distances, 'distances'),
       radii = _copySlots(radii, 'radii'),
       strokeWidths = _copySlots(strokeWidths, 'strokeWidths'),
       fontSizes = _copySlots(fontSizes, 'fontSizes'),
       fontWeights = _copySlots(fontWeights, 'fontWeights'),
       lineHeights = _copySlots(lineHeights, 'lineHeights'),
       letterSpacings = _copySlots(letterSpacings, 'letterSpacings'),
       durations = _copySlots(durations, 'durations'),
       fontFamilies = _copySlots(fontFamilies, 'fontFamilies'),
       curves = _copySlots(curves, 'curves');

  T read<T extends KlpStyleValue>(
    KlpStyleKind<T> kind,
    KlpPrimitiveIndex index,
  ) {
    final KlpStyleValue value = switch (kind.name) {
      'color' => colors[index.index],
      'distance' => distances[index.index],
      'radius' => radii[index.index],
      'strokeWidth' => strokeWidths[index.index],
      'fontSize' => fontSizes[index.index],
      'fontWeight' => fontWeights[index.index],
      'lineHeight' => lineHeights[index.index],
      'letterSpacing' => letterSpacings[index.index],
      'duration' => durations[index.index],
      'fontFamily' => fontFamilies[index.index],
      'curve' => curves[index.index],
      _ => throw KlpContractError(
        'unknown_primitive_kind',
        'primitives.${kind.name}: unsupported kind.',
      ),
    };
    return value as T;
  }

  static List<T> _copySlots<T extends KlpStyleValue>(
    List<T> values,
    String path,
  ) {
    final snapshot = List<T>.unmodifiable(values);
    if (snapshot.length != KlpPrimitiveIndex.values.length) {
      throw KlpContractError(
        'invalid_primitive_slots',
        'primitives.$path: expected exactly ${KlpPrimitiveIndex.values.length} slots, found ${snapshot.length}.',
      );
    }
    return snapshot;
  }
}
