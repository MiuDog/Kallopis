# KlpDataColumnSpan

Flutter · Stable · 資料與型別

## 主要職責

資料表欄位相對於其他欄位所占的比例。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpDataColumnSpan.double;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpDataColumnSpan
```

## 建構子 KlpDataColumnSpan



```dart
const KlpDataColumnSpan(int flex)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `flex` | `int` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### double

```dart
static const KlpDataColumnSpan double
```



### single

```dart
static const KlpDataColumnSpan single
```



### triple

```dart
static const KlpDataColumnSpan triple
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/advanced/models/klp_advanced_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/advanced/models/klp_advanced_models.dart`。
