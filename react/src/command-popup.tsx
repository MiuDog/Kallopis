import { useLayoutEffect, useRef, useState, type KeyboardEvent, type PointerEvent } from 'react';
import { KlpRegisteredCommandMenu, type KlpRegisteredCommandMenuProps } from './command-entries.js';
import type { KlpCommandExecutionResult } from './command-registry.js';
import { useKlp } from './theme.js';

export interface KlpCommandPopupAnchor {

	/* x/y 是同視窗邏輯 viewport 座標；width/height 為非負尺寸，零尺寸表示 context point。 */
	readonly x: number;
	readonly y: number;
	readonly width: number;
	readonly height: number;
}

export type KlpCommandPopupDismissReason = 'escape' | 'outside' | 'executed';

export interface KlpRegisteredCommandPopupProps<C = unknown> extends Pick<KlpRegisteredCommandMenuProps<C>, 'registry' | 'getContext' | 'items' | 'label' | 'emptyLabel' | 'onResult' | 'className' | 'id'> {

	/* menu 欄位沿公開契約；open 保留產品開關權威；anchor 由產品更新；onDismiss 僅回傳意圖。 */
	open: boolean;
	anchor: KlpCommandPopupAnchor;
	onDismiss: (reason: KlpCommandPopupDismissReason) => void;
}

interface PopupGeometry {

	/* left/top 是 viewport 位置；width 是有限面板寬；height 是本次有限 scrollport，不能寫回 pack。 */
	left: number;
	top: number;
	width: number;
	height: number;
}

function length(value: unknown): number {
	return typeof value === 'number' && Number.isFinite(value) && value > 0 ? value : 0;
}

function trailingEdge(start: number, extent: number, limit: number): number {
	if (start < 0) return Math.max(0, Math.min(limit, start + extent));

	const leading = Math.min(start, limit);
	return leading + Math.min(extent, limit - leading);
}

function placement(anchor: KlpCommandPopupAnchor, viewport: PopupGeometry, content: PopupGeometry, rtl: boolean): PopupGeometry {
	// 步驟 1：先夾 anchor 邊與風格空間，避免巨大合法座標加總溢位。
	const inset = Math.min(content.left, Math.min(viewport.width, viewport.height) / 2);
	const width = Math.min(content.width, Math.max(0, viewport.width - 2 * inset));
	const top = Math.max(0, Math.min(viewport.height, anchor.y));
	const bottom = trailingEdge(anchor.y, anchor.height, viewport.height);
	const above = Math.max(0, Math.min(viewport.height - 2 * inset, top - inset));
	const below = Math.max(0, Math.min(viewport.height - 2 * inset, viewport.height - inset - bottom));
	const useBelow = content.height <= below || (content.height > above && below >= above);
	const height = Math.min(content.height, useBelow ? below : above);

	// 步驟 2：依方向對齊並夾入有效 viewport；高度交回公開 menu 的 scrollport。
	const preferredLeft = rtl ? trailingEdge(anchor.x, anchor.width, viewport.width) - width : Math.max(0, Math.min(viewport.width, anchor.x));
	const left = Math.max(inset, Math.min(viewport.width - inset - width, preferredLeft));
	const preferredTop = useBelow ? bottom : top - height;
	return { left, top: Math.max(inset, Math.min(viewport.height - inset - height, preferredTop)), width, height };
}

export function KlpRegisteredCommandPopup<C = unknown>(props: KlpRegisteredCommandPopupProps<C>) {
	const { anchor } = props;
	if (!anchor || !Number.isFinite(anchor.x) || !Number.isFinite(anchor.y) || !Number.isFinite(anchor.width) || !Number.isFinite(anchor.height) || anchor.width < 0 || anchor.height < 0) throw new TypeError('anchor requires finite coordinates and nonnegative dimensions');
	if (typeof props.label !== 'string' || !props.label.trim() || typeof props.emptyLabel !== 'string' || !props.emptyLabel.trim()) throw new TypeError('label and emptyLabel require non-whitespace text');
	const identity = useRef({
		/* registry 指向當前產品清冊；version 只隔離 replacement 的 menu 與 callback 生命週期。 */
		registry: props.registry,
		version: 0,
	});
	if (identity.current.registry !== props.registry) {
		identity.current = { registry: props.registry, version: identity.current.version + 1 };
	}
	if (!props.open) return null;

	return <PopupSession key={identity.current.version} {...props} />;
}

