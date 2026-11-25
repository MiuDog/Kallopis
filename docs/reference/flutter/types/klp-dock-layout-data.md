# KlpDockLayoutData

Flutter · Stable · 資料與型別

## 主要職責

描述固定 Stage 周圍三個可停駐區域的受控布局狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockLayoutData createExample(KlpDockAreaData left, KlpDockAreaData right, KlpDockAreaData bottom) => KlpDockLayoutData(left: left, right: right, bottom: bottom);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockLayoutData
```

## 建構子 KlpDockLayoutData



```dart
const KlpDockLayoutData({
	required KlpDockAreaData left,
	required KlpDockAreaData right,
	required KlpDockAreaData bottom,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `left` | `KlpDockAreaData` | 是 | — | 依公開型別提供此輸入。 |
| `right` | `KlpDockAreaData` | 是 | — | 依公開型別提供此輸入。 |
| `bottom` | `KlpDockAreaData` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### copyWith

```dart
KlpDockLayoutData copyWith({
	KlpDockAreaData? left,
	KlpDockAreaData? right,
	KlpDockAreaData? bottom,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `left` | `KlpDockAreaData?` | 否 | null | 依公開型別提供此輸入。 |
| `right` | `KlpDockAreaData?` | 否 | null | 依公開型別提供此輸入。 |
| `bottom` | `KlpDockAreaData?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpDockAreaData](klp-dock-area-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_models.dart`。
