# KlpSidebarFrame

Flutter · Stable · 布局元件

## 主要職責

側邊欄：由側邊欄自己決定內容與 footer 的內距，再交給無內距的 PanelFrame
提供背景、圓角與外側 dock margin。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSidebarFrame createExample(Widget content) => KlpSidebarFrame(content: content);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSidebarFrame extends StatelessWidget
```

## 建構子 KlpSidebarFrame



```dart
const KlpSidebarFrame({
	Key? key,
	required Widget content,
	Widget? footer,
	KlpSidebarInset inset = KlpSidebarInset.chromePanel,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `content` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `footer` | `Widget?` | 否 | null | 頁尾內容。 |
| `inset` | `KlpSidebarInset` | 否 | KlpSidebarInset.chromePanel | 依公開型別提供此輸入。 |


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
- [KlpSidebarInset](../../types/klp-sidebar-inset.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart`。
