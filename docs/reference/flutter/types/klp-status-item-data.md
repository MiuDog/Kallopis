# KlpStatusItemData

Flutter · Stable · 資料與型別

## 主要職責

一個可注入至側欄或狀態列的產品中立狀態項目。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStatusItemData createExample(String label) => KlpStatusItemData(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStatusItemData
```

## 建構子 KlpStatusItemData



```dart
const KlpStatusItemData({
	required String label,
	KlpStatusKind kind = KlpStatusKind.dot,
	bool active = true,
	Color? color,
	bool showsIndicator = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `kind` | `KlpStatusKind` | 否 | KlpStatusKind.dot | 依公開型別提供此輸入。 |
| `active` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `color` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `showsIndicator` | `bool` | 否 | true | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpStatusKind](klp-status-kind.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/status/klp_status_item_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/status/klp_status_item_data.dart`。
