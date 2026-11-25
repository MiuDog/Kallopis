# KlpDockPanel

Flutter · Stable · 資料與型別

## 主要職責

可停駐布局中的產品中立面板描述；內容與可放置方向由呼叫端提供。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockPanel createExample(String id, Widget content) => KlpDockPanel(id: id, content: content);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockPanel
```

## 建構子 KlpDockPanel



```dart
const KlpDockPanel({
	required String id,
	Widget? header,
	required Widget content,
	ScrollController? contentScrollController,
	bool isDraggable = true,
	bool allowBottom = true,
	bool allowSide = true,
	List<KlpDockHeaderAction> actions = const [],
	bool isPinned = false,
	bool isDirty = false,
	FutureOr<bool> Function()? onCloseRequested,
	String? closeLabel,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `header` | `Widget?` | 否 | null | 標頭內容。 |
| `content` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `contentScrollController` | `ScrollController?` | 否 | null | 依公開型別提供此輸入。 |
| `isDraggable` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `allowBottom` | `bool` | 否 | true | 是否允許放入 Stage 下方的 Bottom Area。 |
| `allowSide` | `bool` | 否 | true | 是否允許放入 Stage 左右兩側的 Area。 |
| `actions` | `List<KlpDockHeaderAction>` | 否 | const [] | Active panel 顯示於 Dock Header 右側的產品動作。 |
| `isPinned` | `bool` | 否 | false | 產品投影的釘選與修改狀態，不改布局順序或保存格式。 |
| `isDirty` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `onCloseRequested` | `FutureOr<bool> Function()?` | 否 | null | 產品批准後才從布局移出；正文與 registry 始終由產品保留。 |
| `closeLabel` | `String?` | 否 | null | 可選的產品關閉文案，省略時使用本庫既有在地化。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpDockHeaderAction](klp-dock-header-action.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_panel.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_panel.dart`。
