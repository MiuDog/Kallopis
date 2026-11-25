import { cloneElement, useEffect, useId, useRef, useState, type AnchorHTMLAttributes, type HTMLAttributes, type ReactElement, type ReactNode } from 'react';
import { useKlp } from '../theme.js';
import { resolveRelief } from '../relief.js';
import { KlpButton, KlpText } from '../components.js';

export interface KlpProgressProps {
	/* label：工作名稱；value：已完成值，省略表示不確定進度；max：總量。 */
	label: string;
	value?: number;
	max?: number;
}

export function KlpProgress({ label, value, max = 100 }: KlpProgressProps) {

	useKlp();
	return <label className="klp-progress"><span>{label}</span><progress aria-label={label} value={value} max={max} /></label>;
}

export interface KlpAlertProps {
	/* title：訊息名稱；children：補充說明；tone：狀態語意，danger 採立即告知。 */
	title: string;
	children?: ReactNode;
	tone?: 'info' | 'success' | 'warning' | 'danger';
}

export function KlpAlert({ title, children, tone = 'info' }: KlpAlertProps) {

	const theme = useKlp();
	return <div style={{ boxShadow: resolveRelief(theme) }} className={`klp-alert klp-alert-${tone}`} role={tone === 'danger' ? 'alert' : 'status'}><KlpText role="body-strong">{title}</KlpText>{children && <div>{children}</div>}</div>;
}

export interface KlpEmptyStateProps {
	/* title：狀態名稱；description：原因／下一步；action：consumer 提供的合法動作。 */
	title: string;
	description?: string;
	action?: ReactNode;
}

export function KlpEmptyState({ title, description, action }: KlpEmptyStateProps) {

	useKlp();
	return <div className="klp-empty"><KlpText as="h3" role="h3">{title}</KlpText>{description && <KlpText as="p" tone="muted">{description}</KlpText>}{action}</div>;
}

export interface KlpDialogProps {
	/* placement：center 為對話框，end 為右側抽屜，共用 modal 焦點管理。 */
	placement?: 'center' | 'end';
	/* open：受控顯示；title：對話框名稱；onClose：關閉請求；children：內容；actions：產品動作。 */
	open: boolean;
	title: string;
	onClose: () => void;
	children: ReactNode;
	actions?: ReactNode;
}

export function KlpDialog({ open, title, onClose, children, actions, placement = 'center' }: KlpDialogProps) {

	const theme = useKlp();
	const id = useId();
	const ref = useRef<HTMLDialogElement>(null);
	useEffect(() => {
		const dialog = ref.current;
		if (!dialog || !open) return;

		const previous = document.activeElement;
		/* 原生 modal 提供焦點限制、背景 inert 與 Escape；清理時回到觸發控制。 */
		dialog.showModal();
		return () => { dialog.close(); if (previous instanceof HTMLElement && previous.isConnected) previous.focus(); };
	}, [open]);
	return <dialog style={{ boxShadow: resolveRelief(theme) }} ref={ref} className={`klp-dialog klp-dialog-${placement}`} aria-labelledby={id} onCancel={event => { event.preventDefault(); onClose(); }}><div className="klp-desktop-stack"><KlpText as="h2" role="h3" id={id}>{title}</KlpText><div>{children}</div><div className="klp-desktop-row">{actions}<KlpButton size="sm" onClick={onClose}>關閉</KlpButton></div></div></dialog>;
}

export interface KlpTooltipProps {
	/* text：輔助說明；children：可取得焦點的公開控制；避免把必要資訊只放 tooltip。 */
	text: string;
	children: ReactElement<HTMLAttributes<HTMLElement>>;
}

export function KlpTooltip({ text, children }: KlpTooltipProps) {

	const theme = useKlp();
	const id = useId();
	const [visible, setVisible] = useState(false);
	const description = [children.props['aria-describedby'], visible ? id : undefined].filter(Boolean).join(' ') || undefined;
	return <span className="klp-tooltip-host" onMouseEnter={() => setVisible(true)} onMouseLeave={() => setVisible(false)} onFocus={() => setVisible(true)} onBlur={() => setVisible(false)} onKeyDown={event => { if (event.key === 'Escape') setVisible(false); }}>{cloneElement(children, { 'aria-describedby': description })}{visible && <span style={{ boxShadow: resolveRelief(theme) }} id={id} role="tooltip" className="klp-tooltip">{text}</span>}</span>;
}

export function KlpStatusBar({ children, className = '', ...props }: HTMLAttributes<HTMLDivElement>) {

	useKlp();
	return <div {...props} role="status" className={`klp-status-bar ${className}`}>{children}</div>;
}

export function KlpSeparator() {

	useKlp();
	return <hr className="klp-separator" />;
}

export function KlpLink({ className = '', ...props }: AnchorHTMLAttributes<HTMLAnchorElement>) {

	useKlp();
	return <a {...props} className={`klp-link ${className}`} />;
}

export interface KlpAvatarProps {
	/* label：人物名稱；src：產品圖片；fallback：圖片失效時的文字。 */
	label: string;
	src?: string;
	fallback?: string;
}

export function KlpAvatar({ label, src, fallback }: KlpAvatarProps) {

	useKlp();
	const [failed, setFailed] = useState<string>();
	return <span className="klp-avatar" role="img" aria-label={label}>{src && failed !== src ? <img src={src} alt="" onError={() => setFailed(src)} /> : fallback ?? label.slice(0, 1)}</span>;
}

export function KlpSkeleton({ label = '載入中' }: { label?: string }) {

	useKlp();
	return <div className="klp-skeleton" role="status" aria-label={label}><span className="klp-tone-muted">{label}</span></div>;
}
