> **正式通用視覺規範從 [KALLOPIS-DESIGN-MAP.md](KALLOPIS-DESIGN-MAP.md) 進入**。使用者於 2026-10-11 指定直接採用既有統整內容，現已按責任分檔，依 [維護規則](maintenance.md) 修訂。本頁的 theme 欄位表與 JSON／CSS／ZIP 保留為 2026-10-05 匯出快照，不作第二份可獨立修訂的正式規範；網頁整合尚待網站 module 落實。

# Kallopis 設計語意與完整 Design Token 清單

擷取日期：2026-10-05。套件版本 0.8.0；風格配方 1.0.0；JSON schemaVersion 3。

本清單記錄目前工作樹（含既有未提交修改）。公開來源為 `lib/kallopis_theme.dart` 與 `lib/kallopis_foundation.dart`；名稱含 legacy 的實作目錄仍承載現行公開 ThemeExtension，不能只憑目錄名判定為淘汰。現行薄 design system 邊界依 KLP-0022，不使用已移除的 declarative runtime。

## 搬移檔案

- `kallopis-light.json`：完整淺色預設主題。
- `kallopis-dark.json`：完整深色預設主題。
- `kallopis-ultraDark.json`：完整極深色預設主題。
- `kallopis-transparent.json`：深色加透明視窗；app 透明，surface／stageSurface alpha 為 0.72。JSON 以 8-bit alpha 184 保存，重載後為 184/255；實際視窗透底仍需要平台支援。
- `kallopis-primitives.json`：公開 KlpScale、KlpPalette 原料及六組強調色配對。這不是 KlpVisualStyleJson 的輸入。
- `kallopis.css`：供其他技術棧使用的 CSS 變數，`:root` 為淺色，`[data-klp-theme="dark"]`／`ultra-dark`／`transparent` 切換變體；只提供 tokens 與具名配方，元件與平台能力由目標專案實作。

JSON 色彩是 **#AARRGGBB**（透明度在前），CSS 是 **#RRGGBBAA**（透明度在後）。JSON 距離／字級是無單位數值，Flutter 為 logical pixels，跨平台對應 CSS px；時長為 ms，行高是倍率，字重為 100–900 整數，curve 是四個 cubic-bezier 控制點。

## 設計語意與責任

1. Primitive 是設計字彙；semantic 為用途；component 為可空覆寫。`null` 表示繼承 semantic，不是 0。
2. 顏色分成 app → 輔助 surface → 主內容 component／stageSurface／overlay。預設為暖灰；品牌 `brand`、操作 `interaction`、狀態 `success/warning/danger/info` 分別保留用途。
3. 共用元件內部風格由 Kallopis 擁有；產品擁有頁面組合、欄寬選用、順序與流程。Flutter consumer 使用 `context.klp`，不引用 `lib/src` 或複製一份共用 theme。
4. 間距按 content、control、chrome、navigation、overlay 等範圍命名；同為 8 不表示可以任意互換用途。
5. 文字按 role、family、tone 組合；標題與內文預設都是主文字，說明再指定 muted／faint。UI／body 用 Noto Sans TC；程式碼用 IBM Plex Mono。
6. Frame 的現行外距／群組間距為 8，圓角 12、內容 padding 0。PanelFrame 有自己的 card 圓角 7 與 dockMargin 4；不能將所有 Frame 型元件當成相同幾何。
7. 紙片雙層陰影與 Frame 可選微立體是兩組配方。flat 不畫微立體；raised 明確啟用。陰影放在裁切之外。
8. 主題切換預設 0ms，ThemeExtension 在 t=0.5 整套切換；減少動態效果時 stateTransition、overlayEnter、overlayExit 歸零。

## Flutter 套用入口

現有 Flutter 產品優先依賴 Kallopis，根節點設定 `buildKlpTheme(Brightness.light)`／`buildKlpTheme(Brightness.dark)`，產品 Widget 讀 `context.klp.color`、`.type`、`.space`、`.shape`、`.motion`、`.surface`、`.component`、`.dataVisualization`、`.geometry`。完整根節點示例見 [產品使用指南](../ai/product-usage.md)。

要載入上述 JSON：將解析後的 `Map<String, Object?>` 傳給 `KlpVisualStyleJson.decode`，再將回傳 style 傳給 `buildKlpTheme` 的 `style` 參數。明確提供 style 時，色彩完全採用 style.colors，brightness 不會替你換成另一組配色。JSON 的 `colors.transparent` 對應 Dart `color.clear`；JSON `components` 對應 Dart `context.klp.component`。

可用 `KlpVisualStyle.defaultStyle.copyWith(...)` 調整整套 semantic。`buildKlpTheme(accent: ...)` 改 interaction 與 interactionSoft；品牌識別由 colors.brand 設定，不會自動把 accent 參數當成 brand。未指定 brand 的內建配方，brand 初始沿用 accent。

字型資產必須一起安裝：Flutter 保留 `packages/kallopis/` 家族名稱；Web 請註冊 `Noto Sans TC` 與 `IBM Plex Mono` 的 @font-face。`assets/fonts` 的 Noto、IBM 授權檔必須保留；Flaticon 圖示字型另受其授權約束。已打包 IBM Plex Sans TC，但它不是目前預設 UI 字型。

## 全部公開主題欄位

以下列出 350 個持久化 token 欄位（陣列以一個欄位計數；不含 name／schemaVersion）。顏色與圖表列出三種明暗變體；其餘使用相同預設。這是預設主題的值，不是所有元件在所有狀態下的最終值。


### 顏色：context.klp.color

