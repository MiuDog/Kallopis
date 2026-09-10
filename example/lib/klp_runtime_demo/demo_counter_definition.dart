import 'package:kallopis/kallopis_declarative.dart';

import 'demo_counter.dart';

/// 計數的用途參照在定義期建立；顯示摘要不改變實際計數資料。
KlpComponentDefinition<DemoCounter> demoCounterDefinition() {
	final color = KlpSemanticKey(DemoCounter.typeId, 'valueColor', KlpStyleKind.color);
	final family = KlpSemanticKey(DemoCounter.typeId, 'valueFamily', KlpStyleKind.fontFamily);
	final size = KlpSemanticKey(DemoCounter.typeId, 'valueSize', KlpStyleKind.fontSize);
	final weight = KlpSemanticKey(DemoCounter.typeId, 'valueWeight', KlpStyleKind.fontWeight);
	final height = KlpSemanticKey(DemoCounter.typeId, 'valueHeight', KlpStyleKind.lineHeight);
	final spacing = KlpSemanticKey(DemoCounter.typeId, 'valueSpacing', KlpStyleKind.letterSpacing);
	final semantics = KlpSemanticSchema(DemoCounter.typeId, [
		KlpSemanticToken(color, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i1)),
		KlpSemanticToken(family, const KlpPrimitiveRef(KlpStyleKind.fontFamily, KlpPrimitiveIndex.i0)),
		KlpSemanticToken(size, const KlpPrimitiveRef(KlpStyleKind.fontSize, KlpPrimitiveIndex.i1)),
		KlpSemanticToken(weight, const KlpPrimitiveRef(KlpStyleKind.fontWeight, KlpPrimitiveIndex.i4)),
		KlpSemanticToken(height, const KlpPrimitiveRef(KlpStyleKind.lineHeight, KlpPrimitiveIndex.i1)),
		KlpSemanticToken(spacing, const KlpPrimitiveRef(KlpStyleKind.letterSpacing, KlpPrimitiveIndex.i3)),
	]);
	return KlpComponentDefinition(
		DemoCounter.typeId,
		semantics: semantics,
		content: KlpTextTemplate<DemoCounter>(text: (counter) => counter.value > 99 ? '99+' : '${counter.value}', semantics: KlpTextSemantics(color: color, fontFamily: family, fontSize: size, fontWeight: weight, lineHeight: height, letterSpacing: spacing)),
	);
}
