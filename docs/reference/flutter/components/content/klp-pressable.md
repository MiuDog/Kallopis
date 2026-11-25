# KlpPressable

Flutter · Stable · 內容元件

## 主要職責

可按壓表面的 hover／focus 視覺。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPressable createExample(Widget child, void Function()? onPressed) => KlpPressable(onPressed: onPressed, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPressable extends StatefulWidget
```

## 建構子 KlpPressable



```dart
const KlpPressable({
	Key? key,
	required Widget child,
	required VoidCallback? onPressed,
	VoidCallback? onLongPress,
	Color? longPressProgressColor,
	BorderRadius? borderRadius,
	ValueChanged<bool>? onHover,
	ValueChanged<bool>? onFocusChange,
	bool selected = false,
	bool hoverHighlight = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `onLongPress` | `void Function()?` | 否 | null | 長按回呼。 |
| `longPressProgressColor` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `borderRadius` | `BorderRadius?` | 否 | null | 依公開型別提供此輸入。 |
| `onHover` | `void Function(bool)?` | 否 | null | 依公開型別提供此輸入。 |
| `onFocusChange` | `void Function(bool)?` | 否 | null | 依公開型別提供此輸入。 |
| `selected` | `bool` | 否 | false | 受控選取狀態；視覺完全由目前的 Kallopis theme 決定。 |
| `hoverHighlight` | `bool` | 否 | true | 是否由 [KlpPressable] 自己畫 hover／focus 的高亮。<br><br>設為 `false` 的場合是「外層已經畫了狀態」——例如 [KlpButton] 本身就有底色，<br>再疊一層高亮只會讓它看起來髒掉。這不是關掉狀態表達，是把它交給外層。 |


## 成員與方法

### createState

```dart
State<KlpPressable> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpButton](../actions/klp-button.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/interaction/klp_pressable.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_pressable.dart`。
