part of '../klp_dock_layout.dart';

extension _KlpDockLayoutDataOperations on _KlpDockLayoutState {

	void _finishStageAreaDrop(_KlpDockPanelDragData data, _KlpDockAreaSlot targetSlot) {
		if (_areaForSlot(widget.layout, targetSlot).groups.isNotEmpty) return;
		if (!_canDropPanelInSlot(data.panelId, targetSlot)) return;

		var nextLayout = widget.layout;
		final sourceArea = _areaForSlot(nextLayout, data.slot);
		final nextSourceArea = _removePanel(sourceArea, data);
		if (nextSourceArea == null) return;

		nextLayout = _replaceArea(nextLayout, data.slot, nextSourceArea);
		final targetArea = _areaForSlot(nextLayout, targetSlot);
		final targetConstraints = _constraintsForSlot(targetSlot);
		final targetExtent = targetArea.extent.clamp(
			targetConstraints.minExtent,
			targetConstraints.maxExtent,
		).toDouble();
		final nextTargetArea = targetArea.copyWith(
			isVisible: true,
			extent: targetExtent,
			groups: [
				KlpDockGroupData(
					id: _createGroupId(),
					panelIds: [data.panelId],
					activePanelId: data.panelId,
					mainAxisExtent: targetExtent,
				),
			],
		);

		widget.onLayoutChanged(_replaceArea(nextLayout, targetSlot, nextTargetArea));
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

		if (data.slot == targetSlot && data.groupId == targetGroup.id && placement == _KlpDockDropPlacement.merge) {
			_reorderPanelInGroup(
				targetSlot,
				targetArea,
				targetGroup,
				data.panelId,
				insertionIndex ?? targetGroup.panelIds.length,
			);
			return;
		}

		if (placement == _KlpDockDropPlacement.splitAfter) {
			final minExtent = _resolveGroupMinExtent(targetArea);
			if (targetExtent - handleExtent < minExtent * 2) return;
		}

		var nextLayout = widget.layout;
		final sourceArea = _areaForSlot(nextLayout, data.slot);
		final nextSourceArea = _removePanel(sourceArea, data);
		if (nextSourceArea == null) return;

		final targetGroups = data.slot == targetSlot
			? List<KlpDockGroupData>.of(nextSourceArea.groups)
			: List<KlpDockGroupData>.of(targetArea.groups);
		final targetGroupIndex = targetGroups.indexWhere((group) => group.id == targetGroup.id);
		if (targetGroupIndex < 0) return;

		if (placement == _KlpDockDropPlacement.merge) {
			final currentTargetGroup = targetGroups[targetGroupIndex];
			final targetPanelIds = List<String>.of(currentTargetGroup.panelIds);
			final requestedIndex = insertionIndex ?? targetPanelIds.length;
			final targetIndex = requestedIndex.clamp(0, targetPanelIds.length);

			targetPanelIds.insert(targetIndex, data.panelId);
			targetGroups[targetGroupIndex] = currentTargetGroup.copyWith(
				panelIds: targetPanelIds,
				activePanelId: data.panelId,
			);
		}
		else {
			final currentTargetGroup = targetGroups[targetGroupIndex];
			final splitContentExtent = targetExtent - handleExtent;
			final splitExtent = splitContentExtent / 2;

			targetGroups[targetGroupIndex] = currentTargetGroup.copyWith(mainAxisExtent: splitExtent);
			targetGroups.insert(
				targetGroupIndex + 1,
				KlpDockGroupData(
					id: _createGroupId(),
					panelIds: [data.panelId],
					activePanelId: data.panelId,
					mainAxisExtent: splitExtent,
				),
			);
		}

		if (data.slot == targetSlot) {
			nextLayout = _replaceArea(nextLayout, targetSlot, targetArea.copyWith(groups: targetGroups));
		}
		else {
			nextLayout = _replaceArea(nextLayout, data.slot, nextSourceArea);
			nextLayout = _replaceArea(nextLayout, targetSlot, targetArea.copyWith(groups: targetGroups));
		}

		widget.onLayoutChanged(nextLayout);
	}

	KlpDockAreaData? _removePanel(KlpDockAreaData area, _KlpDockPanelDragData data) {
		final groups = List<KlpDockGroupData>.of(area.groups);
		final groupIndex = groups.indexWhere((group) => group.id == data.groupId);
		if (groupIndex < 0) return null;

		final group = groups[groupIndex];
		final panelIds = List<String>.of(group.panelIds);
		if (!panelIds.remove(data.panelId)) return null;

		if (panelIds.isEmpty) {
			groups.removeAt(groupIndex);
			return area.copyWith(groups: groups);
		}

		final activePanelId = group.activePanelId == data.panelId ? panelIds.first : group.activePanelId;
		groups[groupIndex] = group.copyWith(panelIds: panelIds, activePanelId: activePanelId);
		return area.copyWith(groups: groups);
	}

	void _reorderPanelInGroup(
		_KlpDockAreaSlot slot,
		KlpDockAreaData area,
		KlpDockGroupData group,
		String panelId,
		int? insertionIndex,
	) {
		if (insertionIndex == null) return;

		final sourceIndex = group.panelIds.indexOf(panelId);
		if (sourceIndex < 0) return;

		final panelIds = List<String>.of(group.panelIds);
		panelIds.removeAt(sourceIndex);

		final adjustedInsertionIndex = sourceIndex < insertionIndex ? insertionIndex - 1 : insertionIndex;
		final targetIndex = adjustedInsertionIndex.clamp(0, panelIds.length);
		panelIds.insert(targetIndex, panelId);

		final groupIndex = area.groups.indexWhere((candidate) => candidate.id == group.id);
		final groups = List<KlpDockGroupData>.of(area.groups);
		groups[groupIndex] = group.copyWith(panelIds: panelIds);
		_emitAreaChange(slot, area.copyWith(groups: groups));
	}

	String _createGroupId() {
		final ids = <String>{
			for (final area in [widget.layout.left, widget.layout.right, widget.layout.bottom])
				for (final group in area.groups) group.id,
		};

		late String id;
		do {
			id = 'dock-group-${_groupSequence++}';
		}
		while (ids.contains(id));

		return id;
	}

	KlpDockAreaData _areaForSlot(KlpDockLayoutData layout, _KlpDockAreaSlot slot) {
		switch (slot) {
			case _KlpDockAreaSlot.left:
				return layout.left;
			case _KlpDockAreaSlot.right:
				return layout.right;
			case _KlpDockAreaSlot.bottom:
				return layout.bottom;
		}
	}
}
