import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';

/// 保留每步已知結果，不能將後續失敗當成先前修改已回復。
final class KlpFlutterTextInputResult {

	final KlpEditingProjection projection;
	final List<KlpEditingReply> replies;
	final bool synchronized;
	final Object? error;
	final StackTrace? stackTrace;

	KlpFlutterTextInputResult({required this.projection, required Iterable<KlpEditingReply> replies, required this.synchronized, this.error, this.stackTrace}) : replies = List.unmodifiable(replies);
}
