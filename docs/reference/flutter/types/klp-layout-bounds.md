# KlpLayoutBounds

Flutter · Stable · 資料與型別

## 主要職責

一般布局節點的主軸尺寸限制；空間不足由共通演算法退化。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpLayoutBounds createExample() => KlpLayoutBounds();
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpLayoutBounds
```

## 建構子 KlpLayoutBounds



```dart
const KlpLayoutBounds({
	double minimum = 0,
	double? maximum,
	double? preferred,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `minimum` | `double` | 否 | 0 | 正常空間下的最小值與可選上限。 |
| `maximum` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `preferred` | `double?` | 否 | null | 未指定時保留正 flex 擴展、零 flex 自然量測語意。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [一般布局 bounds 與 divider](../../../guides/flutter/08-klp-layout-pane.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_app_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_app_layout.dart`。
