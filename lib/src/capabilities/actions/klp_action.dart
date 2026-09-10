/// 宣告式操作標記；消費端只能將操作放進元件資料，不能自行派送。
abstract interface class KlpAction {}

/// 消費端注入的一般 callback；是否啟動與呈現狀態仍由本庫控制。
final class KlpCallbackAction implements KlpAction {

	final void Function() callback;

	const KlpCallbackAction(this.callback);
}
