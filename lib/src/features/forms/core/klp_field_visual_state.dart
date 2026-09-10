/// 欄位可能處於的視覺／驗證狀態詞彙表，供消費端的表單狀態機使用。
///
/// 目前庫內元件不直接讀取這個列舉——[KlpField] 等元件是把 `error`／`status`
/// 這類已算好的字串當參數。它存在的目的是讓不同產品在描述「這個欄位現在算
/// dirty 還是 conflict」時用同一套語彙，而不是各自發明字串常數。
enum KlpFieldVisualState {
  pristine,
  dirty,
  touched,
  focused,
  validating,
  valid,
  invalid,
  disabled,
  readOnly,
  conflict,
}
