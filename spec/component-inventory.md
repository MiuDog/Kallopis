# 元件清單與組合關係

> 本檔由 `dart run tool/inventory.dart` 從實際程式碼產生，不是手寫的。
> 元件樹是**真的**組合關係——解析每個型別實作區段內出現的其他 `Klp*` 建構
> 呼叫，因此它不會與程式碼分岔；手寫的架構圖會，而且分岔時沒有任何徵兆。

## 總覽

- 公開型別 **282** 個，其中 widget **160** 個
- 分為 **18** 個領域

### 領域之間的依賴方向

箭頭是「用到」，數字是引用次數。這張圖唯一該有的形狀是**單向**——
`controls` 可以用 `surface`，`surface` 不可以用 `controls`。
出現回頭的箭頭就代表分層破了。

```mermaid
graph TD
  tokens["tokens — primitive 層"]
  theme["theme — semantic 與 component token"]
  foundation["foundation — 圖示、色盤、度量"]
  typography["typography — 文字"]
  surface["surface — 表面與描邊"]
  interaction["interaction — 互動"]
  layout["layout — 版面原語"]
  overlay["overlay — 浮層"]
  controls["controls — 控制項"]
  data["data — 資料呈現"]
  form["form — 表單"]
  feedback["feedback — 狀態與回饋"]
  navigation["navigation — 導覽元件"]
  editor["editor — 編輯器周邊"]
  routing["routing — 分發"]
  shell["shell — 應用外殼"]
  settings["settings — 設定呈現"]
  app["app — 接入層"]
  form -->|21| typography
  data -->|20| typography
  controls -->|10| typography
  data -->|10| foundation
  form -->|9| controls
  navigation -->|9| typography
  controls -->|7| foundation
  editor -->|7| typography
  feedback -->|7| typography
  interaction -->|7| surface
  feedback -->|6| foundation
  data -->|5| surface
  form -->|5| surface
  navigation -->|5| foundation
  overlay -->|5| surface
  settings -->|5| surface
  shell -->|5| typography
  data -->|4| interaction
  editor -->|4| controls
  editor -->|4| data
  interaction -->|4| typography
  settings -->|4| typography
  controls -->|3| overlay
  data -->|3| overlay
  feedback -->|3| surface
  form -->|3| data
  navigation -->|3| interaction
  overlay -->|3| typography
  shell -->|3| theme
  app -->|2| routing
  controls -->|2| interaction
  editor -->|2| surface
  feedback -->|2| controls
  layout -->|2| surface
  overlay -->|2| controls
  shell -->|2| foundation
  app -->|1| l10n
  app -->|1| shell
  controls -->|1| surface
  data -->|1| controls
  feedback -->|1| interaction
  form -->|1| interaction
  interaction -->|1| controls
  interaction -->|1| foundation
  navigation -->|1| controls
  navigation -->|1| overlay
  navigation -->|1| surface
  overlay -->|1| foundation
  settings -->|1| data
  settings -->|1| shell
  shell -->|1| interaction
  shell -->|1| overlay
  shell -->|1| surface
  surface -->|1| theme
  surface -->|1| typography
  typography -->|1| foundation
```

### 分層違規

以下型別用到了比自己更上層的領域。**這些不是待辦事項清單，是設計債**
——一個底層元件依賴上層，代表它被歸錯領域，或它其實不屬於這個庫。

- `interaction/KlpSelectionToolbar → controls/KlpButton`
- `overlay/KlpDialog → controls/KlpButton`
- `overlay/KlpMenuItem → controls/KlpToggleIndicator`

## 各領域的元件樹

### tokens — primitive 層

型別 1 個，widget 0 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpScale` | 107 | （葉節點） |

### theme — semantic 與 component token

型別 22 個，widget 1 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpComponentTheme` | 174 | （葉節點） |
| `KlpControlGeometry` | 88 | （葉節點） |
| `KlpDataGeometry` | 99 | （葉節點） |
| `KlpDataVisualizationTheme` | 190 | （葉節點） |
| `KlpFieldFillState` | 3 | （葉節點） |
| `KlpFieldStyle` | 269 | （葉節點） |
| `KlpGeometryTheme` | 118 | `KlpControlGeometry`、`KlpDataGeometry`、`KlpLayoutGeometry`、`KlpOpticalGeometry` |
| `KlpLayoutGeometry` | 107 | （葉節點） |
| `KlpMotionTheme` | 139 | （葉節點） |
| `KlpOpticalGeometry` | 34 | （葉節點） |
| `KlpShapeTheme` | 150 | （葉節點） |
| `KlpSpacingTheme` | 510 | （葉節點） |
| `KlpSurfaceSeparation` | 19 | （葉節點） |
| `KlpSurfaceTheme` | 282 | （葉節點） |
| `KlpTheme` | 131 | `KlpVisualStyle` |
| `KlpThemeContrast` | 26 | （葉節點） |
| `KlpThemeData` | 377 | （葉節點） |
| `KlpThemeVariant` | 8 | （葉節點） |
| `KlpTokenOverride` | 41 | （葉節點） |
| `KlpTypographyTheme` | 378 | （葉節點） |
| `KlpVisualStyle` | 118 | （葉節點） |
| `KlpVisualStyleJson` | 84 | `KlpVisualStyle` |

```mermaid
graph LR
  KlpControlGeometry["KlpControlGeometry"]
  KlpDataGeometry["KlpDataGeometry"]
  KlpGeometryTheme["KlpGeometryTheme"]
  KlpLayoutGeometry["KlpLayoutGeometry"]
  KlpOpticalGeometry["KlpOpticalGeometry"]
  KlpTheme["KlpTheme"]
  KlpVisualStyle["KlpVisualStyle"]
  KlpVisualStyleJson["KlpVisualStyleJson"]
  KlpGeometryTheme --> KlpControlGeometry
  KlpGeometryTheme --> KlpDataGeometry
  KlpGeometryTheme --> KlpLayoutGeometry
  KlpGeometryTheme --> KlpOpticalGeometry
  KlpTheme --> KlpVisualStyle
  KlpVisualStyleJson --> KlpVisualStyle
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### foundation — 圖示、色盤、度量

型別 21 個，widget 4 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpAccent` | 26 | （葉節點） |
| `KlpCodeMetrics` | 21 | （葉節點） |
| `KlpControlMetrics` | 14 | （葉節點） |
| `KlpDecorativePalette` | 18 | （葉節點） |
| `KlpElevation` | 14 | （葉節點） |
| `KlpFormMetrics` | 18 | （葉節點） |
| `KlpGeometricSpinner` | 164 | （葉節點） |
| `KlpIcon` | 34 | （葉節點） |
| `KlpIcons` | 82 | （葉節點） |
| `KlpInlineCode` | 54 | （葉節點） |
| `KlpLayoutGap` | 8 | （葉節點） |
| `KlpLine` | 13 | （葉節點） |
| `KlpMotion` | 9 | （葉節點） |
| `KlpPalette` | 205 | （葉節點） |
| `KlpPlaceholderMetrics` | 23 | （葉節點） |
| `KlpRadius` | 18 | （葉節點） |
| `KlpSegmentedProgress` | 34 | （葉節點） |
| `KlpSize` | 35 | （葉節點） |
| `KlpSpace` | 16 | （葉節點） |
| `KlpTransparency` | 4 | （葉節點） |
| `KlpTypography` | 71 | （葉節點） |

