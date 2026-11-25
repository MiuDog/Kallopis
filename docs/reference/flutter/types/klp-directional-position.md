# KlpDirectionalPosition

Flutter · Stable · 資料與型別

## 主要職責

方向感知定位原語的幾何介面。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDirectionalPosition createExample() => KlpDirectionalPosition();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDirectionalPosition
```

## 建構子 KlpDirectionalPosition



```dart
const KlpDirectionalPosition({
	double? start,
	double? top,
	double? end,
	double? bottom,
	double? width,
	double? height,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `start` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `top` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `end` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `bottom` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `width` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `height` | `double?` | 否 | null | 依公開型別提供此輸入。 |


## 建構子 KlpDirectionalPosition.atTop



```dart
const KlpDirectionalPosition.atTop({required double? height})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `height` | `double?` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpDirectionalPosition.below



```dart
const KlpDirectionalPosition.below({required double? top})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `top` | `double?` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpDirectionalPosition.fill



```dart
const KlpDirectionalPosition.fill()
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/layout/klp_directional_position.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_directional_position.dart`。
