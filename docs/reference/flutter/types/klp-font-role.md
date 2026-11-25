# KlpFontRole

Flutter · Stable · 資料與型別

## 主要職責

字族的語意角色。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpFontRole.body;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpFontRole
```

## 建構子 KlpFontRole



```dart
const KlpFontRole()
```



## 成員與方法

### body

```dart
static const KlpFontRole body
```



### mono

```dart
static const KlpFontRole mono
```



### ui

```dart
static const KlpFontRole ui
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/content/klp_font_role.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/content/klp_font_role.dart`。
