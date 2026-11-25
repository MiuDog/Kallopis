# KlpDockAreaConstraints

Flutter · Stable · 資料與型別

## 主要職責

限制可停駐區域的最小與最大像素尺寸，不決定產品保存策略。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockAreaConstraints createExample(double minExtent, double maxExtent) => KlpDockAreaConstraints(minExtent: minExtent, maxExtent: maxExtent);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockAreaConstraints
```

## 建構子 KlpDockAreaConstraints



```dart
const KlpDockAreaConstraints({required double minExtent, required double maxExtent})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `minExtent` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `maxExtent` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### closeThreshold

```dart
double get closeThreshold
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_models.dart`。
