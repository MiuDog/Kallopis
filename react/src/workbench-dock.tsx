import { useId, useImperativeHandle, useRef, type CSSProperties, type HTMLAttributes, type KeyboardEvent, type ReactNode, type Ref } from 'react';
import { KlpIconButton, KlpSurface, KlpText } from './components.js';
import { useKlp, type KlpTheme } from './theme.js';
import { encodeKlpDockLayout, restoreKlpDockLayout, type KlpDockLayoutData, type KlpDockPanelPolicy } from './dock-layout-state.js';
import { applyKlpDockAction, type KlpDockAction, type KlpDockArea } from './dock-layout-operations.js';
import { resolveKlpDockGeometry, type KlpDockAreaConstraints, type KlpDockRect } from './dock-geometry.js';
import { resolveKlpLinearLayout } from './linear-layout.js';
import { useDockClose, useDockSize } from './workbench-dock-lifecycle.js';

export interface KlpDockPanel extends KlpDockPanelPolicy {
	/** label／icon：分頁名稱與產品圖示；content：產品原生內容，不寫入保存資料。 */
	readonly label: string;
	readonly icon?: ReactNode;
	readonly content: ReactNode;
	/** draggable 是停靠操作能力；pinned／dirty 只呈現產品 metadata，不介入批准或排序。 */
	readonly draggable?: boolean;
	readonly isPinned?: boolean;
	readonly isDirty?: boolean;
	/** callback 批准後才移出布局；closeLabel 供產品本地化，callback 身分應保持穩定。 */
	readonly onCloseRequested?: () => boolean | Promise<boolean>;
	readonly closeLabel?: string;
}
export interface KlpDockLayoutProps extends Omit<HTMLAttributes<HTMLDivElement>, 'children'> {
	/** layout 是唯一保存權威；panels 提供當前清冊；stage／contentHeader 是產品內容槽。 */
	layout: KlpDockLayoutData;
	panels: readonly KlpDockPanel[];
	stage: ReactNode;
	contentHeader?: ReactNode;
	/** 三區限制屬於產品邏輯；缺省 Bottom 僅允許隱藏且空，實際配額另由有限宿主解算。 */
	leftConstraints: KlpDockAreaConstraints;
	rightConstraints: KlpDockAreaConstraints;
	bottomConstraints?: KlpDockAreaConstraints;
	/** changed 才通知一次；onCloseError 讓產品呈現批准錯誤，未提供則交宿主。 */
	onLayoutChanged: (layout: KlpDockLayoutData) => void;
	onCloseError?: (error: unknown, panelId: string) => void;
	/** label／areaLabels 是可及與本地化名称；ref 指向有限布局宿主。 */
	label?: string;
	areaLabels?: Partial<Record<KlpDockArea, string>>;
	ref?: Ref<HTMLDivElement>;
}
const areas: readonly KlpDockArea[] = ['left', 'right', 'bottom'];
const defaultLabels = { left: 'Left', right: 'Right', bottom: 'Bottom' };

function label(value: unknown, field: string): void {
	if (typeof value !== 'string' || !value.trim()) throw new TypeError('Dock: invalid ' + field);
}
function numeric(theme: KlpTheme, id: string): number {
	const value = Number(theme.semantic(id));
	if (!Number.isFinite(value) || value < 0) throw new TypeError('Dock: invalid semantic ' + id);
	return value;
}
function validate(props: KlpDockLayoutProps): readonly KlpDockPanelPolicy[] {
	if (!Array.isArray(props.panels)) throw new TypeError('Dock: panels must be an array');
	if (typeof props.onLayoutChanged !== 'function') throw new TypeError('Dock: onLayoutChanged required');
	if (props.onCloseError !== undefined && typeof props.onCloseError !== 'function') throw new TypeError('Dock: invalid onCloseError');
	label(props.label ?? 'Workbench', 'label');
	for (const area of areas) label(props.areaLabels?.[area] ?? defaultLabels[area], 'areaLabels.' + area);
	const policies = props.panels.map(panel => {
		if (!panel || typeof panel !== 'object') throw new TypeError('Dock: invalid panel');
		label(panel.label, 'panel.label');
		if (panel.closeLabel !== undefined) label(panel.closeLabel, 'panel.closeLabel');
		for (const field of ['draggable', 'isPinned', 'isDirty'] as const) {
			if (panel[field] !== undefined && typeof panel[field] !== 'boolean') throw new TypeError('Dock: invalid panel.' + field);
		}
		if (panel.onCloseRequested !== undefined && typeof panel.onCloseRequested !== 'function') throw new TypeError('Dock: invalid onCloseRequested');
		return { id: panel.id, ...(panel.allowSide === undefined ? {} : { allowSide: panel.allowSide }), ...(panel.allowBottom === undefined ? {} : { allowBottom: panel.allowBottom }) };
	});
	const result = restoreKlpDockLayout(encodeKlpDockLayout(props.layout), policies);
	if (result.missingPanelIds.length) throw new TypeError('Dock: current layout contains missing panels');
	return policies;
}
function position(rect: KlpDockRect): CSSProperties {
	return { position: 'absolute', left: rect.left, top: rect.top, width: rect.width, height: rect.height, minWidth: 0, minHeight: 0, overflow: 'hidden', boxSizing: 'border-box' };
}

