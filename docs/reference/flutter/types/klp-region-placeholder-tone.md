# KlpRegionPlaceholderTone

Flutter · Stable · 資料與型別

## 主要職責

提供區域佔位的語意選項；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpRegionPlaceholderTone.neutral;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpRegionPlaceholderTone
```

## 建構子 KlpRegionPlaceholderTone



```dart
const KlpRegionPlaceholderTone()
```



## 成員與方法

### neutral

```dart
static const KlpRegionPlaceholderTone neutral
```



### pending

```dart
static const KlpRegionPlaceholderTone pending
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/feedback/klp_region_placeholder.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/klp_region_placeholder.dart`。
