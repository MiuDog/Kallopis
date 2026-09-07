import 'package:flutter/material.dart';

import '../../interaction/klp_drag_drop.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';
import '../panel/klp_panel_frame.dart';
import '../panel/klp_panel_layout.dart';
import 'klp_dock_header.dart';
import 'klp_dock_layout_models.dart';
import 'klp_dock_panel.dart';

part 'internal/klp_dock_resize_handle.dart';
part 'internal/klp_dock_layout_data.dart';

class KlpDockLayout extends StatefulWidget implements KlpPanelLayout {
  const KlpDockLayout({
    super.key,
    required this.stage,
    required this.panels,
    required this.layout,
    required this.onLayoutChanged,
    required this.leftConstraints,
    required this.rightConstraints,
    this.bottomConstraints,
  });

  final KlpPanelFrame stage;
  final List<KlpDockPanel> panels;
  final KlpDockLayoutData layout;
  final ValueChanged<KlpDockLayoutData> onLayoutChanged;
  final KlpDockAreaConstraints leftConstraints;
  final KlpDockAreaConstraints rightConstraints;

  /// Bottom 可用時的高度限制；沒有任何 Bottom-capable panel 時可省略。
  final KlpDockAreaConstraints? bottomConstraints;

  @override
  State<KlpDockLayout> createState() => _KlpDockLayoutState();

  @override
  Widget buildPanelLayout(BuildContext context) => this;
}

class _KlpDockLayoutState extends State<KlpDockLayout> {
  static const double _minHorizontalGroupExtent = 120;

  final Set<_KlpDockAreaSlot> _openingAreaSlots = {};
  String? _activeDropTarget;
  _KlpDockDropPlacement? _activeDropPlacement;
  int _groupSequence = 0;

