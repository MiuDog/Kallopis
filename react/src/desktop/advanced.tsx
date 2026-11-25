import { useEffect, useId, useRef, useState, type ReactNode } from 'react';
import { useKlp } from '../theme.js';
import { resolveRelief } from '../relief.js';
import { KlpButton, KlpText, KlpTextField } from '../components.js';
import { KlpCheckbox } from './controls.js';
import { KlpAlert, KlpDialog } from './feedback.js';
import { KlpTabs, type KlpTab } from './views.js';

export interface KlpTreeItem {
	/* id：唯一識別；label：名稱；children：階層；disabled：禁止操作。 */
	id: string;
	label: string;
	children?: readonly KlpTreeItem[];
	disabled?: boolean;
}
export interface KlpTreeProps {
	/* label：樹用途；items：資料；expandedIds／selectedId：受控狀態；兩個 callback：回報使用者意圖。 */
	label: string;
	items: readonly KlpTreeItem[];
	expandedIds: readonly string[];
	selectedId?: string;
	onSelect: (id: string) => void;
	onToggle: (id: string) => void;
}
export function KlpTree({ label, items, expandedIds, selectedId, onSelect, onToggle }: KlpTreeProps) {

	useKlp();
	const refs = useRef(new Map<string, HTMLDivElement>());
	const [focused, setFocused] = useState<string>();
	/* item：來源節點；level：可及階層；parent：左鍵返回；position／size：同層位置。 */
	const visible: { item: KlpTreeItem; level: number; parent?: string; position: number; size: number }[] = [];
	function visit(nodes: readonly KlpTreeItem[], level: number, parent?: string) {
		nodes.forEach((item, index) => {
			visible.push({ item, level, parent, position: index + 1, size: nodes.length });
			if (item.children && expandedIds.includes(item.id)) visit(item.children, level + 1, item.id);
		});
	}
	visit(items, 1);
	const enabled = visible.filter(row => !row.item.disabled);
	const active = enabled.find(row => row.item.id === focused)?.item.id ?? enabled.find(row => row.item.id === selectedId)?.item.id ?? enabled[0]?.item.id;
	function focus(id?: string) {
		if (!id) return;
		setFocused(id);
		refs.current.get(id)?.focus();
	}
	return <div role="tree" aria-label={label} className="klp-tree">{visible.map((row, index) => <div key={row.item.id} ref={element => { if (element) refs.current.set(row.item.id, element); else refs.current.delete(row.item.id); }} role="treeitem" aria-level={row.level} aria-posinset={row.position} aria-setsize={row.size} aria-selected={selectedId === row.item.id} aria-disabled={row.item.disabled || undefined} aria-expanded={row.item.children?.length ? expandedIds.includes(row.item.id) : undefined} tabIndex={active === row.item.id ? 0 : -1} className="klp-tree-item" style={{ paddingInlineStart: `calc(var(--klp-spacing-contentInset) + ${row.level - 1} * var(--klp-spacing-comfortable))` }} onFocus={() => setFocused(row.item.id)} onClick={() => { if (!row.item.disabled) onSelect(row.item.id); }} onKeyDown={event => {
		if (row.item.disabled) return;
		const position = enabled.findIndex(value => value.item.id === row.item.id);
		if (event.key === 'ArrowDown') focus(enabled[Math.min(position + 1, enabled.length - 1)]?.item.id);
		else if (event.key === 'ArrowUp') focus(enabled[Math.max(0, position - 1)]?.item.id);
		else if (event.key === 'Home') focus(enabled[0]?.item.id);
		else if (event.key === 'End') focus(enabled.at(-1)?.item.id);
		else if (event.key === 'ArrowRight' && row.item.children?.length) { if (!expandedIds.includes(row.item.id)) onToggle(row.item.id); else if (visible[index + 1]?.parent === row.item.id && !visible[index + 1].item.disabled) focus(visible[index + 1].item.id); }
		else if (event.key === 'ArrowLeft') { if (row.item.children?.length && expandedIds.includes(row.item.id)) onToggle(row.item.id); else focus(row.parent); }
		else if (event.key === 'Enter' || event.key === ' ') onSelect(row.item.id);
		else return;
		event.preventDefault();
	}}>{row.item.children?.length ? <button type="button" className="klp-tree-toggle" tabIndex={-1} aria-label={`${expandedIds.includes(row.item.id) ? '收合' : '展開'} ${row.item.label}`} disabled={row.item.disabled} onClick={event => { event.stopPropagation(); focus(row.item.id); onToggle(row.item.id); }}>{expandedIds.includes(row.item.id) ? '−' : '+'}</button> : <span className="klp-tree-leaf" />}{row.item.label}</div>)}</div>;
}