### typography — 文字

型別 11 個，widget 2 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpFontRole` | 11 | （葉節點） |
| `KlpRichText` | 135 | `KlpInlineCode`、`KlpText` |
| `KlpRichTextKind` | 19 | （葉節點） |
| `KlpRichTextNode` | 26 | （葉節點） |
| `KlpRichTextSpan` | 10 | （葉節點） |
| `KlpText` | 128 | （葉節點） |
| `KlpTextColorTier` | 4 | （葉節點） |
| `KlpTextRole` | 24 | （葉節點） |
| `KlpTextStyleDefinition` | 41 | （葉節點） |
| `KlpTextStyles` | 177 | `KlpTextStyleDefinition` |
| `KlpTextTone` | 7 | （葉節點） |

```mermaid
graph LR
  KlpInlineCode["KlpInlineCode"]:::external
  KlpRichText["KlpRichText"]
  KlpText["KlpText"]
  KlpTextStyleDefinition["KlpTextStyleDefinition"]
  KlpTextStyles["KlpTextStyles"]
  KlpRichText --> KlpInlineCode
  KlpRichText --> KlpText
  KlpTextStyles --> KlpTextStyleDefinition
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### surface — 表面與描邊

型別 9 個，widget 6 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpDashedBorder` | 51 | `KlpStrokeFrame` |
| `KlpDashedDivider` | 111 | （葉節點） |
| `KlpDivider` | 14 | （葉節點） |
| `KlpSection` | 46 | `KlpText` |
| `KlpStrokeFrame` | 139 | （葉節點） |
| `KlpStrokeRole` | 2 | （葉節點） |
| `KlpStrokeState` | 2 | （葉節點） |
| `KlpSurface` | 106 | `KlpTokenOverride` |
| `KlpSurfaceTone` | 16 | （葉節點） |

```mermaid
graph LR
  KlpDashedBorder["KlpDashedBorder"]
  KlpSection["KlpSection"]
  KlpStrokeFrame["KlpStrokeFrame"]
  KlpSurface["KlpSurface"]
  KlpText["KlpText"]:::external
  KlpTokenOverride["KlpTokenOverride"]:::external
  KlpDashedBorder --> KlpStrokeFrame
  KlpSection --> KlpText
  KlpSurface --> KlpTokenOverride
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### interaction — 互動

型別 14 個，widget 9 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpDragPreview` | 18 | `KlpSurface` |
| `KlpDropIndicator` | 17 | （葉節點） |
| `KlpDropTarget` | 19 | `KlpStrokeFrame`、`KlpSurface` |
| `KlpFilterBar` | 169 | `KlpDashedBorder`、`KlpIcon`、`KlpPressable`、`KlpText` |
| `KlpFilterOption` | 15 | （葉節點） |
| `KlpHighlightState` | 19 | （葉節點） |
| `KlpInteractionSettings` | 27 | （葉節點） |
| `KlpPresenceIndicator` | 33 | `KlpText` |
| `KlpPressable` | 191 | （葉節點） |
| `KlpRovingIndex` | 41 | （葉節點） |
| `KlpSelectionAction` | 15 | （葉節點） |
| `KlpSelectionToolbar` | 75 | `KlpButton`、`KlpDashedBorder`、`KlpPressable`、`KlpSurface`、`KlpText` |
| `KlpShortcutHint` | 20 | `KlpSurface`、`KlpText` |
| `KlpStateHighlight` | 43 | （葉節點） |

```mermaid
graph LR
  KlpButton["KlpButton"]:::external
  KlpDashedBorder["KlpDashedBorder"]:::external
  KlpDragPreview["KlpDragPreview"]
  KlpDropTarget["KlpDropTarget"]
  KlpFilterBar["KlpFilterBar"]
  KlpIcon["KlpIcon"]:::external
  KlpPresenceIndicator["KlpPresenceIndicator"]
  KlpPressable["KlpPressable"]
  KlpSelectionToolbar["KlpSelectionToolbar"]
  KlpShortcutHint["KlpShortcutHint"]
  KlpStrokeFrame["KlpStrokeFrame"]:::external
  KlpSurface["KlpSurface"]:::external
  KlpText["KlpText"]:::external
  KlpDragPreview --> KlpSurface
  KlpDropTarget --> KlpStrokeFrame
  KlpDropTarget --> KlpSurface
  KlpFilterBar --> KlpDashedBorder
  KlpFilterBar --> KlpIcon
  KlpFilterBar --> KlpPressable
  KlpFilterBar --> KlpText
  KlpPresenceIndicator --> KlpText
  KlpSelectionToolbar --> KlpButton
  KlpSelectionToolbar --> KlpDashedBorder
  KlpSelectionToolbar --> KlpPressable
  KlpSelectionToolbar --> KlpSurface
  KlpSelectionToolbar --> KlpText
  KlpShortcutHint --> KlpSurface
  KlpShortcutHint --> KlpText
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### layout — 版面原語

型別 8 個，widget 8 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpOverlayHost` | 16 | （葉節點） |
| `KlpRegion` | 40 | `KlpSurface` |
| `KlpResizablePane` | 13 | （葉節點） |
| `KlpResizeHandle` | 23 | （葉節點） |
| `KlpScrollViewport` | 23 | （葉節點） |
| `KlpSplitLayout` | 62 | `KlpDashedDivider` |
| `KlpVirtualGrid` | 45 | （葉節點） |
| `KlpVirtualList` | 26 | （葉節點） |

```mermaid
graph LR
  KlpDashedDivider["KlpDashedDivider"]:::external
  KlpRegion["KlpRegion"]
  KlpSplitLayout["KlpSplitLayout"]
  KlpSurface["KlpSurface"]:::external
  KlpRegion --> KlpSurface
  KlpSplitLayout --> KlpDashedDivider
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### overlay — 浮層

