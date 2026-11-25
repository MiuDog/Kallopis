# KlpSettingsPage

Flutter · Experimental · 內容元件

## 主要職責

設定頁的自適應雙 pane 版面。

只安排 navigation 與 content；route、Popup 與設定狀態由產品層負責。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSettingsPage createExample(Widget navigation, Widget content) => KlpSettingsPage(navigation: navigation, content: content);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSettingsPage extends StatelessWidget
```

## 建構子 KlpSettingsPage



```dart
const KlpSettingsPage({
	Key? key,
	required Widget navigation,
	required Widget content,
	double? navigationWidth,
	double? twoColumnBreakpoint,
	ValueChanged<double>? onNavigationWidthChanged,
	String? navigationResizeLabel,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `navigation` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `content` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `navigationWidth` | `double?` | 否 | null | `null` 時使用 theme 的 settings navigation 寬度。 |
| `twoColumnBreakpoint` | `double?` | 否 | null | `null` 時使用 theme 的 primary pane content breakpoint。 |
| `onNavigationWidthChanged` | `void Function(double)?` | 否 | null | 非 `null` 時寬版導覽欄可拖曳調整；寬度狀態由消費者持有。 |
| `navigationResizeLabel` | `String?` | 否 | null | 導覽欄拖曳把手的無障礙標籤。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/workspace/settings/klp_settings_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/settings/klp_settings_layout.dart`。
