import 'package:flutter/widgets.dart';

import '../layout/klp_layout.dart';
import '../theme/klp_theme.dart';

/// Workbench pane 可由產品注入的寬度限制。
///
/// Kallopis 負責在拖曳預覽與提交時套用限制；產品只需決定允許的尺寸範圍。
@immutable
class KlpPaneWidthConstraints {
  const KlpPaneWidthConstraints({
    required this.minWidth,
    this.maxWidth = double.infinity,
  }) : assert(minWidth >= 0 && minWidth != double.infinity),
       assert(maxWidth >= minWidth);

  final double minWidth;
  final double maxWidth;

  double constrain(double width) => width.clamp(minWidth, maxWidth).toDouble();
}

/// 工作區外殼：主要面板、舞台與選用的次要面板。
/// 這是桌面型應用最外層的版面骨架。
class KlpWorkbenchShell extends StatefulWidget {
  const KlpWorkbenchShell({
    super.key,
    required this.primary,
    required this.stage,
    this.secondary,
    this.primaryVisible = true,
    this.secondaryVisible = true,
    this.primaryWidth,
    this.secondaryWidth,
    this.primaryWidthConstraints,
    this.secondaryWidthConstraints,
    this.onPrimaryWidthChanged,
    this.onSecondaryWidthChanged,
    this.onPrimaryWidthChangeEnd,
    this.onSecondaryWidthChangeEnd,
    this.padding,
    this.paneGap,
    this.paneMargin,
    this.panePadding,
  }) : assert(paneGap == null || (paneGap >= 0 && paneGap != double.infinity)),
       assert(
         paneMargin == null || panePadding == null,
         'paneMargin and panePadding cannot both be provided.',
       );

  final Widget primary;
  final Widget stage;
  final Widget? secondary;

  final bool primaryVisible;
  final bool secondaryVisible;
  final double? primaryWidth;
  final double? secondaryWidth;

  /// Primary pane 的產品尺寸限制；未提供時不額外限制語意預設寬度。
  final KlpPaneWidthConstraints? primaryWidthConstraints;

  /// Secondary pane 的產品尺寸限制；未提供時不額外限制語意預設寬度。
  final KlpPaneWidthConstraints? secondaryWidthConstraints;
  final ValueChanged<double>? onPrimaryWidthChanged;
  final ValueChanged<double>? onSecondaryWidthChanged;

  /// Primary pane 拖曳結束時提交最終寬度。
  ///
  /// 只提供這個 callback、不提供 [onPrimaryWidthChanged] 時，拖曳預覽完全由
  /// Kallopis 局部更新，產品不需在每個 pointer event 重建整個工作區。
  final ValueChanged<double>? onPrimaryWidthChangeEnd;

  /// Secondary pane 拖曳結束時提交最終寬度。
  final ValueChanged<double>? onSecondaryWidthChangeEnd;

  /// 外殼與三欄內容之間的額外留白。
  ///
  /// `null` 且使用預設 individual-pane 模式時不重複加入 App 外圈 margin；
  /// 整體外圈由 `KlpApp` 統一管理。
  final EdgeInsetsGeometry? padding;

  /// 相鄰欄位之間的單一留白與拖曳命中寬度。
  ///
  /// 這是舊版的 shared-gap 模式；只有明確指定時才啟用。`null` 時每個 pane
  /// 預設各自擁有四周半個緊湊 margin。
  final double? paneGap;

  /// 各欄位可視表面之外的四周 margin。
  ///
  /// Primary、Stage、Secondary 的表面與碰撞範圍不包含 margin；相鄰欄位各自
  /// 貢獻一半 margin，resize handle 位於兩個可視表面之間的 margin 正中央。
  /// `null` 且未指定 [paneGap] 時使用半個語意緊湊間距。
  final EdgeInsetsGeometry? paneMargin;

  /// [paneMargin] 的舊名稱；此空間位於 pane 表面之外，不是 padding。
  @Deprecated('Use paneMargin; this space is outside the pane surface.')
  final EdgeInsetsGeometry? panePadding;

  @override
  State<KlpWorkbenchShell> createState() => _KlpWorkbenchShellState();
}

class _KlpWorkbenchShellState extends State<KlpWorkbenchShell> {
  double? _primaryPreviewWidth;
  double? _secondaryPreviewWidth;

  double _constrainPrimaryWidth(double value) =>
      widget.primaryWidthConstraints?.constrain(value) ?? value;

  double _constrainSecondaryWidth(double value) =>
      widget.secondaryWidthConstraints?.constrain(value) ?? value;

  void _previewPrimaryWidth(double value) {
    final constrained = _constrainPrimaryWidth(value);
    if (_primaryPreviewWidth != constrained) {
      setState(() => _primaryPreviewWidth = constrained);
    }
    widget.onPrimaryWidthChanged?.call(constrained);
  }