| Token | 淺色 | 深色 | 極深色 |
|---|---|---|---|
| `app` | #FFE7E4DD | #FF201F1C | #FF101010 |
| `surface` | #FFEFEDE7 | #FF292724 | #FF232323 |
| `surfaceInset` | #FFEFEDE7 | #FF292724 | #FF232323 |
| `surfaceMuted` | #FFE1DDD2 | #FF484339 | #FF232323 |
| `component` | #FFF8F6F1 | #FF35322D | #FF1D1D1D |
| `stageSurface` | #FFF8F6F1 | #FF35322D | #FF1D1D1D |
| `overlay` | #FFF8F6F1 | #FF35322D | #FF232323 |
| `surfaceRaised` | #FFF8F6F1 | #FF35322D | #FF232323 |
| `modalScrim` | #99010202 | #99010202 | #99010202 |
| `guide` | #FFD3CFC4 | #FF514B40 | #FF7F7A75 |
| `divider` | #FFD3CFC4 | #FF514B40 | #FF292929 |
| `pagePattern` | #FFD3CFC4 | #FF514B40 | #FF414344 |
| `text` | #FF21201B | #FFF0EDE6 | #FFF2F0EB |
| `textMuted` | #FF6A655B | #FFBAB5AA | #FF9E998F |
| `textFaint` | #FF6A655B | #FFBAB5AA | #FF8E8982 |
| `border` | #FFD3CFC4 | #FF514B40 | #00000000 |
| `borderStrong` | #FFD3CFC4 | #FF514B40 | #00000000 |
| `brand` | #FF1D1D1D | #FFFFFFFF | #FFF2F0EB |
| `accent` | #FF1D1D1D | #FFFFFFFF | #FFF2F0EB |
| `accentSoft` | #FFE6E3DC | #FF303030 | #FF232323 |
| `interaction` | #FF1D1D1D | #FFFFFFFF | #FFF2F0EB |
| `interactionSoft` | #FFE6E3DC | #FF303030 | #FF232323 |
| `success` | #FF51B77B | #FF51B77B | #FF51B77B |
| `warning` | #FFF6B52E | #FFF6B52E | #FFF6B52E |
| `danger` | #FFFA6C73 | #FFFA6C73 | #FFFA6C73 |
| `info` | #FF5499DF | #FF5499DF | #FF5499DF |
| `onStatus` | #FFFFFFFF | #FFFFFFFF | #FFFFFFFF |
| `onLightBackground` | #FF21201B | #FF21201B | #FF1D1D1D |
| `onDarkBackground` | #FFF0EDE6 | #FFF0EDE6 | #FFFFFFFF |
| `mutedOnLightBackground` | #FF6A655B | #FF6A655B | #FF6B6459 |
| `mutedOnDarkBackground` | #FFBAB5AA | #FFBAB5AA | #FFADA89E |
| `faintOnBackground` | #FF6A655B | #FFBAB5AA | #FF8E8982 |
| `transparent` | #00000000 | #00000000 | #00000000 |

### 字體：context.klp.type

| Token | 預設值 |
|---|---|
| `sansFamily` | packages/kallopis/Noto Sans TC |
| `sansFallback` | Noto Sans TC, Microsoft JhengHei UI, Microsoft JhengHei, PingFang TC, sans-serif |
| `monoFamily` | packages/kallopis/IBM Plex Mono |
| `monoFallback` | packages/kallopis/Noto Sans TC, IBM Plex Mono, Consolas, Courier New, monospace |
| `uiFamily` | packages/kallopis/Noto Sans TC |
| `bodyFamily` | packages/kallopis/Noto Sans TC |
| `codeFamily` | packages/kallopis/IBM Plex Mono |
| `micro` | 10 |
| `caption` | 12 |
| `sub` | 14 |
| `body` | 16 |
| `lead` | 18 |
| `h4` | 22 |
| `h3` | 28 |
| `h2` | 36 |
| `h1` | 48 |
| `display` | 64 |
| `label` | 14 |
| `section` | 28 |
| `headingSmall` | 22 |
| `heading` | 36 |
| `title` | 48 |
| `microLeading` | 1.2 |
| `captionLeading` | 1.333 |
| `subLeading` | 1.428 |
| `bodyLeading` | 1.5 |
| `leadLeading` | 1.555 |
| `h4Leading` | 1.272 |
| `h3Leading` | 1.285 |
| `h2Leading` | 1.222 |
| `h1Leading` | 1.166 |
| `displayLeading` | 1.125 |
| `headingLeading` | 1.222 |
| `codeLeading` | 1.428 |
| `readingLeading` | 1.555 |
| `labelLeading` | 1.333 |
| `labelTracking` | 0 |
| `displayTracking` | -0.5 |
| `regular` | 400 |
| `medium` | 400 |
| `semiBold` | 600 |
| `bold` | 700 |
| `extraBold` | 700 |
| `strong` | 600 |

### 間距與密度：context.klp.space

