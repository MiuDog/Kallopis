import { useEffect, useLayoutEffect, useRef, useState, useId, type InputHTMLAttributes, type SelectHTMLAttributes, type TextareaHTMLAttributes } from 'react';
import { useKlp } from '../theme.js';

export interface KlpOption {
	/* value：穩定選項值；label：可讀名稱；disabled：不可選取的選項。 */
	value: string;
	label: string;
	disabled?: boolean;
}

export interface KlpTextAreaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> {
	/* label：欄位名稱；hint：產品說明；error：套用錯誤語意。 */
	label: string;
	hint?: string;
	error?: boolean;
}

export function KlpTextArea({ label, hint, error, id, className = '', ...props }: KlpTextAreaProps) {

	useKlp();
	const generated = useId();
	const inputId = id ?? generated;
	return <div className={`klp-field klp-desktop-field ${className}`}><label htmlFor={inputId}>{label}</label><textarea {...props} id={inputId} aria-invalid={error || undefined} aria-describedby={hint ? `${inputId}-hint` : props['aria-describedby']} />{hint && <span id={`${inputId}-hint`} className="klp-text-caption klp-tone-muted">{hint}</span>}</div>;
}

export interface KlpCheckboxProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'type'> {
	/* label：讓 checkbox 具有可存取名稱。 */
	label: string;
}

export function KlpCheckbox({ label, className = '', ...props }: KlpCheckboxProps) {

	useKlp();
	return <label className={`klp-choice ${className}`}><input {...props} type="checkbox" /><span>{label}</span></label>;
}

export function KlpSwitch({ label, className = '', ...props }: KlpCheckboxProps) {

	useKlp();
	return <label className={`klp-choice klp-switch ${className}`}><input {...props} type="checkbox" role="switch" /><span>{label}</span></label>;
}

export interface KlpRadioGroupProps {
	/* label：群組名稱；options：可選資料；value：受控值；onValueChange：選取回報；disabled：整組停用。 */
	label: string;
	options: readonly KlpOption[];
	value: string;
	onValueChange: (value: string) => void;
	disabled?: boolean;
}

export function KlpRadioGroup({ label, options, value, onValueChange, disabled }: KlpRadioGroupProps) {

	useKlp();
	const name = useId();
	return <fieldset className="klp-option-group" disabled={disabled}><legend>{label}</legend><div className="klp-desktop-row">{options.map(option => <label className="klp-choice" key={option.value}><input type="radio" name={name} value={option.value} checked={value === option.value} disabled={option.disabled} onChange={() => onValueChange(option.value)} /><span>{option.label}</span></label>)}</div></fieldset>;
}

export interface KlpSelectProps extends SelectHTMLAttributes<HTMLSelectElement> {
	/* label：欄位標籤；options：原生選項；hint：說明；error：產品驗證結果。 */
	label: string;
	options: readonly KlpOption[];
	hint?: string;
	error?: boolean;
}

export function KlpSelect({ label, options, hint, error, id, className = '', ...props }: KlpSelectProps) {

	useKlp();
	const generated = useId();
	const inputId = id ?? generated;
	return <div className={`klp-field klp-desktop-field ${className}`}><label htmlFor={inputId}>{label}</label><select {...props} id={inputId} aria-invalid={error || undefined} aria-describedby={hint ? `${inputId}-hint` : props['aria-describedby']}>{options.map(option => <option key={option.value} value={option.value} disabled={option.disabled}>{option.label}</option>)}</select>{hint && <span id={`${inputId}-hint`} className="klp-text-caption klp-tone-muted">{hint}</span>}</div>;
}

export interface KlpComboBoxProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'list' | 'type'> {
	/* label：輸入名稱；options：建議值，接受自由輸入；建議列表由本庫呈現，保留原生 input 的輸入與表單事件。 */
	label: string;
	options: readonly string[];
}