export interface KlpMultiSelectProps {
	/* label：用途；options：穩定 value／label／disabled；value：受控集合；onValueChange：新集合；disabled：整組停用。 */
	label: string;
	options: readonly { value: string; label: string; disabled?: boolean }[];
	value: readonly string[];
	onValueChange: (values: string[]) => void;
	disabled?: boolean;
}
export function KlpMultiSelect({ label, options, value, onValueChange, disabled }: KlpMultiSelectProps) {

	useKlp();
	const [query, setQuery] = useState('');
	function toggle(id: string) { onValueChange(value.includes(id) ? value.filter(item => item !== id) : [...value, id]); }
	return <fieldset className="klp-option-group klp-desktop-stack" disabled={disabled}><legend>{label}</legend><KlpTextField label="篩選選項" value={query} disabled={disabled} onChange={event => setQuery(event.target.value)} /><div className="klp-desktop-row">{options.filter(option => value.includes(option.value)).map(option => <KlpButton key={option.value} size="sm" disabled={disabled || option.disabled} aria-label={`移除 ${option.label}`} onClick={() => toggle(option.value)}>{option.label} ×</KlpButton>)}</div>{options.filter(option => option.label.toLocaleLowerCase().includes(query.toLocaleLowerCase())).map(option => <KlpCheckbox key={option.value} label={option.label} disabled={disabled || option.disabled} checked={value.includes(option.value)} onChange={() => toggle(option.value)} />)}</fieldset>;
}

export interface KlpVirtualListProps {
	/* label：用途；items：固定單行資料；selectedId／onSelect：受控選取；height／rowHeight：視窗與列步距 px。 */
	label: string;
	items: readonly { id: string; label: string; disabled?: boolean }[];
	selectedId?: string;
	onSelect: (id: string) => void;
	height?: number;
	rowHeight?: number;
}
export function KlpVirtualList({ label, items, selectedId, onSelect, height = 240, rowHeight = 40 }: KlpVirtualListProps) {

	useKlp();
	const id = useId();
	const ref = useRef<HTMLDivElement>(null);
	const [scroll, setScroll] = useState(0);
	const [focusIndex, setFocusIndex] = useState(0);
	const step = Number.isFinite(rowHeight) ? Math.max(32, rowHeight) : 40;
	const viewport = Number.isFinite(height) ? Math.max(step, height) : 240;
	const active = Math.min(focusIndex, Math.max(0, items.length - 1));
	const start = Math.min(Math.max(0, items.length - 1), Math.max(0, Math.floor(scroll / step) - 2));
	const end = Math.min(items.length, start + Math.ceil(viewport / step) + 4);
	const indexes = [...new Set([...Array.from({ length: end - start }, (_, offset) => start + offset), ...(items.length ? [active] : [])])].sort((a, b) => a - b);
	function move(index: number) {
		setFocusIndex(index);
		if (ref.current) {
			if (index * step < ref.current.scrollTop) ref.current.scrollTop = index * step;
			else if ((index + 1) * step > ref.current.scrollTop + viewport) ref.current.scrollTop = (index + 1) * step - viewport;
		}
	}
	return <div ref={ref} role="listbox" aria-label={label} aria-activedescendant={items.length ? `${id}-${active}` : undefined} tabIndex={0} className="klp-virtual-list" style={{ height: viewport }} onScroll={event => setScroll(event.currentTarget.scrollTop)} onKeyDown={event => {
		const enabled = items.map((item, index) => item.disabled ? -1 : index).filter(index => index >= 0);
		const position = enabled.indexOf(active);
		let target: number | undefined;
		if (event.key === 'ArrowDown') target = enabled[Math.min(position + 1, enabled.length - 1)];
		else if (event.key === 'ArrowUp') target = enabled[Math.max(position - 1, 0)];
		else if (event.key === 'Home') target = enabled[0];
		else if (event.key === 'End') target = enabled.at(-1);
		else if ((event.key === 'Enter' || event.key === ' ') && items[active] && !items[active].disabled) onSelect(items[active].id);
		else return;
		event.preventDefault();
		if (target !== undefined) move(target);
	}}><div style={{ height: items.length * step, position: 'relative' }}>{indexes.map(index => <div id={`${id}-${index}`} role="option" aria-selected={selectedId === items[index].id} aria-disabled={items[index].disabled || undefined} aria-posinset={index + 1} aria-setsize={items.length} key={items[index].id} className="klp-virtual-item" data-focused={active === index} style={{ position: 'absolute', top: index * step, height: step, insetInline: 0 }} onClick={() => { if (!items[index].disabled) { move(index); onSelect(items[index].id); } }}>{items[index].label}</div>)}</div>{!items.length && <KlpText>沒有資料</KlpText>}</div>;
}

