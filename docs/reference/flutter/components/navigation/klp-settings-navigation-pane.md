# KlpSettingsNavigationPane

Flutter · Experimental · 導覽元件

## 主要職責

設定導覽 pane 的預設表面、內距與捲動行為。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSettingsNavigationPane createExample(List<Widget> children) => KlpSettingsNavigationPane(children: children);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSettingsNavigationPane extends StatelessWidget
```

## 建構子 KlpSettingsNavigationPane



```dart
const KlpSettingsNavigationPane({
	Key? key,
	required List<Widget> children,
	Widget? header,
	ScrollController? controller,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `children` | `List<Widget>` | 是 | — | 產品提供的子內容。 |
| `header` | `Widget?` | 否 | null | 標頭內容。 |
| `controller` | `ScrollController?` | 否 | null | 借用產品提供的控制器。 |


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
