# KlpSpacingTheme

Flutter · Stable · 語意風格

## 主要職責

Layer 2：間距與密度的 semantic token。

這是換風格時差異最大的一組 token——高密度與寬鬆兩種取向用的是同一批元件。
因此 padding **必須**由 theme 提供；元件內寫死 `EdgeInsets.all(12)` 會讓該元件在
換風格時原地不動，是最典型的風格不對齊。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSpacingTheme createExample(double hairline, double tight, double base, double comfortable, double loose, double section, double page, double controlPaddingX, double controlPaddingY, double containerPadding, double itemGap, double groupGap, double controlHeight, double controlHeightSmall, double controlHeightLarge, double iconSmall, double icon, double iconLarge, double chromeHeader, double chromeStatusBar, double chromeRail, double chromeTab, double iconButton, double iconTiny, double indicatorDot, double indicatorDotLarge, double noticeIconSlot, double toastIconSlot, double gutterNumber, double gutterMarker, double micro, double calendarContentCell, double iconMicro, double avatarSmall, double progressTrack, double skeletonLine, double railItem) => KlpSpacingTheme(hairline: hairline, tight: tight, base: base, comfortable: comfortable, loose: loose, section: section, page: page, controlPaddingX: controlPaddingX, controlPaddingY: controlPaddingY, containerPadding: containerPadding, itemGap: itemGap, groupGap: groupGap, controlHeight: controlHeight, controlHeightSmall: controlHeightSmall, controlHeightLarge: controlHeightLarge, iconSmall: iconSmall, icon: icon, iconLarge: iconLarge, chromeHeader: chromeHeader, chromeStatusBar: chromeStatusBar, chromeRail: chromeRail, chromeTab: chromeTab, iconButton: iconButton, iconTiny: iconTiny, indicatorDot: indicatorDot, indicatorDotLarge: indicatorDotLarge, noticeIconSlot: noticeIconSlot, toastIconSlot: toastIconSlot, gutterNumber: gutterNumber, gutterMarker: gutterMarker, micro: micro, calendarContentCell: calendarContentCell, iconMicro: iconMicro, avatarSmall: avatarSmall, progressTrack: progressTrack, skeletonLine: skeletonLine, railItem: railItem);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSpacingTheme extends ThemeExtension<KlpSpacingTheme>
```

## 建構子 KlpSpacingTheme



```dart
const KlpSpacingTheme({
	double space0_5 = KlpScale.space50,
	double space1 = KlpScale.space100,
	double space2 = KlpScale.space200,
	double space3 = KlpScale.space300,
	double space4 = KlpScale.space400,
	double space6 = KlpScale.space600,
	double space8 = KlpScale.space800,
	double space12 = KlpScale.space1200,
	double space16 = KlpScale.space1600,
	double space24 = KlpScale.space2400,
	required double hairline,
	required double tight,
	double contentInlineGap = KlpScale.space200,
	double contentStackGap = KlpScale.space200,
	double contentInset = KlpScale.space200,
	double controlContentGap = KlpScale.space200,
	double controlInset = KlpScale.space200,
	double actionGap = KlpScale.space200,
	double chromeGap = KlpScale.space200,
	double chromePanelInset = KlpScale.space200,
	double chromeToolbarGap = KlpScale.space200,
	double navigationItemInset = KlpScale.space200,
	double navigationRailInset = KlpScale.space200,
	double navigationRailItemGap = KlpScale.space200,
	double overlayContentInset = KlpScale.space200,
	double overlayHeadingGap = KlpScale.space200,
	double overlayItemGap = KlpScale.space200,
	double navigationSectionGap = KlpScale.space200 - KlpScale.space50,
	double appFrameInset = KlpScale.space100,
	double windowHeaderMargin = KlpScale.space100,
	double dockMargin = KlpScale.space100,
	required double base,
	required double comfortable,
	required double loose,
	required double section,
	double sectionLarge = KlpScale.space1200,
	required double page,
	double pageLarge = KlpScale.space2400,
	double controlPaddingXSmall = KlpScale.space300,
	required double controlPaddingX,
	double controlPaddingXLarge = KlpScale.space600,
	double controlPaddingXXLarge = KlpScale.space800,
	required double controlPaddingY,
	required double containerPadding,
	required double itemGap,
	required double groupGap,
	required double controlHeight,
	double controlHeightXSmall = 30,
	required double controlHeightSmall,
	required double controlHeightLarge,
	double controlHeightXLarge = 56,
	required double iconSmall,
	double iconBase = 16,
	double iconGlyph = 18,
	required double icon,
	double iconMedium = 24,
	required double iconLarge,
	required double chromeHeader,
	required double chromeStatusBar,
	required double chromeRail,
	required double chromeTab,
	required double iconButton,
	required double iconTiny,
	required double indicatorDot,
	required double indicatorDotLarge,
	required double noticeIconSlot,
	required double toastIconSlot,
	required double gutterNumber,
	required double gutterMarker,
	required double micro,
	required double calendarContentCell,
	double gridTileWidth = 170,
	required double iconMicro,
	required double avatarSmall,
	required double progressTrack,
	required double skeletonLine,
	required double railItem,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `space0_5` | `double` | 否 | KlpScale.space50 | 依公開型別提供此輸入。 |
| `space1` | `double` | 否 | KlpScale.space100 | 依公開型別提供此輸入。 |
| `space2` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `space3` | `double` | 否 | KlpScale.space300 | 依公開型別提供此輸入。 |
| `space4` | `double` | 否 | KlpScale.space400 | 依公開型別提供此輸入。 |
| `space6` | `double` | 否 | KlpScale.space600 | 依公開型別提供此輸入。 |
| `space8` | `double` | 否 | KlpScale.space800 | 依公開型別提供此輸入。 |
| `space12` | `double` | 否 | KlpScale.space1200 | 依公開型別提供此輸入。 |
| `space16` | `double` | 否 | KlpScale.space1600 | 依公開型別提供此輸入。 |
| `space24` | `double` | 否 | KlpScale.space2400 | 依公開型別提供此輸入。 |
| `hairline` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `tight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `contentInlineGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `contentStackGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `contentInset` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `controlContentGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `controlInset` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `actionGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `chromeGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `chromePanelInset` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `chromeToolbarGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `navigationItemInset` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `navigationRailInset` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `navigationRailItemGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `overlayContentInset` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `overlayHeadingGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `overlayItemGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `navigationSectionGap` | `double` | 否 | KlpScale.space200 - KlpScale.space50 | 依公開型別提供此輸入。 |
| `appFrameInset` | `double` | 否 | KlpScale.space100 | 依公開型別提供此輸入。 |
| `windowHeaderMargin` | `double` | 否 | KlpScale.space100 | 依公開型別提供此輸入。 |
| `dockMargin` | `double` | 否 | KlpScale.space100 | 依公開型別提供此輸入。 |
| `base` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `comfortable` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `loose` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `section` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `sectionLarge` | `double` | 否 | KlpScale.space1200 | 依公開型別提供此輸入。 |
| `page` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `pageLarge` | `double` | 否 | KlpScale.space2400 | 依公開型別提供此輸入。 |
| `controlPaddingXSmall` | `double` | 否 | KlpScale.space300 | 依公開型別提供此輸入。 |
| `controlPaddingX` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `controlPaddingXLarge` | `double` | 否 | KlpScale.space600 | 依公開型別提供此輸入。 |
| `controlPaddingXXLarge` | `double` | 否 | KlpScale.space800 | 依公開型別提供此輸入。 |
| `controlPaddingY` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `containerPadding` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `itemGap` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `groupGap` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `controlHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `controlHeightXSmall` | `double` | 否 | 30 | 依公開型別提供此輸入。 |
| `controlHeightSmall` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `controlHeightLarge` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `controlHeightXLarge` | `double` | 否 | 56 | 依公開型別提供此輸入。 |
| `iconSmall` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `iconBase` | `double` | 否 | 16 | 依公開型別提供此輸入。 |
| `iconGlyph` | `double` | 否 | 18 | 畫在 [icon] 尺寸格子裡的字形大小。<br><br>導覽列等圖示保留固定格線，但字形略小，避免字形頂滿格線而顯得過重。 |
| `icon` | `double` | 是 | — | 操作或內容圖示。 |
| `iconMedium` | `double` | 否 | 24 | 依公開型別提供此輸入。 |
| `iconLarge` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `chromeHeader` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `chromeStatusBar` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `chromeRail` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `chromeTab` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `iconButton` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `iconTiny` | `double` | 是 | — | 10px。狀態圓點形式的圖示 |
| `indicatorDot` | `double` | 是 | — | 6px。狀態圓點（badge、狀態列） |
| `indicatorDotLarge` | `double` | 是 | — | 8px。導覽軌上的未讀圓點 |
| `noticeIconSlot` | `double` | 是 | — | 28px。行內提示的圖示格 |
| `toastIconSlot` | `double` | 是 | — | 22px。浮動提示的圖示格 |
| `gutterNumber` | `double` | 是 | — | 24px。程式碼行號欄寬 |
| `gutterMarker` | `double` | 是 | — | 14px。差異標記欄寬 |
| `micro` | `double` | 是 | — | 1px。視覺上僅作分隔用的最小間隙 |
| `calendarContentCell` | `double` | 是 | — | 帶內容的月曆日期格最小高度。<br><br>只在 [KlpCalendar] 給了 `dayContentBuilder` 時生效——純日期選擇的格子用<br>[controlHeightSmall]，塞進內容後那個高度會擠成一團。 |
| `gridTileWidth` | `double` | 否 | 170 | 卡片式網格的單欄寬度。<br><br>瀑布流與磚牆排版以單欄寬度維持規律節奏；元件只能讀此語意 token，<br>不得把欄寬分散成各自的風格常數。 |
| `iconMicro` | `double` | 是 | — | 11px。狀態字形用的最小圖示 |
| `avatarSmall` | `double` | 是 | — | 28px。頭像堆疊中的小頭像 |
| `progressTrack` | `double` | 是 | — | 3px。進度條軌道厚度 |
| `skeletonLine` | `double` | 是 | — | 10px。骨架屏的單行高 |
| `railItem` | `double` | 是 | — | 32px。導覽軌上的正方形可點區塊。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### comfortableDensity

```dart
static const KlpSpacingTheme comfortableDensity
```

現代風：呼吸感優先，控制項預設 40px。

### containerInsets

```dart
EdgeInsets get containerInsets
```



### controlInsets

```dart
EdgeInsets get controlInsets
```



### copyWith

```dart
KlpSpacingTheme copyWith({
	double? iconTiny,
	double? indicatorDot,
	double? indicatorDotLarge,
	double? noticeIconSlot,
	double? toastIconSlot,
	double? gutterNumber,
	double? gutterMarker,
	double? micro,
	double? calendarContentCell,
	double? gridTileWidth,
	double? iconMicro,
	double? avatarSmall,
	double? progressTrack,
	double? skeletonLine,
	double? railItem,
	double? space0_5,
	double? space1,
	double? space2,
	double? space3,
	double? space4,
	double? space6,
	double? space8,
	double? space12,
	double? space16,
	double? space24,
	double? hairline,
	double? tight,
	double? contentInlineGap,
	double? contentStackGap,
	double? contentInset,
	double? controlContentGap,
	double? controlInset,
	double? actionGap,
	double? chromeGap,
	double? chromePanelInset,
	double? chromeToolbarGap,
	double? navigationItemInset,
	double? navigationRailInset,
	double? navigationRailItemGap,
	double? overlayContentInset,
	double? overlayHeadingGap,
	double? overlayItemGap,
	double? navigationSectionGap,
	double? appFrameInset,
	double? windowHeaderMargin,
	double? dockMargin,
	double? base,
	double? comfortable,
	double? loose,
	double? section,
	double? sectionLarge,
	double? page,
	double? pageLarge,
	double? controlPaddingXSmall,
	double? controlPaddingX,
	double? controlPaddingXLarge,
	double? controlPaddingXXLarge,
	double? controlPaddingY,
	double? containerPadding,
	double? itemGap,
	double? groupGap,
	double? controlHeight,
	double? controlHeightXSmall,
	double? controlHeightSmall,
	double? controlHeightLarge,
	double? controlHeightXLarge,
	double? iconSmall,
	double? iconBase,
	double? iconGlyph,
	double? icon,
	double? iconMedium,
	double? iconLarge,
	double? chromeHeader,
	double? chromeStatusBar,
	double? chromeRail,
	double? chromeTab,
	double? iconButton,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `iconTiny` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `indicatorDot` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `indicatorDotLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `noticeIconSlot` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `toastIconSlot` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `gutterNumber` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `gutterMarker` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `micro` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `calendarContentCell` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `gridTileWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `iconMicro` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `avatarSmall` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `progressTrack` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `skeletonLine` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `railItem` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space0_5` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space1` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space2` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space3` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space4` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space6` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space8` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space12` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space16` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `space24` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `hairline` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `tight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `contentInlineGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `contentStackGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `contentInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlContentGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `actionGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `chromeGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `chromePanelInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `chromeToolbarGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `navigationItemInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `navigationRailInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `navigationRailItemGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayContentInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayHeadingGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayItemGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `navigationSectionGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `appFrameInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `windowHeaderMargin` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `dockMargin` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `base` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `comfortable` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `loose` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `section` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `sectionLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `page` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `pageLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlPaddingXSmall` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlPaddingX` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlPaddingXLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlPaddingXXLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlPaddingY` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `containerPadding` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `itemGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `groupGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlHeightXSmall` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlHeightSmall` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlHeightLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlHeightXLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `iconSmall` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `iconBase` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `iconGlyph` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `icon` | `double?` | 否 | null | 操作或內容圖示。 |
| `iconMedium` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `iconLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `chromeHeader` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `chromeStatusBar` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `chromeRail` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `chromeTab` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `iconButton` | `double?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



### lerp

```dart
KlpSpacingTheme lerp(KlpSpacingTheme? other, double t)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpSpacingTheme?` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### xxs

```dart
double get xxs
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ThemeExtension<KlpSpacingTheme>](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)。
- [KlpCalendar](../components/content/klp-calendar.md)
- [KlpScale](klp-scale.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_spacing_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_spacing_theme.dart`。
