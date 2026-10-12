import 'dart:convert';

import 'package:flutter/widgets.dart' show Axis, immutable;

import 'klp_dock_layout_models.dart';

/// 產品面板清冊的停靠能力投影，不保存內容與呈現狀態。
@immutable
class KlpDockPanelPolicy {
	/// 原始 identity 不 trim，避免改寫產品保存資料。
	final String id;
	/// 左右區域共用的產品能力。
	final bool allowSide;
	/// 下方區域的產品能力。
	final bool allowBottom;

	const KlpDockPanelPolicy({
		required this.id,
		this.allowSide = true,
		this.allowBottom = true,
	});
}

/// 載入成功後的布局與清冊差異，由產品決定是否採用。
@immutable
class KlpDockRestoreResult {
	/// 深層不可變快照，不持有產品原始列表。
	final KlpDockLayoutData layout;
	/// 按保存區域、群組與分頁順序列出不存在的面板。
	final List<String> missingPanelIds;
	/// 按清冊順序列出可由產品開啟的未放置面板。
	final List<String> availablePanelIds;

	KlpDockRestoreResult._({
		required this.layout,
		required List<String> missingPanelIds,
		required List<String> availablePanelIds,
	}) : missingPanelIds = List.unmodifiable(missingPanelIds),
			availablePanelIds = List.unmodifiable(availablePanelIds);
}

/// 版本化資料邊界，不執行 storage 或替換受控布局。
abstract final class KlpDockLayoutCodec {
	/// 驗證完整布局後輸出 schemaVersion 1，不依清冊刪除資料。
	static String encode(KlpDockLayoutData layout) {
		final document = _wire(layout);
		_snapshot(document);
		return jsonEncode(document);
	}

	/// 先完整驗證再比對清冊；任何非法資料以 FormatException 拒絕。
	static KlpDockRestoreResult restore(
		String source, {
		required List<KlpDockPanelPolicy> panels,
	}) {
		final saved = _snapshot(jsonDecode(source));
		final policies = <String, KlpDockPanelPolicy>{};
		for (final panel in panels) {
			final id = _id(panel.id, 'registry.id');
			if (policies.containsKey(id)) _invalid('registry.id', 'duplicate $id');
			policies[id] = panel;
		}
		final missing = <String>[];
		final placed = <String>{};
		KlpDockAreaData reconcile(KlpDockAreaData area, String slot) {
			final groups = <KlpDockGroupData>[];
			for (final group in area.groups) {
				final ids = <String>[];
				for (final id in group.panelIds) {
					final policy = policies[id];
					if (policy == null) {
						missing.add(id);
						continue;
					}
					final permitted = slot == 'bottom' ? policy.allowBottom : policy.allowSide;
					if (!permitted) _invalid('areas.$slot', 'panel $id is not permitted');
					ids.add(id);
					placed.add(id);
				}
				if (ids.isEmpty) continue;
				groups.add(group.copyWith(
					panelIds: List.unmodifiable(ids),
					activePanelId: ids.contains(group.activePanelId) ? group.activePanelId : ids.first,
				));
			}
			return area.copyWith(groups: List.unmodifiable(groups));
		}
		final layout = KlpDockLayoutData(
			left: reconcile(saved.left, 'left'),
			right: reconcile(saved.right, 'right'),
			bottom: reconcile(saved.bottom, 'bottom'),
		);
		return KlpDockRestoreResult._(
			layout: layout,
			missingPanelIds: missing,
			availablePanelIds: policies.keys.where((id) => !placed.contains(id)).toList(),
		);
	}

	static Map<String, Object> _wire(KlpDockLayoutData layout) {
		Map<String, Object> area(KlpDockAreaData value) => {
			'axis': value.axis.name,
			'isVisible': value.isVisible,
			'extent': value.extent,
			'groups': [
				for (final group in value.groups)
					{
						'id': group.id,
						'panelIds': List<String>.of(group.panelIds),
						'activePanelId': group.activePanelId,
						'mainAxisExtent': group.mainAxisExtent,
					},
			],
		};
		return {
			'schemaVersion': 1,
			'areas': {'left': area(layout.left), 'right': area(layout.right), 'bottom': area(layout.bottom)},
		};
	}

	static KlpDockLayoutData _snapshot(Object? value) {
		final document = _object(value, ['schemaVersion', 'areas'], 'document');
		if (document['schemaVersion'] != 1) _invalid('schemaVersion', 'unsupported version');
		final areas = _object(document['areas'], ['left', 'right', 'bottom'], 'areas');
		final groupIds = <String>{};
		final panelIds = <String>{};
		KlpDockAreaData area(String slot) {
			final path = 'areas.$slot';
			final data = _object(areas[slot], ['axis', 'isVisible', 'extent', 'groups'], path);
			final axis = switch (data['axis']) {
				'horizontal' => Axis.horizontal,
				'vertical' => Axis.vertical,
				_ => _invalid('$path.axis', 'unsupported axis'),
			};
			final visible = data['isVisible'];
			if (visible is! bool) _invalid('$path.isVisible', 'expected boolean');
			final extent = _extent(data['extent'], '$path.extent');
			final rawGroups = data['groups'];
			if (rawGroups is! List) _invalid('$path.groups', 'expected list');
			final groups = <KlpDockGroupData>[];
			for (var index = 0; index < rawGroups.length; index++) {
				final groupPath = '$path.groups[$index]';
				final group = _object(rawGroups[index], ['id', 'panelIds', 'activePanelId', 'mainAxisExtent'], groupPath);
				final id = _id(group['id'], '$groupPath.id');
				if (!groupIds.add(id)) _invalid('$groupPath.id', 'duplicate $id');
				final rawIds = group['panelIds'];
				if (rawIds is! List || rawIds.isEmpty) _invalid('$groupPath.panelIds', 'expected nonempty list');
				final ids = <String>[];
				for (final value in rawIds) {
					final panelId = _id(value, '$groupPath.panelIds');
					if (!panelIds.add(panelId)) _invalid('$groupPath.panelIds', 'duplicate $panelId');
					ids.add(panelId);
				}
				final active = _id(group['activePanelId'], '$groupPath.activePanelId');
				if (!ids.contains(active)) _invalid('$groupPath.activePanelId', 'not in group');
				groups.add(KlpDockGroupData(
					id: id,
					panelIds: List.unmodifiable(ids),
					activePanelId: active,
					mainAxisExtent: _extent(group['mainAxisExtent'], '$groupPath.mainAxisExtent', positive: true),
				));
			}
			return KlpDockAreaData(
				axis: axis,
				groups: List.unmodifiable(groups),
				extent: extent,
				isVisible: visible,
			);
		}
		return KlpDockLayoutData(left: area('left'), right: area('right'), bottom: area('bottom'));
	}

	static Map<String, Object?> _object(
		Object? value,
		List<String> fields,
		String path,
	) {
		if (value is! Map || value.length != fields.length || !fields.every(value.containsKey)) {
			_invalid(path, 'expected exact fields: ${fields.join(', ')}');
		}
		return {for (final field in fields) field: value[field]};
	}

	static String _id(Object? value, String path) {
		if (value is! String || value.trim().isEmpty) _invalid(path, 'expected nonblank identity');
		return value;
	}

	static double _extent(
		Object? value,
		String path, {
		bool positive = false,
	}) {
		if (value is! num || !value.isFinite || value < 0 || positive && value == 0) {
			_invalid(path, 'expected finite ${positive ? 'positive' : 'nonnegative'} number');
		}
		return value.toDouble();
	}

	static Never _invalid(String path, String reason) => throw FormatException('$path: $reason');
}
