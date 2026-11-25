# KlpWindowHeaderStrategy

Flutter · Stable · 資料與型別

## 主要職責

將 Window Header 共用輸入轉為各平台 layout 的建構策略。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWindowHeaderStrategy createExample(Widget? title, double controlExtent, double appIconExtent, Key appIconSlotKey, void Function() onMinimize, void Function() onToggleMaximize, void Function() onClose) => KlpWindowHeaderStrategy(title: title, controlExtent: controlExtent, appIconExtent: appIconExtent, appIconSlotKey: appIconSlotKey, onMinimize: onMinimize, onToggleMaximize: onToggleMaximize, onClose: onClose);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpWindowHeaderStrategy
```

## 建構子 KlpWindowHeaderStrategy



```dart
const KlpWindowHeaderStrategy({
	required Widget? title,
	required double controlExtent,
	required double appIconExtent,
	required Key appIconSlotKey,
	required VoidCallback onMinimize,
	required VoidCallback onToggleMaximize,
	required VoidCallback onClose,
	Widget? appIcon,
	Widget? appIconButton,
	List<Widget>? actions,
	Widget? leading,
	Widget? trailing,
	Widget? titleTrailing,
	bool isMaximized = false,
	bool showWindowControls = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` | 是 | — | 依公開型別提供此輸入。 |
| `controlExtent` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `appIconExtent` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `appIconSlotKey` | `Key` | 是 | — | 依公開型別提供此輸入。 |
| `onMinimize` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |
| `onToggleMaximize` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |
| `onClose` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |
| `appIcon` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `appIconButton` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `actions` | `List<Widget>?` | 否 | null | 依公開型別提供此輸入。 |
| `leading` | `Widget?` | 否 | null | 前方內容。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |
| `titleTrailing` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `isMaximized` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `showWindowControls` | `bool` | 否 | true | 依公開型別提供此輸入。 |


## 成員與方法

### buildControls

```dart
Widget buildControls(KlpWindowControlsStyle style)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `style` | `KlpWindowControlsStyle` | 是 | — | 依公開型別提供此輸入。 |


### buildIdentity

```dart
Widget buildIdentity(BuildContext context, bool appIconUsesIndependentSlot)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |
| `appIconUsesIndependentSlot` | `bool` | 是 | — | 依公開型別提供此輸入。 |


### buildMacOS

```dart
Widget buildMacOS(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### buildWindows

```dart
Widget buildWindows(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpWindowControlsStyle](klp-window-controls-style.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/window/klp_window_header_strategy.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_header_strategy.dart`。
