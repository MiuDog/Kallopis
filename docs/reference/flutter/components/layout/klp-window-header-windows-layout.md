# KlpWindowHeaderWindowsLayout

Flutter · Stable · 布局元件

## 主要職責

Windows 平台的視窗標題列排版元件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWindowHeaderWindowsLayout createExample(Widget identity, Widget controls, double controlExtent) => KlpWindowHeaderWindowsLayout(identity: identity, controls: controls, controlExtent: controlExtent);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpWindowHeaderWindowsLayout extends StatelessWidget
```

## 建構子 KlpWindowHeaderWindowsLayout



```dart
const KlpWindowHeaderWindowsLayout({
	Key? key,
	required Widget identity,
	required Widget controls,
	required double controlExtent,
	Widget? leading,
	Widget? appIconButton,
	Widget? trailing,
	Widget? titleTrailing,
	List<Widget>? actions,
	VoidCallback? onToggleMaximize,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `identity` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `controls` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `controlExtent` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `leading` | `Widget?` | 否 | null | 前方內容。 |
| `appIconButton` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |
| `titleTrailing` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `actions` | `List<Widget>?` | 否 | null | 依公開型別提供此輸入。 |
| `onToggleMaximize` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |


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

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/window/klp_window_header_windows_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_header_windows_layout.dart`。
