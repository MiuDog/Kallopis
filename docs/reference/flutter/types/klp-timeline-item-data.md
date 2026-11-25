# KlpTimelineItemData

Flutter · Stable · 資料與型別

## 主要職責

時間軸上的一個事件。

[marker] 為 `null` 時使用預設圓點；需要客製標記（例如放圖示）時提供這個 slot，
而不是加一堆布林參數去描述「這是哪一種標記」。[highlighted] 只改變預設圓點的
顏色深淺，不表達產品語意（不是「成功」或「危險」那種狀態）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTimelineItemData createExample(String title) => KlpTimelineItemData(title: title);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTimelineItemData
```

## 建構子 KlpTimelineItemData



```dart
const KlpTimelineItemData({
	required String title,
	String? time,
	Widget? content,
	Widget? marker,
	bool highlighted = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `time` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `content` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `marker` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `highlighted` | `bool` | 否 | false | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/timeline/klp_timeline.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/timeline/klp_timeline.dart`。