型別 13 個，widget 8 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpContextMenu` | 145 | `KlpMenu`、`KlpMenuItemData` |
| `KlpContextMenuController` | 31 | （葉節點） |
| `KlpDialog` | 76 | `KlpButton`、`KlpSurface`、`KlpText` |
| `KlpDrawer` | 94 | `KlpSurface` |
| `KlpDrawerEdge` | 9 | （葉節點） |
| `KlpMenu` | 171 | `KlpDivider`、`KlpMenuItem`、`KlpSurface`、`KlpText` |
| `KlpMenuItem` | 120 | `KlpIcon`、`KlpText`、`KlpToggleIndicator` |
| `KlpMenuItemData` | 36 | （葉節點） |
| `KlpMenuLayout` | 98 | （葉節點） |
| `KlpMenuStyle` | 31 | （葉節點） |
| `KlpPopover` | 15 | `KlpSurface` |
| `KlpTooltip` | 12 | （葉節點） |
| `KlpTooltipSurface` | 42 | （葉節點） |

```mermaid
graph LR
  KlpButton["KlpButton"]:::external
  KlpContextMenu["KlpContextMenu"]
  KlpDialog["KlpDialog"]
  KlpDivider["KlpDivider"]:::external
  KlpDrawer["KlpDrawer"]
  KlpIcon["KlpIcon"]:::external
  KlpMenu["KlpMenu"]
  KlpMenuItem["KlpMenuItem"]
  KlpMenuItemData["KlpMenuItemData"]
  KlpPopover["KlpPopover"]
  KlpSurface["KlpSurface"]:::external
  KlpText["KlpText"]:::external
  KlpToggleIndicator["KlpToggleIndicator"]:::external
  KlpContextMenu --> KlpMenu
  KlpContextMenu --> KlpMenuItemData
  KlpDialog --> KlpButton
  KlpDialog --> KlpSurface
  KlpDialog --> KlpText
  KlpDrawer --> KlpSurface
  KlpMenuItem --> KlpIcon
  KlpMenuItem --> KlpText
  KlpMenuItem --> KlpToggleIndicator
  KlpMenu --> KlpDivider
  KlpMenu --> KlpMenuItem
  KlpMenu --> KlpSurface
  KlpMenu --> KlpText
  KlpPopover --> KlpSurface
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### controls — 控制項

型別 21 個，widget 15 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpButton` | 138 | `KlpPressable`、`KlpText` |
| `KlpButtonTone` | 5 | （葉節點） |
| `KlpCheckbox` | 74 | `KlpIcon`、`KlpText` |
| `KlpCombobox` | 208 | `KlpMenu`、`KlpMenuItemData`、`KlpTextField` |
| `KlpComboboxOption` | 23 | （葉節點） |
| `KlpCompactSwitch` | 58 | `KlpPressable` |
| `KlpControlSize` | 1 | （葉節點） |
| `KlpIconButton` | 72 | `KlpIcon`、`KlpTooltip` |
| `KlpPhaseOption` | 19 | （葉節點） |
| `KlpPhaseToggle` | 161 | `KlpIcon`、`KlpText` |
| `KlpRadioGroup` | 133 | `KlpText` |
| `KlpSegmentedControl` | 152 | `KlpIcon`、`KlpText` |
| `KlpSelect` | 84 | `KlpIcon`、`KlpStrokeFrame`、`KlpText` |
| `KlpSelectionOption` | 7 | （葉節點） |
| `KlpSlider` | 78 | `KlpText` |
| `KlpSlidingSelection` | 111 | `KlpIcon` |
| `KlpTextField` | 277 | `KlpIcon`、`KlpText` |
| `KlpToggle` | 51 | `KlpText`、`KlpToggleIndicator` |
| `KlpToggleIndicator` | 53 | （葉節點） |
| `KlpTriState` | 2 | （葉節點） |
| `KlpTriStateToggle` | 41 | `KlpSelectionOption`、`KlpSlidingSelection`、`KlpText` |

```mermaid
graph LR
  KlpButton["KlpButton"]
  KlpCheckbox["KlpCheckbox"]
  KlpCombobox["KlpCombobox"]
  KlpCompactSwitch["KlpCompactSwitch"]
  KlpIcon["KlpIcon"]:::external
  KlpIconButton["KlpIconButton"]
  KlpMenu["KlpMenu"]:::external
  KlpMenuItemData["KlpMenuItemData"]:::external
  KlpPhaseToggle["KlpPhaseToggle"]
  KlpPressable["KlpPressable"]:::external
  KlpRadioGroup["KlpRadioGroup"]
  KlpSegmentedControl["KlpSegmentedControl"]
  KlpSelect["KlpSelect"]
  KlpSelectionOption["KlpSelectionOption"]
  KlpSlider["KlpSlider"]
  KlpSlidingSelection["KlpSlidingSelection"]
  KlpStrokeFrame["KlpStrokeFrame"]:::external
  KlpText["KlpText"]:::external
  KlpTextField["KlpTextField"]
  KlpToggle["KlpToggle"]
  KlpToggleIndicator["KlpToggleIndicator"]
  KlpTooltip["KlpTooltip"]:::external
  KlpTriStateToggle["KlpTriStateToggle"]
  KlpButton --> KlpPressable
  KlpButton --> KlpText
  KlpCheckbox --> KlpIcon
  KlpCheckbox --> KlpText
  KlpCombobox --> KlpMenu
  KlpCombobox --> KlpMenuItemData
  KlpCombobox --> KlpTextField
  KlpCompactSwitch --> KlpPressable
  KlpIconButton --> KlpIcon
  KlpIconButton --> KlpTooltip
  KlpPhaseToggle --> KlpIcon
  KlpPhaseToggle --> KlpText
  KlpRadioGroup --> KlpText
  KlpSegmentedControl --> KlpIcon
  KlpSegmentedControl --> KlpText
  KlpSelect --> KlpIcon
  KlpSelect --> KlpStrokeFrame
  KlpSelect --> KlpText
  KlpSlider --> KlpText
  KlpSlidingSelection --> KlpIcon
  KlpTextField --> KlpIcon
  KlpTextField --> KlpText
  KlpToggle --> KlpText
  KlpToggle --> KlpToggleIndicator
  KlpTriStateToggle --> KlpSelectionOption
  KlpTriStateToggle --> KlpSlidingSelection
  KlpTriStateToggle --> KlpText
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### data — 資料呈現

