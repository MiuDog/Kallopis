# KlpDockLayout

Flutter · Stable · 工作區元件

## 主要職責

呈現受控停靠布局，將操作意圖交回產品更新布局資料。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockLayout createExample(KlpPanelFrame stage, List<KlpDockPanel> panels, KlpDockLayoutData layout, void Function(KlpDockLayoutData) onLayoutChanged, KlpDockAreaConstraints leftConstraints, KlpDockAreaConstraints rightConstraints) => KlpDockLayout(stage: stage, panels: panels, layout: layout, onLayoutChanged: onLayoutChanged, leftConstraints: leftConstraints, rightConstraints: rightConstraints);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockLayout extends StatefulWidget implements KlpPanelLayout
```

## 建構子 KlpDockLayout



```dart
const KlpDockLayout({
	Key? key,
	required KlpPanelFrame stage,
	required List<KlpDockPanel> panels,
	required KlpDockLayoutData layout,
	required ValueChanged<KlpDockLayoutData> onLayoutChanged,
	required KlpDockAreaConstraints leftConstraints,
	required KlpDockAreaConstraints rightConstraints,
	KlpDockAreaConstraints? bottomConstraints,
	PreferredSizeWidget? contentHeader,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `stage` | `KlpPanelFrame` | 是 | — | 依公開型別提供此輸入。 |
| `panels` | `List<KlpDockPanel>` | 是 | — | 依公開型別提供此輸入。 |
| `layout` | `KlpDockLayoutData` | 是 | — | 依公開型別提供此輸入。 |
| `onLayoutChanged` | `void Function(KlpDockLayoutData)` | 是 | — | 依公開型別提供此輸入。 |
| `leftConstraints` | `KlpDockAreaConstraints` | 是 | — | 依公開型別提供此輸入。 |
| `rightConstraints` | `KlpDockAreaConstraints` | 是 | — | 依公開型別提供此輸入。 |
| `bottomConstraints` | `KlpDockAreaConstraints?` | 否 | null | Bottom 可用時的高度限制；沒有任何 Bottom-capable panel 時可省略。 |
| `contentHeader` | `PreferredSizeWidget?` | 否 | null | 橫跨固定 Stage 與右側 Area 的頂列，左側 Area 保持全高。 |


## 成員與方法

### buildPanelLayout

```dart
Widget buildPanelLayout(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### createState

```dart
State<KlpDockLayout> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- [Dock 布局保存與載入](../../../../guides/flutter/09-klp-dock-layout-codec.md)：跨元件使用流程。
- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- 繼承／實作：[KlpPanelLayout](../../types/klp-panel-layout.md)。
- [KlpDockAreaConstraints](../../types/klp-dock-area-constraints.md)
- [KlpDockLayoutData](../../types/klp-dock-layout-data.md)
- [KlpDockPanel](../../types/klp-dock-panel.md)
- [KlpPanelFrame](../layout/klp-panel-frame.md)
- [KlpPanelLayout](../../types/klp-panel-layout.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout.dart`。
