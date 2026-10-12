import { useCallback, useEffect, useId, useLayoutEffect, useRef, useState, useSyncExternalStore, type CSSProperties, type FormEvent, type KeyboardEvent, type MouseEvent } from 'react';
import { createPortal } from 'react-dom';
import { KlpButton, KlpText, KlpTextField } from './components.js';
import { useKlp, type KlpTheme } from './theme.js';
import { styleVariables } from './style-pack.js';
import type { KlpCommandExecutionResult, KlpCommandRegistry, KlpCommandState } from './command-registry.js';

export type KlpCommandDismissReason = 'escape' | 'outside' | 'executed';

export interface KlpRegisteredCommandPaletteProps<C = unknown> {
	/* registry/context 是產品權威；open 為產品受控的 modal 生命週期。 */
	registry: KlpCommandRegistry<C>;
	getContext: () => C;
	open: boolean;
	/* 三個名稱由產品本地化；callback 保留原結果與明確關閉理由。 */
	label: string;
	searchLabel: string;
	emptyLabel: string;
	onResult: (result: KlpCommandExecutionResult) => void;
	onDismiss: (reason: KlpCommandDismissReason) => void;
	/* id/className 只標識原生宿主，不建立第二份內部風格。 */
	id?: string;
	className?: string;
}

interface Viewport {
	/* width/height 為原生 viewport，只用於有限幾何，不保存到命令或產品布局。 */
	width: number;
	height: number;
}

function requireText(value: string, name: string): void {
	if (typeof value !== 'string' || !value.trim()) throw new TypeError(`${name} must contain non-whitespace text`);
}

function fieldScore(field: string, term: string): number {
	if (field === term) return 0;
	if (field.startsWith(term)) return 1;
	if (field.includes(term)) return 2;
	let position = 0;
	for (let index = 0; index < term.length; index++) {
		position = field.indexOf(term[index], position);
		if (position < 0) return Infinity;
		position++;
	}
	return 3;
}

function search(states: readonly KlpCommandState[], query: string): readonly KlpCommandState[] {
	const words = query.trim().toLowerCase().split(/\s+/u).filter(Boolean);
	// state 保留清冊快照；score 只決定本次搜尋排序，不改 metadata 或業務狀態。
	const candidates: { state: KlpCommandState; score: number }[] = [];
	for (const state of states) {
		if (!state.visible) continue;
		const fields = [state.label, state.id, state.category ?? '', state.description ?? '', ...state.keywords].map(value => value.toLowerCase());
		let score = 0;
		for (const word of words) score += Math.min(...fields.map(field => fieldScore(field, word)));
		if (Number.isFinite(score)) candidates.push({ state, score });
	}
	function compare(left: typeof candidates[number], right: typeof candidates[number]): number {
		if (left.score !== right.score) return left.score - right.score;
		if (left.state.id === right.state.id) return 0;
		return left.state.id < right.state.id ? -1 : 1;
	}
	return candidates.sort(compare).map(item => item.state);
}

function reportToHost(error: unknown): void {
	try {
		if (typeof globalThis.reportError === 'function') globalThis.reportError(error);
		else console.error(error);
	}
	catch {
		// 診斷通道自身錯誤不能覆蓋原產品結果。
	}
}

function finite(value: unknown): number {
	return typeof value === 'number' && Number.isFinite(value) ? Math.max(0, value) : 0;
}

function geometry(theme: KlpTheme, viewport: Viewport): CSSProperties {
	const width = finite(viewport.width), height = finite(viewport.height);
	const inset = Math.min(finite(theme.semantic('theme.geometry.layout.overlayViewportInset')), width / 2, height / 2);
	const panelWidth = Math.min(finite(theme.semantic('theme.geometry.layout.dialogMaximumWidth')), width - 2 * inset);
	const panelHeight = height - 2 * inset;
	const padding = Math.min(finite(theme.semantic('theme.spacing.tight')), panelWidth / 2, panelHeight / 2);
	const contentWidth = Math.max(0, panelWidth - 2 * padding);
	const rowPadding = Math.min(finite(theme.semantic('theme.components.menuPadding')), contentWidth / 2);
	const icon = Math.min(finite(theme.semantic('theme.spacing.iconSmall')), Math.max(0, contentWidth - 2 * rowPadding) / 2);
	const gap = Math.min(finite(theme.semantic('theme.spacing.overlayItemGap')), Math.max(0, contentWidth - 2 * rowPadding - icon));
	return {
		/* 全部 effective 值從同 token/clamp 派生，不是另一份預設風格。 */
		'--klp-palette-inset': `${inset}px`,
		'--klp-palette-width': `${panelWidth}px`,
		'--klp-palette-height': `${panelHeight}px`,
		'--klp-palette-padding': `${padding}px`,
		'--klp-palette-row-padding': `${rowPadding}px`,
		'--klp-palette-icon': `${icon}px`,
		'--klp-palette-gap': `${gap}px`,
	} as CSSProperties;
}

