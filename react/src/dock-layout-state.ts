/** 固定區域內的一組分頁，不包含產品內容或 dirty 狀態。 */
export interface KlpDockGroupData {
	/** 全部區域共用的群組 identity。 */
	readonly id: string;
	/** 保存的分頁順序，panel identity 全域唯一。 */
	readonly panelIds: readonly string[];
	/** 必須屬於自己的 panelIds。 */
	readonly activePanelId: string;
	/** 區域主軸的有限正數偏好尺寸。 */
	readonly mainAxisExtent: number;
}
export interface KlpDockAreaData {
	/** 群組排列方向，不從區域名稱推定。 */
	readonly axis: 'horizontal' | 'vertical';
	/** 收合仍保留原群組與尺寸。 */
	readonly isVisible: boolean;
	/** 左右寬度或下方高度的有限非負偏好尺寸。 */
	readonly extent: number;
	readonly groups: readonly KlpDockGroupData[];
}
export interface KlpDockLayoutData {
	/** Stage 周圍的三個受控區域；Stage 內容不保存。 */
	readonly left: KlpDockAreaData;
	readonly right: KlpDockAreaData;
	readonly bottom: KlpDockAreaData;
}
export interface KlpDockPanelPolicy {
	/** 清冊的原始 identity，不 trim。 */
	readonly id: string;
	/** 未提供表示允許左右區域。 */
	readonly allowSide?: boolean;
	/** 未提供表示允許下方區域。 */
	readonly allowBottom?: boolean;
}
export interface KlpDockRestoreResult {
	/** 與 caller 隔離的深層 frozen 布局。 */
	readonly layout: KlpDockLayoutData;
	/** 按保存區域、群組、分頁順序列出缺少面板。 */
	readonly missingPanelIds: readonly string[];
	/** 按清冊順序列出未放置面板。 */
	readonly availablePanelIds: readonly string[];
}

const slots = ['left', 'right', 'bottom'] as const;

function invalid(path: string, reason: string): never {
	throw new TypeError(path + ': ' + reason);
}
function object(
	value: unknown,
	fields: readonly string[],
	path: string,
	optional: readonly string[] = [],
): Record<string, unknown> {
	if (value === null || typeof value !== 'object' || Array.isArray(value)) invalid(path, 'expected object');
	if (!fields.every(field => Object.hasOwn(value, field)) || Object.keys(value).some(field => !fields.includes(field) && !optional.includes(field))) {
		invalid(path, 'expected exact fields');
	}
	return value as Record<string, unknown>;
}
function identity(value: unknown, path: string): string {
	if (typeof value !== 'string' || !value.trim()) invalid(path, 'expected nonblank identity');
	return value;
}
function extent(value: unknown, path: string, positive = false): number {
	if (typeof value !== 'number' || !Number.isFinite(value) || value < 0 || positive && value === 0) invalid(path, 'expected finite valid extent');
	return value;
}
function list(value: unknown, path: string): unknown[] {
	if (!Array.isArray(value)) invalid(path, 'expected list');
	// native caller 的稀疏陣列不能在 encode 時變成非法 JSON null 群組。
	for (let index = 0; index < value.length; index++) {
		if (!Object.hasOwn(value, index)) invalid(path, 'expected dense list');
	}
	return value;
}

