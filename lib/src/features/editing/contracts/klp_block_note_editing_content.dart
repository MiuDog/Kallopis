import 'package:krepis_block_note/krepis_block_note.dart';
import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_screen_body.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// BlockNote 資產解析結果，攜帶位元組與媒體型別；不負責資產儲存或正文模型。
final class KlpResolvedAsset {

	final List<int> bytes;
	final String mediaType;
	const KlpResolvedAsset({required this.bytes, required this.mediaType});
}

/// 受限的 BlockNote 正文節點；consumer 只能提供文件 session 與保存權威。
final class KlpBlockNoteEditingContent implements KlpScreenBody, KlpCompositeNode {

	static const typeId = 'kallopis.blockNoteEditing';

	@override
	final KlpId id;
	final KlpBlockNoteSessionController controller;
	final List<KrepisPageProjection> pageProjections;
	final Future<void> Function(KrepisPageOpenRequest request)? onOpenPage;
	final Future<KrepisBlockNoteEditResult> Function(KrepisDatabaseDropRequest request)? onDatabaseDrop;
	final Future<void> Function()? onOpened;
	final Future<KlpResolvedAsset> Function(String assetId)? resolveAsset;
	final Future<void> Function(String assetId)? onOpenAsset;
	final Future<void> Function(String referenceId, String sourceDocumentId, String sourceBlockId)? onOpenReference;
	@override
	final KlpChildren children = KlpChildren(const []);

	KlpBlockNoteEditingContent({
		required this.id,
		required this.controller,
		Iterable<KrepisPageProjection> pageProjections = const [],
		this.onOpenPage,
		this.onDatabaseDrop,
		this.onOpened,
		this.resolveAsset,
		this.onOpenAsset,
		this.onOpenReference,
	}) : pageProjections = List.unmodifiable(pageProjections) {
		if (controller.bridge is! KlpBlockNoteBridgeChannel) throw ArgumentError('BlockNote content requires a hosted session controller');
	}

	@override
	String get definitionId => typeId;
}
