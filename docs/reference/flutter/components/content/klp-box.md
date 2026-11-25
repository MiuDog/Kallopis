# KlpBox

Flutter · Stable · 內容元件

## 主要職責

基礎尺寸與邊距容器排版原語。取代 Container 與 SizedBox。
支援風格介面、風格枚舉（KlpSpaceSize）與傳統尺寸邊距設定。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpBox createExample() => KlpBox();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpBox extends StatelessWidget
```

## 建構子 KlpBox



```dart
const KlpBox({
	Key? key,
	double? width,
	double? height,
	KlpSpaceSize? widthSize,
	KlpSpaceSize? heightSize,
	EdgeInsetsGeometry? padding,
	EdgeInsetsGeometry? margin,
	KlpBoxInsets? insets,
	KlpBoxInsets? marginInsets,
	KlpSpaceSize? paddingSize,
	KlpSpaceSize? marginSize,
	KlpSurfaceTone? tone,
	double? radius,
	Widget? child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `width` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `height` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `widthSize` | `KlpSpaceSize?` | 否 | null | 依公開型別提供此輸入。 |
| `heightSize` | `KlpSpaceSize?` | 否 | null | 依公開型別提供此輸入。 |
| `padding` | `EdgeInsetsGeometry?` | 否 | null | 依公開型別提供此輸入。 |
| `margin` | `EdgeInsetsGeometry?` | 否 | null | 依公開型別提供此輸入。 |
| `insets` | `KlpBoxInsets?` | 否 | null | 依公開型別提供此輸入。 |
| `marginInsets` | `KlpBoxInsets?` | 否 | null | 依公開型別提供此輸入。 |
| `paddingSize` | `KlpSpaceSize?` | 否 | null | 依公開型別提供此輸入。 |
| `marginSize` | `KlpSpaceSize?` | 否 | null | 依公開型別提供此輸入。 |
| `tone` | `KlpSurfaceTone?` | 否 | null | 選擇語意呈現。 |
| `radius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `child` | `Widget?` | 否 | null | 產品提供的內容。 |


## 建構子 KlpBox.expand



```dart
const KlpBox.expand({Key? key, Widget? child})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget?` | 否 | null | 產品提供的內容。 |


## 建構子 KlpBox.shrink



```dart
const KlpBox.shrink({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpBox.square



```dart
const KlpBox.square({
	Key? key,
	required double dimension,
	Widget? child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `dimension` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget?` | 否 | null | 產品提供的內容。 |


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

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpBoxInsets](../../types/klp-box-insets.md)
- [KlpSpaceSize](../../types/klp-space-size.md)
- [KlpSurfaceTone](../../types/klp-surface-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_box.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_box.dart`。
