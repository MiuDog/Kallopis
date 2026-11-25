# KlpDockAreaData

Flutter · Stable · 資料與型別

## 主要職責

描述單一可停駐區域的方向、群組、可見性與像素尺寸。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockAreaData createExample(Axis axis, List<KlpDockGroupData> groups, double extent) => KlpDockAreaData(axis: axis, groups: groups, extent: extent);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockAreaData
```

## 建構子 KlpDockAreaData



```dart
const KlpDockAreaData({
	required Axis axis,
	required List<KlpDockGroupData> groups,
	required double extent,
	bool isVisible = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `axis` | `Axis` | 是 | — | Area 內部 group 的排列方向。 |
| `groups` | `List<KlpDockGroupData>` | 是 | — | 依公開型別提供此輸入。 |
| `extent` | `double` | 是 | — | 左右 Area 代表寬度，Bottom Area 代表高度。 |
| `isVisible` | `bool` | 否 | true | 依目前上下文判定是否可見。 |


## 成員與方法

### copyWith

```dart
KlpDockAreaData copyWith({
	Axis? axis,
	List<KlpDockGroupData>? groups,
	bool? isVisible,
	double? extent,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `axis` | `Axis?` | 否 | null | 依公開型別提供此輸入。 |
| `groups` | `List<KlpDockGroupData>?` | 否 | null | 依公開型別提供此輸入。 |
| `isVisible` | `bool?` | 否 | null | 依目前上下文判定是否可見。 |
| `extent` | `double?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpDockGroupData](klp-dock-group-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_models.dart`。