| Token | 預設值 |
|---|---|
| `space0_5` | 2 |
| `space1` | 4 |
| `space2` | 8 |
| `space3` | 12 |
| `space4` | 16 |
| `space6` | 24 |
| `space8` | 32 |
| `space12` | 48 |
| `space16` | 64 |
| `space24` | 96 |
| `hairline` | 2 |
| `tight` | 4 |
| `contentInlineGap` | 8 |
| `contentStackGap` | 8 |
| `contentInset` | 8 |
| `controlContentGap` | 8 |
| `controlInset` | 8 |
| `actionGap` | 8 |
| `chromeGap` | 8 |
| `chromePanelInset` | 8 |
| `chromeToolbarGap` | 8 |
| `navigationItemInset` | 8 |
| `navigationRailInset` | 8 |
| `navigationRailItemGap` | 8 |
| `overlayContentInset` | 8 |
| `overlayHeadingGap` | 8 |
| `overlayItemGap` | 8 |
| `navigationSectionGap` | 6 |
| `appFrameInset` | 4 |
| `windowHeaderMargin` | 4 |
| `dockMargin` | 4 |
| `base` | 16 |
| `comfortable` | 24 |
| `loose` | 32 |
| `section` | 32 |
| `sectionLarge` | 48 |
| `page` | 64 |
| `pageLarge` | 96 |
| `controlPaddingXSmall` | 12 |
| `controlPaddingX` | 16 |
| `controlPaddingXLarge` | 24 |
| `controlPaddingXXLarge` | 32 |
| `controlPaddingY` | 8 |
| `containerPadding` | 16 |
| `itemGap` | 12 |
| `groupGap` | 16 |
| `controlHeightXSmall` | 30 |
| `controlHeightSmall` | 36 |
| `controlHeight` | 40 |
| `controlHeightLarge` | 48 |
| `controlHeightXLarge` | 56 |
| `iconSmall` | 14 |
| `iconBase` | 16 |
| `iconGlyph` | 18 |
| `icon` | 20 |
| `iconMedium` | 24 |
| `iconLarge` | 32 |
| `chromeHeader` | 60 |
| `chromeStatusBar` | 30 |
| `chromeRail` | 48 |
| `chromeTab` | 32 |
| `iconButton` | 32 |
| `iconTiny` | 10 |
| `indicatorDot` | 6 |
| `indicatorDotLarge` | 8 |
| `noticeIconSlot` | 28 |
| `toastIconSlot` | 22 |
| `gutterNumber` | 24 |
| `gutterMarker` | 14 |
| `micro` | 1 |
| `calendarContentCell` | 74 |
| `gridTileWidth` | 170 |
| `iconMicro` | 11 |
| `avatarSmall` | 24 |
| `progressTrack` | 3 |
| `skeletonLine` | 10 |
| `railItem` | 32 |

### 形狀與線條：context.klp.shape

| Token | 預設值 |
|---|---|
| `none` | 0 |
| `sm` | 2 |
| `control` | 6 |
| `controlInner` | 5 |
| `toggleTrack` | 4 |
| `card` | 7 |
| `panel` | 12 |
| `pill` | 9999 |
| `hairline` | 1 |
| `stroke` | 2 |
| `dashedLength` | 3 |
| `dashedGap` | 2 |
| `dashedOpacity` | 0.78 |

### 時間與曲線：context.klp.motion

| Token | 預設值 |
|---|---|
| `themeTransition` | 0 |
| `styleTransition` | 0 |
| `stateTransition` | 140 |
| `overlayEnter` | 140 |
| `overlayExit` | 120 |
| `toastDwell` | 500 |
| `tooltipDelay` | 450 |
| `tooltipDwell` | 4000 |
| `spinnerCycle` | 1000 |
| `longPressThreshold` | 500 |
| `standard` | 0.215, 0.61, 0.355, 1.0 |
| `emphasized` | 0.645, 0.045, 0.355, 1.0 |

### 表面與透明度：context.klp.surface

| Token | 預設值 |
|---|---|
| `separation` | shadow |
| `overlayBlur` | 20.0 |
| `overlaySpread` | 0 |
| `overlayOffsetY` | 8.0 |
| `overlayShadowOpacity` | 0.13333333333333333 |
| `scrimOpacity` | 0.6 |
| `selectionWashOpacity` | 0.1 |
| `focusWashOpacity` | 0.18 |
| `statusFillOpacity` | 0.16 |
| `pressProgressOpacity` | 0.55 |
| `diffFillOpacity` | 0.12 |
| `gridLineOpacity` | 0.18 |
| `veilOpacity` | 0.82 |
| `statusRowOpacity` | 0.14 |
| `statusRowSelectedOpacity` | 0.32 |
| `statusRowOpacityDark` | 0.28 |
| `statusRowSelectedOpacityDark` | 0.48 |
| `frostedOpacity` | 0.14 |
| `frostedVeilOpacity` | 0.12 |
| `backdropBlurSigma` | 12 |
| `dragOpacity` | 0.82 |
| `dragSourceOpacity` | 0.35 |
| `themePreviewDisabledOpacity` | 0.62 |
| `listStatusOpacity` | 0.14 |
| `listStatusSelectedOpacity` | 0.32 |
| `accentSoftOpacityLight` | 0.16 |
| `accentSoftOpacityDark` | 0.22 |
| `windowPaneOpacityLight` | 0.88 |
| `windowPaneOpacityDark` | 0.72 |
| `invalidFillOpacity` | 0.18 |
| `contactBlur` | 3.0 |
| `contactOffsetY` | 2.0 |
| `contactShadowOpacity` | 0.13333333333333333 |
| `overlayShadowColor` | #FF000000 |

### 元件覆寫：context.klp.component

| Token | 預設值 |
|---|---|
| `buttonRadius` | null（繼承語意） |
| `buttonPaddingX` | null（繼承語意） |
| `buttonPaddingY` | null（繼承語意） |
| `buttonHeight` | null（繼承語意） |
| `buttonBorderWidth` | null（繼承語意） |
| `fieldRadius` | null（繼承語意） |
| `fieldPaddingX` | null（繼承語意） |
| `fieldHeight` | null（繼承語意） |
| `fieldBorderWidth` | null（繼承語意） |
| `menuRadius` | null（繼承語意） |
| `menuPadding` | null（繼承語意） |
| `menuItemHeight` | null（繼承語意） |
| `cardRadius` | null（繼承語意） |
| `cardPadding` | null（繼承語意） |
| `badgeRadius` | null（繼承語意） |
| `badgePaddingX` | null（繼承語意） |

### 精確幾何：context.klp.geometry.control

