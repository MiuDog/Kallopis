/// 編輯宿主失敗所屬的局部平台工作階段。
enum KlpEditingHostOrigin { textInput, blockNote, canva }

/// 宿主失敗發生的操作階段；不代表正文交易結果。
enum KlpEditingHostPhase { environmentCreate, bridgeReady, bind, configure, open, flush, receive, callback, input, interrupt, dispose }

/// 將原始例外交由 application 處理，不取得正文或 controller 權威。
final class KlpEditingHostFailure {
	final KlpEditingHostOrigin origin;
	final KlpEditingHostPhase phase;
	final Object error;
	final StackTrace stackTrace;

	const KlpEditingHostFailure({
		required this.origin,
		required this.phase,
		required this.error,
		required this.stackTrace,
	});
}

/// 由唯一 application 宿主安裝的編輯平台失敗接收端。
typedef KlpEditingHostFailureSink = void Function(KlpEditingHostFailure failure);
