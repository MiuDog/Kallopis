import '../../../../styling/primitives/klp_primitive_index.dart';
import '../../../../styling/primitives/klp_style_kind.dart';
import '../../../../styling/primitives/klp_style_value.dart';
import '../../../../styling/references/klp_style_ref.dart';
import '../../../../styling/semantics/klp_semantic_key.dart';
import '../../../../styling/semantics/klp_semantic_schema.dart';
import '../../../../styling/semantics/klp_semantic_token.dart';
import '../contracts/klp_rail.dart';

/// 本庫內部實驗映射；不是正式預設風格，也不授權消費端覆寫用途。
final class KlpRailSemantics {

	static final background = KlpSemanticKey(KlpRail.typeId, 'background', KlpStyleKind.color);
	static final itemBackground = KlpSemanticKey(KlpRail.typeId, 'itemBackground', KlpStyleKind.color);
	static final selectedBackground = KlpSemanticKey(KlpRail.typeId, 'selectedBackground', KlpStyleKind.color);
	static final focusColor = KlpSemanticKey(KlpRail.typeId, 'focusColor', KlpStyleKind.color);
	static final width = KlpSemanticKey(KlpRail.typeId, 'width', KlpStyleKind.distance);
	static final itemExtent = KlpSemanticKey(KlpRail.typeId, 'itemExtent', KlpStyleKind.distance);
	static final inset = KlpSemanticKey(KlpRail.typeId, 'inset', KlpStyleKind.distance);
	static final gap = KlpSemanticKey(KlpRail.typeId, 'gap', KlpStyleKind.distance);
	static final radius = KlpSemanticKey(KlpRail.typeId, 'radius', KlpStyleKind.radius);
	static final focusWidth = KlpSemanticKey(KlpRail.typeId, 'focusWidth', KlpStyleKind.strokeWidth);

	static KlpSemanticToken<T> _token<T extends KlpStyleValue>(KlpSemanticKey<T> key, KlpPrimitiveIndex index) => KlpSemanticToken(key, KlpPrimitiveRef(key.kind, index));

	static KlpSemanticSchema createSchema() => KlpSemanticSchema(KlpRail.typeId, [
		_token(background, KlpPrimitiveIndex.i0),
		_token(itemBackground, KlpPrimitiveIndex.i0),
		_token(selectedBackground, KlpPrimitiveIndex.i2),
		_token(focusColor, KlpPrimitiveIndex.i7),
		_token(width, KlpPrimitiveIndex.i7),
		_token(itemExtent, KlpPrimitiveIndex.i6),
		_token(inset, KlpPrimitiveIndex.i1),
		_token(gap, KlpPrimitiveIndex.i1),
		_token(radius, KlpPrimitiveIndex.i1),
		_token(focusWidth, KlpPrimitiveIndex.i1),
	]);
}
