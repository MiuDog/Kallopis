# KlpAccent

Flutter · Stable · 語意風格

## 主要職責

可選的強調色。

每個值都對著 ink 色梯的表面重新校準過，對比 ≥ 4.70——刻意留 0.2 的餘裕，
*調整色梯時不會立刻踩線**。原本的值全部卡在 4.5 邊緣，色梯換掉後五個彩色全數
掉出 AA，而那不會有任何徵兆：顏色看起來還是好的，只是讀不清楚。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

final value = KlpAccent.crimson;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpAccent
```

## 建構子 KlpAccent



```dart
const KlpAccent({required Color light, required Color dark})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `light` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `dark` | `Color` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### crimson

```dart
static const KlpAccent crimson
```



### ink

```dart
static const KlpAccent ink
```



### ochre

```dart
static const KlpAccent ochre
```



### olive

```dart
static const KlpAccent olive
```



### parse

```dart
static KlpAccent parse(String? value)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `value` | `String?` | 是 | — | 目前值。 |


### resolve

```dart
Color resolve(Brightness brightness)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `brightness` | `Brightness` | 是 | — | 依公開型別提供此輸入。 |


### slate

```dart
static const KlpAccent slate
```



### terracotta

```dart
static const KlpAccent terracotta
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_tokens/primitive_token.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_tokens/primitive_token.dart`。
