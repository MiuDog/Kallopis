import 'package:flutter/widgets.dart';

import '../layout/klp_layout.dart';
import '../theme/klp_theme.dart';

/// 三欄工作區外殼：主要面板、舞台、次要面板，兩側可拖曳調寬並依斷點自動收合。
/// 這是桌面型應用最外層的版面骨架。
class KlpWorkbenchShell extends StatelessWidget {
  const KlpWorkbenchShell({
    super.key,
    required this.primary,
    required this.stage,
    required this.secondary,
    this.primaryVisible = true,
    this.secondaryVisible = true,
    this.primaryWidth,
    this.secondaryWidth,
    this.onPrimaryWidthChanged,
    this.onSecondaryWidthChanged,
    this.padding,
    this.paneGap,
    this.panePadding,
  }) : assert(paneGap == null || (paneGap >= 0 && paneGap != double.infinity));

  final Widget primary;
  final Widget stage;
  final Widget secondary;
  final bool primaryVisible;
  final bool secondaryVisible;
  final double? primaryWidth;
  final double? secondaryWidth;
  final ValueChanged<double>? onPrimaryWidthChanged;
  final ValueChanged<double>? onSecondaryWidthChanged;

  /// 外殼與三欄內容之間的額外留白。
  ///
  /// `null` 且使用預設 individual-pane 模式時不重複加入 App 外圈留白；
  /// 整體外圈由 `KlpApp` 統一管理。
  final EdgeInsetsGeometry? padding;

  /// 相鄰欄位之間的單一留白與拖曳命中寬度。
  ///
  /// 這是舊版的 shared-gap 模式；只有明確指定時才啟用。`null` 時每個 pane
  /// 預設各自擁有四周緊湊留白。
  final double? paneGap;

  /// 各欄位各自擁有的四周留白。
  ///
  /// 指定後，Primary、Stage、Secondary 會分別在自己的版面範圍內套用此留白；
  /// resize handle 疊在兩側欄位的留白區，不再額外佔用欄間寬度。
  /// `null` 且未指定 [paneGap] 時使用語意緊湊間距的一半。
  final EdgeInsetsGeometry? panePadding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final geometry = context.klp.geometry.layout;
    final effectivePrimaryWidth = primaryWidth ?? geometry.primaryPaneWidth;
    final effectiveSecondaryWidth =
        secondaryWidth ?? geometry.secondaryPaneWidth;
    final compact = context.klp.space.compact;
    final paneInset = compact / 2;
    final usesIndividualPanePadding = panePadding != null || paneGap == null;
    final effectivePadding =
        padding ??
        (usesIndividualPanePadding
            ? EdgeInsets.zero
            : EdgeInsets.fromLTRB(compact, 0, compact, compact));
    final effectivePaneGap = paneGap ?? context.klp.space.compact;

