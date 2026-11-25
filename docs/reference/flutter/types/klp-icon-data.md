# KlpIconData

Flutter · Stable · 資料與型別

## 主要職責

Kallopis 圖示字型中的 regular 與 optional thin 字碼。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpIconData createExample(int regularCodePoint) => KlpIconData(regularCodePoint);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpIconData
```

## 建構子 KlpIconData



```dart
const KlpIconData(int regularCodePoint, {int? thinCodePoint})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `regularCodePoint` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `thinCodePoint` | `int?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### codePoint

```dart
int get codePoint
```



### codePointFor

```dart
int codePointFor(KlpIconWeight weight)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `weight` | `KlpIconWeight` | 是 | — | 依公開型別提供此輸入。 |


### supports

```dart
bool supports(KlpIconWeight weight)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `weight` | `KlpIconWeight` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpIconWeight](klp-icon-weight.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/klp_icon_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/klp_icon_data.dart`。
