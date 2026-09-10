/// Guard 僅借用取消訊號，沒有取消交易的寫入權。
final class KlpNavigationCancellation {

	final Future<void> whenCancelled;
	final bool Function() _isCancelled;

	KlpNavigationCancellation(this.whenCancelled, bool Function() isCancelled) : _isCancelled = isCancelled;

	bool get isCancelled => _isCancelled();
}
