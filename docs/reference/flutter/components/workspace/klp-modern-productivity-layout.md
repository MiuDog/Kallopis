# KlpModernProductivityLayout

Flutter · Stable · 工作區元件

## 主要職責

單一全高左側欄與右側 Header／Stage 的公開可重用模板。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpModernProductivityLayout createExample(List<KlpModernProductivityPanel> panels, String selectedId, Widget header, Widget stage) => KlpModernProductivityLayout(panels: panels, selectedId: selectedId, header: header, stage: stage);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpModernProductivityLayout extends StatelessWidget
```

## 建構子 KlpModernProductivityLayout



```dart
KlpModernProductivityLayout({
	Key? key,
	required List<KlpModernProductivityPanel> panels,
	required String selectedId,
	required Widget header,
	required Widget stage,
	ValueChanged<String>? onSelected,
	double? sidebarWidth,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `panels` | `List<KlpModernProductivityPanel>` | 是 | — | 產品提供的非空有序功能清單。 |
| `selectedId` | `String` | 是 | — | 產品目前選取的功能識別。 |
| `header` | `Widget` | 是 | — | 右區頂部的內容，不跨越側欄。 |
| `stage` | `Widget` | 是 | — | 右區 Header 下方的主工作內容。 |
| `onSelected` | `void Function(String)?` | 否 | null | 提出切換事件；缺省時切換按鈕停用。 |
| `sidebarWidth` | `double?` | 否 | null | 期望側欄寬度；缺省沿用正式語意。 |


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
- [KlpModernProductivityPanel](../../types/klp-modern-productivity-panel.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/layout/klp_modern_productivity_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_modern_productivity_layout.dart`。
