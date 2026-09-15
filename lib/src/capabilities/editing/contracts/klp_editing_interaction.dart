/// Flutter host 的輸入生命週期；提供者關閉前必須等待中斷完成。
abstract interface class KlpEditingInteraction {
	Future<void> interrupt();
}

/// 由 Flutter host 持有；關閉只解除本次綁定。
abstract interface class KlpEditingInteractionBinding {
	void close();
}
