# KlpRovingIndex

Flutter · Stable · 資料與型別

## 主要職責

一組項目間以方向鍵移動「高亮索引」的共用邏輯。

本庫多個元件（[KlpCombobox]、[KlpMenu]、[KlpCommandMenu]、[KlpTabs]，見各自
檔案）都需要「↓／↑（或 ←／→）在項目間移動、跳過停用項、到底/到頂循環」這套
規則。抽成純函式而非各自重寫一份，避免同一條規則出現兩份互相分岔的實作
（AGENTS.md 的硬規則：一條規則只能有一個實作）。

這個類別只做索引運算，不涉及任何 widget 或視覺——各元件仍自行決定「高亮」要
畫成什麼樣子（沿用各自既有的視覺語言），這裡只回答「下一個索引是幾號」。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
void acceptValue(KlpRovingIndex value) {
	// 產品接收此抽象契約；請使用公開子型別或靜態方法。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpRovingIndex
```

## 建構子 KlpRovingIndex



```dart
KlpRovingIndex()
```



## 成員與方法

### first

```dart
static int first({required int count, bool Function(int)? isEnabled})
```

跳到第一個可用索引（Home）。找不到可用項目時回傳 `-1`。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `count` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `isEnabled` | `bool Function(int)?` | 否 | null | 依目前上下文判定是否可啟動。 |


### last

```dart
static int last({required int count, bool Function(int)? isEnabled})
```

跳到最後一個可用索引（End）。找不到可用項目時回傳 `-1`。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `count` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `isEnabled` | `bool Function(int)?` | 否 | null | 依目前上下文判定是否可啟動。 |


### move

```dart
static int move({
	required int current,
	required int count,
	required bool forward,
	bool Function(int)? isEnabled,
})
```

從 [current]（可能是 `-1`，代表尚無高亮）往下一個「可用」索引移動。

[count] 是項目總數。[forward] 為 `true` 表示往後移動（例如 ↓ 或 →），
`false` 表示往前移動（↑ 或 ←）。移動會在頭尾之間循環（wrap-around），不會
停在邊界。[isEnabled] 用來判斷某個索引是否可以被高亮，預設全部可用；若所
有項目都不可用，回傳原本的 [current]（不移動）。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `current` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `count` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `forward` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `isEnabled` | `bool Function(int)?` | 否 | null | 依目前上下文判定是否可啟動。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/klp_roving_index.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_roving_index.dart`。