型別 43 個，widget 22 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpAccordion` | 165 | `KlpIcon`、`KlpText` |
| `KlpAccordionItemData` | 20 | （葉節點） |
| `KlpAvatar` | 41 | `KlpText` |
| `KlpAvatarData` | 8 | （葉節點） |
| `KlpAvatarGroup` | 35 | `KlpAvatar` |
| `KlpBadge` | 92 | `KlpText` |
| `KlpBadgeVariant` | 12 | （葉節點） |
| `KlpCard` | 75 | `KlpText` |
| `KlpCodeLanguageOption` | 12 | （葉節點） |
| `KlpCodeLanguages` | 31 | `KlpCodeLanguageOption` |
| `KlpCodeViewer` | 552 | `KlpIcon`、`KlpMenu`、`KlpMenuItemData`、`KlpPressable`、`KlpText`、`KlpTooltip` |
| `KlpCodeViewerLabels` | 27 | （葉節點） |
| `KlpDataAlignment` | 3 | （葉節點） |
| `KlpDataColumn` | 20 | （葉節點） |
| `KlpDataRow` | 12 | （葉節點） |
| `KlpDataSort` | 12 | （葉節點） |
| `KlpDataTable` | 209 | `KlpCheckbox`、`KlpDashedDivider`、`KlpIcon`、`KlpSurface`、`KlpText` |
| `KlpDiffLine` | 32 | （葉節點） |
| `KlpDiffLineType` | 13 | （葉節點） |
| `KlpDiffViewer` | 210 | `KlpPressable`、`KlpText` |
| `KlpFilePreview` | 176 | `KlpDashedDivider`、`KlpGeometricSpinner`、`KlpText` |
| `KlpFilePreviewState` | 8 | （葉節點） |
| `KlpJsonTree` | 186 | `KlpIcon`、`KlpSurface`、`KlpText` |
| `KlpKeyValueItem` | 16 | （葉節點） |
| `KlpKeyValueList` | 74 | `KlpIcon`、`KlpText` |
| `KlpKeyValueRowData` | 7 | （葉節點） |
| `KlpKeyValueTable` | 62 | `KlpSurface`、`KlpText` |
| `KlpListTile` | 141 | `KlpIcon`、`KlpText` |
| `KlpMetricCard` | 102 | `KlpText` |
| `KlpProgress` | 82 | `KlpText` |
| `KlpProgressState` | 2 | （葉節點） |
| `KlpSortControl` | 32 | `KlpIcon`、`KlpText` |
| `KlpSortDirection` | 8 | （葉節點） |
| `KlpStepData` | 11 | （葉節點） |
| `KlpStepStatus` | 4 | （葉節點） |
| `KlpStepper` | 251 | `KlpIcon`、`KlpText` |
| `KlpTag` | 61 | `KlpText` |
| `KlpTerminal` | 119 | `KlpPressable`、`KlpText` |
| `KlpTimeline` | 123 | `KlpText` |
| `KlpTimelineItemData` | 20 | （葉節點） |
| `KlpTree` | 45 | （葉節點） |
| `KlpTreeItem` | 174 | `KlpIcon`、`KlpStateHighlight`、`KlpText` |
| `KlpTreeNode` | 31 | （葉節點） |

```mermaid
graph LR
  KlpAccordion["KlpAccordion"]
  KlpAvatar["KlpAvatar"]
  KlpAvatarGroup["KlpAvatarGroup"]
  KlpBadge["KlpBadge"]
  KlpCard["KlpCard"]
  KlpCheckbox["KlpCheckbox"]:::external
  KlpCodeLanguageOption["KlpCodeLanguageOption"]
  KlpCodeLanguages["KlpCodeLanguages"]
  KlpCodeViewer["KlpCodeViewer"]
  KlpDashedDivider["KlpDashedDivider"]:::external
  KlpDataTable["KlpDataTable"]
  KlpDiffViewer["KlpDiffViewer"]
  KlpFilePreview["KlpFilePreview"]
  KlpGeometricSpinner["KlpGeometricSpinner"]:::external
  KlpIcon["KlpIcon"]:::external
  KlpJsonTree["KlpJsonTree"]
  KlpKeyValueList["KlpKeyValueList"]
  KlpKeyValueTable["KlpKeyValueTable"]
  KlpListTile["KlpListTile"]
  KlpMenu["KlpMenu"]:::external
  KlpMenuItemData["KlpMenuItemData"]:::external
  KlpMetricCard["KlpMetricCard"]
  KlpPressable["KlpPressable"]:::external
  KlpProgress["KlpProgress"]
  KlpSortControl["KlpSortControl"]
  KlpStateHighlight["KlpStateHighlight"]:::external
  KlpStepper["KlpStepper"]
  KlpSurface["KlpSurface"]:::external
  KlpTag["KlpTag"]
  KlpTerminal["KlpTerminal"]
  KlpText["KlpText"]:::external
  KlpTimeline["KlpTimeline"]
  KlpTooltip["KlpTooltip"]:::external
  KlpTreeItem["KlpTreeItem"]
  KlpAccordion --> KlpIcon
  KlpAccordion --> KlpText
  KlpAvatarGroup --> KlpAvatar
  KlpAvatar --> KlpText
  KlpBadge --> KlpText
  KlpCard --> KlpText
  KlpCodeLanguages --> KlpCodeLanguageOption
  KlpCodeViewer --> KlpIcon
  KlpCodeViewer --> KlpMenu
  KlpCodeViewer --> KlpMenuItemData
  KlpCodeViewer --> KlpPressable
  KlpCodeViewer --> KlpText
  KlpCodeViewer --> KlpTooltip
  KlpDataTable --> KlpCheckbox
  KlpDataTable --> KlpDashedDivider
  KlpDataTable --> KlpIcon
  KlpDataTable --> KlpSurface
  KlpDataTable --> KlpText
  KlpDiffViewer --> KlpPressable
  KlpDiffViewer --> KlpText
  KlpFilePreview --> KlpDashedDivider
  KlpFilePreview --> KlpGeometricSpinner
  KlpFilePreview --> KlpText
  KlpJsonTree --> KlpIcon
  KlpJsonTree --> KlpSurface
  KlpJsonTree --> KlpText
  KlpKeyValueList --> KlpIcon
  KlpKeyValueList --> KlpText
  KlpKeyValueTable --> KlpSurface
  KlpKeyValueTable --> KlpText
  KlpListTile --> KlpIcon
  KlpListTile --> KlpText
  KlpMetricCard --> KlpText
  KlpProgress --> KlpText
  KlpSortControl --> KlpIcon
  KlpSortControl --> KlpText
  KlpStepper --> KlpIcon
  KlpStepper --> KlpText
  KlpTag --> KlpText
  KlpTerminal --> KlpPressable
  KlpTerminal --> KlpText
  KlpTimeline --> KlpText
  KlpTreeItem --> KlpIcon
  KlpTreeItem --> KlpStateHighlight
  KlpTreeItem --> KlpText
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### form — 表單