export function KlpComboBox({ label, options, id, className = '', ...props }: KlpComboBoxProps) {

	useKlp();
	const generated = useId();
	const inputId = id ?? generated;
	const listId = `${inputId}-options`;
	const input = useRef<HTMLInputElement>(null);
	const popup = useRef<HTMLDivElement>(null);
	const [open, setOpen] = useState(false);
	const [draft, setDraft] = useState(String(props.defaultValue ?? ''));
	const [active, setActive] = useState(-1);
	/* position：依錨點及 viewport 定位，保持在同一 Provider 的 top layer。 */
	const [position, setPosition] = useState({ top: 0, left: 0, width: 0 });
	const value = String(props.value ?? draft);
	const matches = [...new Set(options)].filter(option => option.toLocaleLowerCase().includes(value.toLocaleLowerCase()));
	const shown = open && !props.disabled && !props.readOnly;
	const current = Math.min(active, matches.length - 1);
	function choose(option: string) {
		const element = input.current;
		if (!element || props.disabled || props.readOnly) return;
		/* 使用原生 setter 與事件，讓 React 的 onChange、受控值與表單資料保持原契約。 */
		const owner = element.ownerDocument.defaultView!;
		Object.getOwnPropertyDescriptor(owner.HTMLInputElement.prototype, 'value')!.set!.call(element, option);
		element.dispatchEvent(new owner.Event('input', { bubbles: true }));
		setOpen(false);
		element.focus();
	}
	useLayoutEffect(() => {
		if (!shown || !popup.current) return;
		const element = popup.current;
		/* 支援時進入 top layer；其他宿主使用同款固定定位列表，不回退成 datalist。 */
		element.showPopover?.();
		function place() {
			const rect = input.current?.getBoundingClientRect();
			if (!rect) return;
			const width = Math.min(rect.width, window.innerWidth);
			/* 先套用實際寬度，再量測換行後高度，避免首次定位與輸入框脫離。 */
			element.style.width = `${width}px`;
			const height = element.getBoundingClientRect().height;
			setPosition({ top: rect.bottom + height > window.innerHeight ? Math.max(0, rect.top - height) : rect.bottom, left: Math.max(0, Math.min(rect.left, window.innerWidth - width)), width });
		}
		function outside(event: PointerEvent) { if (!element.contains(event.target as Node) && event.target !== input.current) setOpen(false); }
		place();
		window.addEventListener('resize', place);
		window.addEventListener('scroll', place, true);
		document.addEventListener('pointerdown', outside);
		return () => { element.hidePopover?.(); window.removeEventListener('resize', place); window.removeEventListener('scroll', place, true); document.removeEventListener('pointerdown', outside); };
	}, [shown, matches.length]);
	useEffect(() => { if (shown) popup.current?.querySelector('[data-active="true"]')?.scrollIntoView?.({ block: 'nearest' }); }, [current, shown]);
	return <div className={`klp-field ${className}`}><label htmlFor={inputId}>{label}</label><input {...props} ref={input} id={inputId} type="text" role="combobox" aria-autocomplete="list" aria-expanded={shown} aria-controls={shown ? listId : undefined} aria-activedescendant={shown && current >= 0 ? `${listId}-${current}` : undefined} onChange={event => { if (props.value === undefined) setDraft(event.target.value); props.onChange?.(event); setActive(-1); setOpen(true); }} onFocus={event => { props.onFocus?.(event); setOpen(true); }} onBlur={event => { props.onBlur?.(event); setOpen(false); }} onKeyDown={event => {
		props.onKeyDown?.(event);
		if (event.defaultPrevented || event.nativeEvent.isComposing || props.readOnly || props.disabled) return;
		if (event.key === 'ArrowDown') { setOpen(true); setActive(shown ? Math.min(current + 1, matches.length - 1) : 0); }
		else if (event.key === 'ArrowUp') { setOpen(true); setActive(shown ? Math.max(current - 1, 0) : matches.length - 1); }
		else if (shown && event.key === 'Enter' && current >= 0) choose(matches[current]);
		else if (shown && event.key === 'Escape') setOpen(false);
		else if (event.key === 'Tab') { setOpen(false); return; }
		else return;
		event.preventDefault();
	}} />{shown && <div ref={popup} popover="manual" id={listId} role="listbox" aria-label={`${label} 建議`} className="klp-combo-popup" style={position} onMouseDown={event => event.preventDefault()}>{matches.map((option, index) => <div key={option} id={`${listId}-${index}`} role="option" aria-selected={option === value} data-active={index === current} className="klp-combo-option" onPointerMove={() => setActive(index)} onClick={() => choose(option)}>{option}</div>)}{!matches.length && <div className="klp-combo-empty" role="status">沒有相符建議，可直接輸入</div>}</div>}</div>;
}

export interface KlpSliderProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'type'> {
	/* label：範圍用途；原生 min/max/step/value/onChange 維持可及鍵盤操作。 */
	label: string;
}

export function KlpSlider({ label, id, className = '', ...props }: KlpSliderProps) {

	useKlp();
	const generated = useId();
	const inputId = id ?? generated;
	return <div className={`klp-range ${className}`}><label htmlFor={inputId}>{label}</label><input {...props} id={inputId} type="range" />{props.value !== undefined && <output htmlFor={inputId}>{props.value}</output>}</div>;
}
