/// 僅限本庫已準備邊界宣告子樹操作資格，消費端節點不能實作此能力。
abstract interface class KlpPreparedActivationPolicy {

	bool get descendantsActive;
}