export interface KlpDataGridProps {
	/* label：表格名稱；columns：key／label／editable；rows：id／values／disabled；onCellChange：立即回報文字；sort／onSort：排序由產品投影。 */
	label: string;
	columns: readonly { key: string; label: string; editable?: boolean }[];
	rows: readonly { id: string; values: Readonly<Record<string, string>>; disabled?: boolean }[];
	onCellChange: (rowId: string, key: string, value: string) => void;
	sort?: { key: string; direction: 'ascending' | 'descending' };
	onSort?: (key: string) => void;
}
export function KlpDataGrid({ label, columns, rows, onCellChange, sort, onSort }: KlpDataGridProps) {

	useKlp();
	return <div className="klp-table-scroll"><table className="klp-table"><caption>{label}</caption><thead><tr>{columns.map(column => <th key={column.key} scope="col" aria-sort={sort?.key === column.key ? sort.direction : undefined}>{onSort ? <KlpButton size="sm" onClick={() => onSort(column.key)}>{column.label}{sort?.key === column.key ? ` · ${sort.direction === 'ascending' ? '升冪' : '降冪'}` : ''}</KlpButton> : column.label}</th>)}</tr></thead><tbody>{rows.map(row => <tr key={row.id}>{columns.map(column => <td key={column.key}>{column.editable ? <KlpTextField label={`${row.id} · ${column.label}`} value={row.values[column.key] ?? ''} disabled={row.disabled} onChange={event => onCellChange(row.id, column.key, event.target.value)} /> : row.values[column.key]}</td>)}</tr>)}</tbody></table>{!rows.length && <KlpText>沒有資料</KlpText>}</div>;
}

export interface KlpPopoverProps {
	/* label：觸發按鈕名稱；open／onOpenChange：受控開關；children：任意內容；disabled：禁止開啟。 */
	label: string;
	open: boolean;
	onOpenChange: (open: boolean) => void;
	children: ReactNode;
	disabled?: boolean;
}
export function KlpPopover({ label, open, onOpenChange, children, disabled }: KlpPopoverProps) {

	const theme = useKlp();
	const id = useId();
	const anchor = useRef<HTMLButtonElement>(null);
	const popup = useRef<HTMLDivElement>(null);
	const [position, setPosition] = useState({ top: 0, left: 0 });
	useEffect(() => {
		if (!open || disabled || !popup.current) return;
		const element = popup.current;
		function place() {
			const rect = anchor.current?.getBoundingClientRect();
			if (!rect) return;
			const size = element.getBoundingClientRect();
			setPosition({ left: Math.max(0, Math.min(rect.left, window.innerWidth - size.width)), top: rect.bottom + size.height > window.innerHeight ? Math.max(0, rect.top - size.height) : rect.bottom });
		}
		/* 原生 top layer 避免被 Panel 裁切；視窗／滾動時重新依錨點定位。 */
		element.showPopover();
		place();
		window.addEventListener('resize', place);
		window.addEventListener('scroll', place, true);
		return () => { element.hidePopover(); window.removeEventListener('resize', place); window.removeEventListener('scroll', place, true); };
	}, [open, disabled]);
	return <><button ref={anchor} type="button" className="klp-button klp-button-secondary klp-size-sm" disabled={disabled} aria-expanded={open && !disabled} aria-controls={id} aria-haspopup="dialog" onClick={() => onOpenChange(!open)}>{label}</button><div ref={popup} id={id} popover="auto" role="dialog" aria-label={label} className="klp-popover klp-desktop-stack" style={{ ...position, boxShadow: resolveRelief(theme) }} onToggle={event => { if (event.newState === 'closed' && open) onOpenChange(false); }} onKeyDown={event => { if (event.key === 'Escape') { event.preventDefault(); onOpenChange(false); anchor.current?.focus(); } }}>{children}<KlpButton size="sm" onClick={() => { onOpenChange(false); anchor.current?.focus(); }}>關閉</KlpButton></div></>;
}

