import { encodeKlpDockLayout, restoreKlpDockLayout, type KlpDockLayoutData, type KlpDockPanelPolicy } from './dock-layout-state.js';

export type KlpDockArea = 'left' | 'right' | 'bottom';
/** index 是移除來源之後的最終位置；group extent 只是偏好尺寸。 */
export type KlpDockDestination =
	| { readonly kind: 'tab'; readonly area: KlpDockArea; readonly groupId: string; readonly index: number }
	| { readonly kind: 'group'; readonly area: KlpDockArea; readonly groupId: string; readonly index: number; readonly extent: number };
/** 單一受控操作，不承載產品內容、dirty 狀態或 callback。 */
export type KlpDockAction =
	| { readonly type: 'select'; readonly panelId: string }
	| { readonly type: 'move' | 'open'; readonly panelId: string; readonly destination: KlpDockDestination }
	| { readonly type: 'merge'; readonly sourceGroupId: string; readonly targetGroupId: string; readonly index: number }
	| { readonly type: 'close'; readonly panelId: string; readonly approved: boolean }
	| { readonly type: 'visibility'; readonly area: KlpDockArea; readonly isVisible: boolean }
	| { readonly type: 'resizeArea'; readonly area: KlpDockArea; readonly extent: number }
	| { readonly type: 'resizeGroup'; readonly groupId: string; readonly extent: number };
export interface KlpDockActionResult {
	/** 深層不可變，與 caller 及其後續修改隔離。 */
	readonly layout: KlpDockLayoutData;
	/** 比較完整保存值，no-op 仍回傳隔離快照。 */
	readonly changed: boolean;
}

type MutableGroup = { id: string; panelIds: string[]; activePanelId: string; mainAxisExtent: number };
type MutableArea = { axis: 'horizontal' | 'vertical'; isVisible: boolean; extent: number; groups: MutableGroup[] };
type MutableLayout = Record<KlpDockArea, MutableArea>;
/** 所有可變引用都只指向此次呼叫擁有的 working copy。 */
type Location = { slot: KlpDockArea; area: MutableArea; group: MutableGroup };
const slots: readonly KlpDockArea[] = ['left', 'right', 'bottom'];
const fields: Record<string, readonly string[]> = {
	select: ['type', 'panelId'], move: ['type', 'panelId', 'destination'], open: ['type', 'panelId', 'destination'],
	merge: ['type', 'sourceGroupId', 'targetGroupId', 'index'], close: ['type', 'panelId', 'approved'],
	visibility: ['type', 'area', 'isVisible'], resizeArea: ['type', 'area', 'extent'], resizeGroup: ['type', 'groupId', 'extent'],
};
function invalid(path: string): never { throw new TypeError('Dock action: ' + path); }
function record(value: unknown): Record<string, unknown> {
	if (!value || typeof value !== 'object' || Array.isArray(value)) invalid('expected object');
	return value as Record<string, unknown>;
}
function exact(value: unknown, keys: readonly string[]): void {
	const data = record(value);
	if (Object.keys(data).length !== keys.length || !keys.every(key => Object.hasOwn(data, key))) invalid('exact fields required');
}
function identity(value: unknown): string {
	if (typeof value !== 'string' || !value.trim()) invalid('nonblank identity required');
	return value;
}
function areaName(value: unknown): KlpDockArea {
	if (typeof value !== 'string' || !slots.includes(value as KlpDockArea)) invalid('unknown area');
	return value as KlpDockArea;
}
function index(value: unknown, maximum: number): number {
	if (typeof value !== 'number' || !Number.isInteger(value) || value < 0 || value > maximum) invalid('index outside final list');
	return value;
}
function extent(value: unknown, positive = false): number {
	if (typeof value !== 'number' || !Number.isFinite(value) || value < 0 || positive && value === 0) invalid('invalid extent');
	return value;
}
function panelAt(layout: MutableLayout, id: string): Location | undefined {
	for (const slot of slots) {
		const area = layout[slot];
		const group = area.groups.find(group => group.panelIds.includes(id));
		if (group) return { slot, area, group };
	}
	return undefined;
}
function placedPanel(layout: MutableLayout, id: string): Location {
	return panelAt(layout, id) ?? invalid('panel not placed: ' + id);
}
function groupAt(layout: MutableLayout, id: string): Location {
	for (const slot of slots) {
		const area = layout[slot];
		const group = area.groups.find(group => group.id === id);
		if (group) return { slot, area, group };
	}
	return invalid('group not found: ' + id);
}
function removePanel(location: Location, id: string): void {
	const { area, group } = location;
	group.panelIds.splice(group.panelIds.indexOf(id), 1);
	if (!group.panelIds.length) area.groups.splice(area.groups.indexOf(group), 1);
	else if (group.activePanelId === id) group.activePanelId = group.panelIds[0];
}
function permitted(panels: readonly KlpDockPanelPolicy[], id: string, slot: KlpDockArea): void {
	const policy = panels.find(panel => panel.id === id);
	if (!policy) invalid('panel not registered: ' + id);
	const allowed = slot === 'bottom' ? policy.allowBottom : policy.allowSide;
	if (allowed === false) invalid('panel not permitted: ' + id);
}

