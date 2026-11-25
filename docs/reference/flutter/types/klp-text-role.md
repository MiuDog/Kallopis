# KlpTextRole

Flutter · Stable · 資料與型別

## 主要職責

文字的語意角色，由 theme 決定對應字級、行高、字重與字族。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpTextRole.appTitle;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpTextRole
```

## 建構子 KlpTextRole



```dart
const KlpTextRole()
```



## 成員與方法

### appTitle

```dart
static const KlpTextRole appTitle
```



### body

```dart
static const KlpTextRole body
```



### bodyStrong

```dart
static const KlpTextRole bodyStrong
```



### caption

```dart
static const KlpTextRole caption
```



### captionStrong

```dart
static const KlpTextRole captionStrong
```



### code

```dart
static const KlpTextRole code
```



### display

```dart
static const KlpTextRole display
```



### editor

```dart
static const KlpTextRole editor
```



### h1

```dart
static const KlpTextRole h1
```



### h2

```dart
static const KlpTextRole h2
```



### h3

```dart
static const KlpTextRole h3
```



### h4

```dart
static const KlpTextRole h4
```



### header

```dart
static const KlpTextRole header
```

標頭內容。

### label

```dart
static const KlpTextRole label
```

顯示標籤。

### lead

```dart
static const KlpTextRole lead
```



### micro

```dart
static const KlpTextRole micro
```



### monoCaptionStrong

```dart
static const KlpTextRole monoCaptionStrong
```



### section

```dart
static const KlpTextRole section
```



### status

```dart
static const KlpTextRole status
```



### sub

```dart
static const KlpTextRole sub
```



### terminal

```dart
static const KlpTextRole terminal
```



### title

```dart
static const KlpTextRole title
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/content/klp_text_role.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/content/klp_text_role.dart`。
