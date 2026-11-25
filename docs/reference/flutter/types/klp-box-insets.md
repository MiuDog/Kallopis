# KlpBoxInsets

Flutter · Stable · 資料與型別

## 主要職責

封裝已由 theme 解析的方向感知內距，避免高階元件傳遞 Flutter 樣式物件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpBoxInsets createExample() => KlpBoxInsets.directional();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpBoxInsets
```

## 建構子 KlpBoxInsets.directional



```dart
const KlpBoxInsets.directional({
	double start = 0,
	double top = 0,
	double end = 0,
	double bottom = 0,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `start` | `double` | 否 | 0 | 依公開型別提供此輸入。 |
| `top` | `double` | 否 | 0 | 依公開型別提供此輸入。 |
| `end` | `double` | 否 | 0 | 依公開型別提供此輸入。 |
| `bottom` | `double` | 否 | 0 | 依公開型別提供此輸入。 |


## 建構子 KlpBoxInsets.uniform



```dart
const KlpBoxInsets.uniform(double value)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `value` | `double` | 是 | — | 目前值。 |


## 成員與方法

### edgeInsets

```dart
EdgeInsetsDirectional get edgeInsets
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/layout/klp_box_insets.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_box_insets.dart`。
