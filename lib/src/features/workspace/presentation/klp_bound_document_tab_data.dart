part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀頁籤呈現資料，攜帶放置身分與文件狀態；不屬使用端 API，也不保存文件。
final class KlpBoundDocumentTabData {
	final KlpPlacementId id;
	final String label;
	final bool dirty;
	final bool closable;
	final bool pinned;
	final bool selected;
	const KlpBoundDocumentTabData({required this.id, required this.label, required this.dirty, required this.closable, required this.pinned, required this.selected});
}
