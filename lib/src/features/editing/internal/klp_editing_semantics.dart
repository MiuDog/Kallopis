import 'package:kallopis/src/styling/primitives/klp_primitive_index.dart';
import 'package:kallopis/src/styling/primitives/klp_style_kind.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_content.dart';

/// 編輯用途的候選映射；已建立唯一解析路徑，但尚未宣稱視覺定型。
final class KlpEditingSemantics {
	// 窄幅清單先保留八個正文 em，再壓縮標記與視覺縮排。
	static const minimumBodyEm = 8.0;
	static final text = KlpSemanticKey(KlpEditingContent.typeId, 'text', KlpStyleKind.color);
	static final ink = KlpSemanticKey(KlpEditingContent.typeId, 'ink', KlpStyleKind.color);
	static final caret = KlpSemanticKey(KlpEditingContent.typeId, 'caret', KlpStyleKind.color);
	static final selection = KlpSemanticKey(KlpEditingContent.typeId, 'selection', KlpStyleKind.color);
	static final fontFamily = KlpSemanticKey(KlpEditingContent.typeId, 'fontFamily', KlpStyleKind.fontFamily);
	static final fontWeight = KlpSemanticKey(KlpEditingContent.typeId, 'fontWeight', KlpStyleKind.fontWeight);
	static final fontSize = KlpSemanticKey(KlpEditingContent.typeId, 'fontSize', KlpStyleKind.fontSize);
	static final lineHeight = KlpSemanticKey(KlpEditingContent.typeId, 'lineHeight', KlpStyleKind.lineHeight);
	static final letterSpacing = KlpSemanticKey(KlpEditingContent.typeId, 'letterSpacing', KlpStyleKind.letterSpacing);
	static final horizontalPadding = KlpSemanticKey(KlpEditingContent.typeId, 'horizontalPaddingScale', KlpStyleKind.distance);
	static final verticalPadding = KlpSemanticKey(KlpEditingContent.typeId, 'verticalPaddingScale', KlpStyleKind.distance);
	static final blockSpacing = KlpSemanticKey(KlpEditingContent.typeId, 'blockSpacing', KlpStyleKind.distance);
	static final overscan = KlpSemanticKey(KlpEditingContent.typeId, 'overscan', KlpStyleKind.distance);
	static final listIndent = KlpSemanticKey(KlpEditingContent.typeId, 'listIndent', KlpStyleKind.distance);
	static final markerGap = KlpSemanticKey(KlpEditingContent.typeId, 'markerGap', KlpStyleKind.distance);
	static final marker = KlpSemanticKey(KlpEditingContent.typeId, 'marker', KlpStyleKind.color);
	static final controlExtent = KlpSemanticKey(KlpEditingContent.typeId, 'controlExtent', KlpStyleKind.distance);
	static final controlRadius = KlpSemanticKey(KlpEditingContent.typeId, 'controlRadius', KlpStyleKind.radius);
	static final controlFontSize = KlpSemanticKey(KlpEditingContent.typeId, 'controlFontSize', KlpStyleKind.fontSize);
	static final controlBackground = KlpSemanticKey(KlpEditingContent.typeId, 'controlBackground', KlpStyleKind.color);
	static final controlFocus = KlpSemanticKey(KlpEditingContent.typeId, 'controlFocus', KlpStyleKind.color);
	static final dragAutoScrollEdge = KlpSemanticKey(KlpEditingContent.typeId, 'dragAutoScrollEdge', KlpStyleKind.distance);
	static final dragAutoScrollStep = KlpSemanticKey(KlpEditingContent.typeId, 'dragAutoScrollStep', KlpStyleKind.distance);
	static final dragAutoScrollInterval = KlpSemanticKey(KlpEditingContent.typeId, 'dragAutoScrollInterval', KlpStyleKind.duration);

	static KlpSemanticToken<T> _token<T extends KlpStyleValue>(KlpSemanticKey<T> key, KlpPrimitiveIndex index) => KlpSemanticToken(key, KlpPrimitiveRef(key.kind, index));

	// 紙感正文內距由內容尺度解析，保持共享距離原料與其他幾何用途不變。
	static KlpDistance resolveHorizontalPadding(KlpDistance scale) => KlpDistance(scale.value * 1.5);
	static KlpDistance resolveVerticalPadding(KlpDistance scale) => KlpDistance(scale.value * 1.4);

	static KlpSemanticSchema schema() => KlpSemanticSchema(KlpEditingContent.typeId, [
		_token(text, KlpPrimitiveIndex.i1),
		_token(ink, KlpPrimitiveIndex.i1),
		_token(caret, KlpPrimitiveIndex.i7),
		_token(selection, KlpPrimitiveIndex.i7),
		_token(fontFamily, KlpPrimitiveIndex.i0),
		_token(fontWeight, KlpPrimitiveIndex.i3),
		_token(fontSize, KlpPrimitiveIndex.i3),
		_token(lineHeight, KlpPrimitiveIndex.i4),
		_token(letterSpacing, KlpPrimitiveIndex.i3),
		_token(horizontalPadding, KlpPrimitiveIndex.i4),
		_token(verticalPadding, KlpPrimitiveIndex.i4),
		_token(blockSpacing, KlpPrimitiveIndex.i2),
		_token(overscan, KlpPrimitiveIndex.i7),
		_token(listIndent, KlpPrimitiveIndex.i4),
		_token(markerGap, KlpPrimitiveIndex.i2),
		_token(marker, KlpPrimitiveIndex.i1),
		_token(controlExtent, KlpPrimitiveIndex.i5),
		_token(controlRadius, KlpPrimitiveIndex.i1),
		_token(controlFontSize, KlpPrimitiveIndex.i2),
		_token(controlBackground, KlpPrimitiveIndex.i5),
		_token(controlFocus, KlpPrimitiveIndex.i7),
		_token(dragAutoScrollEdge, KlpPrimitiveIndex.i5),
		_token(dragAutoScrollStep, KlpPrimitiveIndex.i2),
		_token(dragAutoScrollInterval, KlpPrimitiveIndex.i1),
	]);
}
