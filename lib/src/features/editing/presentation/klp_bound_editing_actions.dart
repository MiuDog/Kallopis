part of 'klp_editing_presentation.dart';

/// renderer 可用的內部命令面；consumer 無法注入 Widget 或平台物件。
abstract interface class KlpBoundEditingActions implements KlpBoundEditingLayout {
	int issueCommandSequence();
	Future<KlpEditingReply> submit(KlpEditingRequest request, {required int committedAtMs});
	Future<KlpEditingReply> selectPoint(KlpEditingPointRequest request);
	KlpEditingInteractionBinding bindInteraction(KlpEditingInteraction interaction);
}
