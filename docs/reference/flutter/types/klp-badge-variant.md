# KlpBadgeVariant

Flutter · Stable · 資料與型別

## 主要職責

標記視覺樣式。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpBadgeVariant.filled;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpBadgeVariant
```

## 建構子 KlpBadgeVariant



```dart
const KlpBadgeVariant()
```



## 成員與方法

### filled

```dart
static const KlpBadgeVariant filled
```

柔和填色底。

### outline

```dart
static const KlpBadgeVariant outline
```

外框無填色，外框與文字同色。

### solid

```dart
static const KlpBadgeVariant solid
```

純深色底與高對比文字。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/badge/klp_badge_variant.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/badge/klp_badge_variant.dart`。
