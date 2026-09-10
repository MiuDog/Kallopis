import 'package:flutter/foundation.dart';

import '../legacy_tokens/primitive_token.dart';

/// Shell、overlay 與 responsive layout 的精確幾何。
@immutable
class KlpLayoutGeometry {
  const KlpLayoutGeometry({
    this.drawerWidth = 320,
    this.drawerHeight = 320,

    this.resizeHandleExtent = KlpScale.space200,
    this.overlayViewportInset = KlpScale.space200,
    this.railDropTargetExtent = KlpScale.space200,
    this.disclosureIconSize = KlpScale.space200,
    this.treeLeadingGap = KlpScale.space200,
    this.tooltipOffsetX = KlpScale.space200,

    required this.primaryPaneWidth,
    required this.secondaryPaneWidth,
    required this.primaryPaneBreakpoint,
    required this.primaryPaneContentBreakpoint,
    required this.responsivePaneBreakpoint,
    required this.secondaryPaneBreakpoint,
    required this.menuWidth,
    required this.commandMenuWidth,
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

  final double drawerWidth;
  final double drawerHeight;
  final double resizeHandleExtent;
  final double overlayViewportInset;
  final double railDropTargetExtent;
  final double disclosureIconSize;
  final double treeLeadingGap;
  final double tooltipOffsetX;
  final double primaryPaneWidth;
  final double secondaryPaneWidth;
  final double primaryPaneBreakpoint;
  final double primaryPaneContentBreakpoint;
  final double responsivePaneBreakpoint;
  final double secondaryPaneBreakpoint;

  final double menuWidth;
  final double commandMenuWidth;
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

  /// Header 可視表面與版面占位高度。
  final double windowHeaderHeight;

  /// 視窗 Header 內正方形控制按鈕的語意尺寸。
  final double windowHeaderControlSize;

  /// 視窗 Header 按鈕內部圖示的語意尺寸。
  final double windowAppIconSize;
  final double windowIdentityGap;

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
  }) => KlpLayoutGeometry(
    drawerWidth: drawerWidth ?? this.drawerWidth,
    drawerHeight: drawerHeight ?? this.drawerHeight,

    resizeHandleExtent: resizeHandleExtent ?? this.resizeHandleExtent,
    overlayViewportInset: overlayViewportInset ?? this.overlayViewportInset,
    railDropTargetExtent: railDropTargetExtent ?? this.railDropTargetExtent,
    disclosureIconSize: disclosureIconSize ?? this.disclosureIconSize,
    treeLeadingGap: treeLeadingGap ?? this.treeLeadingGap,
    tooltipOffsetX: tooltipOffsetX ?? this.tooltipOffsetX,

    primaryPaneWidth: primaryPaneWidth ?? this.primaryPaneWidth,
    secondaryPaneWidth: secondaryPaneWidth ?? this.secondaryPaneWidth,
    primaryPaneBreakpoint: primaryPaneBreakpoint ?? this.primaryPaneBreakpoint,
    primaryPaneContentBreakpoint:
        primaryPaneContentBreakpoint ?? this.primaryPaneContentBreakpoint,
    responsivePaneBreakpoint:
        responsivePaneBreakpoint ?? this.responsivePaneBreakpoint,
    secondaryPaneBreakpoint:
        secondaryPaneBreakpoint ?? this.secondaryPaneBreakpoint,
    menuWidth: menuWidth ?? this.menuWidth,
    commandMenuWidth: commandMenuWidth ?? this.commandMenuWidth,
    menuHeaderHeight: menuHeaderHeight ?? this.menuHeaderHeight,
    menuItemHeight: menuItemHeight ?? this.menuItemHeight,
    dialogMaximumWidth: dialogMaximumWidth ?? this.dialogMaximumWidth,
    toastMaximumWidth: toastMaximumWidth ?? this.toastMaximumWidth,
    inlineNoticeBreakpoint:
        inlineNoticeBreakpoint ?? this.inlineNoticeBreakpoint,
    statusBarBreakpoint: statusBarBreakpoint ?? this.statusBarBreakpoint,
    settingsDialogMaximumWidth:
        settingsDialogMaximumWidth ?? this.settingsDialogMaximumWidth,
    settingsDialogMaximumHeight:
        settingsDialogMaximumHeight ?? this.settingsDialogMaximumHeight,
    settingsPaneGap: settingsPaneGap ?? this.settingsPaneGap,
    settingsNavigationWidth:
        settingsNavigationWidth ?? this.settingsNavigationWidth,
    settingsNavigationMinimumWidth:
        settingsNavigationMinimumWidth ?? this.settingsNavigationMinimumWidth,
    settingsNavigationMaximumWidth:
        settingsNavigationMaximumWidth ?? this.settingsNavigationMaximumWidth,
    settingsContentMaximumWidth:
        settingsContentMaximumWidth ?? this.settingsContentMaximumWidth,
    themePreviewTileWidth: themePreviewTileWidth ?? this.themePreviewTileWidth,
    windowHeaderHeight: windowHeaderHeight ?? this.windowHeaderHeight,
    windowHeaderControlSize:
        windowHeaderControlSize ?? this.windowHeaderControlSize,
    windowAppIconSize: windowAppIconSize ?? this.windowAppIconSize,
    windowIdentityGap: windowIdentityGap ?? this.windowIdentityGap,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpLayoutGeometry &&
          drawerWidth == other.drawerWidth &&
          drawerHeight == other.drawerHeight &&
          resizeHandleExtent == other.resizeHandleExtent &&
          overlayViewportInset == other.overlayViewportInset &&
          railDropTargetExtent == other.railDropTargetExtent &&
          disclosureIconSize == other.disclosureIconSize &&
          treeLeadingGap == other.treeLeadingGap &&
          tooltipOffsetX == other.tooltipOffsetX &&
          primaryPaneWidth == other.primaryPaneWidth &&
          secondaryPaneWidth == other.secondaryPaneWidth &&
          primaryPaneBreakpoint == other.primaryPaneBreakpoint &&
          primaryPaneContentBreakpoint == other.primaryPaneContentBreakpoint &&
          responsivePaneBreakpoint == other.responsivePaneBreakpoint &&
          secondaryPaneBreakpoint == other.secondaryPaneBreakpoint &&
          menuWidth == other.menuWidth &&
          commandMenuWidth == other.commandMenuWidth &&
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
    drawerWidth,
    drawerHeight,

    resizeHandleExtent,
    overlayViewportInset,
    railDropTargetExtent,
    disclosureIconSize,
    treeLeadingGap,
    tooltipOffsetX,

    primaryPaneWidth,
    secondaryPaneWidth,
    primaryPaneBreakpoint,
    primaryPaneContentBreakpoint,
    responsivePaneBreakpoint,
    secondaryPaneBreakpoint,
    menuWidth,
    commandMenuWidth,
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
