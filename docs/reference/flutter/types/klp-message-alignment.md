# KlpMessageAlignment

Flutter · Stable · 資料與型別

## 主要職責

訊息在可用寬度中的對齊方向。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpMessageAlignment.leading;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpMessageAlignment
```

## 建構子 KlpMessageAlignment



```dart
const KlpMessageAlignment()
```



## 成員與方法

### leading

```dart
static const KlpMessageAlignment leading
```

前方內容。

### trailing

```dart
static const KlpMessageAlignment trailing
```

後方內容。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/message_thread/klp_message_alignment.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/message_thread/klp_message_alignment.dart`。
