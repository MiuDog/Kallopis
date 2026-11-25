# KlpLinearItem

Flutter · Stable · 資料與型別

## 主要職責

單一主軸尺寸，不持有內容、panel 或產品狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpLinearItem createExample() => KlpLinearItem();
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpLinearItem
```

## 建構子 KlpLinearItem



```dart
const KlpLinearItem({
	double minimum = 0,
	double? maximum,
	double preferred = 0,
	double flex = 1,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `minimum` | `double` | 否 | 0 | minimum／maximum：正常空間下的尺寸限制。 |
| `maximum` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `preferred` | `double` | 否 | 0 | preferred：分配 flex 前要求的尺寸，會先限制在合法範圍。 |
| `flex` | `double` | 否 | 1 | flex：剩餘空間的比例權重；零表示不增長。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [通用有限尺寸計算](../../../guides/flutter/07-klp-linear-item.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_linear_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_linear_layout.dart`。