| Token | 預設值 |
|---|---|
| `switchTrackWidth` | 36 |
| `switchTrackHeight` | 20 |
| `switchThumb` | 16 |
| `buttonHeightXSmall` | 28 |
| `buttonHeightSmall` | 32 |
| `buttonHeight` | 36 |
| `buttonHeightLarge` | 40 |
| `buttonHeightXLarge` | 48 |
| `pageBackgroundHitRadius` | 8 |
| `presenceMarkerExtent` | 8 |
| `colorPickerCursorRadius` | 8 |
| `swatchExtent` | 8 |
| `segmentedProgressHeight` | 8 |
| `fieldHeight` | 30 |
| `selectionControl` | 18 |
| `selectionIndicatorInset` | 3.5 |
| `selectionIcon` | 12 |
| `toggleWidth` | 30 |
| `toggleHeight` | 16 |
| `toggleThumb` | 12 |
| `toggleInset` | 2 |
| `segmentedDenseHeight` | 30 |
| `segmentedDenseInset` | 3 |
| `segmentedDenseContentInset` | 0 |
| `segmentedDenseItemHeight` | 24 |
| `slidingSelectionHeight` | 36 |
| `slidingSelectionSegmentWidth` | 41.4 |
| `slidingSelectionPadding` | 2 |
| `slidingSelectionIndicatorHeight` | 30 |
| `scrollbarThickness` | 5 |
| `sliderTrackHeight` | 4 |
| `colorPlaneExtent` | 168 |
| `textFieldIndicatorHeightFactor` | 0.4 |
| `textFieldLineHeightFactor` | 1.3 |
| `textFieldMinLines` | 4 |
| `textFieldMaxLines` | 8 |
| `fileExplorerRowHeightAdjustment` | 0 |

### 精確幾何：context.klp.geometry.data

| Token | 預設值 |
|---|---|
| `codeActionButtonSize` | 26 |
| `codeHeaderHeight` | 32 |
| `codeTerminalDot` | 4 |
| `codeTerminalDotGap` | 3 |
| `codeHeaderPaddingX` | 10 |
| `codeBodyPaddingX` | 10 |
| `codeLineNumberWidth` | 32 |
| `codeWrappedLineWidth` | 520 |
| `codeMaximumHeight` | 320 |
| `codeCollapsedHeight` | 120 |
| `codeDisclosureSize` | 9 |
| `filePreviewHeight` | 220 |
| `previewCardCompactHeight` | 64 |
| `previewCardStandardHeight` | 96 |
| `previewCardLargeHeight` | 192 |
| `dateGridCellHeight` | 128 |
| `keyValueLabelWidthCompact` | 96 |
| `keyValueLabelWidthStandard` | 112 |
| `stepperMarkerSize` | 24 |
| `stepperLabelWidth` | 60 |
| `progressIndeterminateFraction` | 0.35 |
| `placeholderMinimumHeight` | 120 |
| `placeholderContentPaddingY` | 12 |
| `placeholderActionPaddingY` | 5 |
| `placeholderHatchBand` | 10.5 |
| `placeholderHatchGap` | 10.5 |
| `placeholderLabelTracking` | 1.32 |
| `placeholderDetailMaximumWidth` | 336 |
| `spinnerSquareFactor` | 0.32 |
| `spinnerOrbitFactor` | 0.22 |
| `spinnerCornerFactor` | 0.06 |

### 精確幾何：context.klp.geometry.layout

| Token | 預設值 |
|---|---|
| `drawerWidth` | 320 |
| `drawerHeight` | 320 |
| `resizeHandleExtent` | 8 |
| `overlayViewportInset` | 8 |
| `railDropTargetExtent` | 8 |
| `disclosureIconSize` | 8 |
| `treeLeadingGap` | 8 |
| `tooltipOffsetX` | 8 |
| `primaryPaneWidth` | 300 |
| `secondaryPaneWidth` | 350 |
| `primaryPaneBreakpoint` | 400 |
| `primaryPaneContentBreakpoint` | 800 |
| `responsivePaneBreakpoint` | 960 |
| `secondaryPaneBreakpoint` | 1120 |
| `menuWidth` | 200 |
| `commandMenuWidth` | 300 |
| `menuHeaderHeight` | 28 |
| `menuItemHeight` | 28 |
| `dialogMaximumWidth` | 520 |
| `toastMaximumWidth` | 360 |
| `inlineNoticeBreakpoint` | 480 |
| `statusBarBreakpoint` | 400 |
| `settingsDialogMaximumWidth` | 1380 |
| `settingsDialogMaximumHeight` | 880 |
| `settingsPaneGap` | 8 |
| `settingsNavigationWidth` | 300 |
| `settingsNavigationMinimumWidth` | 260 |
| `settingsNavigationMaximumWidth` | 360 |
| `settingsContentMaximumWidth` | 820 |
| `themePreviewTileWidth` | 168 |
| `windowHeaderHeight` | 24 |
| `windowHeaderControlSize` | 24 |
| `windowAppIconSize` | 20 |
| `windowIdentityGap` | 8 |

### 精確幾何：context.klp.geometry.optical

| Token | 預設值 |
|---|---|
| `menuIconOffsetY` | 1 |
| `railBadgeInset` | 2 |
| `statusIconOffsetY` | 1 |
| `monoBaselineOffsetY` | -1 |
| `uiBaselineOffsetY` | 0 |

### 資料視覺化：context.klp.dataVisualization

| Token | 淺色 | 深色 | 極深色 |
|---|---|---|---|
| `series` | #FFE0BE73, #FFD3A152, #FFC6823D, #FFA96836, #FF895137, #FF683E33 | #FFF0D79A, #FFE8BD70, #FFDFA04E, #FFC88745, #FFA86D43, #FF89573E | #FFF0D79A, #FFE8BD70, #FFDFA04E, #FFC88745, #FFA86D43, #FF89573E |
| `seriesWash` | #FFF8F1E2, #FFF6EBD7, #FFF3E4CF, #FFEEDDD0, #FFE9D8D1, #FFE4D5D1 | #FF453D2B, #FF443725, #FF413222, #FF3D2D22, #FF382A23, #FF332724 | #FF302B20, #FF30271B, #FF2E241A, #FF2C211B, #FF291F1C, #FF261D1C |
| `axis` | #FFD6D0C6 | #FF585249 | #FF45413A |
| `grid` | #FFE4E1DA | #FF433F3A | #FF34302B |
| `gridStrong` | #FFC8C0B4 | #FF6A6256 | #FF585249 |
| `label` | #FF6B6459 | #FFB8B2A4 | #FFB8B2A4 |
| `value` | #FF1D1D1D | #FFF5F2EC | #FFF5F2EC |
| `plotBackground` | #00000000 | #00000000 | #00000000 |
| `crosshair` | #FF8C8477 | #FF918A7B | #FF7A7566 |
| `marketUp` | #FF2D8057 | #FF67AE86 | #FF67AE86 |
| `marketUpWash` | #FFDFF0E5 | #FF243B2D | #FF1D3025 |
| `marketDown` | #FFA7443F | #FFD27B74 | #FFD27B74 |
| `marketDownWash` | #FFFAE3E2 | #FF472925 | #FF3B2320 |
| `marketFlat` | #FF8C8477 | #FF918A7B | #FF7A7566 |