  void _previewSecondaryWidth(double value) {
    final constrained = _constrainSecondaryWidth(value);
    if (_secondaryPreviewWidth != constrained) {
      setState(() => _secondaryPreviewWidth = constrained);
    }
    widget.onSecondaryWidthChanged?.call(constrained);
  }

  void _commitPrimaryWidth(double value) {
    widget.onPrimaryWidthChangeEnd?.call(_constrainPrimaryWidth(value));
    if (_primaryPreviewWidth != null) {
      setState(() => _primaryPreviewWidth = null);
    }
  }

  void _commitSecondaryWidth(double value) {
    widget.onSecondaryWidthChangeEnd?.call(_constrainSecondaryWidth(value));
    if (_secondaryPreviewWidth != null) {
      setState(() => _secondaryPreviewWidth = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final geometry = context.klp.geometry.layout;
    final effectivePrimaryWidth = _constrainPrimaryWidth(
      _primaryPreviewWidth ?? widget.primaryWidth ?? geometry.primaryPaneWidth,
    );
    final effectiveSecondaryWidth = _constrainSecondaryWidth(
      _secondaryPreviewWidth ??
          widget.secondaryWidth ??
          geometry.secondaryPaneWidth,
    );
    final compact = context.klp.space.compact;
    final paneMarginValue = widget.paneMargin ?? widget.panePadding;
    final defaultPaneMargin = compact / 2;
    final usesIndividualPaneMargin =
        paneMarginValue != null || widget.paneGap == null;
    final effectivePadding =
        widget.padding ??
        (usesIndividualPaneMargin
            ? EdgeInsets.zero
            : EdgeInsets.fromLTRB(compact, 0, compact, compact));
    final effectivePaneGap = widget.paneGap ?? context.klp.space.compact;
    final primaryResizable =
        widget.onPrimaryWidthChanged != null ||
        widget.onPrimaryWidthChangeEnd != null;
		final secondaryResizable =
			widget.secondary != null &&
			(widget.onSecondaryWidthChanged != null ||
				widget.onSecondaryWidthChangeEnd != null);

    if (usesIndividualPaneMargin) {
      return _KlpIndividuallyMarginedWorkbench(
        primary: widget.primary,
        stage: widget.stage,
        secondary: widget.secondary,
        primaryVisible: widget.primaryVisible,
        secondaryVisible: widget.secondaryVisible,
        primaryWidth: effectivePrimaryWidth,
        secondaryWidth: effectiveSecondaryWidth,
        onPrimaryWidthChanged: primaryResizable ? _previewPrimaryWidth : null,
        onSecondaryWidthChanged: secondaryResizable
            ? _previewSecondaryWidth
            : null,
        onPrimaryWidthChangeEnd: primaryResizable ? _commitPrimaryWidth : null,
        onSecondaryWidthChangeEnd: secondaryResizable
            ? _commitSecondaryWidth
            : null,
        outerPadding: effectivePadding,
        paneMargin: paneMarginValue ?? EdgeInsets.all(defaultPaneMargin),
        resizeHandleWidth: compact,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final showPrimaryContent =
            widget.primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneContentBreakpoint;
        final showPrimary =
            widget.primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneBreakpoint;
				final showSecondary =
					widget.secondary != null &&
					widget.secondaryVisible &&
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
                  SizedBox(width: resolvedPrimaryWidth, child: widget.primary),
                  _KlpWorkbenchResizeHandle(
                    key: const ValueKey('primary-pane-resize-handle'),
                    enabled: showPrimaryContent && primaryResizable,
                    paneWidth: effectivePrimaryWidth,
                    handleWidth: effectivePaneGap,
                    direction: 1,
                    onWidthChanged: _previewPrimaryWidth,
                    onWidthChangeEnd: _commitPrimaryWidth,
                  ),
                ],
                Expanded(child: widget.stage),
                if (showSecondary) ...[
                  _KlpWorkbenchResizeHandle(
                    key: const ValueKey('secondary-pane-resize-handle'),
                    enabled: secondaryResizable,
                    paneWidth: effectiveSecondaryWidth,
                    handleWidth: effectivePaneGap,
                    direction: -1,
                    onWidthChanged: _previewSecondaryWidth,
                    onWidthChangeEnd: _commitSecondaryWidth,
                  ),
                  SizedBox(
                    width: effectiveSecondaryWidth,
                    child: widget.secondary!,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KlpIndividuallyMarginedWorkbench extends StatelessWidget {
  const _KlpIndividuallyMarginedWorkbench({
    required this.primary,
    required this.stage,
    required this.secondary,
    required this.primaryVisible,
    required this.secondaryVisible,
    required this.primaryWidth,
    required this.secondaryWidth,
    required this.onPrimaryWidthChanged,
    required this.onSecondaryWidthChanged,
    required this.onPrimaryWidthChangeEnd,
    required this.onSecondaryWidthChangeEnd,
    required this.outerPadding,
    required this.paneMargin,
    required this.resizeHandleWidth,
  });

  final Widget primary;
  final Widget stage;
  final Widget? secondary;
  final bool primaryVisible;
  final bool secondaryVisible;
  final double primaryWidth;
  final double secondaryWidth;
  final ValueChanged<double>? onPrimaryWidthChanged;
  final ValueChanged<double>? onSecondaryWidthChanged;
  final ValueChanged<double>? onPrimaryWidthChangeEnd;
  final ValueChanged<double>? onSecondaryWidthChangeEnd;
  final EdgeInsetsGeometry outerPadding;
  final EdgeInsetsGeometry paneMargin;
  final double resizeHandleWidth;

  @override
  Widget build(BuildContext context) {
    final geometry = context.klp.geometry.layout;
    final resolvedMargin = paneMargin.resolve(Directionality.of(context));

    return LayoutBuilder(
      builder: (context, constraints) {
        final showPrimaryContent =
            primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneContentBreakpoint;
        final showPrimary =
            primaryVisible &&
            constraints.maxWidth >= geometry.primaryPaneBreakpoint;
				final showSecondary =
					secondary != null &&
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
                          child: Padding(padding: paneMargin, child: primary),
                        ),
                      Expanded(
                        child: Padding(padding: paneMargin, child: stage),
                      ),
                      if (showSecondary)
                        SizedBox(
                          width: secondaryWidth,
                          child: Padding(padding: paneMargin, child: secondary!),
                        ),
                    ],
                  ),
                ),
                if (showPrimaryContent && onPrimaryWidthChanged != null)
                  PositionedDirectional(
                    start: resolvedPrimaryWidth - resizeHandleWidth / 2,
                    top: resolvedMargin.top,
                    bottom: resolvedMargin.bottom,
                    width: resizeHandleWidth,
                    child: _KlpWorkbenchResizeHandle(
                      key: const ValueKey('primary-pane-resize-handle'),
                      enabled: true,
                      paneWidth: primaryWidth,
                      handleWidth: resizeHandleWidth,
                      direction: 1,
                      onWidthChanged: onPrimaryWidthChanged,
                      onWidthChangeEnd: onPrimaryWidthChangeEnd,
                    ),
                  ),
                if (showSecondary && onSecondaryWidthChanged != null)
                  PositionedDirectional(
                    end: secondaryWidth - resizeHandleWidth / 2,
                    top: resolvedMargin.top,
                    bottom: resolvedMargin.bottom,
                    width: resizeHandleWidth,
                    child: _KlpWorkbenchResizeHandle(
                      key: const ValueKey('secondary-pane-resize-handle'),
                      enabled: true,
                      paneWidth: secondaryWidth,
                      handleWidth: resizeHandleWidth,
                      direction: -1,
                      onWidthChanged: onSecondaryWidthChanged,
                      onWidthChangeEnd: onSecondaryWidthChangeEnd,
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

/// 在單次拖曳內保存起始寬度與累積位移，避免同一 frame 的 pointer event
/// 都從舊的受控寬度重新計算而遺失位移。
class _KlpWorkbenchResizeHandle extends StatefulWidget {
  const _KlpWorkbenchResizeHandle({
    super.key,
    required this.paneWidth,
    required this.handleWidth,
    required this.direction,
    required this.onWidthChanged,
    required this.onWidthChangeEnd,
    required this.enabled,
  });

  final double paneWidth;
  final double handleWidth;
  final double direction;
  final ValueChanged<double>? onWidthChanged;
  final ValueChanged<double>? onWidthChangeEnd;
  final bool enabled;

  @override
  State<_KlpWorkbenchResizeHandle> createState() =>
      _KlpWorkbenchResizeHandleState();
}

class _KlpWorkbenchResizeHandleState extends State<_KlpWorkbenchResizeHandle> {
  double? _dragStartWidth;
  double _dragDelta = 0;

  void _startDrag() {
    _dragStartWidth = widget.paneWidth;
    _dragDelta = 0;
  }

  void _updateDrag(double delta) {
    _dragStartWidth ??= widget.paneWidth;
    _dragDelta += delta;
    widget.onWidthChanged?.call(
      _dragStartWidth! + _dragDelta * widget.direction,
    );
  }

  void _endDrag() {
    final startWidth = _dragStartWidth;
    if (startWidth != null) {
      widget.onWidthChangeEnd?.call(startWidth + _dragDelta * widget.direction);
    }
    _dragStartWidth = null;
    _dragDelta = 0;
  }

  @override
  Widget build(BuildContext context) {
    return KlpResizeHandle(
      enabled: widget.enabled,
      width: widget.handleWidth,
      onDragStart: _startDrag,
      onDelta: _updateDrag,
      onDragEnd: _endDrag,
    );
  }
}
