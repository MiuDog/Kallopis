# KlpMessageConversation

Flutter · Experimental · 內容元件

## 主要職責

在有限區域內組合可捲動訊息內容與底部 Composer。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpMessageConversation createExample(Widget content, Widget composer) => KlpMessageConversation(content: content, composer: composer);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpMessageConversation extends StatelessWidget
```

## 建構子 KlpMessageConversation



```dart
const KlpMessageConversation({
	Key? key,
	required Widget content,
	required Widget composer,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `content` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `composer` | `Widget` | 是 | — | 依公開型別提供此輸入。 |


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

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/message_composer/klp_message_composer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/message_composer/klp_message_composer.dart`。
