# KlpGap

Flutter · Stable · 內容元件

## 主要職責

間距排版原語。取代 SizedBox 進行彈性與固定距離佔位。
支援風格介面與風格枚舉（KlpSpaceSize）為第一優先真相。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpGap createExample(double? extent) => KlpGap(extent);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpGap extends StatelessWidget
```

## 建構子 KlpGap

依據傳統彈性數值指定雙向間距。

```dart
const KlpGap(double? extent, {Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `extent` | `double?` | 是 | — | 依公開型別提供此輸入。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.base

快捷建構子：標準間距

```dart
const KlpGap.base({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.comfortable

快捷建構子：舒適間距

```dart
const KlpGap.comfortable({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.hairline

快捷建構子：微細間距

```dart
const KlpGap.hairline({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.height

依據彈性數值指定垂直高度間距。

```dart
const KlpGap.height(double? height, {Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `height` | `double?` | 是 | — | 依公開型別提供此輸入。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.heightSize

依據風格枚舉指定垂直高度間距。

```dart
const KlpGap.heightSize(KlpSpaceSize? heightSize, {Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `heightSize` | `KlpSpaceSize?` | 是 | — | 依公開型別提供此輸入。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.inline

快捷建構子：內容行內間距

```dart
const KlpGap.inline({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.loose

快捷建構子：鬆散間距

```dart
const KlpGap.loose({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.section

快捷建構子：區塊間距

```dart
const KlpGap.section({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.space

依據風格枚舉指定雙向間距。

```dart
const KlpGap.space(KlpSpaceSize? size, {Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `size` | `KlpSpaceSize?` | 是 | — | 尺寸選擇。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.stack

快捷建構子：內容堆疊間距

```dart
const KlpGap.stack({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.tight

快捷建構子：緊密間距

```dart
const KlpGap.tight({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.width

依據彈性數值指定水平寬度間距。

```dart
const KlpGap.width(double? width, {Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `width` | `double?` | 是 | — | 依公開型別提供此輸入。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 建構子 KlpGap.widthSize

依據風格枚舉指定水平寬度間距。

```dart
const KlpGap.widthSize(KlpSpaceSize? widthSize, {Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `widthSize` | `KlpSpaceSize?` | 是 | — | 依公開型別提供此輸入。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### resolveSpace

```dart
static double resolveSpace(BuildContext context, KlpSpaceSize spaceSize)
```

介面解析器：將風格枚舉映射至目前 Theme 的單一真相來源

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |
| `spaceSize` | `KlpSpaceSize` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpSpaceSize](../../types/klp-space-size.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_gap.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_gap.dart`。
