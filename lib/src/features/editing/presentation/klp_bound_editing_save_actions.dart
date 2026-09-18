part of 'klp_editing_presentation.dart';

/// renderer 借用同一 editor source 的保存權威，不取得目的地或原生資源。
abstract interface class KlpBoundEditingSaveActions {
	KlpState<KlpEditingSaveProjection> get saveState;
	int issueCommandSequence();
	Future<KlpEditingSaveReply> submitSave(KlpEditingSaveRequest request);
}
