# KlpIcon

Flutter · Stable · 內容元件

## 主要職責

提供套件圖示呈現；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpIcon createExample(KlpIconData icon) => KlpIcon(icon);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpIcon extends StatelessWidget
```

## 建構子 KlpIcon



```dart
const KlpIcon(
	KlpIconData icon, {
	Key? key,
	double? size,
	Color? color,
	String? semanticLabel,
	KlpIconWeight weight = KlpIconWeight.regular,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `icon` | `KlpIconData` | 是 | — | 操作或內容圖示。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `size` | `double?` | 否 | null | `null` 表示沿用 theme 的圖示尺寸。 |
| `color` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `semanticLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `weight` | `KlpIconWeight` | 否 | KlpIconWeight.regular | 依公開型別提供此輸入。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### fontFamily

```dart
static const String fontFamily
```

向下相容的預設字型名稱。

### regularFontFamily

```dart
static const String regularFontFamily
```

Regular Rounded 在 Flutter asset manifest 中登記的 family 名稱。

### thinFontFamily

```dart
static const String thinFontFamily
```

Thin Rounded 在 Flutter asset manifest 中登記的 family 名稱。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpIconData](../../types/klp-icon-data.md)
- [KlpIconWeight](../../types/klp-icon-weight.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/klp_icon.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/klp_icon.dart`。
