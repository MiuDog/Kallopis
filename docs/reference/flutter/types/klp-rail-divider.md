# KlpRailDivider

Flutter · Stable · 資料與型別

## 主要職責

Rail 專用的固定分隔 Entry。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRailDivider createExample(String id) => KlpRailDivider(id: id);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpRailDivider extends KlpRailEntry
```

## 建構子 KlpRailDivider



```dart
const KlpRailDivider({required String id})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### isDraggable

```dart
bool get isDraggable
```



<!-- reference-api:end -->

## 使用限制與關聯

- 繼承／實作：[KlpRailEntry](klp-rail-entry.md)。
- [KlpRailEntry](klp-rail-entry.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/rail/klp_rail_divider.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/rail/klp_rail_divider.dart`。
