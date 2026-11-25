# KlpThemeContrast

Flutter · Stable · 語意風格

## 主要職責

依任意背景色算出可讀的前景色，用於背景色由使用者資料決定（而非固定
theme token）的場合，例如彩色標籤或頭像底色。

不要拿它取代 semantic token——theme 內部的文字／背景配對已經照顏色系統
設計好對比，這個類別只服務「背景色本身就是可變資料」這種例外情境。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
void acceptValue(KlpThemeContrast value) {
	// 產品接收此抽象契約；請使用公開子型別或靜態方法。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpThemeContrast
```

## 建構子 KlpThemeContrast



```dart
KlpThemeContrast()
```



## 成員與方法

### foregroundFor

```dart
static Color foregroundFor(Color background)
```

依據背景顏色階梯（500 以下為深色 ink900，600 以上為淺色 ink50）決定前景文字色。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `background` | `Color` | 是 | — | 依公開型別提供此輸入。 |


### isDarkBackground

```dart
static bool isDarkBackground(Color background)
```

判斷背景屬於哪一階梯：
- 500 以下（含 500，如 ink50 ~ ink500）：深色文字
- 600 以上（含 600，如 ink600 ~ ink950）：淺色文字
- 透明背景不構成獨立深色階層，回傳 false

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `background` | `Color` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_theme_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_theme_data.dart`。
