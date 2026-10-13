import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:kallopis/src/foundation/interaction/klp_drag_drop.dart';
import 'package:kallopis/src/foundation/layout/klp_layout.dart';
import 'package:kallopis/src/foundation/surface/klp_surface.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/foundation/content/klp_text.dart';
import 'package:kallopis/src/features/workspace/shell/panel/klp_panel_frame.dart';
import 'package:kallopis/src/features/workspace/layout/klp_linear_layout.dart';
import 'klp_dock_header.dart';
import 'klp_dock_layout_models.dart';
import 'klp_dock_panel.dart';
import 'klp_dock_layout_codec.dart';
import 'klp_dock_layout_operations.dart';
import 'package:kallopis/src/foundation/klp_icons.dart';
import 'package:kallopis/src/foundation/klp_icon.dart';
import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'package:kallopis/src/features/actions/button/klp_icon_button.dart';

part 'internal/klp_dock_geometry.dart';
part 'internal/klp_dock_close.dart';
part 'internal/klp_dock_layout_data.dart';
part 'internal/klp_dock_layout_widget.dart';
part 'internal/klp_dock_area_slot.dart';
part 'internal/klp_dock_drop_placement.dart';
part 'internal/klp_dock_panel_drag_data.dart';
part 'primitives/klp_dock_drop_target.dart';
part 'primitives/klp_dock_header_content_scope.dart';
part 'primitives/klp_dock_indicator_frame.dart';
part 'primitives/klp_dock_panel_draggable.dart';
part 'primitives/klp_dock_resize_handle.dart';
part 'primitives/klp_dock_tab_surface.dart';

/// 直接組合原生 Dock 槽及 gesture；render 只讀保存偏好。
class _KlpDockLayoutState extends State<KlpDockLayout> {
	static const double _minHorizontalGroupExtent = 120;

	/// 只記錄此次拖曳的暫時展開；產品 layout 是唯一保存權威。
	final Set<_KlpDockAreaSlot> _previewAreaSlots = {};
	/// 關閉請求只保存暫態 token，不能持有舊產品 layout。
	final Map<String, _KlpDockCloseRequest> _pendingCloseRequests = {};
	String? _activeDropTarget;
	_KlpDockDropPlacement? _activeDropPlacement;
	int _groupSequence = 0;

	/// State 擁有重建入口，extension 不直接呼叫 protected setState。
	void _updateCloseState(VoidCallback update) => setState(update);

