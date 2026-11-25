# KlpAccordionItemData

Flutter · Stable · 資料與型別

## 主要職責

[KlpAccordion] 裡的單一可摺疊項目。

[id] 在同一個 [KlpAccordion] 內須唯一，用來追蹤展開狀態；[child] 是展開後顯示的
內容——它何時被建構、狀態如何保留由呼叫端決定，這裡不快取也不知道內容是什麼。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAccordionItemData createExample(String id, String title, Widget child) => KlpAccordionItemData(id: id, title: title, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpAccordionItemData
```

## 建構子 KlpAccordionItemData



```dart
const KlpAccordionItemData({
	required String id,
	required String title,
	required Widget child,
	String? subtitle,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `subtitle` | `String?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/accordion/klp_accordion.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/accordion/klp_accordion.dart`。
