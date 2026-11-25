import { useId, useRef, type ReactNode, type HTMLAttributes } from 'react';
import { useKlp } from '../theme.js';
import { KlpButton, KlpText } from '../components.js';

export interface KlpListItem {
	/* id：穩定識別；title：主標題；description：摘要；meta：補充資訊；disabled：禁止選取。 */
	id: string;
	title: string;
	description?: string;
	meta?: string;
	disabled?: boolean;
}

export interface KlpListProps {
	/* label：清單名稱；items：呈現資料；selectedId：受控選取；onSelect：選取回報；empty：無資料提示。 */
	label: string;
	items: readonly KlpListItem[];
	selectedId?: string;
	onSelect: (id: string) => void;
	empty?: string;
}

export function KlpList({ label, items, selectedId, onSelect, empty = '沒有資料' }: KlpListProps) {

	useKlp();
	return <div><ul className="klp-data-list" aria-label={label}>{items.map(item => <li key={item.id}><button className="klp-data-item" type="button" disabled={item.disabled} aria-pressed={selectedId === item.id} onClick={() => onSelect(item.id)}>{item.meta && <KlpText role="caption" tone="muted">{item.meta}</KlpText>}<KlpText role="body-strong">{item.title}</KlpText>{item.description && <KlpText role="caption" tone="muted">{item.description}</KlpText>}</button></li>)}</ul>{!items.length && <KlpText as="p" tone="muted" role="caption">{empty}</KlpText>}</div>;
}

export interface KlpTab {
	/* id：穩定識別；label：頁籤標題；content：產品內容；disabled：不可選取。 */
	id: string;
	label: string;
	content: ReactNode;
	disabled?: boolean;
}

export interface KlpTabsProps {
	/* label：群組用途；tabs：頁籤；value：受控選取；onValueChange：回報有效頁籤。 */
	label: string;
	tabs: readonly KlpTab[];
	value: string;
	onValueChange: (id: string) => void;
}

export function KlpTabs({ label, tabs, value, onValueChange }: KlpTabsProps) {

	useKlp();
	const prefix = useId();
	const buttons = useRef(new Map<string, HTMLButtonElement>());
	const enabled = tabs.filter(tab => !tab.disabled);
	const active = enabled.find(tab => tab.id === value)?.id ?? enabled[0]?.id;
	function move(key: string, id: string) {
		const index = enabled.findIndex(tab => tab.id === id);
		let next = index;
		if (key === 'ArrowRight') next = (index + 1) % enabled.length;
		else if (key === 'ArrowLeft') next = (index - 1 + enabled.length) % enabled.length;
		else if (key === 'Home') next = 0;
		else if (key === 'End') next = enabled.length - 1;
		else return false;

		const target = enabled[next];
		if (target) { onValueChange(target.id); buttons.current.get(target.id)?.focus(); }
		return true;
	}
	return <div className="klp-desktop-stack"><div role="tablist" aria-label={label} className="klp-desktop-row">{tabs.map((tab, index) => <button key={tab.id} ref={element => { if (element) buttons.current.set(tab.id, element); else buttons.current.delete(tab.id); }} type="button" className="klp-button klp-button-ghost klp-size-sm" role="tab" id={`${prefix}-tab-${index}`} aria-controls={`${prefix}-panel-${index}`} aria-selected={active === tab.id} aria-pressed={active === tab.id} disabled={tab.disabled} tabIndex={active === tab.id ? 0 : -1} onClick={() => onValueChange(tab.id)} onKeyDown={event => { if (move(event.key, tab.id)) event.preventDefault(); }}>{tab.label}</button>)}</div>{tabs.map((tab, index) => <div key={tab.id} role="tabpanel" id={`${prefix}-panel-${index}`} aria-labelledby={`${prefix}-tab-${index}`} hidden={active !== tab.id} tabIndex={0}>{tab.content}</div>)}</div>;
}

export interface KlpTableProps {
	/* caption：表格名稱；columns：欄位名稱；rows：每列穩定 id 與儲存格，排序／分頁由 consumer 決定。 */
	caption: string;
	columns: readonly string[];
	rows: readonly { id: string; cells: readonly ReactNode[] }[];
}

export function KlpTable({ caption, columns, rows }: KlpTableProps) {

	useKlp();
	return <div className="klp-table-scroll" role="region" aria-label={caption} tabIndex={0}><table className="klp-table"><caption>{caption}</caption><thead><tr>{columns.map((column, index) => <th key={index} scope="col">{column}</th>)}</tr></thead><tbody>{rows.map(row => <tr key={row.id}>{row.cells.map((cell, index) => <td key={index}>{cell}</td>)}</tr>)}</tbody></table>{!rows.length && <KlpText tone="muted">沒有資料</KlpText>}</div>;
}

export interface KlpAccordionProps {
	/* title：展開控制標題；children：隱藏內容；defaultOpen：初始展開，由原生 details 持有狀態。 */
	title: string;
	children: ReactNode;
	defaultOpen?: boolean;
}

export function KlpAccordion({ title, children, defaultOpen }: KlpAccordionProps) {

	useKlp();
	return <details className="klp-accordion" open={defaultOpen}><summary>{title}</summary><div className="klp-accordion-content">{children}</div></details>;
}

export interface KlpBreadcrumbProps {
	/* label：導航名稱；items：標籤與合法產品 URL，最後一項為目前頁面。 */
	label: string;
	items: readonly { label: string; href: string }[];
}

export function KlpBreadcrumb({ label, items }: KlpBreadcrumbProps) {

	useKlp();
	return <nav aria-label={label}><ol className="klp-breadcrumb">{items.map((item, index) => <li key={`${item.href}-${index}`}><a className="klp-link" href={item.href} aria-current={index === items.length - 1 ? 'page' : undefined}>{item.label}</a></li>)}</ol></nav>;
}

export interface KlpPaginationProps {
	/* page：目前頁（從 1 起）；pageCount：總頁；onPageChange：請求頁；label：導航用途。 */
	page: number;
	pageCount: number;
	onPageChange: (page: number) => void;
	label?: string;
}

export function KlpPagination({ page, pageCount, onPageChange, label = '分頁' }: KlpPaginationProps) {

	useKlp();
	const total = Math.max(1, Math.floor(pageCount) || 1);
	const current = Math.min(total, Math.max(1, Math.floor(page) || 1));
	return <nav className="klp-desktop-row" aria-label={label}><KlpButton size="sm" disabled={current <= 1} onClick={() => onPageChange(current - 1)}>上一頁</KlpButton><KlpText role="caption" aria-live="polite">{current} / {total}</KlpText><KlpButton size="sm" disabled={current >= total} onClick={() => onPageChange(current + 1)}>下一頁</KlpButton></nav>;
}
