/// 一組項目間以方向鍵移動「高亮索引」的共用邏輯。
///
/// 本庫多個元件（[KlpCombobox]、[KlpMenu]、[KlpCommandMenu]、[KlpTabs]，見各自
/// 檔案）都需要「↓／↑（或 ←／→）在項目間移動、跳過停用項、到底/到頂循環」這套
/// 規則。抽成純函式而非各自重寫一份，避免同一條規則出現兩份互相分岔的實作
/// （AGENTS.md 的硬規則：一條規則只能有一個實作）。
///
/// 這個類別只做索引運算，不涉及任何 widget 或視覺——各元件仍自行決定「高亮」要
/// 畫成什麼樣子（沿用各自既有的視覺語言），這裡只回答「下一個索引是幾號」。
abstract final class KlpRovingIndex {
  /// 從 [current]（可能是 `-1`，代表尚無高亮）往下一個「可用」索引移動。
  ///
  /// [count] 是項目總數。[forward] 為 `true` 表示往後移動（例如 ↓ 或 →），
  /// `false` 表示往前移動（↑ 或 ←）。移動會在頭尾之間循環（wrap-around），不會
  /// 停在邊界。[isEnabled] 用來判斷某個索引是否可以被高亮，預設全部可用；若所
  /// 有項目都不可用，回傳原本的 [current]（不移動）。
  static int move({
    required int current,
    required int count,
    required bool forward,
    bool Function(int index)? isEnabled,
  }) {
    if (count <= 0) return -1;
    final enabled = isEnabled ?? (_) => true;
    var next = current;
    for (var step = 0; step < count; step++) {
      next = forward ? (next + 1) % count : (next - 1 + count) % count;
      if (enabled(next)) return next;
    }
    return current;
  }

  /// 跳到第一個可用索引（Home）。找不到可用項目時回傳 `-1`。
  static int first({required int count, bool Function(int index)? isEnabled}) {
    final enabled = isEnabled ?? (_) => true;
    for (var i = 0; i < count; i++) {
      if (enabled(i)) return i;
    }
    return -1;
  }

  /// 跳到最後一個可用索引（End）。找不到可用項目時回傳 `-1`。
  static int last({required int count, bool Function(int index)? isEnabled}) {
    final enabled = isEnabled ?? (_) => true;
    for (var i = count - 1; i >= 0; i--) {
      if (enabled(i)) return i;
    }
    return -1;
  }
}
