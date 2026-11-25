# KlpCodeViewportLimit

Flutter · Stable · 資料與型別

## 主要職責

程式碼資料元件的型別化可視高度限制。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCodeViewportLimit createExample(double height) => KlpCodeViewportLimit.fixed(height);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCodeViewportLimit
```

## 建構子 KlpCodeViewportLimit.fixed



```dart
const KlpCodeViewportLimit.fixed(double _height)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `_height` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpCodeViewportLimit.unbounded



```dart
const KlpCodeViewportLimit.unbounded()
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/code/klp_code_viewer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/code/klp_code_viewer.dart`。