## 元件覆寫的解析落點

| component token | 繼承來源 | 解析預設 |
|---|---|---|
| `buttonRadius` | `shape.control` | 6 |
| `buttonPaddingX` | `spacing.controlPaddingX` | 16 |
| `buttonPaddingY` | `spacing.controlPaddingY` | 8 |
| `buttonHeight` | `geometry.control.buttonHeight` | 36 |
| `buttonBorderWidth` | `shape.none` | 0 |
| `fieldRadius` | `shape.control` | 6 |
| `fieldPaddingX` | `spacing.controlInset` | 8 |
| `fieldHeight` | `spacing.controlHeight` | 40 |
| `fieldBorderWidth` | `shape.none` | 0 |
| `menuRadius` | `shape.card` | 7 |
| `menuPadding` | `spacing.overlayContentInset` | 8 |
| `menuItemHeight` | `geometry.layout.menuItemHeight` | 28 |
| `cardRadius` | `shape.card` | 7 |
| `cardPadding` | `spacing.containerPadding` | 16 |
| `badgeRadius` | `shape.pill` | 9999 |
| `badgePaddingX` | `spacing.tight + spacing.space0_5` | 6 |

`resolveMenuItemHeight(spacing)` 的舊 helper 沿用 controlHeightSmall=36；context.klp.menuItemHeight 的現行 getter 使用 geometry.layout.menuItemHeight=28。geometry.control.fieldHeight=30 與 context.klp.fieldHeight=40 是不同取值路徑，不能合併。iconButton 標準尺寸 32；window 尺寸 24。space.avatarSmall 實際 24，即使欄位註解仍寫 28。medium 實際 400、extraBold 實際 700，採 recipe 值而非命名猜測。


## 文字角色的完整對應

| Role | 字級 | 行高倍率 | 字重 | 字距 | 家族 |
|---|---|---|---|---|---|
| `display` | 64 | 1.125 | 700 | -0.5 | ui |
| `h1` | 48 | 1.166 | 700 | 0 | ui |
| `h2` | 36 | 1.222 | 600 | 0 | ui |
| `h3` | 28 | 1.285 | 600 | 0 | ui |
| `h4` | 22 | 1.272 | 600 | 0 | ui |
| `lead` | 18 | 1.555 | 600 | 0 | ui |
| `body` | 16 | 1.5 | 400 | 0 | ui |
| `sub` | 14 | 1.428 | 400 | 0 | ui |
| `caption` | 12 | 1.333 | 400 | 0 | ui |
| `captionStrong` | 12 | 1.333 | 600 | 0 | ui |
| `monoCaptionStrong` | 12 | 1.333 | 700 | 0 | mono |
| `micro` | 10 | 1.2 | 600 | 0 | ui |
| `title` | 48 | 1.166 | 700 | 0 | ui |
| `section` | 28 | 1.285 | 600 | 0 | ui |
| `editor` | 16 | 1.5 | 400 | 0 | body |
| `terminal` | 16 | 1.5 | 400 | 0 | mono |
| `bodyStrong` | 16 | 1.5 | 600 | 0 | ui |
| `appTitle` | 14 | 1.333 | 500 | 0 | mono |
| `header` | 16 | 1.5 | 600 | 0 | mono |
| `status` | 14 | 1.428 | 500 | 0 | mono |
| `label` | 14 | 1.333 | 400 | 0 | mono |
| `code` | 14 | 1.428 | 400 | 0 | mono |

所有角色 tier=prominent → color.text；tone.muted → textMuted、tone.faint → textFaint。primary／accent／danger／success 的文字 tone 在現行 KlpTextStyles 中仍解析為 prominent，不自動切換到同名狀態色。mono 角色光學 Y 位移 -1，其他角色 0；tracking.placeholder 使用 geometry.data.placeholderLabelTracking=1.32。


## 互動狀態與衍生語意


| 名稱／用途 | 現行解析 |
|---|---|
| color.selection | text |
| color.onSelection | app |
| color.selectionBackground | interactionSoft |
| color.selectionForeground | text |
| klp.selectionWash | text 的 alpha 替換為 selectionWashOpacity=0.10 |
| klp.selectedWash | interaction 的 alpha 替換為 selectionWashOpacity=0.10 |
| klp.primary | brand，強制不透明 |
| klp.onPrimary | sRGB luma=0.299R+0.587G+0.114B；小於160使用 onDarkBackground，否則 onLightBackground |
| color.onInteraction | interaction 相對亮度小於0.15使用 onDarkBackground，否則 onLightBackground |
| klp.isDark | surface 相對亮度小於0.5 |
| field rest | surfaceInset |
| field hover | alphaBlend(selectionWash, surfaceInset) |
| field focused／selected | alphaBlend(interaction × focusWashOpacity=0.18, surfaceInset) |
| field disabled | surfaceMuted |
| field error | danger × invalidFillOpacity=0.18，保留半透明疊層 |
| button primary | 不透明 brand，前景由實際背景依 luma 門檻解析 |
| button secondary | component，前景 text |
| button ghost／dashed | clear，前景 text |
| button danger | danger × statusFillOpacity=0.16，前景 danger |
| button disabled | surfaceInset，前景 textFaint |
| button hover／focus | selectionWash 疊於原底；primary 改用 onPrimary × 0.10 |
| button selected | interaction × 0.18 疊於原底；primary 改用 onPrimary × 0.18 |
| icon button rest | standalone=component；inline=clear |
| icon button selected | selectionBackground |
| icon button hover／focus | text wash 疊於 component；淺色 alpha=0.18、深色 alpha=0.10 |
| action region selected | selectionBackground；前景 text |
| action region hover／focus | selectionWash；一般前景 textMuted |
| action region destructive active | danger；前景 onStatus |