型別 41 個，widget 29 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpApprovalStepData` | 8 | （葉節點） |
| `KlpApprovalStepsField` | 153 | `KlpText` |
| `KlpCalendar` | 248 | `KlpIconButton`、`KlpStateHighlight`、`KlpText` |
| `KlpCalendarRange` | 28 | （葉節點） |
| `KlpCalendarSelectionMode` | 7 | （葉節點） |
| `KlpChoiceOption` | 18 | （葉節點） |
| `KlpCodeEditorField` | 112 | `KlpText` |
| `KlpCodeField` | 41 | `KlpCodeViewer`、`KlpText`、`KlpTextArea` |
| `KlpColorRoleField` | 29 | `KlpSelectField` |
| `KlpConditionalFieldRegion` | 18 | （葉節點） |
| `KlpDateField` | 83 | `KlpCalendar`、`KlpTextField` |
| `KlpDateFieldCalendar` | 33 | （葉節點） |
| `KlpField` | 123 | `KlpFieldDescription`、`KlpFieldLabel`、`KlpText` |
| `KlpFieldDescription` | 20 | `KlpText` |
| `KlpFieldError` | 24 | `KlpText` |
| `KlpFieldGroup` | 31 | `KlpField` |
| `KlpFieldLabel` | 16 | `KlpText` |
| `KlpFieldVisualState` | 19 | （葉節點） |
| `KlpFileAttachment` | 13 | （葉節點） |
| `KlpFileDropzoneField` | 148 | `KlpText` |
| `KlpFileField` | 43 | `KlpButton`、`KlpFilePreview`、`KlpText` |
| `KlpFileValue` | 13 | （葉節點） |
| `KlpForm` | 40 | （葉節點） |
| `KlpFormActions` | 53 | `KlpButton` |
| `KlpFormErrorSummary` | 52 | `KlpSurface`、`KlpText` |
| `KlpFormSection` | 56 | `KlpSurface`、`KlpText` |
| `KlpKeyValueEditor` | 66 | `KlpText`、`KlpTextField` |
| `KlpKeyValueEntry` | 25 | （葉節點） |
| `KlpMultiSelectField` | 64 | `KlpText` |
| `KlpNumberField` | 41 | `KlpTextField` |
| `KlpPasswordField` | 149 | `KlpText` |
| `KlpPasswordRequirement` | 8 | （葉節點） |
| `KlpReferenceOption` | 16 | （葉節點） |
| `KlpReferencePicker` | 81 | `KlpBadge`、`KlpSurface`、`KlpText`、`KlpTextField` |
| `KlpRepeaterField` | 57 | `KlpButton`、`KlpSurface`、`KlpText` |
| `KlpRepeaterItem` | 12 | （葉節點） |
| `KlpSelectField` | 101 | `KlpStrokeFrame`、`KlpText` |
| `KlpStatusRoleSwatches` | 80 | `KlpText` |
| `KlpTagChip` | 44 | `KlpText` |
| `KlpTagInputField` | 84 | `KlpTagChip`、`KlpText` |
| `KlpTextArea` | 38 | `KlpTextField` |

```mermaid
graph LR
  KlpApprovalStepsField["KlpApprovalStepsField"]
  KlpBadge["KlpBadge"]:::external
  KlpButton["KlpButton"]:::external
  KlpCalendar["KlpCalendar"]
  KlpCodeEditorField["KlpCodeEditorField"]
  KlpCodeField["KlpCodeField"]
  KlpCodeViewer["KlpCodeViewer"]:::external
  KlpColorRoleField["KlpColorRoleField"]
  KlpDateField["KlpDateField"]
  KlpField["KlpField"]
  KlpFieldDescription["KlpFieldDescription"]
  KlpFieldError["KlpFieldError"]
  KlpFieldGroup["KlpFieldGroup"]
  KlpFieldLabel["KlpFieldLabel"]
  KlpFileDropzoneField["KlpFileDropzoneField"]
  KlpFileField["KlpFileField"]
  KlpFilePreview["KlpFilePreview"]:::external
  KlpFormActions["KlpFormActions"]
  KlpFormErrorSummary["KlpFormErrorSummary"]
  KlpFormSection["KlpFormSection"]
  KlpIconButton["KlpIconButton"]:::external
  KlpKeyValueEditor["KlpKeyValueEditor"]
  KlpMultiSelectField["KlpMultiSelectField"]
  KlpNumberField["KlpNumberField"]
  KlpPasswordField["KlpPasswordField"]
  KlpReferencePicker["KlpReferencePicker"]
  KlpRepeaterField["KlpRepeaterField"]
  KlpSelectField["KlpSelectField"]
  KlpStateHighlight["KlpStateHighlight"]:::external
  KlpStatusRoleSwatches["KlpStatusRoleSwatches"]
  KlpStrokeFrame["KlpStrokeFrame"]:::external
  KlpSurface["KlpSurface"]:::external
  KlpTagChip["KlpTagChip"]
  KlpTagInputField["KlpTagInputField"]
  KlpText["KlpText"]:::external
  KlpTextArea["KlpTextArea"]
  KlpTextField["KlpTextField"]:::external
  KlpApprovalStepsField --> KlpText
  KlpCalendar --> KlpIconButton
  KlpCalendar --> KlpStateHighlight
  KlpCalendar --> KlpText
  KlpCodeEditorField --> KlpText
  KlpCodeField --> KlpCodeViewer
  KlpCodeField --> KlpText
  KlpCodeField --> KlpTextArea
  KlpColorRoleField --> KlpSelectField
  KlpDateField --> KlpCalendar
  KlpDateField --> KlpTextField
  KlpFieldDescription --> KlpText
  KlpFieldError --> KlpText
  KlpFieldGroup --> KlpField
  KlpFieldLabel --> KlpText
  KlpField --> KlpFieldDescription
  KlpField --> KlpFieldLabel
  KlpField --> KlpText
  KlpFileDropzoneField --> KlpText
  KlpFileField --> KlpButton
  KlpFileField --> KlpFilePreview
  KlpFileField --> KlpText
  KlpFormActions --> KlpButton
  KlpFormErrorSummary --> KlpSurface
  KlpFormErrorSummary --> KlpText
  KlpFormSection --> KlpSurface
  KlpFormSection --> KlpText
  KlpKeyValueEditor --> KlpText
  KlpKeyValueEditor --> KlpTextField
  KlpMultiSelectField --> KlpText
  KlpNumberField --> KlpTextField
  KlpPasswordField --> KlpText
  KlpReferencePicker --> KlpBadge
  KlpReferencePicker --> KlpSurface
  KlpReferencePicker --> KlpText
  KlpReferencePicker --> KlpTextField
  KlpRepeaterField --> KlpButton
  KlpRepeaterField --> KlpSurface
  KlpRepeaterField --> KlpText
  KlpSelectField --> KlpStrokeFrame
  KlpSelectField --> KlpText
  KlpStatusRoleSwatches --> KlpText
  KlpTagChip --> KlpText
  KlpTagInputField --> KlpTagChip
  KlpTagInputField --> KlpText
  KlpTextArea --> KlpTextField
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### feedback — 狀態與回饋

