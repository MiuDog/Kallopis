# KlpOklchChromaRange

Flutter · Stable · 資料與型別

## 主要職責

OKLCH 編輯控制項可操作的 Chroma 範圍。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpOklchChromaRange createExample(double upperBound) => KlpOklchChromaRange.custom(upperBound);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpOklchChromaRange
```

## 建構子 KlpOklchChromaRange.custom



```dart
const KlpOklchChromaRange.custom(double upperBound)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `upperBound` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### standard

```dart
static const KlpOklchChromaRange standard
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/color/klp_oklch_chroma_range.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/color/klp_oklch_chroma_range.dart`。