/** 成功才產生新快照；UI 在 hover／取消時不應呼叫此提交邊界。 */
export function applyKlpDockAction(layout: KlpDockLayoutData, panels: readonly KlpDockPanelPolicy[], action: KlpDockAction): KlpDockActionResult {
	const before = encodeKlpDockLayout(layout);
	const validated = restoreKlpDockLayout(before, panels);
	if (validated.missingPanelIds.length) invalid('current layout has missing panels');
	const data = record(action);
	if (typeof data.type !== 'string' || !Object.hasOwn(fields, data.type)) invalid('unknown action');
	exact(action, fields[data.type]);
	const work = JSON.parse(before).areas as MutableLayout;
	switch (action.type) {
		case 'select': {
			const id = identity(action.panelId);
			placedPanel(work, id).group.activePanelId = id;
			break;
		}
		case 'move':
		case 'open': {
			const id = identity(action.panelId);
			const destination = record(action.destination);
			if (destination.kind !== 'tab' && destination.kind !== 'group') invalid('unknown destination');
			exact(destination, destination.kind === 'tab' ? ['kind', 'area', 'groupId', 'index'] : ['kind', 'area', 'groupId', 'index', 'extent']);
			const slot = areaName(destination.area);
			const groupId = identity(destination.groupId);
			permitted(panels, id, slot);
			const source = panelAt(work, id);
			if (action.type === 'move' && !source || action.type === 'open' && source) invalid('panel placement does not match action');
			const target = work[slot];
			if (destination.kind === 'tab') {
				const location = groupAt(work, groupId);
				if (location.slot !== slot) invalid('group area mismatch');
				const sameGroup = source?.group === location.group;
				const insertion = index(destination.index, location.group.panelIds.length - (sameGroup ? 1 : 0));
				if (sameGroup) location.group.panelIds.splice(location.group.panelIds.indexOf(id), 1);
				else if (source) removePanel(source, id);
				location.group.panelIds.splice(insertion, 0, id);
				location.group.activePanelId = id;
			} else {
				if (slots.some(slot => work[slot].groups.some(group => group.id === groupId))) invalid('new group identity already exists');
				const preferred = extent(destination.extent, true);
				if (source) removePanel(source, id);
				const insertion = index(destination.index, target.groups.length);
				target.groups.splice(insertion, 0, { id: groupId, panelIds: [id], activePanelId: id, mainAxisExtent: preferred });
			}
			target.isVisible = true;
			break;
		}
		case 'merge': {
			const source = groupAt(work, identity(action.sourceGroupId));
			const target = groupAt(work, identity(action.targetGroupId));
			if (source.group === target.group) invalid('cannot merge same group');
			const insertion = index(action.index, target.group.panelIds.length);
			for (const id of source.group.panelIds) permitted(panels, id, target.slot);
			// 陣列拼接避免大量合法 tabs 超過引擎函式參數上限。
			target.group.panelIds = [...target.group.panelIds.slice(0, insertion), ...source.group.panelIds, ...target.group.panelIds.slice(insertion)];
			target.group.activePanelId = source.group.activePanelId;
			source.area.groups.splice(source.area.groups.indexOf(source.group), 1);
			target.area.isVisible = true;
			break;
		}
		case 'close': {
			const id = identity(action.panelId);
			const source = placedPanel(work, id);
			if (typeof action.approved !== 'boolean') invalid('approval boolean required');
			if (action.approved) removePanel(source, id);
			break;
		}
		case 'visibility':
			if (typeof action.isVisible !== 'boolean') invalid('visibility boolean required');
			work[areaName(action.area)].isVisible = action.isVisible;
			break;
		case 'resizeArea':
			work[areaName(action.area)].extent = extent(action.extent);
			break;
		case 'resizeGroup':
			groupAt(work, identity(action.groupId)).group.mainAxisExtent = extent(action.extent, true);
			break;
	}
	const after = encodeKlpDockLayout(work);
	return Object.freeze({ layout: restoreKlpDockLayout(after, panels).layout, changed: before !== after });
}
