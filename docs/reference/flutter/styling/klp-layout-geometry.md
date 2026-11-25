# KlpLayoutGeometry

Flutter · Stable · 語意風格

## 主要職責

Shell、overlay 與 responsive layout 的精確幾何。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpLayoutGeometry createExample(double primaryPaneWidth, double secondaryPaneWidth, double primaryPaneBreakpoint, double primaryPaneContentBreakpoint, double responsivePaneBreakpoint, double secondaryPaneBreakpoint, double menuWidth, double commandMenuWidth, double menuHeaderHeight, double menuItemHeight, double dialogMaximumWidth, double toastMaximumWidth, double inlineNoticeBreakpoint, double statusBarBreakpoint, double settingsDialogMaximumWidth, double settingsDialogMaximumHeight, double settingsPaneGap, double settingsNavigationWidth, double settingsNavigationMinimumWidth, double settingsNavigationMaximumWidth, double settingsContentMaximumWidth, double themePreviewTileWidth, double windowHeaderHeight, double windowHeaderControlSize, double windowAppIconSize, double windowIdentityGap) => KlpLayoutGeometry(primaryPaneWidth: primaryPaneWidth, secondaryPaneWidth: secondaryPaneWidth, primaryPaneBreakpoint: primaryPaneBreakpoint, primaryPaneContentBreakpoint: primaryPaneContentBreakpoint, responsivePaneBreakpoint: responsivePaneBreakpoint, secondaryPaneBreakpoint: secondaryPaneBreakpoint, menuWidth: menuWidth, commandMenuWidth: commandMenuWidth, menuHeaderHeight: menuHeaderHeight, menuItemHeight: menuItemHeight, dialogMaximumWidth: dialogMaximumWidth, toastMaximumWidth: toastMaximumWidth, inlineNoticeBreakpoint: inlineNoticeBreakpoint, statusBarBreakpoint: statusBarBreakpoint, settingsDialogMaximumWidth: settingsDialogMaximumWidth, settingsDialogMaximumHeight: settingsDialogMaximumHeight, settingsPaneGap: settingsPaneGap, settingsNavigationWidth: settingsNavigationWidth, settingsNavigationMinimumWidth: settingsNavigationMinimumWidth, settingsNavigationMaximumWidth: settingsNavigationMaximumWidth, settingsContentMaximumWidth: settingsContentMaximumWidth, themePreviewTileWidth: themePreviewTileWidth, windowHeaderHeight: windowHeaderHeight, windowHeaderControlSize: windowHeaderControlSize, windowAppIconSize: windowAppIconSize, windowIdentityGap: windowIdentityGap);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpLayoutGeometry
```

## 建構子 KlpLayoutGeometry



```dart
const KlpLayoutGeometry({
	double drawerWidth = 320,
	double drawerHeight = 320,
	double resizeHandleExtent = KlpScale.space200,
	double overlayViewportInset = KlpScale.space200,
	double railDropTargetExtent = KlpScale.space200,
	double disclosureIconSize = KlpScale.space200,
	double treeLeadingGap = KlpScale.space200,
	double tooltipOffsetX = KlpScale.space200,
	required double primaryPaneWidth,
	required double secondaryPaneWidth,
	required double primaryPaneBreakpoint,
	required double primaryPaneContentBreakpoint,
	required double responsivePaneBreakpoint,
	required double secondaryPaneBreakpoint,
	required double menuWidth,
	required double commandMenuWidth,
	required double menuHeaderHeight,
	required double menuItemHeight,
	required double dialogMaximumWidth,
	required double toastMaximumWidth,
	required double inlineNoticeBreakpoint,
	required double statusBarBreakpoint,
	required double settingsDialogMaximumWidth,
	required double settingsDialogMaximumHeight,
	required double settingsPaneGap,
	required double settingsNavigationWidth,
	required double settingsNavigationMinimumWidth,
	required double settingsNavigationMaximumWidth,
	required double settingsContentMaximumWidth,
	required double themePreviewTileWidth,
	required double windowHeaderHeight,
	required double windowHeaderControlSize,
	required double windowAppIconSize,
	required double windowIdentityGap,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `drawerWidth` | `double` | 否 | 320 | 依公開型別提供此輸入。 |
| `drawerHeight` | `double` | 否 | 320 | 依公開型別提供此輸入。 |
| `resizeHandleExtent` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `overlayViewportInset` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `railDropTargetExtent` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `disclosureIconSize` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `treeLeadingGap` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `tooltipOffsetX` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `primaryPaneWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `secondaryPaneWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `primaryPaneBreakpoint` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `primaryPaneContentBreakpoint` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `responsivePaneBreakpoint` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `secondaryPaneBreakpoint` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `menuWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `commandMenuWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `menuHeaderHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `menuItemHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `dialogMaximumWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `toastMaximumWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `inlineNoticeBreakpoint` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `statusBarBreakpoint` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `settingsDialogMaximumWidth` | `double` | 是 | — | Settings modal 的桌面尺寸上限與兩個獨立 pane 之間的間距。 |
| `settingsDialogMaximumHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `settingsPaneGap` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `settingsNavigationWidth` | `double` | 是 | — | Settings 寬版導覽欄的預設、最小與最大寬度。 |
| `settingsNavigationMinimumWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `settingsNavigationMaximumWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `settingsContentMaximumWidth` | `double` | 是 | — | Settings 內容欄的閱讀寬度上限。 |
| `themePreviewTileWidth` | `double` | 是 | — | 顏色模式預覽磚的預設寬度。 |
| `windowHeaderHeight` | `double` | 是 | — | Header 可視表面與版面占位高度。 |
| `windowHeaderControlSize` | `double` | 是 | — | 視窗 Header 內正方形控制按鈕的語意尺寸。 |
| `windowAppIconSize` | `double` | 是 | — | 視窗 Header 按鈕內部圖示的語意尺寸。 |
| `windowIdentityGap` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### copyWith

```dart
KlpLayoutGeometry copyWith({
	double? drawerWidth,
	double? drawerHeight,
	double? resizeHandleExtent,
	double? overlayViewportInset,
	double? railDropTargetExtent,
	double? disclosureIconSize,
	double? treeLeadingGap,
	double? tooltipOffsetX,
	double? primaryPaneWidth,
	double? secondaryPaneWidth,
	double? primaryPaneBreakpoint,
	double? primaryPaneContentBreakpoint,
	double? responsivePaneBreakpoint,
	double? secondaryPaneBreakpoint,
	double? menuWidth,
	double? commandMenuWidth,
	double? menuHeaderHeight,
	double? menuItemHeight,
	double? dialogMaximumWidth,
	double? toastMaximumWidth,
	double? inlineNoticeBreakpoint,
	double? statusBarBreakpoint,
	double? settingsDialogMaximumWidth,
	double? settingsDialogMaximumHeight,
	double? settingsPaneGap,
	double? settingsNavigationWidth,
	double? settingsNavigationMinimumWidth,
	double? settingsNavigationMaximumWidth,
	double? settingsContentMaximumWidth,
	double? themePreviewTileWidth,
	double? windowHeaderHeight,
	double? windowHeaderControlSize,
	double? windowAppIconSize,
	double? windowIdentityGap,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `drawerWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `drawerHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `resizeHandleExtent` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayViewportInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `railDropTargetExtent` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `disclosureIconSize` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `treeLeadingGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `tooltipOffsetX` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `primaryPaneWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `secondaryPaneWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `primaryPaneBreakpoint` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `primaryPaneContentBreakpoint` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `responsivePaneBreakpoint` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `secondaryPaneBreakpoint` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `menuWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `commandMenuWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `menuHeaderHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `menuItemHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `dialogMaximumWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `toastMaximumWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `inlineNoticeBreakpoint` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `statusBarBreakpoint` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `settingsDialogMaximumWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `settingsDialogMaximumHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `settingsPaneGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `settingsNavigationWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `settingsNavigationMinimumWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `settingsNavigationMaximumWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `settingsContentMaximumWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `themePreviewTileWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `windowHeaderHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `windowHeaderControlSize` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `windowAppIconSize` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `windowIdentityGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpScale](klp-scale.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_layout_geometry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_layout_geometry.dart`。
