import 'package:flutter/foundation.dart' show immutable;

import 'klp_dock_layout_codec.dart';
import 'klp_dock_layout_models.dart';

/// 固定 Stage 周圍的三個停靠區，不改寫既有 Widget 模型。
enum KlpDockArea { left, right, bottom }

/// 分頁插入或新群組；index 是移除來源之後的最終位置。
@immutable
class KlpDockDestination {
	/// 目標區域，能力由產品清冊決定。
	final KlpDockArea area;
	/// 原群組或新的全域唯一 identity。
	final String groupId;
	/// 最終分頁或群組插入位置，不 clamp。
	final int index;
	/// 新群組的有限正數偏好尺寸；tab 沒有額外尺寸。
	final double? extent;
	/// 區分原群組插入與建立群組，不承載內容。
	final bool createsGroup;

	const KlpDockDestination.tab({
		required this.area,
		required this.groupId,
		required this.index,
	}) : extent = null,
			createsGroup = false;

	const KlpDockDestination.group({
		required this.area,
		required this.groupId,
		required this.index,
		required double extent,
	}) : extent = extent,
			createsGroup = true;
}

enum _DockActionKind { select, move, open, merge, close, visibility, resizeArea, resizeGroup }

/// Typed named constructors 固定合法操作形狀，數值在提交邊界驗證。
@immutable
class KlpDockAction {
	// 私有 tag 與 payload 只由 typed constructors 建立，不暴露 JSON action tree。
	final _DockActionKind _kind;
	final String? _panelId;
	final KlpDockDestination? _destination;
	final String? _sourceGroupId;
	final String? _targetGroupId;
	final int? _index;
	final bool? _approved;
	final KlpDockArea? _area;
	final bool? _isVisible;
	final double? _extent;
	final String? _groupId;

	const KlpDockAction._(
		this._kind, {
		String? panelId,
		KlpDockDestination? destination,
		String? sourceGroupId,
		String? targetGroupId,
		int? index,
		bool? approved,
		KlpDockArea? area,
		bool? isVisible,
		double? extent,
		String? groupId,
	}) : _panelId = panelId,
			_destination = destination,
			_sourceGroupId = sourceGroupId,
			_targetGroupId = targetGroupId,
			_index = index,
			_approved = approved,
			_area = area,
			_isVisible = isVisible,
			_extent = extent,
			_groupId = groupId;

	const KlpDockAction.select({required String panelId}) : this._(_DockActionKind.select, panelId: panelId);
	const KlpDockAction.move({required String panelId, required KlpDockDestination destination}) : this._(_DockActionKind.move, panelId: panelId, destination: destination);
	const KlpDockAction.open({required String panelId, required KlpDockDestination destination}) : this._(_DockActionKind.open, panelId: panelId, destination: destination);
	const KlpDockAction.merge({
		required String sourceGroupId,
		required String targetGroupId,
		required int index,
	}) : this._(
			_DockActionKind.merge,
			sourceGroupId: sourceGroupId,
			targetGroupId: targetGroupId,
			index: index,
		);
	const KlpDockAction.close({required String panelId, required bool approved}) : this._(_DockActionKind.close, panelId: panelId, approved: approved);
	const KlpDockAction.visibility({required KlpDockArea area, required bool isVisible}) : this._(_DockActionKind.visibility, area: area, isVisible: isVisible);
	const KlpDockAction.resizeArea({required KlpDockArea area, required double extent}) : this._(_DockActionKind.resizeArea, area: area, extent: extent);
	const KlpDockAction.resizeGroup({required String groupId, required double extent}) : this._(_DockActionKind.resizeGroup, groupId: groupId, extent: extent);
}

/// 操作結果由產品採用，no-op 也提供隔離快照。
@immutable
class KlpDockActionResult {
	/// 深層不可變布局，不持有 caller 的可變列表。
	final KlpDockLayoutData layout;
	/// 完整保存值是否改變。
	final bool changed;

	const KlpDockActionResult._({required this.layout, required this.changed});
}

typedef _DockLocation = ({KlpDockArea slot, KlpDockGroupData group});
typedef _DockWorking = Map<KlpDockArea, KlpDockAreaData>;

Never _invalid(String reason) => throw FormatException('Dock action: $reason');
String _identity(String value) {
	if (value.trim().isEmpty) _invalid('nonblank identity required');
	return value;
}
int _insertion(int value, int maximum) {
	if (value < 0 || value > maximum) _invalid('index outside final list');
	return value;
}
double _extent(double value, {bool positive = false}) {
	if (!value.isFinite || value < 0 || positive && value == 0) _invalid('invalid extent');
	return value;
}
_DockLocation? _findPanel(_DockWorking work, String id) {
	for (final slot in KlpDockArea.values) {
		for (final group in work[slot]!.groups) {
			if (group.panelIds.contains(id)) return (slot: slot, group: group);
		}
	}
	return null;
}
_DockLocation _placedPanel(_DockWorking work, String id) => _findPanel(work, id) ?? _invalid('panel not placed: $id');
_DockLocation _group(_DockWorking work, String id) {
	for (final slot in KlpDockArea.values) {
		for (final group in work[slot]!.groups) {
			if (group.id == id) return (slot: slot, group: group);
		}
	}
	return _invalid('group not found: $id');
}
void _setGroup(_DockWorking work, _DockLocation location) {
	final area = work[location.slot]!;
	final groups = List<KlpDockGroupData>.of(area.groups);
	final index = groups.indexWhere((group) => group.id == location.group.id);
	if (index < 0) _invalid('group not found: ${location.group.id}');
	groups[index] = location.group;
	work[location.slot] = area.copyWith(groups: groups);
}
void _deleteGroup(_DockWorking work, _DockLocation location) {
	final area = work[location.slot]!;
	work[location.slot] = area.copyWith(groups: area.groups.where((group) => group.id != location.group.id).toList());
}
void _removePanel(_DockWorking work, _DockLocation location, String id) {
	final ids = List<String>.of(location.group.panelIds)..remove(id);
	if (ids.isEmpty) {
		_deleteGroup(work, location);
		return;
	}
	_setGroup(work, (
		slot: location.slot,
		group: location.group.copyWith(
			panelIds: ids,
			activePanelId: location.group.activePanelId == id ? ids.first : location.group.activePanelId,
		),
	));
}
void _permitted(
	List<KlpDockPanelPolicy> panels,
	String id,
	KlpDockArea slot,
) {
	final matches = panels.where((panel) => panel.id == id);
	if (matches.isEmpty) _invalid('panel not registered: $id');
	final panel = matches.first;
	final allowed = slot == KlpDockArea.bottom ? panel.allowBottom : panel.allowSide;
	if (!allowed) _invalid('panel not permitted: $id');
}

