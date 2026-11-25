# KlpWindowControlsGeometry

Flutter · Stable · 資料與型別

## 主要職責

視窗控制鈕已解析的幾何介面。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWindowControlsGeometry createExample(double extent) => KlpWindowControlsGeometry(extent: extent);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpWindowControlsGeometry
```

## 建構子 KlpWindowControlsGeometry



```dart
const KlpWindowControlsGeometry({required double extent})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `extent` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### iconExtent

```dart
double get iconExtent
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/window/klp_window_controls_geometry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_controls_geometry.dart`。
