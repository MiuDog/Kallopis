import { useLayoutEffect, useRef, useState, type DragEvent, type PointerEvent as ReactPointerEvent, type RefObject } from 'react';
import type { KlpTheme } from './theme.js';
import type { KlpDockLayoutProps } from './workbench-dock.js';
import { encodeKlpDockLayout, type KlpDockPanelPolicy } from './dock-layout-state.js';
import { applyKlpDockAction, type KlpDockAction, type KlpDockArea } from './dock-layout-operations.js';
import type { KlpDockRect } from './dock-geometry.js';
import { resolveKlpLinearLayout } from './linear-layout.js';
import { dockAreas, dockMinimum, resolveDockView, type DockGroupView, type DockView } from './workbench-dock-view.js';

interface InputArgs {
	/** props／policies 是最新受控資料；size／theme／host 提供有限座標轉換，prefix 僅產生本 instance ID。 */
	props: KlpDockLayoutProps;
	policies: readonly KlpDockPanelPolicy[];
	size: { width: number; height: number };
	theme: KlpTheme;
	host: RefObject<HTMLDivElement | null>;
	prefix: string;
}
interface Point { /** x／y 是 root CSS 座標，不含 transform scale。 */ x: number; y: number; }
interface Target {
	/** actions 是本次成功才套用的 typed 請求；rect 只屬提示，不是保存布局。 */
	actions: readonly KlpDockAction[];
	rect: KlpDockRect;
}
interface ResizeSession {
	/** pointerId／start／initial 決定此次手勢；area 或 groupId 選擇相鄰配額，moved 抑制 click。 */
	pointerId: number;
	start: Point;
	initial: number;
	area?: KlpDockArea;
	groupId?: string;
	moved: boolean;
}
function contains(rect: KlpDockRect, point: Point): boolean {
	return rect.width > 0 && rect.height > 0 && point.x >= rect.left && point.y >= rect.top && point.x <= rect.left + rect.width && point.y <= rect.top + rect.height;
}
function constraints(props: KlpDockLayoutProps, area: KlpDockArea) {
	return area === 'bottom' ? props.bottomConstraints : props[(area + 'Constraints') as 'leftConstraints' | 'rightConstraints'];
}
function allowed(props: KlpDockLayoutProps, panelId: string, area: KlpDockArea): boolean {
	const panel = props.panels.find(panel => panel.id === panelId);
	return !!panel && (area === 'bottom' ? panel.allowBottom !== false && !!props.bottomConstraints : panel.allowSide !== false);
}
function location(view: DockView, panelId: string): DockGroupView | undefined { return view.groups.find(group => group.data.panelIds.includes(panelId)); }