function PopupSession<C>(props: KlpRegisteredCommandPopupProps<C>) {
	const theme = useKlp();
	const dialog = useRef<HTMLDialogElement>(null);
	const panel = useRef<HTMLDivElement>(null);
	const latest = useRef(props);
	latest.current = props;
	const alive = useRef(false);
	const dismissed = useRef(new Set<KlpCommandPopupDismissReason>());
	const [geometry, setGeometry] = useState<PopupGeometry>({ left: 0, top: 0, width: 0, height: 0 });
	const menuWidth = length(theme.semantic('theme.geometry.layout.commandMenuWidth'));
	const inset = length(theme.semantic('theme.geometry.layout.overlayViewportInset'));

	function dismiss(reason: KlpCommandPopupDismissReason): void {
		if (!alive.current || !latest.current.open || dismissed.current.has(reason)) return;

		dismissed.current.add(reason);
		latest.current.onDismiss(reason);
	}

	function result(value: KlpCommandExecutionResult): void {
		if (!alive.current || !latest.current.open) return;

		latest.current.onResult(value);
		if (value.status === 'executed') dismiss('executed');
	}

	function attachModal() {
		const node = dialog.current;
		if (!node) return;

		const popup = node;
		alive.current = true;
		const owner = popup.ownerDocument.activeElement;
		dismissed.current.clear();

		// 原生 top layer 與 inert 由同 Provider DOM 的 dialog 擁有，先開 modal 再讓 menu effect 聚焦。
		popup.showModal();
		function detach() {
			alive.current = false;
			const active = popup.ownerDocument.activeElement;
			const belongs = active === popup || popup.contains(active);
			popup.close();
			const target = belongs ? owner : active;
			if (target instanceof popup.ownerDocument.defaultView!.HTMLElement && target.isConnected) target.focus();
		}
		return detach;
	}
	useLayoutEffect(attachModal, []);

	function observe() {
		const node = panel.current;
		const modal = dialog.current;
		if (!node || !modal) return;

		const container = node;
		const popup = modal;
		const win = popup.ownerDocument.defaultView;
		function measure() {
			const native = popup.ownerDocument.documentElement;
			const width = length(native.clientWidth);
			const height = length(native.clientHeight);
			const menu = container.querySelector<HTMLElement>('[role="menu"]');
			const natural = length(menu?.scrollHeight);
			const nativeDirection = win?.getComputedStyle(popup).direction;
			const direction = nativeDirection || popup.closest('[dir]')?.getAttribute('dir');
			const rtl = direction === 'rtl';
			const next = placement(latest.current.anchor, { left: 0, top: 0, width, height }, { left: inset, top: 0, width: menuWidth, height: natural }, rtl);
			function update(previous: PopupGeometry): PopupGeometry {
				if (previous.left === next.left && previous.top === next.top && previous.width === next.width && previous.height === next.height) return previous;

				return next;
			}
			setGeometry(update);
		}

		// 原生內容與視窗改變只更新有效 geometry；同值 guard 及 cleanup 防止量測迴圈。
		measure();
		const Observer = win?.ResizeObserver;
		const observer = Observer ? new Observer(measure) : null;
		observer?.observe(container);
		const menu = container.querySelector<HTMLElement>('[role="menu"]');
		if (menu) observer?.observe(menu);
		win?.addEventListener('resize', measure);
		return () => { observer?.disconnect(); win?.removeEventListener('resize', measure); };
	}
	useLayoutEffect(observe, [props.anchor.x, props.anchor.y, props.anchor.width, props.anchor.height, props.items, theme, inset, menuWidth]);

	function key(event: KeyboardEvent<HTMLDialogElement>): void {
		if (event.key !== 'Tab') return;

		event.preventDefault();
		const menu = panel.current?.querySelector<HTMLElement>('[role="menu"]');
		const buttons = [...(menu?.querySelectorAll<HTMLButtonElement>('button[data-klp-command-id]:not(:disabled)') ?? [])];
		if (!buttons.length) { menu?.focus(); return; }

		const current = buttons.indexOf(event.currentTarget.ownerDocument.activeElement as HTMLButtonElement);
		const delta = event.shiftKey ? -1 : 1;
		const next = (current + delta + buttons.length) % buttons.length;
		buttons[next].focus();
	}

	function outside(event: PointerEvent<HTMLDialogElement>): void {
		if (event.target === event.currentTarget) dismiss('outside');
	}
	function escape() { dismiss('escape'); }
	function cancel(event: React.SyntheticEvent<HTMLDialogElement>): void { event.preventDefault(); escape(); }
	function namedOutside() { dismiss('outside'); }
	return <dialog ref={dialog} id={props.id} className={`klp-command-popup ${props.className ?? ''}`} aria-label={props.label} onCancel={cancel} onPointerDown={outside} onKeyDown={key}>
		<button type="button" className="klp-command-popup-dismiss" tabIndex={-1} aria-label={props.label} onClick={namedOutside} />
		<div ref={panel} className="klp-command-popup-panel" style={{ position: 'absolute', left: `${geometry.left}px`, top: `${geometry.top}px`, width: `${geometry.width}px`, height: `${geometry.height}px` }}>
			<KlpRegisteredCommandMenu registry={props.registry} getContext={props.getContext} items={props.items} label={props.label} emptyLabel={props.emptyLabel} onResult={result} onDismiss={escape} autoFocus />
		</div>
	</dialog>;
}