`Color.alphaBlend` 是疊色，不是把兩個 hex 直接替換；需保留底色和 alpha。hover／selected 同色是既有接受的視覺方向，但目前各 resolver 有上述差異，不能宣稱所有元件用同一個最終色。舊 spec/interaction-state-language.md 的 Explorer 虛線與 primary=interactionSoft 等敘述已不符合目前入口／實作，不帶入新專案。

## 陰影、分層與 Frame 配方

- 紙片／overlay：黑色 alpha=34/255；接觸層 offset(0,2)、blur=3、spread=0；環境層 offset(0,8)、blur=20、spread=0。surface.separation=shadow 才由 overlayShadow 產生陰影，其他模式為空清單。
- Frame raised：尺度 f=space.space1/4，預設 f=1；陰影 offset(2f,3f)、blur=5f、spread=-f，RGB 取 overlayShadowColor；淺色 alpha=46/255、深色 alpha=122/255。白色亮邊 offset(-f,-f)、blur=0；淺色 alpha=217/255、深色 alpha=18/255。配方深色判斷為 surface 的 R/G/B 全部小於100，與 klp.isDark 的亮度判斷不同。
- PanelFrame 的 elevation 預設 flat，raised 套用同一微立體；外層圓角 card=7，內層裁切半徑 card−stroke=5。
- Surface separation 可選 tone、outline、frosted、gradient、shadow。blurSigma=12 只是 frosted 相關參數，複製 token 不會自動建立 BackdropFilter。
- 視窗透明：app=clear，surface／stageSurface 使用 pane alpha，淺色0.88、深色0.72；其他 token 不自動變透明。

## 公開 primitive 原料清單

185 個 KlpScale／KlpPalette 常數完整保留。它們是字彙表，consumer 的共用視覺仍應使用 semantic，不以 palette 常數取代用途。

| 名稱 | 值 |
|---|---|