/** 事件只投影 typed actions；drag/resize presentation 與 caller 保存資料完全分離。 */
export function useDockInput(args: InputArgs) {
	const [preview, setPreview] = useState<ReadonlySet<KlpDockArea>>(new Set());
	const [hint, setHint] = useState<KlpDockRect | null>(null);
	const [dragPanel, setDragPanel] = useState<string | null>(null);
	const view = resolveDockView(args.props, args.size, args.theme, preview);
	const latest = useRef({ ...args, view });
	const drag = useRef<string | null>(null);
	const resizing = useRef<ResizeSession | null>(null);
	const previousLayout = useRef(args.props.layout);
	const suppressEdge = useRef<KlpDockArea | null>(null);
	const counter = useRef(0);
	const mounted = useRef(false);
	function clear(): void {
		drag.current = null;
		resizing.current = null;
		if (mounted.current) { setPreview(new Set()); setHint(null); setDragPanel(null); }
	}
	function point(event: { clientX: number; clientY: number }): Point | null {
		const data = latest.current;
		const rect = data.host.current!.getBoundingClientRect();
		if (!Number.isFinite(event.clientX) || !Number.isFinite(event.clientY) || rect.width <= 0 || rect.height <= 0 || data.size.width <= 0 || data.size.height <= 0) return null;
		const x = (event.clientX - rect.left) * (data.size.width / rect.width);
		const y = (event.clientY - rect.top) * (data.size.height / rect.height);
		return Number.isFinite(x) && Number.isFinite(y) ? { x, y } : null;
	}
	function batch(actions: readonly KlpDockAction[]): void {
		const data = latest.current;
		const before = encodeKlpDockLayout(data.props.layout);
		let layout = data.props.layout;
		for (const action of actions) layout = applyKlpDockAction(layout, data.policies, action).layout;
		if (encodeKlpDockLayout(layout) !== before) data.props.onLayoutChanged(layout);
	}
	function newGroupId(): string {
		const ids = latest.current.view.groups.map(group => group.data.id);
		let id: string;
		do { id = latest.current.prefix + ':group:' + ++counter.current; } while (ids.includes(id));
		return id;
	}
	function tabTarget(group: DockGroupView, originalIndex: number, rect: KlpDockRect): Target {
		const source = location(latest.current.view, drag.current!)!;
		const originalSourceIndex = source.data.panelIds.indexOf(drag.current!);
		const index = originalIndex - Number(source.data.id === group.data.id && originalSourceIndex < originalIndex);
		return { actions: [{ type: 'move', panelId: drag.current!, destination: { kind: 'tab', area: group.area, groupId: group.data.id, index } }], rect };
	}
	function target(event: DragEvent<HTMLDivElement>): Target | null {
		const data = latest.current;
		const p = point(event);
		const source = drag.current && location(data.view, drag.current);
		if (!p || !source || !contains({ left: 0, top: 0, ...data.size }, p)) return null;
		const element = event.target as Element;
		const tab = typeof element.closest === 'function' ? element.closest<HTMLButtonElement>('[role="tab"]') : null;
		if (tab && data.host.current!.contains(tab)) {
			const group = location(data.view, tab.dataset.panelId!);
			if (!group || !data.view.layout[group.area].isVisible || !allowed(data.props, drag.current!, group.area)) return null;
			const r = tab.getBoundingClientRect();
			const after = event.clientX >= r.left + r.width / 2;
			return tabTarget(group, group.data.panelIds.indexOf(tab.dataset.panelId!) + Number(after), group.inner);
		}
		const group = data.view.groups.find(group => data.view.layout[group.area].isVisible && contains(group.outer, p));
		if (group) {
			if (!allowed(data.props, drag.current!, group.area)) return null;
			if (p.y <= group.inner.top + group.headerHeight) return tabTarget(group, group.data.panelIds.length, group.inner);
			if (source.data.id === group.data.id && source.data.panelIds.length === 1) return null;
			const vertical = data.view.layout[group.area].axis === 'vertical';
			const minimum = dockMinimum(data.view.layout[group.area].axis);
			const pair = resolveKlpLinearLayout({ extent: vertical ? group.outer.height : group.outer.width, gutter: data.view.handle, gutterCount: 1, items: [{ minimum, preferred: minimum, flex: 1 }, { minimum, preferred: minimum, flex: 1 }] });
			if (pair.extents.some(extent => extent < minimum)) return null;
			const groups = data.props.layout[group.area].groups;
			let index = groups.findIndex(item => item.id === group.data.id) + 1;
			if (source.area === group.area && source.data.id !== group.data.id && source.data.panelIds.length === 1 && groups.findIndex(item => item.id === source.data.id) < index) index--;
			return {
				actions: [{ type: 'move', panelId: drag.current!, destination: { kind: 'group', area: group.area, groupId: newGroupId(), index, extent: pair.extents[1] } }, { type: 'resizeGroup', groupId: group.data.id, extent: pair.extents[0] }],
				rect: group.outer,
			};
		}
		const stage = data.view.geometry.stage;
		if (!contains(stage, p)) return null;
		const candidates = [
			{ area: 'left' as const, distance: p.x - stage.left, band: Math.min(data.view.rail, stage.width / 2) },
			{ area: 'right' as const, distance: stage.left + stage.width - p.x, band: Math.min(data.view.rail, stage.width / 2) },
			{ area: 'bottom' as const, distance: stage.top + stage.height - p.y, band: Math.min(data.view.rail, stage.height / 2) },
		].filter(item => item.distance <= item.band && item.band > 0 && !data.props.layout[item.area].groups.length && allowed(data.props, drag.current!, item.area)).sort((a, b) => a.distance - b.distance);
		const area = candidates[0]?.area;
		if (!area) return null;
		const limit = constraints(data.props, area)!;
		const extent = Math.max(limit.minExtent, Math.min(data.props.layout[area].extent, limit.maxExtent ?? Infinity));
		return { actions: [{ type: 'move', panelId: drag.current!, destination: { kind: 'group', area, groupId: newGroupId(), index: 0, extent: dockMinimum(data.props.layout[area].axis) } }, { type: 'resizeArea', area, extent }], rect: stage };
	}
	function previewAt(event: DragEvent<HTMLDivElement>): void {
		const data = latest.current;
		const p = point(event);
		if (!p || !drag.current || !contains({ left: 0, top: 0, ...data.size }, p)) return;
		const geometry = data.view.geometry;
		for (const area of dockAreas) {
			if (data.props.layout[area].isVisible || !data.props.layout[area].groups.length || !allowed(data.props, drag.current, area)) continue;
			let hit = p.x <= Math.min(data.view.rail, data.size.width);
			if (area === 'right') hit = p.x >= data.size.width - Math.min(data.view.rail, data.size.width) && p.y >= geometry.stage.top;
			if (area === 'bottom') hit = p.y >= data.size.height - Math.min(data.view.rail, data.size.height) && p.x >= geometry.stage.left && p.x <= geometry.stage.left + geometry.stage.width;
			if (hit) setPreview(previous => previous.has(area) ? previous : new Set([...previous, area]));
		}
	}
	function resizeTarget(event: { clientX: number; clientY: number }): Target | null {
		const data = latest.current;
		const session = resizing.current;
		const p = point(event);
		if (!p || !session) return null;
		if (session.area) {
			const area = session.area;
			const delta = area === 'bottom' ? p.y - session.start.y : p.x - session.start.x;
			const requested = session.initial + (area === 'left' ? delta : -delta);
			if (!Number.isFinite(requested)) return null;
			const handle = data.view.geometry[(area + 'Handle') as 'leftHandle' | 'rightHandle' | 'bottomHandle'];
			const limit = constraints(data.props, area)!;
			const maximum = Math.min(limit.maxExtent ?? Infinity, data.view.geometry[('maximum' + area[0].toUpperCase() + area.slice(1)) as 'maximumLeft' | 'maximumRight' | 'maximumBottom']);
			const collapse = requested < (data.props.collapseThresholds?.[area] ?? 0);
			if (!collapse && maximum < limit.minExtent) return null;
			const extent = collapse ? 0 : Math.max(limit.minExtent, Math.min(requested, maximum));
			const rect = { ...handle };
			if (area === 'left') rect.left = extent;
			else if (area === 'right') rect.left = Math.max(0, data.size.width - extent - handle.width);
			else rect.top = Math.max(data.view.geometry.stage.top, data.size.height - extent - handle.height);
			return { actions: [collapse ? { type: 'visibility', area, isVisible: false } : { type: 'resizeArea', area, extent }], rect };
		}
		const groups = data.view.groups;
		const first = groups.find(group => group.data.id === session.groupId);
		if (!first?.gutterAfter) return null;
		const adjacent = groups.filter(group => group.area === first.area);
		const second = adjacent[adjacent.indexOf(first) + 1];
		const vertical = data.props.layout[first.area].axis === 'vertical';
		const minimum = dockMinimum(data.props.layout[first.area].axis);
		const total = vertical ? first.outer.height + second.outer.height : first.outer.width + second.outer.width;
		if (total < 2 * minimum) return null;
		const delta = vertical ? p.y - session.start.y : p.x - session.start.x;
		const requested = session.initial + delta;
		if (!Number.isFinite(requested)) return null;
		const extent = Math.max(minimum, Math.min(requested, total - minimum));
		const rect = { ...first.gutterAfter };
		if (vertical) rect.top = first.outer.top + extent;
		else rect.left = first.outer.left + extent;
		return { actions: [{ type: 'resizeGroup', groupId: first.data.id, extent }, { type: 'resizeGroup', groupId: second.data.id, extent: total - extent }], rect };
	}
	useLayoutEffect(() => {
		latest.current = { ...args, view };
		const source = drag.current && args.props.panels.find(panel => panel.id === drag.current);
		if (previousLayout.current !== args.props.layout || drag.current && (!source || source.draggable === false || !location(view, drag.current))) clear();
		previousLayout.current = args.props.layout;
	});
	useLayoutEffect(() => {
		mounted.current = true;
		const document = args.host.current!.ownerDocument;
		const move = (event: PointerEvent) => {
			const session = resizing.current;
			if (!session || event.pointerId !== session.pointerId) return;
			const p = point(event);
			if (p && (p.x !== session.start.x || p.y !== session.start.y)) session.moved = true;
			setHint(resizeTarget(event)?.rect ?? null);
			if (session.moved) event.preventDefault();
		};
		const up = (event: PointerEvent) => {
			const session = resizing.current;
			if (!session || event.pointerId !== session.pointerId) return;
			const result = session.moved ? resizeTarget(event) : null;
			if (session.moved && session.area) suppressEdge.current = session.area;
			clear();
			if (result) batch(result.actions);
		};
		const cancel = (event: PointerEvent) => { if (resizing.current?.pointerId === event.pointerId) clear(); };
		const end = () => { if (drag.current) clear(); };
		const key = (event: KeyboardEvent) => { if (event.key === 'Escape' && (drag.current || resizing.current)) { event.preventDefault(); clear(); } };
		document.addEventListener('pointermove', move, { passive: false });
		document.addEventListener('pointerup', up);
		document.addEventListener('pointercancel', cancel);
		document.addEventListener('dragend', end);
		document.addEventListener('keydown', key);
		return () => {
			mounted.current = false;
			drag.current = null; resizing.current = null;
			document.removeEventListener('pointermove', move);
			document.removeEventListener('pointerup', up);
			document.removeEventListener('pointercancel', cancel);
			document.removeEventListener('dragend', end);
			document.removeEventListener('keydown', key);
		};
	}, [args.host]);
	function startDrag(event: DragEvent<HTMLButtonElement>, panelId: string): void {
		const data = latest.current;
		if (data.props.panels.find(panel => panel.id === panelId)?.draggable === false) { event.preventDefault(); return; }
		clear();
		drag.current = panelId;
		setDragPanel(panelId);
		event.dataTransfer.effectAllowed = 'move';
		event.dataTransfer.setData('application/x-kallopis-panel', panelId);
	}
	function onDragOver(event: DragEvent<HTMLDivElement>): void {
		if (!drag.current) return;
		previewAt(event);
		const result = target(event);
		setHint(result?.rect ?? null);
		if (result) { event.preventDefault(); event.dataTransfer.dropEffect = 'move'; }
	}
	function onDrop(event: DragEvent<HTMLDivElement>): void {
		if (!drag.current) return;
		const result = target(event);
		clear();
		if (result) { event.preventDefault(); batch(result.actions); }
	}
	function startResize(event: ReactPointerEvent<HTMLElement>, area?: KlpDockArea, groupId?: string): void {
		suppressEdge.current = null;
		if (event.button !== 0 || event.buttons !== 1 || event.isPrimary === false) return;
		const p = point(event);
		const data = latest.current;
		const group = groupId && data.view.groups.find(group => group.data.id === groupId);
		const rect = area ? data.view.geometry[area] : group && group.outer;
		if (!p || !rect || area && !data.props.layout[area].isVisible) return;
		clear();
		const vertical = area === 'bottom' || !!group && data.props.layout[group.area].axis === 'vertical';
		resizing.current = { pointerId: event.pointerId, start: p, initial: vertical ? rect.height : rect.width, area, groupId, moved: false };
	}
	function ignoreClick(area: KlpDockArea, detail: number): boolean {
		if (suppressEdge.current === area && detail > 0) { suppressEdge.current = null; return true; }
		return false;
	}
	function onDragLeave(event: DragEvent<HTMLDivElement>): void {
		const next = event.relatedTarget as Node | null;
		if (!next || !args.host.current!.contains(next)) setHint(null);
	}
	return { view, hint, dragPanel, startDrag, onDragOver, onDrop, onDragLeave, startResize, ignoreClick };
}