    if (usesIndividualPanePadding) {
      return _KlpIndividuallyPaddedWorkbench(
        primary: primary,
        stage: stage,
        secondary: secondary,
        primaryVisible: primaryVisible,
        secondaryVisible: secondaryVisible,
        primaryWidth: effectivePrimaryWidth,
        secondaryWidth: effectiveSecondaryWidth,
        onPrimaryWidthChanged: onPrimaryWidthChanged,
        onSecondaryWidthChanged: onSecondaryWidthChanged,
        outerPadding: effectivePadding,
        panePadding: panePadding ?? EdgeInsets.all(paneInset),
        resizeHandleWidth: compact,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final showPrimaryContent =
            primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneContentBreakpoint;
        final showPrimary =
            primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneBreakpoint;
        final showSecondary =
            secondaryVisible &&
            constraints.maxWidth >= geometry.secondaryPaneBreakpoint;
        final resolvedPrimaryWidth = showPrimaryContent
            ? effectivePrimaryWidth
            : context.klp.space.chromeRail + context.klp.space.base;

        return ColoredBox(
          color: tokens.app,
          child: Padding(
            padding: effectivePadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showPrimary) ...[
                  SizedBox(width: resolvedPrimaryWidth, child: primary),
                  KlpResizeHandle(
                    key: const ValueKey('primary-pane-resize-handle'),
                    enabled:
                        showPrimaryContent && onPrimaryWidthChanged != null,
                    width: effectivePaneGap,
                    onDelta: (delta) => onPrimaryWidthChanged?.call(
                      effectivePrimaryWidth + delta,
                    ),
                  ),
                ],
                Expanded(child: stage),
                if (showSecondary) ...[
                  KlpResizeHandle(
                    key: const ValueKey('secondary-pane-resize-handle'),
                    enabled: onSecondaryWidthChanged != null,
                    width: effectivePaneGap,
                    onDelta: (delta) => onSecondaryWidthChanged?.call(
                      effectiveSecondaryWidth - delta,
                    ),
                  ),
                  SizedBox(width: effectiveSecondaryWidth, child: secondary),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KlpIndividuallyPaddedWorkbench extends StatelessWidget {
  const _KlpIndividuallyPaddedWorkbench({
    required this.primary,
    required this.stage,
    required this.secondary,
    required this.primaryVisible,
    required this.secondaryVisible,
    required this.primaryWidth,
    required this.secondaryWidth,
    required this.onPrimaryWidthChanged,
    required this.onSecondaryWidthChanged,
    required this.outerPadding,
    required this.panePadding,
    required this.resizeHandleWidth,
  });

  final Widget primary;
  final Widget stage;
  final Widget secondary;
  final bool primaryVisible;
  final bool secondaryVisible;
  final double primaryWidth;
  final double secondaryWidth;
  final ValueChanged<double>? onPrimaryWidthChanged;
  final ValueChanged<double>? onSecondaryWidthChanged;
  final EdgeInsetsGeometry outerPadding;
  final EdgeInsetsGeometry panePadding;
  final double resizeHandleWidth;

  @override
  Widget build(BuildContext context) {
    final geometry = context.klp.geometry.layout;
    final resolvedPadding = panePadding.resolve(Directionality.of(context));

    return LayoutBuilder(
      builder: (context, constraints) {
        final showPrimaryContent =
            primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneContentBreakpoint;
        final showPrimary =
            primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneBreakpoint;
        final showSecondary =
            secondaryVisible &&
            constraints.maxWidth >= geometry.secondaryPaneBreakpoint;
        final resolvedPrimaryWidth = showPrimaryContent
            ? primaryWidth
            : context.klp.space.chromeRail + context.klp.space.base;

        return ColoredBox(
          color: context.klpColors.app,
          child: Padding(
            padding: outerPadding,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showPrimary)
                        SizedBox(
                          width: resolvedPrimaryWidth,
                          child: Padding(padding: panePadding, child: primary),
                        ),
                      Expanded(
                        child: Padding(padding: panePadding, child: stage),
                      ),
                      if (showSecondary)
                        SizedBox(
                          width: secondaryWidth,
                          child: Padding(
                            padding: panePadding,
                            child: secondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (showPrimaryContent && onPrimaryWidthChanged != null)
                  PositionedDirectional(
                    start: resolvedPrimaryWidth - resizeHandleWidth / 2,
                    top: resolvedPadding.top,
                    bottom: resolvedPadding.bottom,
                    width: resizeHandleWidth,
                    child: KlpResizeHandle(
                      key: const ValueKey('primary-pane-resize-handle'),
                      enabled: true,
                      width: resizeHandleWidth,
                      onDelta: (delta) =>
                          onPrimaryWidthChanged!(primaryWidth + delta),
                    ),
                  ),
                if (showSecondary && onSecondaryWidthChanged != null)
                  PositionedDirectional(
                    end: secondaryWidth - resizeHandleWidth / 2,
                    top: resolvedPadding.top,
                    bottom: resolvedPadding.bottom,
                    width: resizeHandleWidth,
                    child: KlpResizeHandle(
                      key: const ValueKey('secondary-pane-resize-handle'),
                      enabled: true,
                      width: resizeHandleWidth,
                      onDelta: (delta) =>
                          onSecondaryWidthChanged!(secondaryWidth - delta),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
