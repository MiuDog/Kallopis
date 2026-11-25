# KlpCodeViewerLabels

Flutter · Stable · 資料與型別

## 主要職責

Code Viewer 的介面文字。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCodeViewerLabels createExample(String copy, String menu, String toggleView, String languageMenu, String wrap, String lineNumbers) => KlpCodeViewerLabels(copy: copy, menu: menu, toggleView: toggleView, languageMenu: languageMenu, wrap: wrap, lineNumbers: lineNumbers);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCodeViewerLabels
```

## 建構子 KlpCodeViewerLabels



```dart
const KlpCodeViewerLabels({
	required String copy,
	required String menu,
	required String toggleView,
	required String languageMenu,
	required String wrap,
	required String lineNumbers,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `copy` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `menu` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `toggleView` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `languageMenu` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `wrap` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `lineNumbers` | `String` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### english

```dart
static const KlpCodeViewerLabels english
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/code/models/klp_code_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/code/models/klp_code_models.dart`。
