# KlpRichTextKind

Flutter · Stable · 資料與型別

## 主要職責

結構化行內文字節點的語意種類。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpRichTextKind.code;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpRichTextKind
```

## 建構子 KlpRichTextKind



```dart
const KlpRichTextKind()
```



## 成員與方法

### code

```dart
static const KlpRichTextKind code
```



### emphasis

```dart
static const KlpRichTextKind emphasis
```



### lineBreak

```dart
static const KlpRichTextKind lineBreak
```



### link

```dart
static const KlpRichTextKind link
```



### mention

```dart
static const KlpRichTextKind mention
```



### strike

```dart
static const KlpRichTextKind strike
```



### strong

```dart
static const KlpRichTextKind strong
```



### text

```dart
static const KlpRichTextKind text
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/content/klp_rich_text_kind.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/content/klp_rich_text_kind.dart`。
