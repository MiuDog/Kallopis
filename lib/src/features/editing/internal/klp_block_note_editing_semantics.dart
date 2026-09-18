import 'package:kallopis/src/features/editing/contracts/klp_block_note_editing_content.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_index.dart';
import 'package:kallopis/src/styling/primitives/klp_style_kind.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';

/// BlockNote 只接收 Kallopis 已解析的必要呈現值，不形成第二份 theme 來源。
final class KlpBlockNoteEditingSemantics {
	static final background = KlpSemanticKey(KlpBlockNoteEditingContent.typeId, 'background', KlpStyleKind.color);
	static final text = KlpSemanticKey(KlpBlockNoteEditingContent.typeId, 'text', KlpStyleKind.color);
	static final fontFamily = KlpSemanticKey(KlpBlockNoteEditingContent.typeId, 'fontFamily', KlpStyleKind.fontFamily);
	static final fontSize = KlpSemanticKey(KlpBlockNoteEditingContent.typeId, 'fontSize', KlpStyleKind.fontSize);

	static KlpSemanticSchema schema() => KlpSemanticSchema(KlpBlockNoteEditingContent.typeId, [
		KlpSemanticToken(background, KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i3)),
		KlpSemanticToken(text, KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i1)),
		KlpSemanticToken(fontFamily, KlpPrimitiveRef(KlpStyleKind.fontFamily, KlpPrimitiveIndex.i0)),
		KlpSemanticToken(fontSize, KlpPrimitiveRef(KlpStyleKind.fontSize, KlpPrimitiveIndex.i3)),
	]);
}
