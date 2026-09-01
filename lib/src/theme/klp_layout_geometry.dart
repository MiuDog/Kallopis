import 'package:flutter/foundation.dart';

/// Shell、overlay 與 responsive layout 的精確幾何。
@immutable
class KlpLayoutGeometry {
  const KlpLayoutGeometry({
    required this.primaryPaneWidth,
    required this.secondaryPaneWidth,
    required this.primaryPaneBreakpoint,
    required this.primaryPaneContentBreakpoint,
    required this.secondaryPaneBreakpoint,
    required this.menuWidth,
    required this.menuHeaderHeight,
    required this.menuItemHeight,
    required this.dialogMaximumWidth,
    required this.toastMaximumWidth,
    required this.inlineNoticeBreakpoint,
    required this.statusBarBreakpoint,
    required this.settingsDialogMaximumWidth,
    required this.settingsDialogMaximumHeight,
    required this.settingsPaneGap,
    required this.settingsNavigationWidth,
    required this.settingsNavigationMinimumWidth,
    required this.settingsNavigationMaximumWidth,
    required this.settingsContentMaximumWidth,
    required this.themePreviewTileWidth,
    required this.windowHeaderHeight,
    required this.windowHeaderControlSize,
    required this.windowAppIconSize,
    required this.windowIdentityGap,
  });

  final double primaryPaneWidth;
  final double secondaryPaneWidth;
  final double primaryPaneBreakpoint;
  final double primaryPaneContentBreakpoint;
  final double secondaryPaneBreakpoint;

  final double menuWidth;
  final double menuHeaderHeight;
  final double menuItemHeight;
  final double dialogMaximumWidth;
  final double toastMaximumWidth;
  final double inlineNoticeBreakpoint;
  final double statusBarBreakpoint;

  /// Settings modal 的桌面尺寸上限與兩個獨立 pane 之間的間距。
  final double settingsDialogMaximumWidth;
  final double settingsDialogMaximumHeight;
  final double settingsPaneGap;

  /// Settings 寬版導覽欄的預設、最小與最大寬度。
  final double settingsNavigationWidth;
  final double settingsNavigationMinimumWidth;
  final double settingsNavigationMaximumWidth;

  /// Settings 內容欄的閱讀寬度上限。
  final double settingsContentMaximumWidth;

  /// 顏色模式預覽磚的預設寬度。
  final double themePreviewTileWidth;

  /// Header 可視表面高度；版面占位另加四周各半個 compact margin。
  final double windowHeaderHeight;

  /// 視窗 Header 內正方形控制按鈕的語意尺寸。
  final double windowHeaderControlSize;

  /// 視窗 Header 按鈕內部圖示的語意尺寸。
  final double windowAppIconSize;
  final double windowIdentityGap;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpLayoutGeometry &&
          primaryPaneWidth == other.primaryPaneWidth &&
          secondaryPaneWidth == other.secondaryPaneWidth &&
          primaryPaneBreakpoint == other.primaryPaneBreakpoint &&
          primaryPaneContentBreakpoint == other.primaryPaneContentBreakpoint &&
          secondaryPaneBreakpoint == other.secondaryPaneBreakpoint &&
          menuWidth == other.menuWidth &&
          menuHeaderHeight == other.menuHeaderHeight &&
          menuItemHeight == other.menuItemHeight &&
          dialogMaximumWidth == other.dialogMaximumWidth &&
          toastMaximumWidth == other.toastMaximumWidth &&
          inlineNoticeBreakpoint == other.inlineNoticeBreakpoint &&
          statusBarBreakpoint == other.statusBarBreakpoint &&
          settingsDialogMaximumWidth == other.settingsDialogMaximumWidth &&
          settingsDialogMaximumHeight == other.settingsDialogMaximumHeight &&
          settingsPaneGap == other.settingsPaneGap &&
          settingsNavigationWidth == other.settingsNavigationWidth &&
          settingsNavigationMinimumWidth ==
              other.settingsNavigationMinimumWidth &&
          settingsNavigationMaximumWidth ==
              other.settingsNavigationMaximumWidth &&
          settingsContentMaximumWidth == other.settingsContentMaximumWidth &&
          themePreviewTileWidth == other.themePreviewTileWidth &&
          windowHeaderHeight == other.windowHeaderHeight &&
          windowHeaderControlSize == other.windowHeaderControlSize &&
          windowAppIconSize == other.windowAppIconSize &&
          windowIdentityGap == other.windowIdentityGap;

  @override
  int get hashCode => Object.hashAll([
    primaryPaneWidth,
    secondaryPaneWidth,
    primaryPaneBreakpoint,
    primaryPaneContentBreakpoint,
    secondaryPaneBreakpoint,
    menuWidth,
    menuHeaderHeight,
    menuItemHeight,
    dialogMaximumWidth,
    toastMaximumWidth,
    inlineNoticeBreakpoint,
    statusBarBreakpoint,
    settingsDialogMaximumWidth,
    settingsDialogMaximumHeight,
    settingsPaneGap,
    settingsNavigationWidth,
    settingsNavigationMinimumWidth,
    settingsNavigationMaximumWidth,
    settingsContentMaximumWidth,
    themePreviewTileWidth,
    windowHeaderHeight,
    windowHeaderControlSize,
    windowAppIconSize,
    windowIdentityGap,
  ]);
}
