# KlpDockGroupData

Flutter · Stable · 資料與型別

## 主要職責

描述同一可停駐區域內的一組分頁及目前顯示項目。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockGroupData createExample(String id, List<String> panelIds, String activePanelId, double mainAxisExtent) => KlpDockGroupData(id: id, panelIds: panelIds, activePanelId: activePanelId, mainAxisExtent: mainAxisExtent);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockGroupData
```

## 建構子 KlpDockGroupData



```dart
const KlpDockGroupData({
	required String id,
	required List<String> panelIds,
	required String activePanelId,
	required double mainAxisExtent,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `panelIds` | `List<String>` | 是 | — | 群組內的分頁，由左到右排列。 |
| `activePanelId` | `String` | 是 | — | 目前顯示的 panel。 |
| `mainAxisExtent` | `double` | 是 | — | Group 沿著 Area 排列方向的像素尺寸。 |


## 成員與方法

### copyWith

```dart
KlpDockGroupData copyWith({
	String? id,
	List<String>? panelIds,
	String? activePanelId,
	double? mainAxisExtent,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String?` | 否 | null | 穩定識別，用於查詢或回報。 |
| `panelIds` | `List<String>?` | 否 | null | 依公開型別提供此輸入。 |
| `activePanelId` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `mainAxisExtent` | `double?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_models.dart`。
