import { useCallback, useEffect, useRef, useState, useSyncExternalStore, type CSSProperties, type KeyboardEvent } from 'react';
import { KlpButton, KlpText } from './components.js';
import { useKlp } from './theme.js';
import type { KlpCommandRegistry, KlpCommandExecutionResult, KlpCommandState } from './command-registry.js';

export interface KlpCommandReference {
	/* commandId 引用registry；kind 只決定原生呈現語意，不擁有handler或狀態。 */
	readonly commandId: string;
	readonly kind?: 'action' | 'toggle';
}

export interface KlpRegisteredCommandToolbarProps<C = unknown> {
	/* registry 是唯一命令權威；getContext 每次讀產品；items/label 指定入口排列與可存取名稱。 */
	registry: KlpCommandRegistry<C>;
	getContext: () => C;
	items: readonly KlpCommandReference[];
	label: string;
	/* onResult 交產品處理業務結果；className/id/style 供原生外部宿主。 */
	onResult: (result: KlpCommandExecutionResult) => void;
	className?: string;
	id?: string;
	style?: CSSProperties;
}

export interface KlpRegisteredCommandMenuProps<C = unknown> extends KlpRegisteredCommandToolbarProps<C> {
	/* emptyLabel 為產品空清冊文案；autoFocus 可明確取得初始焦點；onDismiss 交彈出宿主管理關閉。 */
	emptyLabel: string;
	autoFocus?: boolean;
	onDismiss?: () => void;
}

interface CommandRowData {
	/* reference 保留產品排列/role；state 為本次registry唯讀查詢。 */
	reference: KlpCommandReference;
	state: KlpCommandState;
}

interface CommandRowProps {
	/* row 是registry投影；mode 指定水平/垂直呈現；active 只控制可用tabstop。 */
	row: CommandRowData;
	mode: 'toolbar' | 'menu';
	active: boolean;
	/* onActivate dispatch ID；onFocus 更新此入口roving位置，不改業務狀態。 */
	onActivate: (id: string) => Promise<void>;
	onFocus: (id: string) => void;
}

function requireText(value: unknown, name: string): asserts value is string {
	if (typeof value !== 'string' || !value.trim()) throw new TypeError(`${name} must contain non-whitespace text`);
}

function copyReferences(items: readonly KlpCommandReference[]): readonly KlpCommandReference[] {
	if (!Array.isArray(items)) throw new TypeError('Command items must be an array');
	const ids = new Set<string>();
	function copy(item: KlpCommandReference): KlpCommandReference {
		if (!item || typeof item !== 'object') throw new TypeError('Command reference must be an object');
		requireText(item.commandId, 'commandId');
		if (item.kind !== undefined && item.kind !== 'action' && item.kind !== 'toggle') throw new TypeError('Invalid command reference kind');
		if (ids.has(item.commandId)) throw new TypeError(`Duplicate command reference: ${item.commandId}`);
		ids.add(item.commandId);
		return { commandId: item.commandId, kind: item.kind };
	}
	return items.map(copy);
}

function reportToHost(error: unknown): void {
	try {
		if (typeof globalThis.reportError === 'function') globalThis.reportError(error);
		else console.error(error);
	}
	catch {
		// 宿主通道失敗不能蓋過registry的原產品結果。
	}
}

