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
    required this.settingsContentMaximumWidth,
    required this.themePreviewTileWidth,
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

  /// Settings 內容欄的閱讀寬度上限。
  final double settingsContentMaximumWidth;

  /// 顏色模式預覽磚的預設寬度。
  final double themePreviewTileWidth;

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
          settingsContentMaximumWidth == other.settingsContentMaximumWidth &&
          themePreviewTileWidth == other.themePreviewTileWidth &&
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
    settingsContentMaximumWidth,
    themePreviewTileWidth,
    windowAppIconSize,
    windowIdentityGap,
  ]);
}
