# resolveKlpLinearLayout

Flutter · Stable · 工具函式

## 主要職責

先保留 gutter，再解析 minimum、preferred 與受限 flex。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final productResolveKlpLinearLayout = resolveKlpLinearLayout;
```

<!-- reference-api:start -->

## 公開簽名

```dart
KlpLinearLayoutResult resolveKlpLinearLayout({
	required double extent,
	required double gutter,
	required int gutterCount,
	required List<KlpLinearItem> items,
})
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `extent` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `gutter` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `gutterCount` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `items` | `List<KlpLinearItem>` | 是 | — | 由產品提供的項目。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [通用有限尺寸計算](../../../guides/flutter/07-klp-linear-item.md)：跨元件使用流程。

- [KlpLinearItem](../types/klp-linear-item.md)
- [KlpLinearLayoutResult](../types/klp-linear-layout-result.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_linear_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_linear_layout.dart`。