export interface KlpDrawerProps {
	/* open：受控開關；title：標題；onClose：關閉請求；children：內容，不持有產品資料。 */
	open: boolean;
	title: string;
	onClose: () => void;
	children: ReactNode;
}
export function KlpDrawer(props: KlpDrawerProps) {

	return <KlpDialog {...props} placement="end" />;
}
export interface KlpToastRegionProps {
	/* label：通知群組；items：產品持有的 id/title/message/tone；onDismiss：移除請求。 */
	label?: string;
	items: readonly { id: string; title: string; message?: string; tone?: 'info' | 'success' | 'warning' | 'danger' }[];
	onDismiss: (id: string) => void;
}
export function KlpToastRegion({ label = '通知', items, onDismiss }: KlpToastRegionProps) {

	useKlp();
	return <section aria-label={label} className="klp-toast-region">{items.map(item => <KlpAlert key={item.id} title={item.title} tone={item.tone}><div className="klp-desktop-stack">{item.message}<KlpButton size="sm" aria-label={`關閉 ${item.title}`} onClick={() => onDismiss(item.id)}>關閉</KlpButton></div></KlpAlert>)}</section>;
}
export function KlpSpinner({ label = '處理中' }: { label?: string }) {

	useKlp();
	return <span role="status" className="klp-desktop-row"><span className="klp-spinner" aria-hidden="true"><i /><i /><i /></span>{label}</span>;
}
export interface KlpSplitButtonProps {
	/* label／onAction：主要動作；options：id/label/onAction/disabled 的次要動作；disabled：整組停用。 */
	label: string;
	onAction: () => void;
	options: readonly { id: string; label: string; onAction: () => void; disabled?: boolean }[];
	disabled?: boolean;
}
export function KlpSplitButton({ label, onAction, options, disabled }: KlpSplitButtonProps) {

	const [open, setOpen] = useState(false);
	return <div className="klp-desktop-row"><KlpButton size="sm" disabled={disabled} onClick={onAction}>{label}</KlpButton><KlpPopover label={`${label}：更多動作`} open={open} onOpenChange={setOpen} disabled={disabled}>{options.map(option => <KlpButton key={option.id} size="sm" disabled={option.disabled} onClick={() => { setOpen(false); option.onAction(); }}>{option.label}</KlpButton>)}</KlpPopover></div>;
}
export interface KlpRibbonProps {
	/* label：工具區用途；tabs：各頁內容使用公開命令工具列；value／onValueChange：目前頁籤。 */
	label: string;
	tabs: readonly KlpTab[];
	value: string;
	onValueChange: (id: string) => void;
}
export function KlpRibbon(props: KlpRibbonProps) {

	const theme = useKlp();
	return <div className="klp-ribbon" style={{ boxShadow: resolveRelief(theme) }}><KlpTabs {...props} /></div>;
}
export interface KlpContentHostProps {
	/* label：外部內容名稱；children：引擎提供的 React／canvas／iframe；loading／error：產品接回引擎狀態。 */
	label: string;
	children: ReactNode;
	loading?: boolean;
	error?: string;
}
export function KlpContentHost({ label, children, loading, error }: KlpContentHostProps) {

	useKlp();
	return <section aria-label={label} aria-busy={loading || undefined} className="klp-content-host">{error && <KlpAlert title="內容無法載入" tone="danger">{error}</KlpAlert>}{loading && <KlpSpinner label={`載入 ${label}`} />}<div hidden={!!loading || !!error}>{children}</div></section>;
}
export interface KlpSystemActionProps {
	/* label：宿主動作；onAction：消費端能力，缺少時停用；disabled：產品權限；unavailable：缺少能力的原因。 */
	label: string;
	onAction?: () => void | Promise<void>;
	disabled?: boolean;
	unavailable?: string;
}
export function KlpSystemAction({ label, onAction, disabled, unavailable = '此環境未提供此功能' }: KlpSystemActionProps) {

	useKlp();
	const [pending, setPending] = useState(false);
	const [error, setError] = useState('');
	const busy = useRef(false);
	const mounted = useRef(true);
	useEffect(() => { mounted.current = true; return () => { mounted.current = false; }; }, []);
	async function run() {
		if (!onAction || disabled || busy.current) return;
		busy.current = true;
		setPending(true);
		setError('');
		try { await onAction(); }
		catch (reason) { if (mounted.current) setError(reason instanceof Error ? reason.message : '操作失敗，請重試'); }
		finally { busy.current = false; if (mounted.current) setPending(false); }
	}
	return <div className="klp-desktop-stack"><KlpButton size="sm" disabled={disabled || !onAction || pending} onClick={run}>{pending ? `${label}…` : label}</KlpButton>{!onAction && <KlpText role="caption">{unavailable}</KlpText>}{error && <KlpAlert title="操作未完成" tone="danger">{error}</KlpAlert>}</div>;
}

