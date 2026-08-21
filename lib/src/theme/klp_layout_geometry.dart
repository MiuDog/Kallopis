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
          statusBarBreakpoint == other.statusBarBreakpoint;

  @override
  int get hashCode => Object.hash(
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
  );
}
