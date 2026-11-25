# KlpDockDestination

Flutter · Stable · 資料與型別

## 主要職責

分頁插入或新群組；index 是移除來源之後的最終位置。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockDestination createExample(KlpDockArea area, String groupId, int index, double extent) => KlpDockDestination.group(area: area, groupId: groupId, index: index, extent: extent);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockDestination
```

## 建構子 KlpDockDestination.group



```dart
const KlpDockDestination.group({
	required KlpDockArea area,
	required String groupId,
	required int index,
	required double extent,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `area` | `KlpDockArea` | 是 | — | 目標區域，能力由產品清冊決定。 |
| `groupId` | `String` | 是 | — | 原群組或新的全域唯一 identity。 |
| `index` | `int` | 是 | — | 最終分頁或群組插入位置，不 clamp。 |
| `extent` | `double` | 是 | — | 新群組的有限正數偏好尺寸；tab 沒有額外尺寸。 |


## 建構子 KlpDockDestination.tab



```dart
const KlpDockDestination.tab({
	required KlpDockArea area,
	required String groupId,
	required int index,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `area` | `KlpDockArea` | 是 | — | 目標區域，能力由產品清冊決定。 |
| `groupId` | `String` | 是 | — | 原群組或新的全域唯一 identity。 |
| `index` | `int` | 是 | — | 最終分頁或群組插入位置，不 clamp。 |


## 成員與方法

### createsGroup

```dart
final bool createsGroup
```

區分原群組插入與建立群組，不承載內容。

<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpDockArea](klp-dock-area.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_operations.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_operations.dart`。
