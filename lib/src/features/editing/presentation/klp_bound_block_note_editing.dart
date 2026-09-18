part of 'klp_editing_presentation.dart';

/// 已通過組裝檢查的 BlockNote session，不接受 consumer Widget 或 script。
final class KlpBoundBlockNoteEditing extends KlpBoundTemplate {
	final KlpBlockNoteSessionController controller;
	final Future<void> Function()? onOpened;
	final Future<KlpResolvedAsset> Function(String assetId)? resolveAsset;
	final Future<void> Function(String assetId)? onOpenAsset;
	final Future<void> Function(String referenceId, String sourceDocumentId, String sourceBlockId)? onOpenReference;
	final String background;
	final String text;
	final String fontFamily;
	final double fontSize;
	const KlpBoundBlockNoteEditing(this.controller, {required this.background, required this.text, required this.fontFamily, required this.fontSize, this.onOpened, this.resolveAsset, this.onOpenAsset, this.onOpenReference});
}
