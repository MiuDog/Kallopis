# KlpStateHighlight

Flutter · Stable · 內容元件

## 主要職責

疊在內容上的狀態高亮。

*hover 與 selected 一律以高亮色表達，不畫邊框。** 先前這兩個狀態在庫裡有兩套
語彙——`KlpPressable` 用高亮、表單與 explorer 用虛線框——同一件事兩種畫法，
消費者無從預期。

高亮以 [Stack] 疊在內容之上而不是換掉內容的底色：後者會逼每個元件自己知道
「我原本的底色是什麼、混上去之後該是什麼」，而那正是元件不該知道的事。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStateHighlight createExample(KlpHighlightState state, Widget child) => KlpStateHighlight(state: state, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStateHighlight extends StatelessWidget
```

## 建構子 KlpStateHighlight



```dart
const KlpStateHighlight({
	Key? key,
	required KlpHighlightState state,
	required Widget child,
	BorderRadius? borderRadius,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `state` | `KlpHighlightState` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `borderRadius` | `BorderRadius?` | 否 | null | `null` 表示沿用 theme 的控制項圓角。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpHighlightState](../../types/klp-highlight-state.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/interaction/klp_state_highlight.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_state_highlight.dart`。