function useCommandEntries<C>(props: KlpRegisteredCommandToolbarProps<C>) {
	const { registry } = props;
	const subscribe = useCallback((listener: () => void) => { if (registry.isDisposed) return () => {}; return registry.subscribe(listener); }, [registry]);
	const getVersion = useCallback(() => registry.version, [registry]);
	useSyncExternalStore(subscribe, getVersion, getVersion);
	const currentProps = useRef(props);
	currentProps.current = props;
	const mounted = useRef(true);
	const generation = useRef(0);
	const root = useRef<HTMLDivElement>(null);
	const [selectedId, setSelectedId] = useState<string | null>(null);
	function attachLifetime() {
		mounted.current = true;
		generation.current++;
		return () => { mounted.current = false; generation.current++; };
	}
	useEffect(attachLifetime, [registry]);
	const references = copyReferences(props.items);
	const rows: CommandRowData[] = [];
	if (!registry.isDisposed) {
		const context = props.getContext();
		for (const reference of references) {
			const state = registry.getState(reference.commandId, context);
			if (state?.visible) rows.push({ reference, state });
		}
	}
	const enabled = rows.filter(row => row.state.enabled && !row.state.running);
	let activeId: string | null = enabled[0]?.reference.commandId ?? null;
	if (enabled.some(row => row.reference.commandId === selectedId)) activeId = selectedId;

	function focus(id: string | null): void {
		if (id === null) { root.current?.focus(); return; }
		setSelectedId(id);
		const buttons = root.current?.querySelectorAll<HTMLButtonElement>('button[data-klp-command-id]');
		const button = [...(buttons ?? [])].find(item => item.dataset.klpCommandId === id);
		button?.focus();
	}

	async function activate(id: string): Promise<void> {
		const source = currentProps.current;
		const owner = generation.current;
		let result: KlpCommandExecutionResult;
		try {
			result = await source.registry.execute(id, source.getContext());
		}
		catch (error) {
			if (mounted.current && generation.current === owner && currentProps.current.registry === source.registry) reportToHost(error);
			return;
		}
		if (!mounted.current || generation.current !== owner || currentProps.current.registry !== source.registry) return;
		try { currentProps.current.onResult(result); }
		catch (error) { reportToHost(error); }
	}

	function keyDown(event: KeyboardEvent<HTMLDivElement>, mode: 'toolbar' | 'menu', onDismiss?: () => void): void {
		if (event.defaultPrevented) return;
		if (event.key === 'Escape' && mode === 'menu') { event.preventDefault(); onDismiss?.(); return; }
		const button = (event.target as HTMLElement).closest?.('button[data-klp-command-id]') as HTMLButtonElement | null;
		if (button?.disabled || !enabled.length) return;
		const current = button?.dataset.klpCommandId ?? activeId;
		let index = enabled.findIndex(row => row.reference.commandId === current);
		if (index < 0) index = 0;
		if (event.key === 'Enter' || event.key === ' ') {
			event.preventDefault();
			if (!event.repeat) void activate(enabled[index].reference.commandId);
			return;
		}
		const forward = mode === 'toolbar' ? 'ArrowRight' : 'ArrowDown';
		const back = mode === 'toolbar' ? 'ArrowLeft' : 'ArrowUp';
		if (event.key === forward) index = (index + 1) % enabled.length;
		else if (event.key === back) index = (index + enabled.length - 1) % enabled.length;
		else if (event.key === 'Home') index = 0;
		else if (event.key === 'End') index = enabled.length - 1;
		else return;
		event.preventDefault();
		focus(enabled[index].reference.commandId);
	}
	return { root, rows, activeId, focus, activate, keyDown, setSelectedId };
}

function CommandRow({ row, mode, active, onActivate, onFocus }: CommandRowProps) {
	const { state, reference } = row;
	const toggle = reference.kind === 'toggle';
	const menu = mode === 'menu';
	let role: 'menuitem' | 'menuitemcheckbox' | undefined;
	if (menu) role = toggle ? 'menuitemcheckbox' : 'menuitem';
	return <KlpButton
		role={role}
		tone="ghost"
		selected={!menu && toggle ? state.checked : undefined}
		aria-checked={menu && toggle ? state.checked : undefined}
		aria-busy={state.running || undefined}
		disabled={!state.enabled || state.running}
		tabIndex={active ? 0 : -1}
		data-klp-command-id={reference.commandId}
		className={`klp-command-row klp-command-row-${mode}`}
		title={menu ? undefined : state.description}
		onFocus={() => onFocus(reference.commandId)}
		onClick={() => void onActivate(reference.commandId)}
	>
		{state.icon != null && <span className="klp-command-icon" aria-hidden="true">{state.icon}</span>}
		<span className="klp-command-copy"><KlpText role="label">{state.label}</KlpText>{menu && state.description && <KlpText role="caption" tone="muted">{state.description}</KlpText>}</span>
	</KlpButton>;
}

export function KlpRegisteredCommandToolbar<C = unknown>(props: KlpRegisteredCommandToolbarProps<C>) {
	useKlp();
	requireText(props.label, 'label');
	const host = useCommandEntries(props);
	return <div ref={host.root} id={props.id} role="toolbar" aria-label={props.label} className={`klp-command-toolbar ${props.className ?? ''}`} style={props.style} onKeyDown={event => host.keyDown(event, 'toolbar')}>
		{host.rows.map(row => <CommandRow key={row.reference.commandId} row={row} mode="toolbar" active={host.activeId === row.reference.commandId} onActivate={host.activate} onFocus={host.setSelectedId} />)}
	</div>;
}

export function KlpRegisteredCommandMenu<C = unknown>(props: KlpRegisteredCommandMenuProps<C>) {
	const theme = useKlp();
	requireText(props.label, 'label');
	requireText(props.emptyLabel, 'emptyLabel');
	const host = useCommandEntries(props);
	function autofocus() { if (props.autoFocus) host.focus(host.activeId); }
	useEffect(autofocus, [props.autoFocus, props.registry]);
	return <div ref={host.root} id={props.id} role="menu" tabIndex={-1} aria-label={props.label} data-klp-separation={String(theme.semantic('theme.surface.separation'))} className={`klp-command-menu ${props.className ?? ''}`} style={props.style} onKeyDown={event => host.keyDown(event, 'menu', props.onDismiss)}>
		{host.rows.map(row => <CommandRow key={row.reference.commandId} row={row} mode="menu" active={host.activeId === row.reference.commandId} onActivate={host.activate} onFocus={host.setSelectedId} />)}
		{!host.rows.length && <KlpText role="caption" tone="muted">{props.emptyLabel}</KlpText>}
	</div>;
}
