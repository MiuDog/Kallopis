part of '../klp_dock_layout.dart';

/// UI 只轉換 pointer 意圖，保存規則由公開 pure operations 擁有。
extension _KlpDockLayoutDataOperations on _KlpDockLayoutState {
	KlpDockArea _publicArea(_KlpDockAreaSlot slot) => switch (slot) {
		_KlpDockAreaSlot.left => KlpDockArea.left,
		_KlpDockAreaSlot.right => KlpDockArea.right,
		_KlpDockAreaSlot.bottom => KlpDockArea.bottom,
	};

	/// 所有中間快照都私有；一批成功後只提交最終值一次。
	void _commitActions(List<KlpDockAction> actions) {
		final policies = [for (final panel in widget.panels) KlpDockPanelPolicy(
			id: panel.id, allowSide: panel.allowSide, allowBottom: panel.allowBottom,
		)];
		var next = widget.layout;
		for (final action in actions) {
			next = applyKlpDockAction(layout: next, panels: policies, action: action).layout;
		}
		if (KlpDockLayoutCodec.encode(next) != KlpDockLayoutCodec.encode(widget.layout)) {
			widget.onLayoutChanged(next);
		}
	}

	void _finishStageAreaDrop(
		_KlpDockPanelDragData data,
		_KlpDockAreaSlot targetSlot,
	) {
		final target = _areaForSlot(widget.layout, targetSlot);
		if (target.groups.isNotEmpty || !_canDropPanelInSlot(data.panelId, targetSlot)) return;
		final limits = _constraintsForSlot(targetSlot);
		final extent = target.extent.clamp(limits.minExtent, limits.maxExtent).toDouble();
		_commitActions([
			KlpDockAction.move(
				panelId: data.panelId,
				destination: KlpDockDestination.group(
					area: _publicArea(targetSlot),
					groupId: _createGroupId(),
					index: 0,
					extent: math.max(_resolveGroupMinExtent(target), extent),
				),
			),
			KlpDockAction.resizeArea(area: _publicArea(targetSlot), extent: extent),
		]);
	}

	void _finishPanelDrop(
		_KlpDockPanelDragData data,
		_KlpDockAreaSlot targetSlot,
		KlpDockAreaData targetArea,
		KlpDockGroupData targetGroup,
		_KlpDockDropPlacement placement,
		double targetExtent,
		double handleExtent, {
		int? insertionIndex,
	}) {
		if (!_canDropPanelInSlot(data.panelId, targetSlot)) return;
		final sourceArea = _areaForSlot(widget.layout, data.slot);
		final sourceGroups = sourceArea.groups.where((group) => group.id == data.groupId);
		if (sourceGroups.isEmpty || !sourceGroups.first.panelIds.contains(data.panelId)) return;
		final source = sourceGroups.first;
		final currentTarget = _areaForSlot(widget.layout, targetSlot);
		final targets = currentTarget.groups.where((group) => group.id == targetGroup.id);
		if (targets.isEmpty) return;
		final target = targets.first;
		final sameGroup = source.id == target.id;
		if (placement == _KlpDockDropPlacement.merge) {
			final requested = insertionIndex ?? target.panelIds.length;
			final sourceIndex = source.panelIds.indexOf(data.panelId);
			final removedBefore = sameGroup && sourceIndex < requested;
			final finalIndex = (requested - (removedBefore ? 1 : 0)).clamp(
				0,
				target.panelIds.length - (sameGroup ? 1 : 0),
			);
			_commitActions([KlpDockAction.move(
				panelId: data.panelId,
				destination: KlpDockDestination.tab(
					area: _publicArea(targetSlot), groupId: target.id, index: finalIndex,
				),
			)]);
			return;
		}
		if (sameGroup && source.panelIds.length == 1) return;
		final minimum = _resolveGroupMinExtent(currentTarget);
		// 單 group 當前沒有 gutter；split 必須解析將新增的一個有效 gutter。
		final splitGutter = resolveKlpLinearLayout(
			extent: targetExtent,
			gutter: context.klp.geometry.layout.resizeHandleExtent,
			gutterCount: 1,
			items: [
				KlpLinearItem(minimum: minimum, preferred: minimum, flex: 1),
				KlpLinearItem(minimum: minimum, preferred: minimum, flex: 1),
			],
		).gutter;
		final available = targetExtent - splitGutter;
		if (available < minimum * 2) return;
		final splitExtent = available / 2;
		// group index 以 source removal 後的列表計算，pure API 不做隱含 clamp。
		final remainingGroups = currentTarget.groups.where((group) =>
			!(data.slot == targetSlot && group.id == source.id && source.panelIds.length == 1),
		).toList();
		final targetIndex = remainingGroups.indexWhere((group) => group.id == target.id);
		_commitActions([
			KlpDockAction.move(
				panelId: data.panelId,
				destination: KlpDockDestination.group(
					area: _publicArea(targetSlot), groupId: _createGroupId(),
					index: targetIndex + 1, extent: splitExtent,
				),
			),
			KlpDockAction.resizeGroup(groupId: target.id, extent: splitExtent),
		]);
	}

	String _createGroupId() {
		final ids = <String>{
			for (final area in [widget.layout.left, widget.layout.right, widget.layout.bottom])
				for (final group in area.groups) group.id,
		};
		late String id;
		do {
			id = 'dock-group-${_groupSequence++}';
		} while (ids.contains(id));
		return id;
	}

	KlpDockAreaData _areaForSlot(
		KlpDockLayoutData layout,
		_KlpDockAreaSlot slot,
	) => switch (slot) {
		_KlpDockAreaSlot.left => layout.left,
		_KlpDockAreaSlot.right => layout.right,
		_KlpDockAreaSlot.bottom => layout.bottom,
	};
}