/** 完整資料驗證先於清冊比對；不能靠過濾面板掩蓋非法保存資料。 */
function snapshot(value: unknown): KlpDockLayoutData {
	const areas = object(value, slots, 'areas');
	const groupIds = new Set<string>();
	const panelIds = new Set<string>();
	function area(slot: typeof slots[number]): KlpDockAreaData {
		const path = 'areas.' + slot;
		const data = object(areas[slot], ['axis', 'isVisible', 'extent', 'groups'], path);
		if (data.axis !== 'horizontal' && data.axis !== 'vertical') invalid(path + '.axis', 'unsupported axis');
		if (typeof data.isVisible !== 'boolean') invalid(path + '.isVisible', 'expected boolean');
		const areaExtent = extent(data.extent, path + '.extent');
		const groups = list(data.groups, path + '.groups').map((value, index) => {
			const groupPath = path + '.groups[' + index + ']';
			const group = object(value, ['id', 'panelIds', 'activePanelId', 'mainAxisExtent'], groupPath);
			const id = identity(group.id, groupPath + '.id');
			if (groupIds.has(id)) invalid(groupPath + '.id', 'duplicate ' + id);
			groupIds.add(id);
			const ids = list(group.panelIds, groupPath + '.panelIds');
			if (!ids.length) invalid(groupPath + '.panelIds', 'expected nonempty list');
			const panels: string[] = [];
			for (const value of ids) {
				const panelId = identity(value, groupPath + '.panelIds');
				if (panelIds.has(panelId)) invalid(groupPath + '.panelIds', 'duplicate ' + panelId);
				panelIds.add(panelId);
				panels.push(panelId);
			}
			const activePanelId = identity(group.activePanelId, groupPath + '.activePanelId');
			if (!panels.includes(activePanelId)) invalid(groupPath + '.activePanelId', 'not in group');
			return Object.freeze({ id, panelIds: Object.freeze(panels), activePanelId, mainAxisExtent: extent(group.mainAxisExtent, groupPath + '.mainAxisExtent', true) });
		});
		return Object.freeze({ axis: data.axis, isVisible: data.isVisible, extent: areaExtent, groups: Object.freeze(groups) });
	}
	return Object.freeze({ left: area('left'), right: area('right'), bottom: area('bottom') });
}

/** 保存完整布局；只輸出資料，不執行 storage 或修改 caller。 */
export function encodeKlpDockLayout(layout: KlpDockLayoutData): string {
	return JSON.stringify({ schemaVersion: 1, areas: snapshot(layout) });
}

/** 載入成功後由產品決定是否採用；任何錯誤都不替換目前 state。 */
export function restoreKlpDockLayout(source: string, panels: readonly KlpDockPanelPolicy[]): KlpDockRestoreResult {
	if (typeof source !== 'string') invalid('source', 'expected JSON string');
	let parsed: unknown;
	try { parsed = JSON.parse(source); }
	catch { invalid('source', 'invalid JSON'); }
	const document = object(parsed, ['schemaVersion', 'areas'], 'document');
	if (document.schemaVersion !== 1) invalid('schemaVersion', 'unsupported version');
	const saved = snapshot(document.areas);
	const policies = new Map<string, KlpDockPanelPolicy>();
	for (const value of list(panels, 'registry')) {
		const data = object(
			value,
			['id'],
			'registry',
			['allowSide', 'allowBottom'],
		);
		const id = identity(data.id, 'registry.id');
		if (policies.has(id)) invalid('registry.id', 'duplicate ' + id);
		for (const field of ['allowSide', 'allowBottom']) {
			if (data[field] !== undefined && typeof data[field] !== 'boolean') invalid('registry.' + field, 'expected boolean');
		}
		policies.set(id, { id, allowSide: data.allowSide as boolean | undefined, allowBottom: data.allowBottom as boolean | undefined });
	}
	const missingPanelIds: string[] = [];
	const placed = new Set<string>();
	function reconcile(slot: typeof slots[number]): KlpDockAreaData {
		const area = saved[slot];
		const groups: KlpDockGroupData[] = [];
		for (const group of area.groups) {
			const ids: string[] = [];
			for (const id of group.panelIds) {
				const policy = policies.get(id);
				if (!policy) { missingPanelIds.push(id); continue; }
				const permitted = slot === 'bottom' ? policy.allowBottom : policy.allowSide;
				if (permitted === false) invalid('areas.' + slot, 'panel ' + id + ' is not permitted');
				ids.push(id);
				placed.add(id);
			}
			if (!ids.length) continue;
			groups.push(Object.freeze({ ...group, panelIds: Object.freeze(ids), activePanelId: ids.includes(group.activePanelId) ? group.activePanelId : ids[0] }));
		}
		return Object.freeze({ ...area, groups: Object.freeze(groups) });
	}
	const layout = Object.freeze({ left: reconcile('left'), right: reconcile('right'), bottom: reconcile('bottom') });
	return Object.freeze({
		layout,
		missingPanelIds: Object.freeze(missingPanelIds),
		availablePanelIds: Object.freeze([...policies.keys()].filter(id => !placed.has(id))),
	});
}
