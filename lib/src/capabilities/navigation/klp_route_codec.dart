/// 消費端將型別化路由參數轉成中立的字串資料；不接觸網址、平台或畫面。
abstract interface class KlpRouteCodec<P> {
  Map<String, String> encode(P parameters);
  P decode(Map<String, String> values);
}
