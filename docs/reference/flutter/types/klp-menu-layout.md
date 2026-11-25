# KlpMenuLayout

Flutter · Stable · 資料與型別

## 主要職責

計算 [KlpMenu] 彈出時的尺寸與位置，供呼叫端在插入 overlay 之前先算好座標。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
void acceptValue(KlpMenuLayout value) {
	// 產品接收此抽象契約；請使用公開子型別或靜態方法。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpMenuLayout
```

## 建構子 KlpMenuLayout



```dart
KlpMenuLayout()
```



## 成員與方法

### estimatedHeight

```dart
static double estimatedHeight({
	required BuildContext context,
	required int itemCount,
	int separatorCount = 0,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |
| `itemCount` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `separatorCount` | `int` | 否 | 0 | 依公開型別提供此輸入。 |


### resolvePosition

```dart
static Offset resolvePosition({
	required Offset anchor,
	required Size viewport,
	required BuildContext context,
	required int itemCount,
	int separatorCount = 0,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `anchor` | `Offset` | 是 | — | 依公開型別提供此輸入。 |
| `viewport` | `Size` | 是 | — | 依公開型別提供此輸入。 |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |
| `itemCount` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `separatorCount` | `int` | 否 | 0 | 依公開型別提供此輸入。 |


### resolveSubmenuPosition

```dart
static Offset resolveSubmenuPosition({
	required Offset parentPosition,
	required Size viewport,
	required BuildContext context,
	required int itemCount,
	int separatorCount = 0,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `parentPosition` | `Offset` | 是 | — | 依公開型別提供此輸入。 |
| `viewport` | `Size` | 是 | — | 依公開型別提供此輸入。 |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |
| `itemCount` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `separatorCount` | `int` | 否 | 0 | 依公開型別提供此輸入。 |


### width

```dart
static double get width
```



### widthForItems

```dart
static double widthForItems(
	BuildContext context,
	List<KlpMenuItemData> items, {
	bool scrollable = false,
})
```

詳細選單依實際文字量測寬度，避免說明和快捷鍵互相擠壓。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |
| `items` | `List<KlpMenuItemData>` | 是 | — | 由產品提供的項目。 |
| `scrollable` | `bool` | 否 | false | 依公開型別提供此輸入。 |


### widthOf

```dart
static double widthOf(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpMenuItemData](klp-menu-item-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/overlays/klp_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_menu.dart`。