/// 驗證後只修改 owned working lists；hover 或取消不提交此操作。
KlpDockActionResult applyKlpDockAction({
	required KlpDockLayoutData layout,
	required List<KlpDockPanelPolicy> panels,
	required KlpDockAction action,
}) {
	final before = KlpDockLayoutCodec.encode(layout);
	final restored = KlpDockLayoutCodec.restore(before, panels: panels);
	if (restored.missingPanelIds.isNotEmpty) _invalid('current layout has missing panels');
	final work = <KlpDockArea, KlpDockAreaData>{
		KlpDockArea.left: restored.layout.left,
		KlpDockArea.right: restored.layout.right,
		KlpDockArea.bottom: restored.layout.bottom,
	};
	switch (action._kind) {
		case _DockActionKind.select:
			final id = _identity(action._panelId!);
			final source = _placedPanel(work, id);
			_setGroup(work, (slot: source.slot, group: source.group.copyWith(activePanelId: id)));
		case _DockActionKind.move:
		case _DockActionKind.open:
			final id = _identity(action._panelId!);
			final destination = action._destination!;
			final groupId = _identity(destination.groupId);
			final slot = destination.area;
			_permitted(panels, id, slot);
			final source = _findPanel(work, id);
			if (action._kind == _DockActionKind.move && source == null || action._kind == _DockActionKind.open && source != null) {
				_invalid('panel placement does not match action');
			}
			if (!destination.createsGroup) {
				final target = _group(work, groupId);
				if (target.slot != slot) _invalid('group area mismatch');
				final sameGroup = source?.group.id == target.group.id;
				final ids = List<String>.of(target.group.panelIds);
				final insertion = _insertion(destination.index, ids.length - (sameGroup ? 1 : 0));
				if (sameGroup) {
					ids.remove(id);
				} else if (source != null) {
					_removePanel(work, source, id);
				}
				ids.insert(insertion, id);
				_setGroup(work, (slot: slot, group: target.group.copyWith(panelIds: ids, activePanelId: id)));
			} else {
				if (work.values.any((area) => area.groups.any((group) => group.id == groupId))) _invalid('new group identity already exists');
				final preferred = _extent(destination.extent!, positive: true);
				if (source != null) _removePanel(work, source, id);
				final area = work[slot]!;
				final groups = List<KlpDockGroupData>.of(area.groups);
				groups.insert(_insertion(destination.index, groups.length), KlpDockGroupData(
					id: groupId,
					panelIds: [id],
					activePanelId: id,
					mainAxisExtent: preferred,
				));
				work[slot] = area.copyWith(groups: groups);
			}
			work[slot] = work[slot]!.copyWith(isVisible: true);
		case _DockActionKind.merge:
			final source = _group(work, _identity(action._sourceGroupId!));
			final target = _group(work, _identity(action._targetGroupId!));
			if (source.group.id == target.group.id) _invalid('cannot merge same group');
			final insertion = _insertion(action._index!, target.group.panelIds.length);
			for (final id in source.group.panelIds) {
				_permitted(panels, id, target.slot);
			}
			final ids = List<String>.of(target.group.panelIds)..insertAll(insertion, source.group.panelIds);
			_setGroup(work, (slot: target.slot, group: target.group.copyWith(panelIds: ids, activePanelId: source.group.activePanelId)));
			_deleteGroup(work, source);
			work[target.slot] = work[target.slot]!.copyWith(isVisible: true);
		case _DockActionKind.close:
			final id = _identity(action._panelId!);
			final source = _placedPanel(work, id);
			if (action._approved!) _removePanel(work, source, id);
		case _DockActionKind.visibility:
			final slot = action._area!;
			work[slot] = work[slot]!.copyWith(isVisible: action._isVisible!);
		case _DockActionKind.resizeArea:
			final slot = action._area!;
			work[slot] = work[slot]!.copyWith(extent: _extent(action._extent!));
		case _DockActionKind.resizeGroup:
			final source = _group(work, _identity(action._groupId!));
			_setGroup(work, (slot: source.slot, group: source.group.copyWith(mainAxisExtent: _extent(action._extent!, positive: true))));
	}
	final result = KlpDockLayoutData(
		left: work[KlpDockArea.left]!,
		right: work[KlpDockArea.right]!,
		bottom: work[KlpDockArea.bottom]!,
	);
	final after = KlpDockLayoutCodec.encode(result);
	return KlpDockActionResult._(
		layout: KlpDockLayoutCodec.restore(after, panels: panels).layout,
		changed: before != after,
	);
}
