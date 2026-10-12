import { useId, type HTMLAttributes, type ButtonHTMLAttributes, type InputHTMLAttributes, type ReactNode } from 'react';
import { useKlp } from './theme.js';

export type KlpTextRole = 'body' | 'body-strong' | 'caption' | 'label' | 'lead' | 'h1' | 'h2' | 'h3' | 'h4' | 'code';
export interface KlpTextProps extends HTMLAttributes<HTMLElement> {
	as?: 'span' | 'p' | 'h1' | 'h2' | 'h3' | 'h4' | 'code';
	role?: KlpTextRole;
	tone?: 'primary' | 'muted' | 'faint';
}
export function KlpText({ as: Tag = 'span', role = 'body', tone = 'primary', className = '', ...props }: KlpTextProps) {
	useKlp();
	return <Tag {...props} className={`klp-text klp-text-${role} klp-tone-${tone} ${className}`} />;
}
export interface KlpSurfaceProps extends HTMLAttributes<HTMLDivElement> {
	tone?: 'base' | 'inset' | 'muted' | 'raised' | 'component' | 'stage';
}
export function KlpSurface({ tone = 'base', className = '', ...props }: KlpSurfaceProps) {
	useKlp();
	return <div {...props} className={`klp-surface klp-surface-${tone} ${className}`} />;
}
export interface KlpCardProps extends KlpSurfaceProps {
	header?: ReactNode;
	footer?: ReactNode;
}
export function KlpCard({ header, footer, children, tone = 'component', className = '', ...props }: KlpCardProps) {
	return <KlpSurface {...props} tone={tone} className={`klp-card ${className}`}>
		{header != null && <div className="klp-card-header">{header}</div>}
		<div className="klp-card-content">{children}</div>
		{footer != null && <div className="klp-card-footer">{footer}</div>}
	</KlpSurface>;
}
export interface KlpBadgeProps extends HTMLAttributes<HTMLSpanElement> {
	tone?: 'neutral' | 'success' | 'warning' | 'danger' | 'info';
}
export function KlpBadge({ tone = 'neutral', className = '', ...props }: KlpBadgeProps) {
	useKlp();
	return <span {...props} className={`klp-badge klp-badge-${tone} ${className}`} />;
}
export interface KlpButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
	tone?: 'primary' | 'secondary' | 'ghost';
	size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
	selected?: boolean;
}
export function KlpButton({ tone = 'secondary', size = 'md', selected, type = 'button', className = '', ...props }: KlpButtonProps) {
	useKlp();
	return <button {...props} type={type} aria-pressed={selected} className={`klp-button klp-button-${tone} klp-size-${size} ${className}`} />;
}
export interface KlpIconButtonProps extends Omit<KlpButtonProps, 'tone'> {
	label: string;
	tone?: 'standalone' | 'inline' | 'window';
}
export function KlpIconButton({ label, tone = 'standalone', className = '', ...props }: KlpIconButtonProps) {
	if (!label.trim()) throw new Error('KlpIconButton label is required');
	return <KlpButton {...props} aria-label={label} className={`klp-icon-button klp-icon-${tone} ${className}`} />;
}
export interface KlpTextFieldProps extends InputHTMLAttributes<HTMLInputElement> {
	label: string;
	error?: boolean;
	hint?: string;
}
export function KlpTextField({ label, error = false, hint, id, className = '', ...props }: KlpTextFieldProps) {
	useKlp();
	const generatedId = useId();
	const inputId = id ?? generatedId;
	if (!label.trim()) throw new Error('KlpTextField label is required');
	return <div className={`klp-field ${className}`}>
		<label className="klp-text-label" htmlFor={inputId}>{label}</label>
		<input {...props} id={inputId} aria-invalid={error || undefined} aria-describedby={hint ? `${inputId}-hint` : props['aria-describedby']} />
		{hint && <span id={`${inputId}-hint`} className="klp-text-caption klp-tone-muted">{hint}</span>}
	</div>;
}
export interface KlpFrameProps extends HTMLAttributes<HTMLDivElement> {
	role?: 'content' | 'sidebar' | 'auxiliary';
	header?: ReactNode;
	footer?: ReactNode;
}
export function KlpFrame({ role = 'content', header, footer, children, className = '', ...props }: KlpFrameProps) {
	useKlp();
	return <div {...props} className={`klp-frame klp-frame-${role} ${className}`}>
		{header != null && <div className="klp-frame-header">{header}</div>}
		<div className="klp-frame-body">{children}</div>
		{footer != null && <div className="klp-frame-footer">{footer}</div>}
	</div>;
}
export interface KlpWorkspaceProps extends HTMLAttributes<HTMLDivElement> {
	children: ReactNode;
}
export function KlpWorkspace({ children, className = '', ...props }: KlpWorkspaceProps) {
	useKlp();
	return <div {...props} className={`klp-workspace ${className}`}>{children}</div>;
}
export interface KlpExplorerItem {
	id: string;
	label: string;
	icon?: ReactNode;
}
export interface KlpExplorerSection extends KlpExplorerItem {
	items: readonly KlpExplorerItem[];
}
export interface KlpFileExplorerProps extends Omit<HTMLAttributes<HTMLElement>, 'onSelect' | 'onToggle'> {
	sections: readonly KlpExplorerSection[];
	expandedIds: readonly string[];
	selectedId?: string;
	onToggle: (id: string) => void;
	onSelect: (id: string) => void;
	label?: string;
}
export function KlpFileExplorer({ sections, expandedIds, selectedId, onToggle, onSelect, label = 'Explorer', className = '', ...props }: KlpFileExplorerProps) {
	useKlp();
	const prefix = useId();
	const ids = sections.flatMap(section => [section.id, ...section.items.map(item => item.id)]);
	if (ids.some(id => !id) || new Set(ids).size !== ids.length) throw new Error('Explorer IDs must be unique and nonempty');
	return <nav {...props} aria-label={label} className={`klp-explorer ${className}`}>
		{sections.map((section, index) => {
			const expanded = expandedIds.includes(section.id);
			const listId = `${prefix}-${index}`;
			return <div key={section.id} className="klp-explorer-section">
				<button type="button" className="klp-explorer-row klp-explorer-folder" aria-expanded={expanded} aria-controls={listId} onClick={() => onToggle(section.id)}>{section.icon && <span aria-hidden="true">{section.icon}</span>}{section.label}</button>
				<ul id={listId} hidden={!expanded}>
					{section.items.map(item => <li key={item.id}><button type="button" className="klp-explorer-row klp-explorer-item" aria-pressed={selectedId === item.id} onClick={() => onSelect(item.id)}>{item.icon && <span aria-hidden="true">{item.icon}</span>}{item.label}</button></li>)}
				</ul>
			</div>;
		})}
	</nav>;
}
