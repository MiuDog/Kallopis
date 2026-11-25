# KlpVisualStyleJson

Flutter · Stable · 語意風格

## 主要職責

[KlpVisualStyle] 唯一的 JSON 編解碼邊界。

JSON 的 curve 契約只支援四點 cubic；公開 model 仍可使用任意 `Curve`，但非
`Cubic` 無法無損序列化，encode 會以完整欄位路徑拋出 [FormatException]。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpVisualStyleJson.schemaVersion;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpVisualStyleJson
```

## 建構子 KlpVisualStyleJson



```dart
KlpVisualStyleJson()
```



## 成員與方法

### decode

```dart
static KlpVisualStyle decode(Map<String, Object?> json, {KlpVisualStyle base = KlpVisualStyle.defaultStyle})
```

將局部 JSON 疊加到 [base]；缺少的欄位完整沿用 base。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `json` | `Map<String, Object?>` | 是 | — | 依公開型別提供此輸入。 |
| `base` | `KlpVisualStyle` | 否 | KlpVisualStyle.defaultStyle | 依公開型別提供此輸入。 |


### encode

```dart
static Map<String, Object?> encode(KlpVisualStyle style)
```

輸出完整且順序穩定的 JSON object。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `style` | `KlpVisualStyle` | 是 | — | 依公開型別提供此輸入。 |


### schemaVersion

```dart
static const int schemaVersion
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpVisualStyle](klp-visual-style.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_visual_style_json.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_visual_style_json.dart`。