| `KlpScale.space0` | 0 |
| `KlpScale.space50` | 2 |
| `KlpScale.space100` | 4 |
| `KlpScale.space200` | 8 |
| `KlpScale.space250` | 10 |
| `KlpScale.space300` | 12 |
| `KlpScale.space400` | 16 |
| `KlpScale.space600` | 24 |
| `KlpScale.space800` | 32 |
| `KlpScale.space1000` | 40 |
| `KlpScale.space1200` | 48 |
| `KlpScale.space1600` | 64 |
| `KlpScale.space2400` | 96 |
| `KlpScale.radius0` | 0 |
| `KlpScale.radius50` | 2 |
| `KlpScale.radius100` | 4 |
| `KlpScale.radius150` | 6 |
| `KlpScale.radius200` | 8 |
| `KlpScale.radius250` | 10 |
| `KlpScale.radius300` | 12 |
| `KlpScale.radius400` | 16 |
| `KlpScale.radiusFull` | 9999 |
| `KlpScale.stroke0` | 0 |
| `KlpScale.stroke100` | 1 |
| `KlpScale.stroke200` | 2 |
| `KlpScale.font100` | 10 |
| `KlpScale.font200` | 12 |
| `KlpScale.font300` | 14 |
| `KlpScale.font400` | 16 |
| `KlpScale.font500` | 18 |
| `KlpScale.font600` | 22 |
| `KlpScale.font700` | 28 |
| `KlpScale.font800` | 36 |
| `KlpScale.font900` | 48 |
| `KlpScale.font1000` | 64 |
| `KlpScale.leading100` | 1.125 |
| `KlpScale.leading116` | 1.166 |
| `KlpScale.leading120` | 1.2 |
| `KlpScale.leading122` | 1.222 |
| `KlpScale.leading127` | 1.272 |
| `KlpScale.leading128` | 1.285 |
| `KlpScale.leading133` | 1.333 |
| `KlpScale.leading142` | 1.428 |
| `KlpScale.leading150` | 1.5 |
| `KlpScale.leading155` | 1.555 |
| `KlpScale.leading150Legacy` | 1.2 |
| `KlpScale.leading200` | 1.25 |
| `KlpScale.leading300` | 1.3 |
| `KlpScale.leading350` | 1.35 |
| `KlpScale.leading400` | 1.4 |
| `KlpScale.leading450` | 1.45 |
| `KlpScale.leading500` | 1.5 |
| `KlpScale.leading550` | 1.55 |
| `KlpScale.leading650` | 1.65 |
| `KlpScale.tracking0` | 0 |
| `KlpScale.trackingTight` | -0.5 |
| `KlpScale.trackingWide` | 1.2 |
| `KlpScale.trackingWider` | 1.32 |
| `KlpScale.weight400` | 400 |
| `KlpScale.weight500` | 500 |
| `KlpScale.weight600` | 600 |
| `KlpScale.weight700` | 700 |
| `KlpScale.weight800` | 800 |
| `KlpScale.duration0` | 0 |
| `KlpScale.duration100` | 120 |
| `KlpScale.duration150` | 140 |
| `KlpScale.duration400` | 450 |
| `KlpScale.duration500` | 500 |
| `KlpScale.easeStandard` | 0.215, 0.61, 0.355, 1.0 |
| `KlpScale.easeEmphasized` | 0.645, 0.045, 0.355, 1.0 |
| `KlpScale.opacity100` | 0.1 |
| `KlpScale.opacity120` | 0.12 |
| `KlpScale.opacity140` | 0.14 |
| `KlpScale.opacity160` | 0.16 |
| `KlpScale.opacity180` | 0.18 |
| `KlpScale.opacity220` | 0.22 |
| `KlpScale.opacity280` | 0.28 |
| `KlpScale.opacity320` | 0.32 |
| `KlpScale.opacity350` | 0.35 |
| `KlpScale.opacity440` | 0.44 |
| `KlpScale.opacity480` | 0.48 |
| `KlpScale.opacity550` | 0.55 |
| `KlpScale.opacity620` | 0.62 |
| `KlpScale.opacity720` | 0.72 |
| `KlpScale.opacity780` | 0.78 |
| `KlpScale.opacity820` | 0.82 |
| `KlpPalette.parchment50` | #FFF8F6F1 |
| `KlpPalette.parchment75` | #FFF0EDE6 |
| `KlpPalette.parchment100` | #FFEFEDE7 |
| `KlpPalette.parchment150` | #FFE7E4DD |
| `KlpPalette.parchment200` | #FFE1DDD2 |
| `KlpPalette.parchment250` | #FFD3CFC4 |
| `KlpPalette.parchment350` | #FFBAB5AA |
| `KlpPalette.parchment550` | #FF6A655B |
| `KlpPalette.parchment700` | #FF514B40 |
| `KlpPalette.parchment750` | #FF484339 |
| `KlpPalette.parchment800` | #FF35322D |
| `KlpPalette.parchment825` | #FF33322C |
| `KlpPalette.parchment900` | #FF292724 |
| `KlpPalette.parchment925` | #FF21201B |
| `KlpPalette.parchment950` | #FF201F1C |
| `KlpPalette.ink1000` | #FF000000 |
| `KlpPalette.transparent` | #00000000 |
| `KlpPalette.ink50` | #FFFFFFFF |
| `KlpPalette.ink100` | #FFF2F0EB |
| `KlpPalette.ink150` | #FFEAE7E1 |
| `KlpPalette.ink200` | #FFE6E3DC |
| `KlpPalette.ink250` | #FFBCB8B0 |
| `KlpPalette.ink300` | #FFADA89E |
| `KlpPalette.ink350` | #FF9E998F |
| `KlpPalette.ink400` | #FF8E8982 |
| `KlpPalette.ink450` | #FF7F7A75 |
| `KlpPalette.ink500` | #FF6F6C67 |
| `KlpPalette.ink550` | #FF6B6459 |
| `KlpPalette.ink600` | #FF4F5151 |
| `KlpPalette.ink650` | #FF414344 |
| `KlpPalette.ink700` | #FF343637 |
| `KlpPalette.ink750` | #FF303030 |
| `KlpPalette.ink800` | #FF292929 |
| `KlpPalette.ink850` | #FF232323 |
| `KlpPalette.ink900` | #FF1D1D1D |
| `KlpPalette.ink950` | #FF101010 |
| `KlpPalette.warmNeutral25` | #FFF5F2EC |
| `KlpPalette.warmNeutral50` | #FFE4E1DA |
| `KlpPalette.warmNeutral100` | #FFD6D0C6 |
| `KlpPalette.warmNeutral200` | #FFC8C0B4 |
| `KlpPalette.warmNeutral300` | #FFB8B2A4 |
| `KlpPalette.warmNeutral400` | #FF918A7B |
| `KlpPalette.warmNeutral450` | #FF8C8477 |
| `KlpPalette.warmNeutral500` | #FF7A7566 |
| `KlpPalette.warmNeutral600` | #FF6A6256 |
| `KlpPalette.warmNeutral700` | #FF585249 |
| `KlpPalette.warmNeutral750` | #FF45413A |
| `KlpPalette.warmNeutral800` | #FF433F3A |
| `KlpPalette.warmNeutral900` | #FF34302B |
| `KlpPalette.sand50` | #FFF8F1E2 |
| `KlpPalette.sand300` | #FFF0D79A |
| `KlpPalette.sand500` | #FFE0BE73 |
| `KlpPalette.sand800` | #FF453D2B |
| `KlpPalette.sand900` | #FF302B20 |
| `KlpPalette.gold50` | #FFF6EBD7 |
| `KlpPalette.gold300` | #FFE8BD70 |
| `KlpPalette.gold500` | #FFD3A152 |
| `KlpPalette.gold800` | #FF443725 |
| `KlpPalette.gold900` | #FF30271B |
| `KlpPalette.ochre50` | #FFF3E4CF |
| `KlpPalette.ochre300` | #FFDFA04E |
| `KlpPalette.ochre500` | #FFC6823D |
| `KlpPalette.ochre800` | #FF413222 |
| `KlpPalette.ochre900` | #FF2E241A |
| `KlpPalette.terracotta50` | #FFEEDDD0 |
| `KlpPalette.terracotta300` | #FFC88745 |
| `KlpPalette.terracotta500` | #FFA96836 |
| `KlpPalette.terracotta800` | #FF3D2D22 |
| `KlpPalette.terracotta900` | #FF2C211B |
| `KlpPalette.clay50` | #FFE9D8D1 |
| `KlpPalette.clay300` | #FFA86D43 |
| `KlpPalette.clay500` | #FF895137 |
| `KlpPalette.clay800` | #FF382A23 |
| `KlpPalette.clay900` | #FF291F1C |
| `KlpPalette.umber50` | #FFE4D5D1 |
| `KlpPalette.umber300` | #FF89573E |
| `KlpPalette.umber500` | #FF683E33 |
| `KlpPalette.umber800` | #FF332724 |
| `KlpPalette.umber900` | #FF261D1C |
| `KlpPalette.green100` | #FFDFF0E5 |
| `KlpPalette.green400` | #FF67AE86 |
| `KlpPalette.green500` | #FF51B77B |
| `KlpPalette.green600` | #FF2D8057 |
| `KlpPalette.green800` | #FF243B2D |
| `KlpPalette.green900` | #FF1D3025 |
| `KlpPalette.red100` | #FFFAE3E2 |
| `KlpPalette.red300` | #FFFA6C73 |
| `KlpPalette.red400` | #FFD27B74 |
| `KlpPalette.red600` | #FFA7443F |
| `KlpPalette.red800` | #FF472925 |
| `KlpPalette.red900` | #FF3B2320 |
| `KlpPalette.amber500` | #FFF6B52E |
| `KlpPalette.blue500` | #FF5499DF |
| `KlpPalette.scrim` | #99010202 |
| `KlpPalette.line` | #00000000 |
| `KlpPalette.transparentSurface` | #9426292D |
| `KlpPalette.transparentSurfaceInset` | #A8404449 |
| `KlpPalette.pureWhite` | #FFFFFFFF |
| `KlpPalette.pureBlack` | #FF000000 |

