# KlpPanelLayout

Flutter · Stable · 資料與型別

## 主要職責

App background 後唯一合法的 Kallopis Panel Tree 節點。

產品不得以任意 Flutter widget 擔任 app 主內容根節點；必須使用
[KlpPanelFrame] 或 Kallopis 提供的具名 Panel 排版元件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
void acceptValue(KlpPanelLayout value) {
	// 產品接收此抽象契約；請使用公開子型別或靜態方法。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract interface class KlpPanelLayout implements Widget
```

## 建構子 KlpPanelLayout



```dart
KlpPanelLayout()
```



## 成員與方法

### buildPanelLayout

```dart
Widget buildPanelLayout(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- 框架繼承成員：[Widget](https://api.flutter.dev/flutter/widgets/Widget-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/layout/klp_panel_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_panel_layout.dart`。
