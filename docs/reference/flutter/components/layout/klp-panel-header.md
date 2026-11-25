# KlpPanelHeader

Flutter · Stable · 布局元件

## 主要職責

面板標題列；內容抓取區與右側操作各自擁有尺寸槽。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPanelHeader createExample() => KlpPanelHeader();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPanelHeader extends StatelessWidget
```

## 建構子 KlpPanelHeader



```dart
const KlpPanelHeader({
	Key? key,
	String? title,
	Widget? content,
	String? label,
	Widget? leading,
	List<Widget> actions = const [],
	KlpTextRole titleRole = KlpTextRole.header,
	KlpPanelHeaderDragRegionBuilder? dragRegionBuilder,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String?` | 否 | null | 標準文字標題與自訂內容擇一；標籤保留原語意與次序。 |
| `content` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |
| `leading` | `Widget?` | 否 | null | 前置與操作內容由 caller 提供，庫只分配自己的槽。 |
| `actions` | `List<Widget>` | 否 | const [] | 依公開型別提供此輸入。 |
| `titleRole` | `KlpTextRole` | 否 | KlpTextRole.header | 依公開型別提供此輸入。 |
| `dragRegionBuilder` | `Widget Function(Widget)?` | 否 | null | 只包住標題／內容，不包含右側操作。 |


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
- [KlpPanelHeaderDragRegionBuilder](../../types/klp-panel-header-drag-region-builder.md)
- [KlpTextRole](../../types/klp-text-role.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/panel/klp_panel_header.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/panel/klp_panel_header.dart`。