型別 14 個，widget 11 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpEmptyState` | 52 | `KlpDashedBorder`、`KlpIcon`、`KlpText` |
| `KlpErrorState` | 34 | `KlpButton` |
| `KlpFeedbackTone` | 29 | （葉節點） |
| `KlpInlineNotice` | 99 | `KlpIcon`、`KlpSurface`、`KlpText` |
| `KlpLoadingState` | 35 | `KlpGeometricSpinner`、`KlpText` |
| `KlpPermissionState` | 26 | （葉節點） |
| `KlpProgressOverlay` | 95 | `KlpDashedBorder`、`KlpIcon`、`KlpLoadingState`、`KlpText` |
| `KlpRegionPlaceholder` | 275 | `KlpPressable`、`KlpText` |
| `KlpRegionPlaceholderTone` | 2 | （葉節點） |
| `KlpSkeletonLine` | 19 | （葉節點） |
| `KlpStatusIndicator` | 93 | `KlpIcon`、`KlpText` |
| `KlpStatusKind` | 24 | （葉節點） |
| `KlpToast` | 115 | `KlpButton`、`KlpIcon`、`KlpText` |
| `KlpToastStack` | 20 | （葉節點） |

```mermaid
graph LR
  KlpButton["KlpButton"]:::external
  KlpDashedBorder["KlpDashedBorder"]:::external
  KlpEmptyState["KlpEmptyState"]
  KlpErrorState["KlpErrorState"]
  KlpGeometricSpinner["KlpGeometricSpinner"]:::external
  KlpIcon["KlpIcon"]:::external
  KlpInlineNotice["KlpInlineNotice"]
  KlpLoadingState["KlpLoadingState"]
  KlpPressable["KlpPressable"]:::external
  KlpProgressOverlay["KlpProgressOverlay"]
  KlpRegionPlaceholder["KlpRegionPlaceholder"]
  KlpStatusIndicator["KlpStatusIndicator"]
  KlpSurface["KlpSurface"]:::external
  KlpText["KlpText"]:::external
  KlpToast["KlpToast"]
  KlpEmptyState --> KlpDashedBorder
  KlpEmptyState --> KlpIcon
  KlpEmptyState --> KlpText
  KlpErrorState --> KlpButton
  KlpInlineNotice --> KlpIcon
  KlpInlineNotice --> KlpSurface
  KlpInlineNotice --> KlpText
  KlpLoadingState --> KlpGeometricSpinner
  KlpLoadingState --> KlpText
  KlpProgressOverlay --> KlpDashedBorder
  KlpProgressOverlay --> KlpIcon
  KlpProgressOverlay --> KlpLoadingState
  KlpProgressOverlay --> KlpText
  KlpRegionPlaceholder --> KlpPressable
  KlpRegionPlaceholder --> KlpText
  KlpStatusIndicator --> KlpIcon
  KlpStatusIndicator --> KlpText
  KlpToast --> KlpButton
  KlpToast --> KlpIcon
  KlpToast --> KlpText
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### navigation — 導覽元件

型別 15 個，widget 12 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpActionGroup` | 20 | （葉節點） |
| `KlpBreadcrumb` | 34 | `KlpText` |
| `KlpFileExplorer` | 132 | `KlpFileExplorerSectionView` |
| `KlpFileExplorerFolderView` | 108 | `KlpIcon`、`KlpStateHighlight`、`KlpText` |
| `KlpFileExplorerItem` | 33 | （葉節點） |
| `KlpFileExplorerItemView` | 105 | `KlpIcon`、`KlpStateHighlight`、`KlpText` |
| `KlpFileExplorerSection` | 20 | （葉節點） |
| `KlpFileExplorerSectionView` | 150 | `KlpFileExplorerFolderView`、`KlpFileExplorerItemView`、`KlpIcon`、`KlpText` |
| `KlpPagination` | 46 | `KlpButton`、`KlpText` |
| `KlpRailItem` | 125 | `KlpIcon`、`KlpTooltipSurface` |
| `KlpSidebarNavigationButton` | 84 | `KlpIcon`、`KlpPressable`、`KlpText` |
| `KlpSidebarSectionLabel` | 27 | `KlpText` |
| `KlpTabs` | 106 | `KlpText` |
| `KlpViewOption` | 14 | （葉節點） |
| `KlpViewSwitcher` | 83 | `KlpSurface`、`KlpText` |

```mermaid
graph LR
  KlpBreadcrumb["KlpBreadcrumb"]
  KlpButton["KlpButton"]:::external
  KlpFileExplorer["KlpFileExplorer"]
  KlpFileExplorerFolderView["KlpFileExplorerFolderView"]
  KlpFileExplorerItemView["KlpFileExplorerItemView"]
  KlpFileExplorerSectionView["KlpFileExplorerSectionView"]
  KlpIcon["KlpIcon"]:::external
  KlpPagination["KlpPagination"]
  KlpPressable["KlpPressable"]:::external
  KlpRailItem["KlpRailItem"]
  KlpSidebarNavigationButton["KlpSidebarNavigationButton"]
  KlpSidebarSectionLabel["KlpSidebarSectionLabel"]
  KlpStateHighlight["KlpStateHighlight"]:::external
  KlpSurface["KlpSurface"]:::external
  KlpTabs["KlpTabs"]
  KlpText["KlpText"]:::external
  KlpTooltipSurface["KlpTooltipSurface"]:::external
  KlpViewSwitcher["KlpViewSwitcher"]
  KlpBreadcrumb --> KlpText
  KlpFileExplorerFolderView --> KlpIcon
  KlpFileExplorerFolderView --> KlpStateHighlight
  KlpFileExplorerFolderView --> KlpText
  KlpFileExplorerItemView --> KlpIcon
  KlpFileExplorerItemView --> KlpStateHighlight
  KlpFileExplorerItemView --> KlpText
  KlpFileExplorerSectionView --> KlpFileExplorerFolderView
  KlpFileExplorerSectionView --> KlpFileExplorerItemView
  KlpFileExplorerSectionView --> KlpIcon
  KlpFileExplorerSectionView --> KlpText
  KlpFileExplorer --> KlpFileExplorerSectionView
  KlpPagination --> KlpButton
  KlpPagination --> KlpText
  KlpRailItem --> KlpIcon
  KlpRailItem --> KlpTooltipSurface
  KlpSidebarNavigationButton --> KlpIcon
  KlpSidebarNavigationButton --> KlpPressable
  KlpSidebarNavigationButton --> KlpText
  KlpSidebarSectionLabel --> KlpText
  KlpTabs --> KlpText
  KlpViewSwitcher --> KlpSurface
  KlpViewSwitcher --> KlpText
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### editor — 編輯器周邊

