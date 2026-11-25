# KlpDockAction

Flutter · Stable · 資料與型別

## 主要職責

Typed named constructors 固定合法操作形狀，數值在提交邊界驗證。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockAction createExample(String panelId, bool approved) => KlpDockAction.close(panelId: panelId, approved: approved);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockAction
```

## 建構子 KlpDockAction.close



```dart
const KlpDockAction.close({required String panelId, required bool approved})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `panelId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `approved` | `bool` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpDockAction.merge



```dart
const KlpDockAction.merge({
	required String sourceGroupId,
	required String targetGroupId,
	required int index,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `sourceGroupId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `targetGroupId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `index` | `int` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpDockAction.move



```dart
const KlpDockAction.move({required String panelId, required KlpDockDestination destination})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `panelId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `destination` | `KlpDockDestination` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpDockAction.open



```dart
const KlpDockAction.open({required String panelId, required KlpDockDestination destination})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `panelId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `destination` | `KlpDockDestination` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpDockAction.resizeArea



```dart
const KlpDockAction.resizeArea({required KlpDockArea area, required double extent})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `area` | `KlpDockArea` | 是 | — | 依公開型別提供此輸入。 |
| `extent` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpDockAction.resizeGroup



```dart
const KlpDockAction.resizeGroup({required String groupId, required double extent})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `groupId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `extent` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpDockAction.select



```dart
const KlpDockAction.select({required String panelId})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `panelId` | `String` | 是 | — | 依公開型別提供此輸入。 |


## 建構子 KlpDockAction.visibility



```dart
const KlpDockAction.visibility({required KlpDockArea area, required bool isVisible})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `area` | `KlpDockArea` | 是 | — | 依公開型別提供此輸入。 |
| `isVisible` | `bool` | 是 | — | 依目前上下文判定是否可見。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpDockArea](klp-dock-area.md)
- [KlpDockDestination](klp-dock-destination.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_operations.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_operations.dart`。
