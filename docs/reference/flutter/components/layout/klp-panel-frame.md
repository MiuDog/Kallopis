# KlpPanelFrame

Flutter · Stable · 布局元件

## 主要職責

通用面板：header 與 content，選用 footer。

消費者只選擇語意背景與 header 尺寸；外距、圓角、裁切、footer 高度與
scrollbar 全由 Kallopis token 與 primitive frame 決定。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPanelFrame createExample(Widget content) => KlpPanelFrame(content: content);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPanelFrame extends StatelessWidget implements KlpPanelLayout
```

## 建構子 KlpPanelFrame



```dart
const KlpPanelFrame({
	Key? key,
	Widget? header,
	required Widget content,
	Widget? footer,
	KlpPanelHeaderSize headerSize = KlpPanelHeaderSize.standard,
	KlpPanelTone tone = KlpPanelTone.surface,
	KlpPanelElevation elevation = KlpPanelElevation.flat,
	ScrollController? contentScrollController,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `header` | `Widget?` | 否 | null | 標頭內容。 |
| `content` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `footer` | `Widget?` | 否 | null | 頁尾內容。 |
| `headerSize` | `KlpPanelHeaderSize` | 否 | KlpPanelHeaderSize.standard | 依公開型別提供此輸入。 |
| `tone` | `KlpPanelTone` | 否 | KlpPanelTone.surface | 選擇語意呈現。 |
| `elevation` | `KlpPanelElevation` | 否 | KlpPanelElevation.flat | 僅改變表面層次，不改布局與內容裁切。 |
| `contentScrollController` | `ScrollController?` | 否 | null | 內容區的捲動控制器。提供時，Frame 只負責繪製 Scrollbar；內容的<br>內距由 [content] 自己決定。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### buildPanelLayout

```dart
Widget buildPanelLayout(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- [3. 投影狀態與回傳事件](../../../../guides/flutter/04-klp-panel-frame.md)：跨元件使用流程。
- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- 繼承／實作：[KlpPanelLayout](../../types/klp-panel-layout.md)。
- [KlpPanelElevation](../../types/klp-panel-elevation.md)
- [KlpPanelHeaderSize](../../types/klp-panel-header-size.md)
- [KlpPanelTone](../../types/klp-panel-tone.md)
- [KlpPanelLayout](../../types/klp-panel-layout.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/panel/klp_panel_frame.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/panel/klp_panel_frame.dart`。