## 可選強調色

| KlpAccent | 淺色 | 深色 |
|---|---|---|
| `ink` | #FF1D1D1D | #FFFFFFFF |
| `terracotta` | #FF92563C | #FFCB8E72 |
| `ochre` | #FF7D612F | #FFB99860 |
| `olive` | #FF5E6A39 | #FF94A366 |
| `slate` | #FF4E678A | #FF879EBD |
| `crimson` | #FF9F4B59 | #FFCE8A95 |

## 圖示語意

KlpIconWeight 有 thin、regular；字型為 Flaticon UIcons Thin Rounded／Regular Rounded，package=kallopis。Lucide SVG 資產另在 assets/icons/lucide，完整 glyph／圖示名稱屬資產清冊，不是數值 design token。圖示外框 slot 與 glyph 分開：space.icon=20、iconGlyph=18；其餘尺寸見完整 spacing 表。

## 私有八槽 preset 的現存原料（不是 Stable consumer API）

以下 KlpWorkspacePreset 仍存在於內部，但未從目前 Stable theme library 匯出。僅供原料對照；不可為了套用它重建 declarative schema、node／adapter／renderer。不要將它的 i0–i7 字級或距離階梯混成公開 KlpScale。

| 原料組 | i0 → i7 |
|---|---|
| distances | 0, 4, 8, 12, 20, 32, 40, 48 |
| radii | 0, 4, 6, 12, 16, 20, 24, 32 |
| strokeWidths | 0, 1, 1.5, 2, 2.5, 3, 3.5, 4 |
| fontSizes | 10, 12, 14, 16, 18, 20, 24, 32 |
| fontWeights | 100, 200, 300, 400, 500, 600, 700, 800 |
| lineHeights | 1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.8, 2 |
| letterSpacings | -0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.4 |
| durations(ms) | 0, 60, 100, 140, 180, 240, 320, 400 |
| fontFamilies | Noto Sans TC, IBM Plex Mono，其餘皆 Noto Sans TC（Flutter package ownership） |
| curves | 各槽都是 cubic(0.2,0,0.2,1) |
| warm light colors | #E7E4DD, #21201B, #EFEDE7, #F8F6F1, #6A655B, #E1DDD2, #22000000(ARGB), #305088 |
| warm dark colors | #201F1C, #F0EDE6, #292724, #35322D, #BAB5AA, #484339, #22000000(ARGB), #A0B8E0 |
| neutral light colors | #E5E5E5, #21201B, #EDEDED, #FAFAFA, #6A655B, #DEDEDE, #22000000(ARGB), #305088 |
| neutral dark colors | #222222, #F0EDE6, #292929, #323232, #BAB5AA, #444444, #22000000(ARGB), #A0B8E0 |

內部 compact density 以 extent H 計算：height=H、icon=H/2、padding=H/4、gap=3H/16、row=9H/8、lineHeight=9H/16、touchTarget=max(48,3H/2)、focusStroke=H/32、windowControl=3H/4。H=32 時依序為32、16、8、6、36、18、48、1、24；不是把所有公開 button 高度改成32。

內部紙材配方：surface.R<100 時 accent=#B5C3A2，否則#587449；sticky 深色以 RGB 全部<100 判別，sage=#3C4636／light #E1E6D7，非 sage=#544B30／light #EEE3B9。這些不是目前公開 semantic 欄位。

## 來源與驗證範圍

- 公開入口：lib/kallopis_theme.dart、lib/kallopis_foundation.dart。
- 模型：lib/src/styling/legacy_theme/；預設配方：lib/src/styling/presets/legacy/。
- Primitive：lib/src/styling/legacy_tokens/primitive_token.dart、internal/klp_palette.dart、internal/klp_accent.dart。
- 精確幾何追溯至 legacy_metrics，但未公開的舊 static aliases 不作新 consumer API，也不覆蓋現行 semantic 值。
- 元件狀態：klp_theme.dart、klp_theme_scope.dart、features/actions/button/internal/、foundation/interaction/primitives/klp_action_region_widget.dart。
- 文字角色：foundation/content/klp_text.dart；字型資產：pubspec.yaml。
- 目前 Frame：features/workspace/layout/klp_app_layout.dart、shell/panel/primitives/klp_panel_frame_view.dart；微立體：styling/presets/klp_frame_relief_recipe.dart。
- Flutter cubic 數值核對目前 package_config 指向的 D:/flutter/packages/flutter/lib/src/animation/curves.dart。

本次為唯讀來源整理與新增文件／資料匯出。以模型欄位覆蓋及 JSON encoder 欄位一致性核對完整性；未執行 Flutter decoder round-trip、編譯、測試或視覺驗收。資料檔為目前原始碼的靜態擷取，不能當作不同版本套件的執行驗證。原有未提交變更保留。