型別 14 個，widget 8 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpBulkActionBar` | 26 | `KlpText` |
| `KlpCommandItemData` | 19 | （葉節點） |
| `KlpCommandMenu` | 214 | `KlpText` |
| `KlpCommandSectionData` | 17 | （葉節點） |
| `KlpEditorActionData` | 14 | （葉節點） |
| `KlpEditorToolbar` | 17 | （葉節點） |
| `KlpEntityPicker` | 111 | `KlpBadge`、`KlpButton`、`KlpText`、`KlpTextField` |
| `KlpEntityResultData` | 14 | （葉節點） |
| `KlpPageChrome` | 57 | `KlpBadge`、`KlpSurface`、`KlpText` |
| `KlpPropertyBadgeData` | 11 | （葉節點） |
| `KlpPropertySummary` | 45 | `KlpBadge`、`KlpSurface`、`KlpTag`、`KlpText` |
| `KlpSaveStatusCard` | 55 | `KlpText` |
| `KlpSearchNavigator` | 112 | `KlpIconButton`、`KlpText`、`KlpTextField` |
| `KlpStatusMessageData` | 15 | （葉節點） |

```mermaid
graph LR
  KlpBadge["KlpBadge"]:::external
  KlpBulkActionBar["KlpBulkActionBar"]
  KlpButton["KlpButton"]:::external
  KlpCommandMenu["KlpCommandMenu"]
  KlpEntityPicker["KlpEntityPicker"]
  KlpIconButton["KlpIconButton"]:::external
  KlpPageChrome["KlpPageChrome"]
  KlpPropertySummary["KlpPropertySummary"]
  KlpSaveStatusCard["KlpSaveStatusCard"]
  KlpSearchNavigator["KlpSearchNavigator"]
  KlpSurface["KlpSurface"]:::external
  KlpTag["KlpTag"]:::external
  KlpText["KlpText"]:::external
  KlpTextField["KlpTextField"]:::external
  KlpBulkActionBar --> KlpText
  KlpCommandMenu --> KlpText
  KlpEntityPicker --> KlpBadge
  KlpEntityPicker --> KlpButton
  KlpEntityPicker --> KlpText
  KlpEntityPicker --> KlpTextField
  KlpPageChrome --> KlpBadge
  KlpPageChrome --> KlpSurface
  KlpPageChrome --> KlpText
  KlpPropertySummary --> KlpBadge
  KlpPropertySummary --> KlpSurface
  KlpPropertySummary --> KlpTag
  KlpPropertySummary --> KlpText
  KlpSaveStatusCard --> KlpText
  KlpSearchNavigator --> KlpIconButton
  KlpSearchNavigator --> KlpText
  KlpSearchNavigator --> KlpTextField
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### routing — 分發

型別 5 個，widget 2 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpRoute` | 30 | （葉節點） |
| `KlpRouteNotFound` | 32 | （葉節點） |
| `KlpRouter` | 84 | `KlpRouteNotFound` |
| `KlpRouterOutlet` | 11 | （葉節點） |
| `KlpRouterScope` | 27 | （葉節點） |

```mermaid
graph LR
  KlpRouteNotFound["KlpRouteNotFound"]
  KlpRouter["KlpRouter"]
  KlpRouter --> KlpRouteNotFound
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### shell — 應用外殼

