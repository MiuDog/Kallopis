# KlpRailButtonEntry

Flutter · Stable · 資料與型別

## 主要職責

一般 Rail 動作的結構化資料。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRailButtonEntry createExample(String id, KlpIconData icon, String label, void Function() onPressed) => KlpRailButtonEntry(id: id, icon: icon, label: label, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpRailButtonEntry extends KlpRailEntry
```

## 建構子 KlpRailButtonEntry



```dart
const KlpRailButtonEntry({
	required String id,
	required KlpIconData icon,
	required String label,
	required VoidCallback onPressed,
	bool selected = false,
	String? badge,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `icon` | `KlpIconData` | 是 | — | 操作或內容圖示。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `badge` | `String?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 繼承／實作：[KlpRailEntry](klp-rail-entry.md)。
- [KlpRailEntry](klp-rail-entry.md)
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/rail/klp_rail_button_entry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/rail/klp_rail_button_entry.dart`。