export interface KlpTreeGridRow {
	/* id：穩定識別；label：階層欄文字；cells：其餘欄位；children：子列；disabled：不可選取。 */
	id: string;
	label: string;
	cells: readonly ReactNode[];
	children?: readonly KlpTreeGridRow[];
	disabled?: boolean;
}
export interface KlpTreeGridProps {
	/* label：表格用途；columns：含階層欄的標題；rows：階層資料；expandedIds／selectedId：受控狀態；callback：回報選取／展開。 */
	label: string;
	columns: readonly string[];
	rows: readonly KlpTreeGridRow[];
	expandedIds: readonly string[];
	selectedId?: string;
	onSelect: (id: string) => void;
	onToggle: (id: string) => void;
}
export function KlpTreeGrid({ label, columns, rows, expandedIds, selectedId, onSelect, onToggle }: KlpTreeGridProps) {

	useKlp();
	const refs = useRef(new Map<string, HTMLTableRowElement>());
	const [focused, setFocused] = useState<string>();
	/* row：產品資料；level／parent：階層導航；position／size：同層可及位置。 */
	const visible: { row: KlpTreeGridRow; level: number; parent?: string; position: number; size: number }[] = [];
	function visit(nodes: readonly KlpTreeGridRow[], level: number, parent?: string) {
		nodes.forEach((row, index) => {
			visible.push({ row, level, parent, position: index + 1, size: nodes.length });
			if (row.children && expandedIds.includes(row.id)) visit(row.children, level + 1, row.id);
		});
	}
	visit(rows, 1);
	const enabled = visible.filter(item => !item.row.disabled);
	const active = enabled.find(item => item.row.id === focused)?.row.id ?? enabled.find(item => item.row.id === selectedId)?.row.id ?? enabled[0]?.row.id;
	function focus(id?: string) {
		if (!id || !enabled.some(item => item.row.id === id)) return;
		setFocused(id);
		refs.current.get(id)?.focus();
	}
	return <div className="klp-table-scroll"><table role="treegrid" aria-label={label} className="klp-table klp-tree-grid"><caption>{label}</caption><thead><tr>{columns.map((column, index) => <th key={index} scope="col">{column}</th>)}</tr></thead><tbody>{visible.map(item => <tr key={item.row.id} ref={element => { if (element) refs.current.set(item.row.id, element); else refs.current.delete(item.row.id); }} tabIndex={active === item.row.id ? 0 : -1} aria-level={item.level} aria-posinset={item.position} aria-setsize={item.size} aria-expanded={item.row.children?.length ? expandedIds.includes(item.row.id) : undefined} aria-selected={selectedId === item.row.id} aria-disabled={item.row.disabled || undefined} onFocus={() => setFocused(item.row.id)} onClick={() => { if (!item.row.disabled) onSelect(item.row.id); }} onKeyDown={event => {
		if (item.row.disabled || event.target !== event.currentTarget) return;
		const index = enabled.findIndex(value => value.row.id === item.row.id);
		if (event.key === 'ArrowDown') focus(enabled[Math.min(index + 1, enabled.length - 1)]?.row.id);
		else if (event.key === 'ArrowUp') focus(enabled[Math.max(index - 1, 0)]?.row.id);
		else if (event.key === 'Home') focus(enabled[0]?.row.id);
		else if (event.key === 'End') focus(enabled.at(-1)?.row.id);
		else if (event.key === 'ArrowRight' && item.row.children?.length) { if (!expandedIds.includes(item.row.id)) onToggle(item.row.id); else focus(item.row.children.find(row => !row.disabled)?.id); }
		else if (event.key === 'ArrowLeft') { if (item.row.children?.length && expandedIds.includes(item.row.id)) onToggle(item.row.id); else focus(item.parent); }
		else if (event.key === 'Enter' || event.key === ' ') onSelect(item.row.id);
		else return;
		event.preventDefault();
	}}><td style={{ paddingInlineStart: `calc(var(--klp-spacing-contentInset) + ${item.level - 1} * var(--klp-spacing-comfortable))` }}>{item.row.children?.length ? <KlpButton size="xs" disabled={item.row.disabled} aria-label={`${expandedIds.includes(item.row.id) ? '收合' : '展開'} ${item.row.label}`} onClick={event => { event.stopPropagation(); onToggle(item.row.id); }}>{expandedIds.includes(item.row.id) ? '−' : '+'}</KlpButton> : null} {item.row.label}</td>{item.row.cells.map((cell, index) => <td key={index}>{cell}</td>)}</tr>)}</tbody></table>{!rows.length && <KlpText>沒有資料</KlpText>}</div>;
}
