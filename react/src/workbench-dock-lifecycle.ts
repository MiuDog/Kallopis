import { useLayoutEffect, useRef, useState } from 'react';
import { observeLayout } from './workbench-layout-dom.js';
import { applyKlpDockAction } from './dock-layout-operations.js';
import type { KlpDockLayoutData, KlpDockPanelPolicy } from './dock-layout-state.js';
import type { KlpDockLayoutProps } from './workbench-dock.js';

interface CloseRequest {
	/** callback 身分與 panel ID 決定批准是否仍屬於同一次請求。 */
	callback: () => boolean | Promise<boolean>;
	panelId: string;
}

function placed(layout: KlpDockLayoutData, panelId: string): boolean {
	return [layout.left, layout.right, layout.bottom].some(area => area.groups.some(group => group.panelIds.includes(panelId)));
}

/** 只量測宿主內容軸；transform 不放大布局數值，沒有瀏覽器時保持 SSR 零槽。 */
export function useDockSize(host: React.RefObject<HTMLDivElement | null>): { width: number; height: number } {
	const [size, setSize] = useState({ width: 0, height: 0 });
	useLayoutEffect(() => {
		const element = host.current!;
		return observeLayout(element, () => {
			const css = element.ownerDocument.defaultView!.getComputedStyle(element);
			const rect = element.getBoundingClientRect();
			const dimension = (axis: 'width' | 'height') => {
				const edges = axis === 'width' ? [css.paddingLeft, css.paddingRight, css.borderLeftWidth, css.borderRightWidth] : [css.paddingTop, css.paddingBottom, css.borderTopWidth, css.borderBottomWidth];
				const padding = edges.slice(0, 2).reduce((sum, value) => sum + (Number.parseFloat(value) || 0), 0);
				const border = edges.slice(2).reduce((sum, value) => sum + (Number.parseFloat(value) || 0), 0);
				const specified = css[axis];
				let value = rect[axis] - padding - border;
				if (/^[\d.e+-]+px$/i.test(specified)) value = Number.parseFloat(specified) - (css.boxSizing === 'border-box' ? padding + border : 0);
				else {
					// client 軸不含 transform/border；CSS 未解成 px 時仍使用同一布局座標。
					const client = axis === 'width' ? element.clientWidth : element.clientHeight;
					if (client > 0 || rect[axis] === 0) value = client - padding;
				}
				return Number.isFinite(value) ? Math.max(0, value) : 0;
			};
			const width = dimension('width');
			const height = dimension('height');
			setSize(previous => previous.width === width && previous.height === height ? previous : { width, height });
		});
	}, [host]);
	return size;
}

/** 不保存產品 layout；pending token 僅擁有批准生命週期，永遠從最新 caller 提交。 */
export function useDockClose(props: KlpDockLayoutProps, policies: readonly KlpDockPanelPolicy[]) {
	const latest = useRef({ props, policies });
	const requests = useRef(new Map<string, CloseRequest>());
	const mounted = useRef(false);
	const [, refresh] = useState(0);
	const update = () => { if (mounted.current) refresh(value => value + 1); };
	useLayoutEffect(() => {
		mounted.current = true;
		return () => { mounted.current = false; requests.current.clear(); };
	}, []);
	useLayoutEffect(() => {
		latest.current = { props, policies };
		let changed = false;
		for (const [id, request] of requests.current) {
			if (!placed(props.layout, id) || props.panels.find(panel => panel.id === id)?.onCloseRequested !== request.callback) {
				requests.current.delete(id);
				changed = true;
			}
		}
		if (changed) update();
	});
	function current(request: CloseRequest): boolean {
		const data = latest.current.props;
		return mounted.current && requests.current.get(request.panelId) === request && placed(data.layout, request.panelId) && data.panels.find(panel => panel.id === request.panelId)?.onCloseRequested === request.callback;
	}
	function report(error: unknown, panelId: string): void {
		const callback = latest.current.props.onCloseError;
		if (callback) callback(error, panelId);
		else if (typeof globalThis.reportError === 'function') globalThis.reportError(error);
		else console.error(error);
	}
	function requestClose(panelId: string): void {
		const data = latest.current.props;
		const callback = data.panels.find(panel => panel.id === panelId)?.onCloseRequested;
		if (!callback || !placed(data.layout, panelId) || requests.current.has(panelId)) return;
		const request: CloseRequest = { callback, panelId };
		requests.current.set(panelId, request);
		update();
		void (async () => {
			try {
				const approved = await callback();
				if (!current(request)) return;
				if (typeof approved !== 'boolean') throw new TypeError('Dock close approval must be boolean');
				if (approved) {
					const data = latest.current;
					const result = applyKlpDockAction(data.props.layout, data.policies, { type: 'close', panelId, approved: true });
					if (result.changed) data.props.onLayoutChanged(result.layout);
				}
			}
			catch (error) {
				if (current(request)) report(error, panelId);
			}
			finally {
				if (requests.current.get(panelId) === request) {
					requests.current.delete(panelId);
					update();
				}
			}
		})();
	}
	return { pending: new Set(requests.current.keys()), requestClose };
}
