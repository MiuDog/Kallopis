# KlpRailEntry

Flutter · Stable · 資料與型別

## 主要職責

導覽軌可接受內容的共同資料契約。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
void acceptValue(KlpRailEntry value) {
	// 產品接收此抽象契約；請使用公開子型別或靜態方法。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract base class KlpRailEntry
```

## 建構子 KlpRailEntry



```dart
const KlpRailEntry({required String id})
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

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/rail/klp_rail_entry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/rail/klp_rail_entry.dart`。
