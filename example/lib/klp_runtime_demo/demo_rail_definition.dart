import 'package:kallopis/kallopis_declarative.dart';

import 'demo_rail_item.dart';
import 'demo_counter_content.dart';

/// 自訂語意只在定義期指定參照，由本庫解析並渲染文字。
KlpComponentDefinition<DemoRailItem> demoRailDefinition() {
	final color = KlpSemanticKey(DemoRailItem.typeId, 'labelColor', KlpStyleKind.color);
	final family = KlpSemanticKey(DemoRailItem.typeId, 'labelFamily', KlpStyleKind.fontFamily);
	final size = KlpSemanticKey(DemoRailItem.typeId, 'labelSize', KlpStyleKind.fontSize);
	final weight = KlpSemanticKey(DemoRailItem.typeId, 'labelWeight', KlpStyleKind.fontWeight);
	final height = KlpSemanticKey(DemoRailItem.typeId, 'labelHeight', KlpStyleKind.lineHeight);
	final spacing = KlpSemanticKey(DemoRailItem.typeId, 'labelSpacing', KlpStyleKind.letterSpacing);
	final gap = KlpSemanticKey(DemoRailItem.typeId, 'contentGap', KlpStyleKind.distance);
	final semantics = KlpSemanticSchema(DemoRailItem.typeId, [
		KlpSemanticToken(color, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i1)),
		KlpSemanticToken(family, const KlpPrimitiveRef(KlpStyleKind.fontFamily, KlpPrimitiveIndex.i0)),
		KlpSemanticToken(size, const KlpPrimitiveRef(KlpStyleKind.fontSize, KlpPrimitiveIndex.i1)),
		KlpSemanticToken(weight, const KlpPrimitiveRef(KlpStyleKind.fontWeight, KlpPrimitiveIndex.i4)),
		KlpSemanticToken(height, const KlpPrimitiveRef(KlpStyleKind.lineHeight, KlpPrimitiveIndex.i1)),
		KlpSemanticToken(spacing, const KlpPrimitiveRef(KlpStyleKind.letterSpacing, KlpPrimitiveIndex.i3)),
		KlpSemanticToken(gap, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i1)),
	]);
	return KlpComponentDefinition(
		DemoRailItem.typeId,
		semantics: semantics,
		content: KlpLinearTemplate<DemoRailItem>(axis: KlpAxis.horizontal, gap: gap, children: [
			KlpTextTemplate<DemoRailItem>(text: (item) => item.label, semantics: KlpTextSemantics(color: color, fontFamily: family, fontSize: size, fontWeight: weight, lineHeight: height, letterSpacing: spacing)),
			KlpChildrenTemplate<DemoRailItem, DemoCounterContent>(slot: DemoRailItem.counterSlot, axis: KlpAxis.horizontal, gap: gap),
		]),
	);
}