export function KlpRegisteredCommandPalette<C = unknown>(props: KlpRegisteredCommandPaletteProps<C>) {
	const theme = useKlp();
	requireText(props.label, 'label');
	requireText(props.searchLabel, 'searchLabel');
	requireText(props.emptyLabel, 'emptyLabel');
	const id = useId();
	const source = useRef<HTMLSpanElement>(null), dialog = useRef<HTMLDialogElement>(null);
	const current = useRef(props);
	current.current = props;
	const alive = useRef(true), generation = useRef(0), composing = useRef(false);
	const [mounted, setMounted] = useState(false), [query, setQuery] = useState('');
	const [selectedId, setSelectedId] = useState<string | null>(null);
	const [viewport, setViewport] = useState<Viewport>({ width: 0, height: 0 });
	const [scopeStyle, setScopeStyle] = useState<CSSProperties>({});
	const { registry, open } = props;
	const subscribe = useCallback((listener: () => void) => { if (!open || registry.isDisposed) return () => {}; return registry.subscribe(listener); }, [registry, open]);
	const getVersion = useCallback(() => registry.version, [registry]);
	useSyncExternalStore(subscribe, getVersion, getVersion);
	function mountClient() { setMounted(true); }
	useEffect(mountClient, []);
	function attachLifetime() {
		alive.current = true;
		generation.current++;
		return () => { alive.current = false; generation.current++; };
	}
	useEffect(attachLifetime, [registry, open]);
	const ownerDocument = source.current?.ownerDocument;
	const candidates = mounted && open && !registry.isDisposed ? search(registry.list(props.getContext()), query) : [];
	const available = candidates.filter(state => state.enabled && !state.running);
	let activeId: string | null = available[0]?.id ?? null;
	if (available.some(state => state.id === selectedId)) activeId = selectedId;
	const activeIndex = candidates.findIndex(state => state.id === activeId);
	const optionId = activeIndex < 0 ? undefined : `${id}-option-${activeIndex}`;

	function copyScope() {
		if (!mounted || !open) return;
		const scope = source.current?.closest<HTMLElement>('.klp-theme');
		const values = { ...styleVariables(theme.tokens) };
		if (scope) {
			// 複製實際 Provider 投影，包括 derived 與 caller scope variables；不重建預設主題。
			for (let index = 0; index < scope.style.length; index++) {
				const property = scope.style.item(index);
				if (property.startsWith('--')) values[property] = scope.style.getPropertyValue(property);
			}
		}
		setScopeStyle(values as CSSProperties);
	}
	useLayoutEffect(copyScope, [theme, mounted, open]);
	function observeViewport() {
		if (!mounted || !open || !ownerDocument?.defaultView) return;
		const win = ownerDocument.defaultView;
		const root = ownerDocument.documentElement;
		let listening = true;
		function resize() {
			if (!listening) return;
			// fixed 可用尺寸排除捲軸；無 layout 的 DOM harness 才沿有限 inner 值退化。
			const hasLayout = root.getClientRects().length > 0;
			const width = finite(root.clientWidth > 0 || hasLayout ? root.clientWidth : win.innerWidth);
			const height = finite(root.clientHeight > 0 || hasLayout ? root.clientHeight : win.innerHeight);
			setViewport(previous => previous.width === width && previous.height === height ? previous : { width, height });
		}
		resize();
		win.addEventListener('resize', resize);
		const observer = typeof win.ResizeObserver === 'function' ? new win.ResizeObserver(resize) : null;
		observer?.observe(root);
		function stopObserving() {
			listening = false;
			observer?.disconnect();
			win.removeEventListener('resize', resize);
		}
		return stopObserving;
	}
	useLayoutEffect(observeViewport, [mounted, open, ownerDocument]);
	function focusSession() {
		const node = dialog.current;
		if (!mounted || !open || !node) return;
		const doc = node.ownerDocument;
		const previous = doc.activeElement as HTMLElement | null;
		setQuery('');
		setSelectedId(null);
		composing.current = false;
		// Native modal 提供 top layer/inert；純 DOM 宿主缺此 API 時仍可觀察原生內容。
		if (typeof node.showModal === 'function') node.showModal();
		else node.setAttribute('open', '');
		node.querySelector<HTMLInputElement>('input')?.focus();
		return () => {
			const focus = doc.activeElement as HTMLElement | null;
			const owned = node.contains(focus) || focus === doc.body || !focus;
			if (node.isConnected && typeof node.close === 'function') node.close();
			if (owned && previous?.isConnected) previous.focus({ preventScroll: true });
			else if (!owned && focus?.isConnected && doc.activeElement !== focus) focus.focus({ preventScroll: true });
		};
	}
	useLayoutEffect(focusSession, [mounted, open]);
	function revealActive() {
		if (!optionId) return;
		const node = ownerDocument?.getElementById(optionId);
		if (typeof node?.scrollIntoView === 'function') node.scrollIntoView({ block: 'nearest' });
	}
	useEffect(revealActive, [optionId, query, ownerDocument]);

	function isCurrent(commandRegistry: KlpCommandRegistry<C>, owner: number): boolean {
		return alive.current && current.current.open && generation.current === owner && current.current.registry === commandRegistry;
	}
	function dismiss(reason: KlpCommandDismissReason): void {
		try { current.current.onDismiss(reason); }
		catch (error) { reportToHost(error); }
	}
	async function activate(commandId: string): Promise<void> {
		const start = current.current, owner = generation.current;
		let result: KlpCommandExecutionResult;
		try { result = await start.registry.execute(commandId, start.getContext()); }
		catch (error) { if (isCurrent(start.registry, owner)) reportToHost(error); return; }
		if (!isCurrent(start.registry, owner)) return;
		try { current.current.onResult(result); }
		catch (error) { reportToHost(error); return; }
		if (result.status === 'executed' && isCurrent(start.registry, owner)) dismiss('executed');
	}
	function changeQuery(event: FormEvent<HTMLInputElement>): void { setQuery(event.currentTarget.value); }
	function keyDown(event: KeyboardEvent<HTMLDialogElement>): void {
		if (event.defaultPrevented || composing.current || event.nativeEvent.isComposing) return;
		if (event.key === 'Escape') { event.preventDefault(); if (!event.repeat) dismiss('escape'); return; }
		if (event.key === 'Tab') { event.preventDefault(); dialog.current?.querySelector<HTMLInputElement>('input')?.focus(); return; }
		if (event.key === 'Enter') { event.preventDefault(); if (!event.repeat && activeId) void activate(activeId); return; }
		if (event.key !== 'ArrowDown' && event.key !== 'ArrowUp') return;
		event.preventDefault();
		if (!available.length) return;
		let index = available.findIndex(state => state.id === activeId);
		if (event.key === 'ArrowDown') index = (index + 1) % available.length;
		else index = (index + available.length - 1) % available.length;
		setSelectedId(available[index].id);
	}
	function outside(event: MouseEvent<HTMLDialogElement>): void {
		if (event.target !== event.currentTarget) return;
		const rect = event.currentTarget.getBoundingClientRect();
		if (event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom) dismiss('outside');
	}
	function renderCandidate(state: KlpCommandState, index: number) {
		return <KlpButton
			key={state.id}
			id={`${id}-option-${index}`}
			role="option"
			tone="ghost"
			tabIndex={-1}
			aria-selected={state.id === activeId}
			aria-disabled={!state.enabled || state.running}
			disabled={!state.enabled || state.running}
			className="klp-palette-option"
			onMouseDown={event => event.preventDefault()}
			onClick={() => { dialog.current?.querySelector<HTMLInputElement>('input')?.focus(); void activate(state.id); }}
		>
			{state.icon != null && <span aria-hidden="true" className="klp-palette-icon">{state.icon}</span>}
			<span className="klp-palette-copy"><KlpText role="label">{state.label}</KlpText>{state.description && <KlpText role="caption" tone="muted">{state.description}</KlpText>}{state.category && <KlpText role="caption" tone="faint">{state.category}</KlpText>}</span>
		</KlpButton>;
	}

	let overlay = null;
	if (mounted && open && ownerDocument) {
		const style = { ...styleVariables(theme.tokens), ...scopeStyle, ...geometry(theme, viewport) };
		const content = <div className="klp-theme klp-palette-host" data-klp-mode={theme.mode} style={style} onClick={event => { if (event.target === event.currentTarget) dismiss('outside'); }}>
			<dialog
				ref={dialog}
				id={props.id}
				role="dialog"
				aria-modal="true"
				aria-label={props.label}
				className={`klp-palette-dialog ${props.className ?? ''}`}
				data-klp-separation={String(theme.semantic('theme.surface.separation'))}
				onKeyDown={keyDown}
				onClick={outside}
				onCancel={event => { event.preventDefault(); if (!composing.current) dismiss('escape'); }}
			>
				<KlpTextField
					label={props.searchLabel}
					aria-label={props.searchLabel}
					role="combobox"
					aria-expanded="true"
					aria-autocomplete="list"
					aria-controls={`${id}-list`}
					aria-activedescendant={optionId}
					value={query}
					onInput={changeQuery}
					onChange={changeQuery}
					onCompositionStart={() => { composing.current = true; }}
					onCompositionEnd={() => { composing.current = false; }}
				/>
				<div id={`${id}-list`} role="listbox" aria-label={props.label} className="klp-palette-list">
					{candidates.map(renderCandidate)}
				</div>
				{!candidates.length && <KlpText role="caption" tone="muted">{props.emptyLabel}</KlpText>}
			</dialog>
		</div>;
		// Portal 保留 React context，CSS 投影則隨 physical scope 一起帶入 owner document。
		overlay = createPortal(content, ownerDocument.body);
	}
	return <><span ref={source} hidden aria-hidden="true" />{overlay}</>;
}