	@override
	void didUpdateWidget(KlpDockLayout oldWidget) {
		super.didUpdateWidget(oldWidget);
		_reconcileCloseRequests();

		if (!identical(oldWidget.layout, widget.layout)) {
			_previewAreaSlots.clear();
			_activeDropTarget = null;
			_activeDropPlacement = null;
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
		final layout = _presentationLayout();
		return KlpSurface(
			tone: KlpSurfaceTone.app,
			child: KlpLayoutBuilder(builder: (dockContext, constraints) {
				final geometry = _resolveDockGeometry(
					size: Size(constraints.maxWidth, constraints.maxHeight),
					layout: layout,
					leftConstraints: widget.leftConstraints,
					rightConstraints: widget.rightConstraints,
					bottomConstraints: widget.bottomConstraints,
					handleExtent: context.klp.geometry.layout.resizeHandleExtent,
					headerExtent: widget.contentHeader?.preferredSize.height,
				);
				return KlpStack(clipBehavior: Clip.hardEdge, children: [
					if (geometry.left case final rect?) _dockSlot('dock-left-slot', rect, _buildArea(_KlpDockAreaSlot.left, layout.left)),
					if (geometry.header case final rect?) _dockSlot('dock-header-slot', rect, widget.contentHeader!),
					_dockSlot('dock-stage-slot', geometry.stage, _buildStage()),
					if (geometry.bottom case final rect?) _dockSlot('dock-bottom-slot', rect, _buildArea(_KlpDockAreaSlot.bottom, layout.bottom)),
					if (geometry.right case final rect?) _dockSlot('dock-right-slot', rect, _buildArea(_KlpDockAreaSlot.right, layout.right)),
					if (_activeDropTarget?.startsWith('stage:') ?? false)
						_buildStageDropIndicator(_activeDropTarget!, geometry.stage),
					if (widget.bottomConstraints case final limits?) _buildAreaResizeOverlay(
						dockContext,
						_KlpDockAreaSlot.bottom,
						layout.bottom,
						limits,
						rect: geometry.bottomHandle,
						maximumExtent: geometry.maximumBottom,
						showIndicator: geometry.bottom != null,
					),
					_buildAreaResizeOverlay(
						dockContext,
						_KlpDockAreaSlot.left,
						layout.left,
						widget.leftConstraints,
						rect: geometry.leftHandle,
						maximumExtent: geometry.maximumLeft,
						showIndicator: geometry.left != null,
					),
					_buildAreaResizeOverlay(
						dockContext,
						_KlpDockAreaSlot.right,
						layout.right,
						widget.rightConstraints,
						rect: geometry.rightHandle,
						maximumExtent: geometry.maximumRight,
						showIndicator: geometry.right != null,
					),
				]);
			}),
		);
	}

	/// 每個具名槽維持自己的 Element，尺寸改變不搬移產品內容。
	Widget _dockSlot(String id, Rect rect, Widget child) => KlpPositioned(
		key: ValueKey(id),
		left: rect.left,
		top: rect.top,
		width: rect.width,
		height: rect.height,
		child: ClipRect(child: child),
	);

	Widget _buildStage() {
		return _KlpDockDropTarget(
			hitTestBehavior: HitTestBehavior.translucent,
			onWillAcceptWithDetails: (targetContext, details) =>
					_hasStageDestination(details.data.panelId),
			onMove: (targetContext, details) =>
					_updateStageDropTarget(targetContext, details.data, details.offset),
			onLeave: (targetContext, data) => _clearDropTarget(),
			onAcceptWithDetails: (targetContext, details) {
				final slot = _resolveStageDestination(
					targetContext,
					details.data,
					details.offset,
					expandHiddenArea: false,
				);
				if (slot != null && _areaForSlot(widget.layout, slot).groups.isEmpty) {
					_finishStageAreaDrop(details.data, slot);
				}
				_clearDropTarget();
			},
			builder: (context, candidateData, rejectedData) => widget.stage,
		);
	}

	Widget _buildAreaResizeOverlay(
		BuildContext dockContext,
		_KlpDockAreaSlot slot,
		KlpDockAreaData area,
		KlpDockAreaConstraints constraints, {
		required Rect rect,
		required double maximumExtent,
		required bool showIndicator,
	}) {
		final axis = slot == _KlpDockAreaSlot.bottom ? Axis.vertical : Axis.horizontal;
		final handleExtent = axis == Axis.vertical ? rect.height : rect.width;
		return _dockSlot('dock-${slot.name}-handle-slot', rect, _KlpDockResizeHandle(
			key: ValueKey('dock-area-${slot.name}-resize-handle'),
			axis: axis,
			showIndicator: showIndicator,
			onPosition: (position) => _handleAreaResizeAt(
				dockContext,
				slot,
				area,
				constraints,
				position,
				handleExtent: handleExtent,
				maximumExtent: maximumExtent,
			),
		));
	}

	Widget _buildArea(_KlpDockAreaSlot slot, KlpDockAreaData area) {
		return KlpLayoutBuilder(
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
		final resolved = _resolveGroupExtents(
			area,
			availableExtent,
			context.klp.geometry.layout.resizeHandleExtent,
		);
		final groupExtents = resolved.extents;
		final handleExtent = resolved.gutter;
		final children = <Widget>[];
		var offset = 0.0;

		for (var index = 0; index < area.groups.length; index++) {
			final group = area.groups[index];
			final groupExtent = groupExtents[index];
			final isLast = index == area.groups.length - 1;

			children.add(
				KlpPositioned(
					key: ValueKey(group.id),
					left: isVertical ? 0 : offset,
					top: isVertical ? offset : 0,
					right: isVertical ? 0 : null,
					bottom: isVertical ? null : 0,
					width: isVertical ? null : groupExtent,
					height: isVertical ? groupExtent : null,
					child: ClipRect(child: _buildGroupDropTarget(
						context,
						slot,
						area,
						group,
						groupExtent,
						handleExtent,
					)),
				),
			);

			offset += groupExtent;
			if (isLast) continue;

			children.add(
				KlpPositioned(
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

		return KlpStack(clipBehavior: Clip.hardEdge, children: children);
	}

	KlpLinearLayoutResult _resolveGroupExtents(
		KlpDockAreaData area,
		double availableExtent,
		double handleExtent,
	) {
		final minimum = _resolveGroupMinExtent(area);
		return resolveKlpLinearLayout(
			extent: availableExtent,
			gutter: handleExtent,
			gutterCount: area.groups.length - 1,
			items: [for (var index = 0; index < area.groups.length; index++) KlpLinearItem(
				minimum: minimum,
				preferred: index == area.groups.length - 1 ? minimum : area.groups[index].mainAxisExtent,
				flex: index == area.groups.length - 1 ? 1 : 0,
			)],
		);
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

		return _KlpDockDropTarget(
			onWillAcceptWithDetails: (targetContext, details) {
				final acceptsPanel =
						details.data.panelId != group.activePanelId ||
						group.panelIds.length > 1;
				return acceptsPanel && _canDropPanelInSlot(details.data.panelId, slot);
			},
			onMove: (targetContext, details) => _updateGroupDropTarget(
				targetContext,
				targetId,
				area,
				group,
				details.offset,
			),
			onLeave: (targetContext, data) => _clearDropTarget(targetId),
			onAcceptWithDetails: (targetContext, details) {
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
				return KlpStack(
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
		);
	}

	Widget _buildDropIndicator({bool vertical = false}) {
		final thickness = context.klp.shape.stroke;

		return _KlpDockIndicatorFrame(
			width: vertical ? thickness : double.infinity,
			height: vertical ? KlpDockHeader.extent : thickness,
		);
	}

	/// Header 內的放置線與 code 標題使用相同的行高；DragTarget 仍由外層完整
	/// header 承擔，因此滑鼠可以在 padding 區域開始拖放。
	Widget _buildHeaderDropIndicator() {
		final type = context.klp.type;
		final definition = KlpTextStyles.definitionOf(KlpTextRole.code, type);
		final height = definition.fontSize * definition.lineHeight;

		return _KlpDockIndicatorFrame(
			width: context.klp.shape.stroke,
			height: height,
			centered: true,
		);
	}

	Widget _buildGroupSplitIndicator(KlpDockAreaData area) {
		if (area.axis == Axis.horizontal) {
			return KlpPositioned(
				top: 0,
				right: 0,
				bottom: 0,
				child: _buildDropIndicator(vertical: true),
			);
		}

		return KlpPositioned(
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
		if (panel == null) return KlpPanelFrame(content: const KlpBox.shrink());

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
						!showTabInsertion &&
						!panel.isPinned && !panel.isDirty && panel.onCloseRequested == null
				? null
				: KlpDockHeader(
						leading: leading,
						actions: [
							...panel.actions,
							if (!hasTabs && panel.onCloseRequested != null) KlpDockHeaderAction(
								icon: KlpIcons.close,
								label: _closeLabel(panel),
								enabled: !_pendingCloseRequests.containsKey(panel.id),
								onPressed: () => _requestClose(panel),
							),
						],
						dragRegionBuilder: panel.isDraggable
								? (child) => _buildPanelDraggable(data, panel, child)
								: null,
					);

		return KlpPanelFrame(
			header: header,
			content: panel.content,
			contentScrollController: panel.contentScrollController,
			headerSize: KlpPanelHeaderSize.dock,
		);
	}

	Widget _buildSinglePanelHeader(
		KlpDockPanel panel, {
		bool showTabInsertion = false,
	}) {
		return KlpRow(
			children: [
				if (panel.header != null) _buildHeaderContent(_panelLabel(panel, panel.header!)),
				if (panel.header == null && (panel.isPinned || panel.isDirty))
					_buildHeaderContent(_panelLabel(panel, const KlpBox.shrink())),
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
		return KlpRow(
			children: [
				for (var index = 0; index < group.panelIds.length; index++) ...[
					_buildDockTab(slot, area, group, index),
					if (index < group.panelIds.length - 1)
						KlpBox(width: context.klp.space.tight),
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

		return _KlpDockDropTarget(
			onWillAcceptWithDetails: (targetContext, details) {
				return _canDropPanelInSlot(details.data.panelId, slot);
			},
			onAcceptWithDetails: (targetContext, details) {
				_finishPanelDrop(
					details.data,
					slot,
					area,
					group,
					_KlpDockDropPlacement.merge,
					group.mainAxisExtent,
					0,
					insertionIndex: index + (_tabDropAfter(targetContext, details.offset) ? 1 : 0),
				);
				_clearDropTarget();
			},
			onMove: (targetContext, details) => _activateDropTarget(
				'tab:$panelId:${_tabDropAfter(targetContext, details.offset) ? 'after' : 'before'}',
				_KlpDockDropPlacement.merge,
			),
			onLeave: (targetContext, data) => _clearDropTarget(),
			builder: (context, candidateData, rejectedData) {
				final after = _activeDropTarget == 'tab:$panelId:after';
				final target = candidateData.isEmpty
						? tab
						: KlpStack(
								children: [
									tab,
									KlpPositioned(
										left: after ? null : 0,
										right: after ? 0 : null,
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

	/// 同一 tab 的前後半部決定原始插入點，提交再轉成 removal 後 index。
	bool _tabDropAfter(BuildContext targetContext, Offset globalOffset) {
		final box = targetContext.findRenderObject();
		if (box is! RenderBox) return false;
		return box.globalToLocal(globalOffset).dx >= box.size.width / 2;
	}

	Widget _buildDockTabSurface(
		KlpDockPanel? panel,
		String panelId,
		bool selected,
		VoidCallback onPressed,
	) {
		final header =
				panel?.header ?? KlpText(panelId, overflow: TextOverflow.ellipsis);
		final child = _buildHeaderContent(panel == null ? header : _panelLabel(panel, header));

		final tab = _KlpDockTabSurface(
			selected: selected,
			onPressed: onPressed,
			child: child,
		);
		if (panel?.onCloseRequested == null) return tab;
		return KlpRow(children: [tab, _closeButton(panel!)]);
	}

	Widget _buildHeaderContent(Widget child) {
		return _KlpDockHeaderContentScope(child: child);
	}

	Widget _buildPanelDraggable(
		_KlpDockPanelDragData data,
		KlpDockPanel panel,
		Widget child,
	) {
		if (!panel.isDraggable) return child;

		return _KlpDockPanelDraggable(
			data: data,
			feedback: _buildHeaderContent(panel.header ?? KlpText(panel.id)),
			onDragFinished: _finishDrag,
			child: child,
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
		_commitActions([KlpDockAction.select(panelId: panelId)]);
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
			final margin = math.min(context.klp.space.dockMargin, renderObject.size.height / 2);
			final headerHeight = math.min(context.klp.space.chromeTab, math.max(0.0, renderObject.size.height - margin * 2));
			final inHeader = _groupHasHeader(group) && localOffset.dy < margin + headerHeight;
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
					_openAreaForDrop(_KlpDockAreaSlot.bottom, bottom);
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
			_openAreaForDrop(slot, area);
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
	) {
		if (area.isVisible || area.groups.isEmpty || _previewAreaSlots.contains(slot)) return;
		setState(() => _previewAreaSlots.add(slot));
	}

	/// 臨時尺寸送到既有有限 geometry，不回寫產品保存偏好。
	KlpDockLayoutData _presentationLayout() {
		var layout = widget.layout;
		for (final slot in _previewAreaSlots) {
			final area = _areaForSlot(layout, slot);
			if (area.isVisible || area.groups.isEmpty) continue;
			layout = _replaceArea(
				layout,
				slot,
				area.copyWith(isVisible: true, extent: _constraintsForSlot(slot).minExtent),
			);
		}
		return layout;
	}

	/// Target leave 只清提示；drag 結束才收回所有展開，讓 Stage 可進入預覽 group。
	void _finishDrag() {
		if (!mounted || (_previewAreaSlots.isEmpty && _activeDropTarget == null && _activeDropPlacement == null)) return;
		setState(() {
			_previewAreaSlots.clear();
			_activeDropTarget = null;
			_activeDropPlacement = null;
		});
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

	Widget _buildStageDropIndicator(String targetId, Rect stage) {
		final slotName = targetId.substring('stage:'.length);
		final slot = _KlpDockAreaSlot.values.firstWhere((candidate) => candidate.name == slotName);
		final horizontalThickness = math.min(context.klp.shape.stroke, stage.width);
		final verticalThickness = math.min(context.klp.shape.stroke, stage.height);
		final rect = switch (slot) {
			_KlpDockAreaSlot.left => stage.topLeft & Size(horizontalThickness, stage.height),
			_KlpDockAreaSlot.right => Offset(stage.right - horizontalThickness, stage.top) & Size(horizontalThickness, stage.height),
			_KlpDockAreaSlot.bottom => Offset(stage.left, stage.bottom - verticalThickness) & Size(stage.width, verticalThickness),
		};
		return _dockSlot('dock-stage-drop-indicator', rect, const _KlpDockIndicatorFrame());
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
		Offset globalPosition, {
		required double handleExtent,
		required double maximumExtent,
	}) {
		final renderObject = dockContext.findRenderObject();
		if (renderObject is! RenderBox) return;

		final localPosition = renderObject.globalToLocal(globalPosition);
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

		final maximum = math.min(constraints.maxExtent, maximumExtent);
		if (maximum < constraints.minExtent || !requestedExtent.isFinite) return;
		final nextExtent = requestedExtent
				.clamp(constraints.minExtent, maximum)
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
		final current = _areaForSlot(widget.layout, slot);
		final actions = <KlpDockAction>[
			if (current.isVisible != area.isVisible)
				KlpDockAction.visibility(area: _publicArea(slot), isVisible: area.isVisible),
			if (current.extent != area.extent)
				KlpDockAction.resizeArea(area: _publicArea(slot), extent: area.extent),
			for (var index = 0; index < area.groups.length; index++)
				if (current.groups[index].mainAxisExtent != area.groups[index].mainAxisExtent)
					KlpDockAction.resizeGroup(groupId: area.groups[index].id, extent: area.groups[index].mainAxisExtent),
		];
		_commitActions(actions);
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
