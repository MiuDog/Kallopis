# KlpViewOption

Flutter · Stable · 資料與型別

## 主要職責

檢視切換器的一個識別、標籤與可選圖示。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpViewOption createExample(String id, String label) => KlpViewOption(id: id, label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpViewOption
```

## 建構子 KlpViewOption



```dart
const KlpViewOption({
	required String id,
	required String label,
	KlpIconData? icon,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/controls/klp_view_option.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/controls/klp_view_option.dart`。
