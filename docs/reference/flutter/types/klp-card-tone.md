# KlpCardTone

Flutter · Stable · 資料與型別

## 主要職責

內容卡片可採用的中性表面層級。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpCardTone.component;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpCardTone
```

## 建構子 KlpCardTone



```dart
const KlpCardTone()
```



## 成員與方法

### component

```dart
static const KlpCardTone component
```



### muted

```dart
static const KlpCardTone muted
```



### raised

```dart
static const KlpCardTone raised
```



### surface

```dart
static const KlpCardTone surface
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/card/klp_card.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/card/klp_card.dart`。
