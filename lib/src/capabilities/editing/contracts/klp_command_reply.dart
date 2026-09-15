import 'klp_editing_projection.dart';
import 'klp_editing_reply.dart';

/// 命令結果攜帶最新 editor 權威；未知 transport 以 error 表示而不偽造 decision。
final class KlpCommandReply {
	final KlpEditingDecision decision;
	final KlpEditingProjection projection;

	const KlpCommandReply(this.decision, this.projection);
}