型別 18 個，widget 14 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpAppScreen` | 33 | `KlpTokenOverride` |
| `KlpAppWindowHeader` | 26 | `KlpPanelHeader` |
| `KlpContentState` | 3 | （葉節點） |
| `KlpPaneCollapseControl` | 65 | `KlpIcon` |
| `KlpPanelFrame` | 66 | `KlpTokenOverride` |
| `KlpPanelHeader` | 57 | `KlpText` |
| `KlpResponsivePaneCoordinator` | 22 | （葉節點） |
| `KlpSidebarFrame` | 33 | `KlpPanelFrame` |
| `KlpStageFrame` | 53 | `KlpTokenOverride` |
| `KlpStatusBar` | 57 | `KlpText` |
| `KlpThemePreviewMode` | 2 | （葉節點） |
| `KlpThemePreviewTile` | 311 | `KlpPressable`、`KlpText` |
| `KlpThemeToggle` | 25 | `KlpSurface`、`KlpText` |
| `KlpWindowAction` | 64 | （葉節點） |
| `KlpWindowControls` | 135 | `KlpIcon`、`KlpTooltip` |
| `KlpWindowControlsStyle` | 11 | （葉節點） |
| `KlpWindowHeader` | 231 | `KlpText`、`KlpWindowControls` |
| `KlpWorkbenchShell` | 149 | （葉節點） |

```mermaid
graph LR
  KlpAppScreen["KlpAppScreen"]
  KlpAppWindowHeader["KlpAppWindowHeader"]
  KlpIcon["KlpIcon"]:::external
  KlpPaneCollapseControl["KlpPaneCollapseControl"]
  KlpPanelFrame["KlpPanelFrame"]
  KlpPanelHeader["KlpPanelHeader"]
  KlpPressable["KlpPressable"]:::external
  KlpSidebarFrame["KlpSidebarFrame"]
  KlpStageFrame["KlpStageFrame"]
  KlpStatusBar["KlpStatusBar"]
  KlpSurface["KlpSurface"]:::external
  KlpText["KlpText"]:::external
  KlpThemePreviewTile["KlpThemePreviewTile"]
  KlpThemeToggle["KlpThemeToggle"]
  KlpTokenOverride["KlpTokenOverride"]:::external
  KlpTooltip["KlpTooltip"]:::external
  KlpWindowControls["KlpWindowControls"]
  KlpWindowHeader["KlpWindowHeader"]
  KlpAppScreen --> KlpTokenOverride
  KlpAppWindowHeader --> KlpPanelHeader
  KlpPaneCollapseControl --> KlpIcon
  KlpPanelFrame --> KlpTokenOverride
  KlpPanelHeader --> KlpText
  KlpSidebarFrame --> KlpPanelFrame
  KlpStageFrame --> KlpTokenOverride
  KlpStatusBar --> KlpText
  KlpThemePreviewTile --> KlpPressable
  KlpThemePreviewTile --> KlpText
  KlpThemeToggle --> KlpSurface
  KlpThemeToggle --> KlpText
  KlpWindowControls --> KlpIcon
  KlpWindowControls --> KlpTooltip
  KlpWindowHeader --> KlpText
  KlpWindowHeader --> KlpWindowControls
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### settings — 設定呈現

型別 9 個，widget 8 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpSettingsActionBar` | 46 | `KlpSurface`、`KlpText` |
| `KlpSettingsContentPane` | 70 | `KlpSurface`、`KlpText` |
| `KlpSettingsField` | 40 | `KlpSurface`、`KlpText` |
| `KlpSettingsNavigationGroup` | 37 | `KlpText` |
| `KlpSettingsNavigationItem` | 54 | `KlpListTile`、`KlpSurface` |
| `KlpSettingsNavigationPane` | 38 | `KlpSurface` |
| `KlpSettingsPage` | 58 | （葉節點） |
| `KlpThemeModeOption` | 15 | （葉節點） |
| `KlpThemeModePicker` | 45 | `KlpThemePreviewTile` |

```mermaid
graph LR
  KlpListTile["KlpListTile"]:::external
  KlpSettingsActionBar["KlpSettingsActionBar"]
  KlpSettingsContentPane["KlpSettingsContentPane"]
  KlpSettingsField["KlpSettingsField"]
  KlpSettingsNavigationGroup["KlpSettingsNavigationGroup"]
  KlpSettingsNavigationItem["KlpSettingsNavigationItem"]
  KlpSettingsNavigationPane["KlpSettingsNavigationPane"]
  KlpSurface["KlpSurface"]:::external
  KlpText["KlpText"]:::external
  KlpThemeModePicker["KlpThemeModePicker"]
  KlpThemePreviewTile["KlpThemePreviewTile"]:::external
  KlpSettingsActionBar --> KlpSurface
  KlpSettingsActionBar --> KlpText
  KlpSettingsContentPane --> KlpSurface
  KlpSettingsContentPane --> KlpText
  KlpSettingsField --> KlpSurface
  KlpSettingsField --> KlpText
  KlpSettingsNavigationGroup --> KlpText
  KlpSettingsNavigationItem --> KlpListTile
  KlpSettingsNavigationItem --> KlpSurface
  KlpSettingsNavigationPane --> KlpSurface
  KlpThemeModePicker --> KlpThemePreviewTile
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

### app — 接入層

型別 1 個，widget 1 個。

| 型別 | 行數 | 組成 |
|---|---|---|
| `KlpApp` | 304 | `KlpLocalizationsDelegate`、`KlpRouterOutlet`、`KlpRouterScope`、`KlpWindowHeader` |

```mermaid
graph LR
  KlpApp["KlpApp"]
  KlpLocalizationsDelegate["KlpLocalizationsDelegate"]:::external
  KlpRouterOutlet["KlpRouterOutlet"]:::external
  KlpRouterScope["KlpRouterScope"]:::external
  KlpWindowHeader["KlpWindowHeader"]:::external
  KlpApp --> KlpLocalizationsDelegate
  KlpApp --> KlpRouterOutlet
  KlpApp --> KlpRouterScope
  KlpApp --> KlpWindowHeader
  classDef external stroke-dasharray: 4 3;
```

虛線框是其他領域的型別。

## 葉節點

不組合任何其他 Kallopis 型別的 widget。它們是這套視覺語言的**詞根**——
每一個都直接對應一個不可再分的視覺概念。

`KlpActionGroup`、`KlpConditionalFieldRegion`、`KlpDashedDivider`、`KlpDivider`、`KlpDropIndicator`、`KlpEditorToolbar`、`KlpForm`、`KlpGeometricSpinner`、`KlpIcon`、`KlpInlineCode`、`KlpOverlayHost`、`KlpPermissionState`、`KlpPressable`、`KlpResizablePane`、`KlpResizeHandle`、`KlpResponsivePaneCoordinator`、`KlpRouterOutlet`、`KlpRouterScope`、`KlpScrollViewport`、`KlpSegmentedProgress`、`KlpSettingsPage`、`KlpSkeletonLine`、`KlpStateHighlight`、`KlpStrokeFrame`、`KlpText`、`KlpToastStack`、`KlpToggleIndicator`、`KlpTokenOverride`、`KlpTooltip`、`KlpTooltipSurface`、`KlpTree`、`KlpVirtualGrid`、`KlpVirtualList`、`KlpWorkbenchShell`

## 被最多型別使用的

改動這些的影響面最大。

| 型別 | 被幾個型別使用 |
|---|---|
| `KlpText` | 92 |
| `KlpIcon` | 30 |
| `KlpSurface` | 26 |
| `KlpPressable` | 10 |
| `KlpButton` | 9 |
| `KlpTextField` | 8 |
| `KlpBadge` | 4 |
| `KlpDashedBorder` | 4 |
| `KlpStateHighlight` | 4 |
| `KlpStrokeFrame` | 4 |
| `KlpTokenOverride` | 4 |
| `KlpDashedDivider` | 3 |
| `KlpMenu` | 3 |
| `KlpMenuItemData` | 3 |
| `KlpTooltip` | 3 |

