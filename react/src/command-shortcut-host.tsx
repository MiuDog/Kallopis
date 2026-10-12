import { useLayoutEffect, useRef, type ReactNode, type KeyboardEvent, type FocusEvent } from 'react';
import { KlpCommandKeymap, type KlpShortcutFocus, type KlpShortcutHandling } from './command-keymap.js';
import type { KlpCommandExecutionResult } from './command-registry.js';

export interface KlpCommandShortcutHostProps<C = unknown> {

	/* keymap 借用解析權威；getContext／getFocus 投影當次產品資料及原生 target，不保存第二份產品狀態。 */
	readonly keymap: KlpCommandKeymap<C>;
	readonly getContext: () => C;
	readonly getFocus: (target: EventTarget | null) => KlpShortcutFocus;
	/* onHandling 回原解析結果供產品呈現；onResult 回原 execution；children 保留原生結構與布局。 */
	readonly onHandling: (handling: KlpShortcutHandling) => void;
	readonly onResult: (result: KlpCommandExecutionResult) => void;
	readonly children: ReactNode;
}

interface HostSession<C> {

	/* keymap 為借用identity；alive 限制callback壽命；timer 單一owned deadline；composing 沿原生組字session。 */
	readonly keymap: KlpCommandKeymap<C>;
	alive: boolean;
	timer?: ReturnType<typeof setTimeout>;
	composing: boolean;
}

export function KlpCommandShortcutHost<C>(props: KlpCommandShortcutHostProps<C>): ReactNode {
	const latest = useRef(props);
	const owner = useRef<HostSession<C> | undefined>(undefined);
	latest.current = props;

	// layout effect 在子元件可接原生事件前建立 owner，StrictMode cleanup/setup 也保持單一資源。
	useLayoutEffect(attach, [props.keymap]);

	function attach(): () => void {
		const session: HostSession<C> = { /* keymap：本次borrowed identity；alive：mounted；composing：尚無原生session。 */ keymap: props.keymap, alive: true, composing: false };
		owner.current = session;
		return () => {
			session.alive = false;
			clearSession(session, true);
			if (owner.current === session) owner.current = undefined;
		};
	}

	function current(session: HostSession<C>): boolean {
		return session.alive && owner.current === session && latest.current.keymap === session.keymap;
	}

	function keydown(event: KeyboardEvent<HTMLDivElement>): void {
		const session = owner.current;
		if (event.defaultPrevented || !session || !current(session)) return;

		let result: KlpShortcutHandling;
		try {
			// 原生 editable 與產品focus做OR；logical key轉換不採 physical code。
			const native = event.nativeEvent;
			const focus = latest.current.getFocus(event.target);
			if (focus.editable !== undefined && typeof focus.editable !== 'boolean') throw new TypeError('Invalid editable projection');
			const projected: KlpShortcutFocus = { /* focusId／scope IDs 沿產品投影；editable 額外保護原生文字。 */ ...focus, editable: !!focus.editable || editable(event.target) };
			const input = {
				/* key：native logical key；四modifier：當次實際旗標；repeat：native repeat；composing：三來源OR。 */
				key: native.key === ' ' ? 'space' : native.key.toLowerCase(),
				ctrl: native.ctrlKey,
				alt: native.altKey,
				shift: native.shiftKey,
				meta: native.metaKey,
				repeat: native.repeat,
				composing: native.isComposing || session.composing || native.keyCode === 229,
			};
			result = session.keymap.handle(input, projected, latest.current.getContext());
		}
		catch (error) {
			report(error);
			return;
		}

		// 決定原生攔截先於產品回呼，回呼錯誤不能再次dispatch或改結果。
		if (result.handled) {
			event.preventDefault();
			event.stopPropagation();
		}
		try {
			updateTimer(session, result);
			latest.current.onHandling(result);
		}
		catch (error) {
			report(error);
		}
		if (result.execution) {
			// 借用原Promise；same-session才能交latest產品callback，不clone value或error。
			void result.execution.then(deliver).catch(report);
		}

		function deliver(value: KlpCommandExecutionResult): void {
			if (current(session!)) latest.current.onResult(value);
		}
	}

	function blur(event: FocusEvent<HTMLDivElement>): void {
		const session = owner.current;
		if (!session || !current(session)) return;

		const target = event.relatedTarget;
		const inside = target instanceof Node && event.currentTarget.contains(target);
		clearSession(session, !inside);
	}

	function compositionStart(): void {
		const session = owner.current;
		if (!session || !current(session)) return;

		session.composing = true;
		session.keymap.cancelChord();
		cancelTimer(session);
	}

	function compositionEnd(): void {
		if (owner.current) owner.current.composing = false;
	}

	return <div style={{ /* display：中立布局宿主，不新增尺寸或tab stop。 */ display: 'contents' }} onKeyDown={keydown} onBlur={blur} onCompositionStart={compositionStart} onCompositionEnd={compositionEnd}>{props.children}</div>;
}

function editable(target: EventTarget | null): boolean {
	let element: Element | null = null;
	if (target instanceof Element) element = target;
	else if (target instanceof Node) element = target.parentElement;

	// 最近的explicit contenteditable=false子區終止继承；原生input/textarea始終保護。
	if (element?.closest('input,textarea')) return true;

	while (element) {
		const attribute = element.getAttribute('contenteditable');
		if (attribute?.toLowerCase() === 'false') return false;
		if (attribute === '' || attribute !== null && ['true', 'plaintext-only'].includes(attribute.toLowerCase())) return true;

		element = element.parentElement;
	}
	return false;
}

function cancelTimer<C>(session: HostSession<C>): void {
	if (session.timer !== undefined) clearTimeout(session.timer);
	delete session.timer;
}

function clearSession<C>(session: HostSession<C>, outside: boolean): void {
	cancelTimer(session);
	session.keymap.cancelChord();
	if (outside) {
		session.keymap.cancelRecording();
		session.composing = false;
	}
}

function updateTimer<C>(session: HostSession<C>, result: KlpShortcutHandling): void {
	if (!session.keymap.pendingSequence.length) {
		cancelTimer(session);
		return;
	}
	if (result.state === 'prefix') cancelTimer(session);
	if (session.timer === undefined) scheduleTimer(session);
}

function scheduleTimer<C>(session: HostSession<C>): void {
	// 只有一次原生timeout；clock未到期限時以相同timeout重試，沒有逐frame或zero-delay輪詢。
	session.timer = setTimeout(expire, session.keymap.chordTimeoutMs);

	function expire(): void {
		delete session.timer;
		if (!session.alive) return;

		try {
			session.keymap.expireChord();
			if (session.keymap.pendingSequence.length) scheduleTimer(session);
		}
		catch (error) {
			report(error);
		}
	}
}

function report(error: unknown): void {
	// 宿主diagnostic不能覆蓋產品execution，也不能因diagnostic callback再次失敗破壞清理。
	try {
		if (typeof globalThis.reportError === 'function') globalThis.reportError(error);
		else console.error(error);
	}
	catch {
		// 原生diagnostic已嘗試交宿主，不重試dispatch。
	}
}
