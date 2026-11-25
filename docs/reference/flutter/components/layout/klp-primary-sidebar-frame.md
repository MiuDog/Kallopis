# KlpPrimarySidebarFrame

Flutter · Stable · 布局元件

## 主要職責

桌面工作區的 Primary Sidebar 外框。

Identity、導覽與 Explorer 緊密排列；上下節奏由各區域自行決定。
content 與 footer 沿用 [KlpSidebarFrame] 的水平 padding 規則；footer 不再
額外包覆垂直 padding。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPrimarySidebarFrame createExample(Widget explorer) => KlpPrimarySidebarFrame(explorer: explorer);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPrimarySidebarFrame extends StatelessWidget
```

## 建構子 KlpPrimarySidebarFrame



```dart
const KlpPrimarySidebarFrame({
	Key? key,
	Widget? header,
	Widget? navigation,
	required Widget explorer,
	Widget? footer,
	KlpStatusItemData? status,
	KlpSidebarInset contentInset = KlpSidebarInset.chromePanel,
	KlpPrimarySidebarHeaderInset headerInset = KlpPrimarySidebarHeaderInset.navigation,
	KlpSpaceSize? headerNavigationGap,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `header` | `Widget?` | 否 | null | 標頭內容。 |
| `navigation` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `explorer` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `footer` | `Widget?` | 否 | null | 頁尾內容。 |
| `status` | `KlpStatusItemData?` | 否 | null | 側欄底部狀態；提供時由框架使用共通狀態元件渲染。 |
| `contentInset` | `KlpSidebarInset` | 否 | KlpSidebarInset.chromePanel | 依公開型別提供此輸入。 |
| `headerInset` | `KlpPrimarySidebarHeaderInset` | 否 | KlpPrimarySidebarHeaderInset.navigation | 依公開型別提供此輸入。 |
| `headerNavigationGap` | `KlpSpaceSize?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpPrimarySidebarHeaderInset](../../types/klp-primary-sidebar-header-inset.md)
- [KlpSidebarInset](../../types/klp-sidebar-inset.md)
- [KlpStatusItemData](../../types/klp-status-item-data.md)
- [KlpSpaceSize](../../types/klp-space-size.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/sidebar/klp_primary_sidebar_frame.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/sidebar/klp_primary_sidebar_frame.dart`。
