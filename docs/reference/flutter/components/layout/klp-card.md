# KlpCard

Flutter · Stable · 布局元件

## 主要職責

內容卡片。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCard createExample(String title, Widget child) => KlpCard(title: title, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCard extends StatelessWidget
```

## 建構子 KlpCard



```dart
const KlpCard({
	Key? key,
	required String title,
	required Widget child,
	String? label,
	Widget? leading,
	Widget? trailing,
	Widget? footer,
	bool selected = false,
	KlpCardTone tone = KlpCardTone.component,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |
| `leading` | `Widget?` | 否 | null | 前方內容。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |
| `footer` | `Widget?` | 否 | null | 頁尾內容。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `tone` | `KlpCardTone` | 否 | KlpCardTone.component | 選擇語意呈現。 |


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
- [KlpCardTone](../../types/klp-card-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/card/klp_card.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/card/klp_card.dart`。
