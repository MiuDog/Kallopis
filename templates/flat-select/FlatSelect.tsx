import { useEffect, useId, useRef, useState, type KeyboardEvent, type ReactNode } from 'react';
import { KlpButton, KlpFrame } from '@kallopis/react';
import './flat-select.css';

export interface FlatSelectProps {
	/* label：控制項與popup的輔助名稱；valueLabel：consumer投影目前選擇，不持有業務值。
	 * children：提供選項並在選擇成功後呼叫close；disabled：宿主鎖定操作；indicator：沿用consumer圖示系統。 */
	label: string;
	valueLabel: string;
	children: (close: () => void) => ReactNode;
	disabled?: boolean;
	indicator?: ReactNode;
}

export function FlatSelectOption({ children, selected = false, disabled = false, onSelect }: { /* children為顯示slot；selected／disabled由consumer決定；onSelect只回報選擇，不改產品值。 */ children: ReactNode; selected?: boolean; disabled?: boolean; onSelect: () => void }) {
	return <KlpButton tone="ghost" data-klp-select-option selected={selected} disabled={disabled} onClick={onSelect}>{children}</KlpButton>;
}

export function FlatSelectGroup({ children }: { /* children為consumer提供的群組，不定義分類或業務順序。 */ children: ReactNode }) {
	return <div><hr className="klp-flat-select-divider" />{children}</div>;
}

export function FlatSelect({ label, valueLabel, children, disabled = false, indicator }: FlatSelectProps) {
	const id = useId();
	const trigger = useRef<HTMLButtonElement>(null);
	const popup = useRef<HTMLDivElement>(null);
	const [open, setOpen] = useState(false);
	const search = useRef({ /* text／at：只供鍵盤前綴尋找，不接觸產品選項資料或保存。 */ text: '', at: 0 });
	function position() {
		const button = trigger.current;
		const panel = popup.current;
		if (!button || !panel) return;
		// 使用原控制項寬度與viewport界線定位top layer，避免被Stage overflow裁切。
		const rect = button.getBoundingClientRect();
		const below = Math.max(0, window.innerHeight - rect.bottom);
		const above = Math.max(0, rect.top);
		const useAbove = panel.scrollHeight > below && above > below;
		panel.style.width = `${Math.min(rect.width, window.innerWidth)}px`;
		panel.style.left = `${Math.max(0, Math.min(rect.left, window.innerWidth - rect.width))}px`;
		panel.style.maxHeight = `${useAbove ? above : below}px`;
		panel.style.top = `${rect.bottom}px`;
		panel.style.bottom = 'auto';
		if (useAbove) { panel.style.top = 'auto'; panel.style.bottom = `${window.innerHeight - rect.top}px`; }
	}
	function close() { if (popup.current?.matches(':popover-open')) popup.current.hidePopover(); }
	function show(edge: 'selected' | 'first' | 'last' = 'selected') {
		if (disabled || trigger.current?.matches(':disabled')) return;
		search.current = { text: '', at: 0 };
		popup.current?.showPopover(); position();
		// 選項保持掛載；只在顯示後將鍵盤焦點交給選項，不重建consumer草稿。
		queueMicrotask(() => {
			if (!popup.current?.matches(':popover-open')) return;
			const options = popup.current?.querySelectorAll<HTMLButtonElement>('[data-klp-select-option]:not(:disabled)');
			if (!options?.length) return;
			const selected = [...options].find(option => option.getAttribute('aria-checked') === 'true');
			let target = selected ?? options[0];
			if (edge === 'first') target = options[0];
			if (edge === 'last') target = options[options.length - 1];
			target.focus();
		});
	}
	function keydown(event: KeyboardEvent<HTMLDivElement>) {
		if (event.altKey || event.ctrlKey || event.metaKey) return;
		if (event.key === 'Escape') { event.preventDefault(); close(); trigger.current?.focus(); return; }
		const options = [...(popup.current?.querySelectorAll<HTMLButtonElement>('[data-klp-select-option]:not(:disabled)') ?? [])];
		if (!options.length) return;
		const index = options.indexOf(document.activeElement as HTMLButtonElement);
		let next = -1;
		if (event.key === 'ArrowDown') next = (index + 1) % options.length;
		if (event.key === 'ArrowUp') next = (index - 1 + options.length) % options.length;
		if (event.key === 'Home') next = 0;
		if (event.key === 'End') next = options.length - 1;
		if (event.key.length === 1 && event.key !== ' ') {
			const now = Date.now();
			search.current = { text: (now - search.current.at < 700 ? search.current.text : '') + event.key.toLocaleLowerCase(), at: now };
			next = options.findIndex(option => option.textContent?.trim().toLocaleLowerCase().startsWith(search.current.text));
		}
		if (next >= 0) { event.preventDefault(); options[next].focus(); }
	}
	useEffect(() => { if (disabled) close(); }, [disabled]);
	useEffect(() => {
		if (!open) return;
		window.addEventListener('resize', position); window.addEventListener('scroll', position, true);
		return () => { window.removeEventListener('resize', position); window.removeEventListener('scroll', position, true); };
	}, [open]);
	return <div className="klp-flat-select"><button ref={trigger} type="button" className="klp-flat-select-trigger" aria-label={label} aria-haspopup="dialog" aria-controls={id} aria-expanded={open} disabled={disabled} onClick={() => { if (open) close(); else show(); }} onKeyDown={event => { if (['ArrowDown', 'ArrowUp', 'Home', 'End'].includes(event.key)) { event.preventDefault(); let edge: 'selected' | 'first' | 'last' = 'selected'; if (event.key === 'Home') edge = 'first'; if (event.key === 'End') edge = 'last'; show(edge); } }}><span>{valueLabel}</span>{indicator}</button><div ref={popup} id={id} popover="auto" role="dialog" aria-label={label} className="klp-flat-select-popup" onToggle={event => setOpen(event.newState === 'open')} onKeyDown={keydown}><KlpFrame surface="flat" className="klp-flat-select-panel">{children(close)}</KlpFrame></div></div>;
}
