import 'package:kallopis/kallopis_declarative.dart';

import 'klp_component_test_item.dart';

/// 只在定義期建立所有風格參照及基礎組合。
KlpComponentDefinition<KlpComponentTestItem> klpComponentTestDefinition({
  String Function(KlpComponentTestItem)? select,
  String Function(KlpComponentTestItem)? accessibilityLabel,
  KlpSemanticKey<KlpColor>? textColor,
  Iterable<String> dependencies = const [],
}) {
  final color = KlpSemanticKey('fixture', 'color', KlpStyleKind.color);
  final fontFamily = KlpSemanticKey(
    'fixture',
    'fontFamily',
    KlpStyleKind.fontFamily,
  );
  final fontSize = KlpSemanticKey('fixture', 'fontSize', KlpStyleKind.fontSize);
  final fontWeight = KlpSemanticKey(
    'fixture',
    'fontWeight',
    KlpStyleKind.fontWeight,
  );
  final lineHeight = KlpSemanticKey(
    'fixture',
    'lineHeight',
    KlpStyleKind.lineHeight,
  );
  final letterSpacing = KlpSemanticKey(
    'fixture',
    'letterSpacing',
    KlpStyleKind.letterSpacing,
  );
  final distance = KlpSemanticKey('fixture', 'distance', KlpStyleKind.distance);
  final radius = KlpSemanticKey('fixture', 'radius', KlpStyleKind.radius);
  final text = KlpTextTemplate<KlpComponentTestItem>(
    text: select ?? (item) => item.label,
    semantics: KlpTextSemantics(
      color: textColor ?? color,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      lineHeight: lineHeight,
      letterSpacing: letterSpacing,
    ),
  );
  return KlpComponentDefinition(
    'fixture',
    semantics: KlpSemanticSchema('fixture', [
      KlpSemanticToken(
        color,
        KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i1),
      ),
      KlpSemanticToken(
        fontFamily,
        KlpPrimitiveRef(KlpStyleKind.fontFamily, KlpPrimitiveIndex.i1),
      ),
      KlpSemanticToken(
        fontSize,
        KlpPrimitiveRef(KlpStyleKind.fontSize, KlpPrimitiveIndex.i1),
      ),
      KlpSemanticToken(
        fontWeight,
        KlpPrimitiveRef(KlpStyleKind.fontWeight, KlpPrimitiveIndex.i1),
      ),
      KlpSemanticToken(
        lineHeight,
        KlpPrimitiveRef(KlpStyleKind.lineHeight, KlpPrimitiveIndex.i1),
      ),
      KlpSemanticToken(
        letterSpacing,
        KlpPrimitiveRef(KlpStyleKind.letterSpacing, KlpPrimitiveIndex.i1),
      ),
      KlpSemanticToken(
        distance,
        KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i1),
      ),
      KlpSemanticToken(
        radius,
        KlpPrimitiveRef(KlpStyleKind.radius, KlpPrimitiveIndex.i1),
      ),
    ], dependencies: dependencies),
    content: KlpSurfaceTemplate(
      background: color,
      radius: radius,
      inset: distance,
      child: KlpLinearTemplate(
        axis: KlpAxis.vertical,
        gap: distance,
        children: [text, text],
      ),
    ),
    accessibilityLabel: accessibilityLabel,
  );
}