/** 受控 native DOM；沒有保存鏡像，所有事件都交既有 pure action。 */
export function KlpDockLayout(props: KlpDockLayoutProps) {
	const theme = useKlp();
	const policies = validate(props);
	const host = useRef<HTMLDivElement>(null);
	const prefix = useId();
	useImperativeHandle(props.ref, () => host.current!, []);
	const size = useDockSize(host);
	const close = useDockClose(props, policies);
	const handle = numeric(theme, 'theme.geometry.layout.resizeHandleExtent');
	const chrome = numeric(theme, 'theme.spacing.chromeTab');
	const margin = numeric(theme, 'theme.spacing.dockMargin');
	const radius = Math.max(0, numeric(theme, 'theme.shape.card') - numeric(theme, 'theme.shape.stroke'));
	const icon = numeric(theme, 'theme.spacing.iconButton');
	const headerPresent = props.contentHeader !== undefined && props.contentHeader !== null;
	const geometry = resolveKlpDockGeometry({
		...size,
		layout: props.layout,
		leftConstraints: props.leftConstraints,
		rightConstraints: props.rightConstraints,
		bottomConstraints: props.bottomConstraints,
		handleExtent: handle,
		headerExtent: headerPresent ? numeric(theme, 'theme.spacing.chromeHeader') : undefined,
	});
	const panelById = new Map(props.panels.map(panel => [panel.id, panel]));
	function commit(action: KlpDockAction): void {
		const result = applyKlpDockAction(props.layout, policies, action);
		if (result.changed) props.onLayoutChanged(result.layout);
	}
	function keyboard(event: KeyboardEvent<HTMLButtonElement>, panelIds: readonly string[]): void {
		const current = panelIds.indexOf(event.currentTarget.dataset.panelId!);
		let index: number;
		if (event.key === 'ArrowRight') index = (current + 1) % panelIds.length;
		else if (event.key === 'ArrowLeft') index = (current + panelIds.length - 1) % panelIds.length;
		else if (event.key === 'Home') index = 0;
		else if (event.key === 'End') index = panelIds.length - 1;
		else return;
		event.preventDefault();
		const id = panelIds[index];
		commit({ type: 'select', panelId: id });
		const tab = host.current!.ownerDocument.getElementById(prefix + ':tab:' + encodeURIComponent(id));
		tab?.focus();
	}
	function renderArea(area: KlpDockArea): ReactNode {
		const data = props.layout[area];
		const rect = geometry[area] ?? { left: 0, top: 0, width: 0, height: 0 };
		const vertical = data.axis === 'vertical';
		const minimum = vertical ? 32 : 120;
		const allocation = resolveKlpLinearLayout({
			extent: vertical ? rect.height : rect.width,
			gutter: handle,
			gutterCount: Math.max(0, data.groups.length - 1),
			items: data.groups.map((group, index) => ({ minimum, preferred: index === data.groups.length - 1 ? minimum : group.mainAxisExtent, flex: index === data.groups.length - 1 ? 1 : 0 })),
		});
		let offset = 0;
		const groups = data.groups.map((group, index) => {
			const extent = allocation.extents[index];
			const slot = { left: vertical ? 0 : offset, top: vertical ? offset : 0, width: vertical ? rect.width : extent, height: vertical ? extent : rect.height };
			offset += extent + allocation.gutter;
			const xMargin = Math.min(margin, slot.width / 2);
			const yMargin = Math.min(margin, slot.height / 2);
			const width = Math.max(0, slot.width - 2 * xMargin);
			const height = Math.max(0, slot.height - 2 * yMargin);
			const headerHeight = Math.min(chrome, height);
			const clipRadius = Math.min(radius, width / 2, height / 2);
			return <div key={group.id} style={position(slot)}>
				<KlpSurface className="klp-dock-panel" style={{ ...position({ left: xMargin, top: yMargin, width, height }), borderRadius: clipRadius }}>
					<div role="tablist" aria-label={(props.areaLabels?.[area] ?? defaultLabels[area]) + ' ' + group.id} className="klp-dock-tabs" style={{ height: headerHeight }}>
						{group.panelIds.map(id => {
							const panel = panelById.get(id)!;
							const selected = group.activePanelId === id;
							return <div key={id} className="klp-dock-tab-entry">
								<button type="button" role="tab" id={prefix + ':tab:' + encodeURIComponent(id)} data-panel-id={id} aria-controls={prefix + ':content:' + encodeURIComponent(id)} aria-selected={selected} tabIndex={selected ? 0 : -1} className="klp-dock-tab" onClick={() => commit({ type: 'select', panelId: id })} onKeyDown={event => keyboard(event, group.panelIds)}>
									{panel.icon && <span aria-hidden="true">{panel.icon}</span>}
									<KlpText role="label">{panel.label}</KlpText>
									{panel.isPinned && <span title="Pinned" aria-label="Pinned">▰</span>}
									{panel.isDirty && <span title="Modified" aria-label="Modified">•</span>}
								</button>
								{panel.onCloseRequested && <KlpIconButton tone="inline" label={panel.closeLabel ?? 'Close ' + panel.label} disabled={close.pending.has(id)} onClick={() => close.requestClose(id)} style={{ width: Math.min(icon, width), height: Math.min(icon, headerHeight), minWidth: 0, minHeight: 0, flexShrink: 0 }}>×</KlpIconButton>}
							</div>;
							})}
					</div>
					{group.panelIds.map(id => <div key={id} id={prefix + ':content:' + encodeURIComponent(id)} role="tabpanel" aria-labelledby={prefix + ':tab:' + encodeURIComponent(id)} hidden={group.activePanelId !== id} className="klp-dock-content" style={position({ left: 0, top: headerHeight, width, height: height - headerHeight })}>{panelById.get(id)!.content}</div>)}
				</KlpSurface>
			</div>;
		});
		return <section key={area} aria-label={props.areaLabels?.[area] ?? defaultLabels[area]} hidden={!data.isVisible || !data.groups.length} style={position(rect)}>{groups}</section>;
	}
	const { layout, panels, stage, contentHeader, leftConstraints, rightConstraints, bottomConstraints, onLayoutChanged, onCloseError, label = 'Workbench', areaLabels, ref, className = '', style, ...native } = props;
	return <div {...native} ref={host} role={native.role ?? 'region'} aria-label={label} className={'klp-dock ' + className} style={{ width: '100%', height: '100%', ...style, position: 'relative', minWidth: 0, minHeight: 0, overflow: 'hidden', padding: 0, border: 0, boxSizing: 'border-box' }}>
		<KlpSurface tone="stage" style={position(geometry.stage)}>{stage}</KlpSurface>
		{geometry.header && <div style={position(geometry.header)}>{contentHeader}</div>}
		{areas.map(renderArea)}
		{areas.map(area => layout[area].groups.length > 0 && <button key={area} type="button" className="klp-dock-edge" aria-label={areaLabels?.[area] ?? defaultLabels[area]} aria-expanded={layout[area].isVisible} onClick={() => commit({ type: 'visibility', area, isVisible: !layout[area].isVisible })} style={position(geometry[(area + 'Handle') as 'leftHandle' | 'rightHandle' | 'bottomHandle'])} />)}
	</div>;
}
