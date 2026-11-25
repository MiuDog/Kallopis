# KlpMessageBubble

Flutter · Stable · 內容元件

## 主要職責

訊息作者、時間與內容的通用呈現單元。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpMessageBubble createExample(String author, String timestamp, Widget child) => KlpMessageBubble(author: author, timestamp: timestamp, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpMessageBubble extends StatelessWidget
```

## 建構子 KlpMessageBubble



```dart
const KlpMessageBubble({
	Key? key,
	required String author,
	required String timestamp,
	required Widget child,
	bool emphasized = false,
	KlpMessageAlignment alignment = KlpMessageAlignment.leading,
	bool? background,
	bool dense = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `author` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `timestamp` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `emphasized` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `alignment` | `KlpMessageAlignment` | 否 | KlpMessageAlignment.leading | 依公開型別提供此輸入。 |
| `background` | `bool?` | 否 | null | 依公開型別提供此輸入。 |
| `dense` | `bool` | 否 | false | 依公開型別提供此輸入。 |


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
- [KlpMessageAlignment](../../types/klp-message-alignment.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/message_thread/klp_message_thread.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/message_thread/klp_message_thread.dart`。