  @override
  void didUpdateWidget(KlpDockLayout oldWidget) {
    super.didUpdateWidget(oldWidget);

    for (final slot in _KlpDockAreaSlot.values) {
      if (_areaForSlot(widget.layout, slot).isVisible) {
        _openingAreaSlots.remove(slot);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.bottomConstraints != null ||
          (!widget.layout.bottom.isVisible &&
              widget.layout.bottom.groups.isEmpty),
      'bottomConstraints 只有在 Bottom 不可用時才能省略。',
    );
    final layout = widget.layout;
    final showLeft = layout.left.isVisible && layout.left.groups.isNotEmpty;
    final showRight = layout.right.isVisible && layout.right.groups.isNotEmpty;
    final showBottom =
        layout.bottom.isVisible && layout.bottom.groups.isNotEmpty;

    return ColoredBox(
      color: context.klpColors.app,
      child: Padding(
        padding: EdgeInsets.zero,
        child: LayoutBuilder(
          builder: (dockContext, dockConstraints) {
            final handleExtent = context.klp.geometry.layout.resizeHandleExtent;
            final centerLeft = showLeft
                ? layout.left.extent + handleExtent
                : 0.0;
            final centerRight = showRight
                ? layout.right.extent + handleExtent
                : 0.0;

            return Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showLeft) ...[
                        SizedBox(
                          width: layout.left.extent,
                          child: _buildArea(_KlpDockAreaSlot.left, layout.left),
                        ),
                        SizedBox(width: handleExtent),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: _buildStage()),
                            if (showBottom) ...[
                              SizedBox(height: handleExtent),
                              SizedBox(
                                height: layout.bottom.extent,
                                child: _buildArea(
                                  _KlpDockAreaSlot.bottom,
                                  layout.bottom,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (showRight) ...[
                        SizedBox(width: handleExtent),
                        SizedBox(
                          width: layout.right.extent,
                          child: _buildArea(
                            _KlpDockAreaSlot.right,
                            layout.right,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_activeDropTarget?.startsWith('stage:') ?? false)
                  _buildStageDropIndicator(_activeDropTarget!),
                if (widget.bottomConstraints case final bottomConstraints?)
                  _buildAreaResizeOverlay(
                    dockContext,
                    _KlpDockAreaSlot.bottom,
                    layout.bottom,
                    bottomConstraints,
                    showIndicator: showBottom,
                    left: centerLeft,
                    right: centerRight,
                    bottom: showBottom ? layout.bottom.extent : 0,
                    height: handleExtent,
                  ),
                _buildAreaResizeOverlay(
                  dockContext,
                  _KlpDockAreaSlot.left,
                  layout.left,
                  widget.leftConstraints,
                  showIndicator: showLeft,
                  left: showLeft ? layout.left.extent : 0,
                  top: 0,
                  bottom: 0,
                  width: handleExtent,
                ),
                _buildAreaResizeOverlay(
                  dockContext,
                  _KlpDockAreaSlot.right,
                  layout.right,
                  widget.rightConstraints,
                  showIndicator: showRight,
                  right: showRight ? layout.right.extent : 0,
                  top: 0,
                  bottom: 0,
                  width: handleExtent,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStage() {
    return Builder(
      builder: (targetContext) => DragTarget<_KlpDockPanelDragData>(
        hitTestBehavior: HitTestBehavior.translucent,
        onWillAcceptWithDetails: (details) =>
            _hasStageDestination(details.data.panelId),
        onMove: (details) =>
            _updateStageDropTarget(targetContext, details.data, details.offset),
        onLeave: (_) => _clearDropTarget(),
        onAcceptWithDetails: (details) {
          final slot = _resolveStageDestination(
            targetContext,
            details.data,
            details.offset,
            expandHiddenArea: false,
          );
          if (slot != null &&
              _areaForSlot(widget.layout, slot).groups.isEmpty) {
            _finishStageAreaDrop(details.data, slot);
          }
          _clearDropTarget();
        },
        builder: (context, candidateData, rejectedData) => widget.stage,
      ),
    );
  }

  Widget _buildAreaResizeOverlay(
    BuildContext dockContext,
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    KlpDockAreaConstraints constraints, {
    required bool showIndicator,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    final axis = slot == _KlpDockAreaSlot.bottom
        ? Axis.vertical
        : Axis.horizontal;

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: _KlpDockResizeHandle(
        key: ValueKey('dock-area-${slot.name}-resize-handle'),
        axis: axis,
        showIndicator: showIndicator,
        onPosition: (globalPosition) => _handleAreaResizeAt(
          dockContext,
          slot,
          area,
          constraints,
          globalPosition,
        ),
      ),
    );
  }

  Widget _buildArea(_KlpDockAreaSlot slot, KlpDockAreaData area) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          _buildAreaGroups(context, slot, area, constraints),
    );
  }

  Widget _buildAreaGroups(
    BuildContext context,
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    BoxConstraints constraints,
  ) {
    assert(area.groups.isNotEmpty);

    final isVertical = area.axis == Axis.vertical;
    final availableExtent = isVertical
        ? constraints.maxHeight
        : constraints.maxWidth;
    final handleExtent = context.klp.geometry.layout.resizeHandleExtent;
    final groupExtents = _resolveGroupExtents(
      area,
      availableExtent,
      handleExtent,
    );
    final children = <Widget>[];
    var offset = 0.0;

    for (var index = 0; index < area.groups.length; index++) {
      final group = area.groups[index];
      final groupExtent = groupExtents[index];
      final isLast = index == area.groups.length - 1;

      children.add(
        Positioned(
          key: ValueKey(group.id),
          left: isVertical ? 0 : offset,
          top: isVertical ? offset : 0,
          right: isVertical ? 0 : null,
          bottom: isVertical ? null : 0,
          width: isVertical ? null : groupExtent,
          height: isVertical ? groupExtent : null,
          child: _buildGroupDropTarget(
            context,
            slot,
            area,
            group,
            groupExtent,
            handleExtent,
          ),
        ),
      );

      offset += groupExtent;
      if (isLast) continue;

      children.add(
        Positioned(
          key: ValueKey('${group.id}-resize-handle'),
          left: isVertical ? 0 : offset,
          top: isVertical ? offset : 0,
          right: isVertical ? 0 : null,
          bottom: isVertical ? null : 0,
          width: isVertical ? null : handleExtent,
          height: isVertical ? handleExtent : null,
          child: _KlpDockResizeHandle(
            axis: area.axis,
            onPosition: (globalPosition) => _handleGroupResizeAt(
              context,
              slot,
              area,
              index,
              groupExtents,
              handleExtent,
              globalPosition,
            ),
          ),
        ),
      );

      offset += handleExtent;
    }

    return Stack(clipBehavior: Clip.hardEdge, children: children);
  }

  List<double> _resolveGroupExtents(
    KlpDockAreaData area,
    double availableExtent,
    double handleExtent,
  ) {
    assert(availableExtent.isFinite);

    final groupCount = area.groups.length;
    final handlesExtent = handleExtent * (groupCount - 1);
    final rawContentExtent = availableExtent - handlesExtent;
    final contentExtent = rawContentExtent > 0 ? rawContentExtent : 0.0;

    if (groupCount == 1) return [contentExtent];

    final minExtent = _resolveGroupMinExtent(area);
    if (contentExtent < minExtent * groupCount) {
      return List<double>.filled(groupCount, contentExtent / groupCount);
    }

    final extents = <double>[];
    var usedExtent = 0.0;

    for (var index = 0; index < groupCount; index++) {
      final isLast = index == groupCount - 1;
      if (isLast) {
        extents.add(contentExtent - usedExtent);
        continue;
      }

      final remainingGroups = groupCount - index - 1;
      final maxExtent =
          contentExtent - usedExtent - minExtent * remainingGroups;
      final extent = area.groups[index].mainAxisExtent
          .clamp(minExtent, maxExtent)
          .toDouble();

      extents.add(extent);
      usedExtent += extent;
    }

    return extents;
  }

  double _resolveGroupMinExtent(KlpDockAreaData area) {
    return area.axis == Axis.vertical
        ? KlpDockHeader.extent
        : _minHorizontalGroupExtent;
  }

  Widget _buildGroupDropTarget(
    BuildContext context,
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    KlpDockGroupData group,
    double groupExtent,
    double handleExtent,
  ) {
    final targetId = _dropTargetId(slot, group.id);

    return Builder(
      builder: (targetContext) => DragTarget<_KlpDockPanelDragData>(
        onWillAcceptWithDetails: (details) {
          final acceptsPanel =
              details.data.panelId != group.activePanelId ||
              group.panelIds.length > 1;
          return acceptsPanel &&
              _canDropPanelInSlot(details.data.panelId, slot);
        },
        onMove: (details) => _updateGroupDropTarget(
          targetContext,
          targetId,
          area,
          group,
          details.offset,
        ),
        onLeave: (_) => _clearDropTarget(targetId),
        onAcceptWithDetails: (details) {
          final placement = _resolveGroupDropPlacement(
            targetContext,
            area,
            group,
            details.offset,
          );
          if (placement == null) {
            _clearDropTarget();
            return;
          }

          _finishPanelDrop(
            details.data,
            slot,
            area,
            group,
            placement,
            groupExtent,
            handleExtent,
          );
          _clearDropTarget();
        },
        builder: (context, candidateData, rejectedData) {
          final placement = _activeDropTarget == targetId
              ? _activeDropPlacement
              : null;
          return Stack(
            fit: StackFit.expand,
            children: [
              _buildGroup(
                slot,
                area,
                group,
                showTabInsertion: placement == _KlpDockDropPlacement.merge,
              ),
              if (placement == _KlpDockDropPlacement.splitAfter)
                _buildGroupSplitIndicator(area),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropIndicator({bool vertical = false}) {
    final thickness = context.klp.shape.stroke;

    return IgnorePointer(
      child: Container(
        width: vertical ? thickness : double.infinity,
        height: vertical ? KlpDockHeader.extent : thickness,
        decoration: BoxDecoration(
          color: context.klp.primary,
          borderRadius: BorderRadius.circular(context.klp.shape.pill),
        ),
      ),
    );
  }

  /// Header 內的放置線與 code 標題使用相同的行高；DragTarget 仍由外層完整
  /// header 承擔，因此滑鼠可以在 padding 區域開始拖放。
  Widget _buildHeaderDropIndicator() {
    final type = context.klp.type;
    final definition = KlpTextStyles.definitionOf(KlpTextRole.code, type);
    final height = definition.fontSize * definition.lineHeight;

    return IgnorePointer(
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: height,
          child: Container(
            width: context.klp.shape.stroke,
            decoration: BoxDecoration(
              color: context.klp.primary,
              borderRadius: BorderRadius.circular(context.klp.shape.pill),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupSplitIndicator(KlpDockAreaData area) {
    if (area.axis == Axis.horizontal) {
      return Positioned(
        top: 0,
        right: 0,
        bottom: 0,
        child: _buildDropIndicator(vertical: true),
      );
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: _buildDropIndicator(),
    );
  }

  Widget _buildGroup(
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    KlpDockGroupData group, {
    bool showTabInsertion = false,
  }) {
    final panel = _findPanel(group.activePanelId);

    assert(panel != null, '找不到 activePanelId：${group.activePanelId}');
    if (panel == null) return KlpPanelFrame(content: const SizedBox.shrink());

    final hasTabs = group.panelIds.length > 1;
    final leading = hasTabs
        ? _buildGroupTabs(slot, area, group, showTabInsertion: showTabInsertion)
        : _buildSinglePanelHeader(panel, showTabInsertion: showTabInsertion);
    final data = _KlpDockPanelDragData(
      slot: slot,
      groupId: group.id,
      panelId: panel.id,
    );
    final header =
        !hasTabs &&
            panel.header == null &&
            panel.actions.isEmpty &&
            !showTabInsertion
        ? null
        : KlpDockHeader(
            leading: leading,
            actions: panel.actions,
            dragRegionBuilder: panel.isDraggable
                ? (child) => _buildPanelDraggable(data, panel, child)
                : null,
          );

    return KlpPanelFrame(
      header: header,
      content: panel.content,
      contentScrollController: panel.contentScrollController,
      headerHeight: header == null ? null : KlpDockHeader.extent,
    );
  }

  Widget _buildSinglePanelHeader(
    KlpDockPanel panel, {
    bool showTabInsertion = false,
  }) {
    return Row(
      children: [
        if (panel.header != null) _buildHeaderContent(panel.header!),
        if (showTabInsertion) _buildHeaderDropIndicator(),
      ],
    );
  }

  Widget _buildGroupTabs(
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    KlpDockGroupData group, {
    bool showTabInsertion = false,
  }) {
    return Row(
      children: [
        for (var index = 0; index < group.panelIds.length; index++) ...[
          _buildDockTab(slot, area, group, index),
          if (index < group.panelIds.length - 1)
            SizedBox(width: context.klp.space.tight),
        ],
        if (showTabInsertion) _buildHeaderDropIndicator(),
      ],
    );
  }

  Widget _buildDockTab(
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    KlpDockGroupData group,
    int index,
  ) {
    final panelId = group.panelIds[index];
    final panel = _findPanel(panelId);
    final selected = panelId == group.activePanelId;
    final tab = _buildDockTabSurface(
      panel,
      panelId,
      selected,
      () => _selectPanel(slot, area, group.id, panelId),
    );

    return DragTarget<_KlpDockPanelDragData>(
      onWillAcceptWithDetails: (details) {
        return details.data.panelId != panelId &&
            _canDropPanelInSlot(details.data.panelId, slot);
      },
      onAcceptWithDetails: (details) {
        _finishPanelDrop(
          details.data,
          slot,
          area,
          group,
          _KlpDockDropPlacement.merge,
          group.mainAxisExtent,
          0,
          insertionIndex: index,
        );
        _clearDropTarget();
      },
      builder: (context, candidateData, rejectedData) {
        final target = candidateData.isEmpty
            ? tab
            : Stack(
                children: [
                  tab,
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: _buildHeaderDropIndicator(),
                  ),
                ],
              );

        if (panel == null) return target;
        final data = _KlpDockPanelDragData(
          slot: slot,
          groupId: group.id,
          panelId: panel.id,
        );
        return _buildPanelDraggable(data, panel, target);
      },
    );
  }

  Widget _buildDockTabSurface(
    KlpDockPanel? panel,
    String panelId,
    bool selected,
    VoidCallback onPressed,
  ) {
    final colors = context.klpColors;
    final header =
        panel?.header ?? Text(panelId, overflow: TextOverflow.ellipsis);
    final child = _buildHeaderContent(header);

    return Material(
      color: selected ? colors.surfaceMuted : colors.surfaceInset,
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.klp.space.base),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildHeaderContent(Widget child) {
    final type = context.klp.type;
    final definition = KlpTextStyles.definitionOf(KlpTextRole.code, type);
    final color = KlpTextStyles.colorFor(
      context.klpColors,
      role: KlpTextRole.code,
    );
    final style = definition.toTextStyle(type).copyWith(color: color);

    return DefaultTextStyle(
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: child,
    );
  }

  Widget _buildPanelDraggable(
    _KlpDockPanelDragData data,
    KlpDockPanel panel,
    Widget child,
  ) {
    if (!panel.isDraggable) return child;

    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Draggable<_KlpDockPanelDragData>(
        data: data,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        hitTestBehavior: HitTestBehavior.opaque,
        onDragEnd: (_) => _clearDropTarget(),
        onDraggableCanceled: (_, _) => _clearDropTarget(),
        feedback: ExcludeSemantics(
          child: IgnorePointer(
            child: Material(
              type: MaterialType.transparency,
              child: KlpDragPreview(
                child: _buildHeaderContent(panel.header ?? Text(panel.id)),
              ),
            ),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.35, child: child),
        child: child,
      ),
    );
  }

  KlpDockPanel? _findPanel(String panelId) {
    for (final panel in widget.panels) {
      if (panel.id == panelId) return panel;
    }

    return null;
  }

  bool _canDropPanelInSlot(String panelId, _KlpDockAreaSlot slot) {
    final panel = _findPanel(panelId);
    if (panel == null) return false;

    switch (slot) {
      case _KlpDockAreaSlot.bottom:
        return panel.allowBottom && widget.bottomConstraints != null;
      case _KlpDockAreaSlot.left:
      case _KlpDockAreaSlot.right:
        return panel.allowSide;
    }
  }

  void _selectPanel(
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    String groupId,
    String panelId,
  ) {
    final groupIndex = area.groups.indexWhere((group) => group.id == groupId);
    if (groupIndex < 0) return;

    final nextGroups = List<KlpDockGroupData>.of(area.groups);
    nextGroups[groupIndex] = nextGroups[groupIndex].copyWith(
      activePanelId: panelId,
    );
    _emitAreaChange(slot, area.copyWith(groups: nextGroups));
  }

  void _updateGroupDropTarget(
    BuildContext targetContext,
    String targetId,
    KlpDockAreaData area,
    KlpDockGroupData group,
    Offset globalOffset,
  ) {
    final placement = _resolveGroupDropPlacement(
      targetContext,
      area,
      group,
      globalOffset,
    );
    if (placement == null) {
      _clearDropTarget(targetId);
      return;
    }

    _activateDropTarget(targetId, placement);
  }

  _KlpDockDropPlacement? _resolveGroupDropPlacement(
    BuildContext targetContext,
    KlpDockAreaData area,
    KlpDockGroupData group,
    Offset globalOffset,
  ) {
    final renderObject = targetContext.findRenderObject();
    if (renderObject is! RenderBox) return null;

    final localOffset = renderObject.globalToLocal(globalOffset);
    if (area.axis == Axis.horizontal) {
      final inHeader =
          _groupHasHeader(group) && localOffset.dy < KlpDockHeader.extent;
      if (inHeader) return _KlpDockDropPlacement.merge;
      if (localOffset.dx >= renderObject.size.width / 2) {
        return _KlpDockDropPlacement.splitAfter;
      }

      return null;
    }

    if (localOffset.dy < renderObject.size.height / 2) {
      return _KlpDockDropPlacement.merge;
    }

    return _KlpDockDropPlacement.splitAfter;
  }

  bool _groupHasHeader(KlpDockGroupData group) {
    if (group.panelIds.length > 1) return true;

    final panel = _findPanel(group.activePanelId);
    return panel != null && (panel.header != null || panel.actions.isNotEmpty);
  }

  void _updateStageDropTarget(
    BuildContext targetContext,
    _KlpDockPanelDragData data,
    Offset globalOffset,
  ) {
    final slot = _resolveStageDestination(
      targetContext,
      data,
      globalOffset,
      expandHiddenArea: true,
    );
    if (slot == null || _areaForSlot(widget.layout, slot).groups.isNotEmpty) {
      _clearDropTarget();
      return;
    }

    _activateDropTarget('stage:${slot.name}', _KlpDockDropPlacement.createArea);
  }

  _KlpDockAreaSlot? _resolveStageDestination(
    BuildContext targetContext,
    _KlpDockPanelDragData data,
    Offset globalOffset, {
    required bool expandHiddenArea,
  }) {
    final renderObject = targetContext.findRenderObject();
    final panel = _findPanel(data.panelId);
    if (renderObject is! RenderBox || panel == null) return null;

    final localOffset = renderObject.globalToLocal(globalOffset);
    final size = renderObject.size;
    final bottom = widget.layout.bottom;
    final bottomConstraints = widget.bottomConstraints;
    final bottomUnavailable = bottom.groups.isEmpty || !bottom.isVisible;

    if (panel.allowBottom &&
        bottomConstraints != null &&
        bottomUnavailable &&
        localOffset.dy >= size.height / 2) {
      if (bottom.groups.isEmpty) return _KlpDockAreaSlot.bottom;
      if (localOffset.dy >= size.height - bottomConstraints.closeThreshold) {
        if (expandHiddenArea) {
          _openAreaForDrop(_KlpDockAreaSlot.bottom, bottom, bottomConstraints);
        }
      }
      return null;
    }

    if (!panel.allowSide) return null;

    final slot = localOffset.dx < size.width / 2
        ? _KlpDockAreaSlot.left
        : _KlpDockAreaSlot.right;
    final area = _areaForSlot(widget.layout, slot);
    final constraints = _constraintsForSlot(slot);
    if (area.groups.isEmpty) return slot;
    if (area.isVisible) return null;

    final inEdgeBand = slot == _KlpDockAreaSlot.left
        ? localOffset.dx <= constraints.closeThreshold
        : localOffset.dx >= size.width - constraints.closeThreshold;
    if (inEdgeBand && expandHiddenArea) {
      _openAreaForDrop(slot, area, constraints);
    }

    return null;
  }

  bool _hasStageDestination(String panelId) {
    final panel = _findPanel(panelId);
    if (panel == null) return false;

    if (panel.allowBottom && widget.bottomConstraints != null) {
      final bottom = widget.layout.bottom;
      if (bottom.groups.isEmpty || !bottom.isVisible) return true;
    }
    if (!panel.allowSide) return false;

    return [
      widget.layout.left,
      widget.layout.right,
    ].any((area) => area.groups.isEmpty || !area.isVisible);
  }

  void _openAreaForDrop(
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    KlpDockAreaConstraints constraints,
  ) {
    if (area.isVisible || area.groups.isEmpty || !_openingAreaSlots.add(slot)) {
      return;
    }

    _emitAreaChange(
      slot,
      area.copyWith(isVisible: true, extent: constraints.minExtent),
    );
  }

  KlpDockAreaConstraints _constraintsForSlot(_KlpDockAreaSlot slot) {
    switch (slot) {
      case _KlpDockAreaSlot.left:
        return widget.leftConstraints;
      case _KlpDockAreaSlot.right:
        return widget.rightConstraints;
      case _KlpDockAreaSlot.bottom:
        return widget.bottomConstraints!;
    }
  }

  Widget _buildStageDropIndicator(String targetId) {
    final slotName = targetId.substring('stage:'.length);
    final slot = _KlpDockAreaSlot.values.firstWhere(
      (candidate) => candidate.name == slotName,
    );
    final thickness = context.klp.shape.stroke;
    final indicator = IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.klp.primary,
          borderRadius: BorderRadius.circular(context.klp.shape.pill),
        ),
      ),
    );

    switch (slot) {
      case _KlpDockAreaSlot.left:
        return Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: thickness,
          child: indicator,
        );
      case _KlpDockAreaSlot.right:
        return Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: thickness,
          child: indicator,
        );
      case _KlpDockAreaSlot.bottom:
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: thickness,
          child: indicator,
        );
    }
  }

  void _activateDropTarget(String targetId, _KlpDockDropPlacement placement) {
    if (_activeDropTarget == targetId && _activeDropPlacement == placement) {
      return;
    }

    setState(() {
      _activeDropTarget = targetId;
      _activeDropPlacement = placement;
    });
  }

  void _clearDropTarget([String? targetId]) {
    if (targetId != null && _activeDropTarget != targetId) return;
    if (!mounted ||
        (_activeDropTarget == null && _activeDropPlacement == null)) {
      return;
    }

    setState(() {
      _activeDropTarget = null;
      _activeDropPlacement = null;
    });
  }

  String _dropTargetId(_KlpDockAreaSlot slot, String groupId) =>
      '${slot.name}:$groupId';

  void _handleAreaResizeAt(
    BuildContext dockContext,
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    KlpDockAreaConstraints constraints,
    Offset globalPosition,
  ) {
    final renderObject = dockContext.findRenderObject();
    if (renderObject is! RenderBox) return;

    final localPosition = renderObject.globalToLocal(globalPosition);
    final handleExtent = context.klp.geometry.layout.resizeHandleExtent;
    final requestedExtent = switch (slot) {
      _KlpDockAreaSlot.left => localPosition.dx - handleExtent / 2,
      _KlpDockAreaSlot.right =>
        renderObject.size.width - localPosition.dx - handleExtent / 2,
      _KlpDockAreaSlot.bottom =>
        renderObject.size.height - localPosition.dy - handleExtent / 2,
    };

    if (requestedExtent < constraints.closeThreshold) {
      if (area.isVisible) {
        _emitAreaChange(slot, area.copyWith(isVisible: false));
      }
      return;
    }

    final nextExtent = requestedExtent
        .clamp(constraints.minExtent, constraints.maxExtent)
        .toDouble();
    if (area.isVisible && area.extent == nextExtent) return;

    _emitAreaChange(slot, area.copyWith(isVisible: true, extent: nextExtent));
  }

  void _handleGroupResizeAt(
    BuildContext areaContext,
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
    int leadingIndex,
    List<double> groupExtents,
    double handleExtent,
    Offset globalPosition,
  ) {
    assert(leadingIndex >= 0);
    assert(leadingIndex < area.groups.length - 1);

    final renderObject = areaContext.findRenderObject();
    if (renderObject is! RenderBox) return;

    final trailingIndex = leadingIndex + 1;
    final leadingGroup = area.groups[leadingIndex];
    final trailingGroup = area.groups[trailingIndex];
    final minExtent = _resolveGroupMinExtent(area);
    final pairExtent = groupExtents[leadingIndex] + groupExtents[trailingIndex];

    if (pairExtent < minExtent * 2) return;

    final localPosition = renderObject.globalToLocal(globalPosition);
    final pointerPosition = area.axis == Axis.vertical
        ? localPosition.dy
        : localPosition.dx;
    var pairStart = handleExtent * leadingIndex;
    for (var index = 0; index < leadingIndex; index++) {
      pairStart += groupExtents[index];
    }

    final requestedLeadingExtent =
        pointerPosition - pairStart - handleExtent / 2;
    final nextLeadingExtent = requestedLeadingExtent
        .clamp(minExtent, pairExtent - minExtent)
        .toDouble();
    final nextTrailingExtent = pairExtent - nextLeadingExtent;
    final nextGroups = List<KlpDockGroupData>.of(area.groups);

    nextGroups[leadingIndex] = leadingGroup.copyWith(
      mainAxisExtent: nextLeadingExtent,
    );
    nextGroups[trailingIndex] = trailingGroup.copyWith(
      mainAxisExtent: nextTrailingExtent,
    );

    _emitAreaChange(slot, area.copyWith(groups: nextGroups));
  }

  void _emitAreaChange(_KlpDockAreaSlot slot, KlpDockAreaData area) {
    widget.onLayoutChanged(_replaceArea(widget.layout, slot, area));
  }

  KlpDockLayoutData _replaceArea(
    KlpDockLayoutData layout,
    _KlpDockAreaSlot slot,
    KlpDockAreaData area,
  ) {
    switch (slot) {
      case _KlpDockAreaSlot.left:
        return layout.copyWith(left: area);
      case _KlpDockAreaSlot.right:
        return layout.copyWith(right: area);
      case _KlpDockAreaSlot.bottom:
        return layout.copyWith(bottom: area);
    }
  }
}

enum _KlpDockAreaSlot { left, right, bottom }

enum _KlpDockDropPlacement { merge, splitAfter, createArea }

@immutable
class _KlpDockPanelDragData {
  final _KlpDockAreaSlot slot;
  final String groupId;
  final String panelId;

  const _KlpDockPanelDragData({
    required this.slot,
    required this.groupId,
    required this.panelId,
  });
}
