import { resolveKlpLinearLayout, type KlpLinearItem } from './linear-layout.js';

/** 尺寸值不持有內容或產品狀態。 */
export interface KlpLayoutBounds {
	readonly minimum?: number;
	readonly maximum?: number;
	readonly preferred?: number;
}

export interface LinearSlotSpec {
	/** 顯式與隱式 gutter 使用相同的語意尺寸。 */
	readonly gutter: boolean;
	readonly bounds: KlpLayoutBounds;
	readonly flex: number;
}
export interface LinearOptions {
	readonly axis: 'row' | 'column';
	readonly gap: number;
	readonly alignment: 'start' | 'end';
	readonly sizing: 'fill' | 'content';
}
const sizeEvent = 'klp-layout-measure';

function finite(value: number, field: string): number {
	if (typeof value !== 'number' || !Number.isFinite(value) || value < 0) throw new RangeError(field + ': expected finite nonnegative size');
	return value;
}

/** 在量測或 DOM 寫入前拒絕非法 caller 資料。 */
export function validateLayoutItem(bounds: KlpLayoutBounds, flex: number, spacer = false): void {
	finite(flex, 'flex');
	if (spacer && flex === 0) throw new RangeError('Spacer flex must be positive');
	if (!bounds || typeof bounds !== 'object') throw new TypeError('bounds must be an object');
	const minimum = finite(bounds.minimum ?? 0, 'minimum');
	if (bounds.maximum !== undefined && finite(bounds.maximum, 'maximum') < minimum) throw new RangeError('maximum below minimum');
	if (bounds.preferred !== undefined) finite(bounds.preferred, 'preferred');
}

function px(value: string): number | undefined {
	return /^\d+(?:\.\d+)?px$/.test(value) ? Number.parseFloat(value) : undefined;
}

/** 讀取未經 transform 放大的 CSS 尺寸；無 layout 引擎時保留矩形觀察邊界。 */
function box(element: HTMLElement, content: boolean): { width: number; height: number } {
	const css = element.ownerDocument.defaultView!.getComputedStyle(element);
	const rect = element.getBoundingClientRect();
	const dimension = (axis: 'width' | 'height') => {
		const padding = axis === 'width' ? [css.paddingLeft, css.paddingRight] : [css.paddingTop, css.paddingBottom];
		const borders = axis === 'width' ? [css.borderLeftWidth, css.borderRightWidth] : [css.borderTopWidth, css.borderBottomWidth];
		const pad = padding.reduce((sum, value) => sum + (px(value) ?? 0), 0);
		const border = borders.reduce((sum, value) => sum + (px(value) ?? 0), 0);
		const computed = px(css[axis]);
		let value = computed === undefined ? rect[axis] : computed + (css.boxSizing === 'border-box' ? 0 : pad + border);
		if (content) value -= pad + border;
		return finite(Math.max(0, value), axis);
	};
	return { width: dimension('width'), height: dimension('height') };
}

function set(element: HTMLElement, property: string, value: string): void {
	if (element.style.getPropertyValue(property) !== value) element.style.setProperty(property, value);
}

/** 使用同一份內容量測，不複製或重掛載產品輸入。 */
function natural(slot: HTMLElement, axis: 'row' | 'column', cross: number): { width: number; height: number } {
	const child = slot.firstElementChild as HTMLElement | null;
	const elements = child ? [slot, child] : [slot];
	const saved = elements.map(element => element.style.cssText);
	try {
		for (const element of elements) {
			set(element, 'width', axis === 'row' ? 'max-content' : cross + 'px');
			set(element, 'height', axis === 'column' ? 'max-content' : 'auto');
			set(element, 'min-width', '0px');
			set(element, 'min-height', '0px');
		}
		set(slot, 'position', 'absolute');
		set(slot, 'visibility', 'hidden');
		return box(slot, false);
	} finally {
		elements.forEach((element, index) => { element.style.cssText = saved[index]; });
	}
}

/** 私有通知只向已配置的直接布局內容傳遞尺寸，不冒泡成產品事件。 */
function notify(element: HTMLElement): void {
	const kind = element.getAttribute('data-klp-layout');
	if (kind === 'row' || kind === 'column') element.dispatchEvent(new element.ownerDocument.defaultView!.Event(sizeEvent));
}

export function layoutRoot(host: HTMLElement, gap: number, inset: 'standard' | 'none'): void {
	const extent = box(host, false);
	const css = host.ownerDocument.defaultView!.getComputedStyle(host);
	const width = Math.max(0, extent.width - (px(css.borderLeftWidth) ?? 0) - (px(css.borderRightWidth) ?? 0));
	const height = Math.max(0, extent.height - (px(css.borderTopWidth) ?? 0) - (px(css.borderBottomWidth) ?? 0));
	const horizontal = inset === 'none' ? 0 : Math.min(gap, width / 2);
	const vertical = inset === 'none' ? 0 : Math.min(gap, height / 2);
	set(host, 'padding', vertical + 'px ' + horizontal + 'px');
	const child = host.firstElementChild as HTMLElement | null;
	if (child) notify(child);
}

export function layoutLinear(host: HTMLElement, specs: readonly LinearSlotSpec[], options: LinearOptions): void {
	const slots = Array.from(host.children) as HTMLElement[];
	const measured = box(host, true);
	const cross = options.axis === 'row' ? measured.height : measured.width;
	const items: KlpLinearItem[] = [];
	let gutterCount = 0;
	for (let index = 0; index < specs.length; index++) {
		const spec = specs[index];
		if (spec.gutter) { gutterCount++; continue; }
		let preferred = spec.bounds.preferred;
		if (preferred === undefined) {
			if (options.sizing === 'content' || spec.flex === 0) {
				const size = natural(slots[index], options.axis, cross);
				preferred = options.axis === 'row' ? size.width : size.height;
			} else preferred = spec.bounds.minimum ?? 0;
		}
		items.push({ ...spec.bounds, preferred, flex: options.sizing === 'content' ? 0 : spec.flex });
	}
	let extent = options.axis === 'row' ? measured.width : measured.height;
	if (options.sizing === 'content') {
		extent = finite(items.reduce((sum, item) => sum + Math.max(item.minimum ?? 0, Math.min(item.preferred!, item.maximum ?? Number.POSITIVE_INFINITY)), options.gap * gutterCount), 'natural extent');
		set(host, options.axis === 'row' ? 'width' : 'height', extent + 'px');
	}
	const result = resolveKlpLinearLayout({ extent, gutter: options.gap, gutterCount, items });
	let itemIndex = 0;
	const tracks: string[] = [];
	slots.forEach((slot, index) => {
		const main = specs[index].gutter ? result.gutter : result.extents[itemIndex++];
		set(slot, 'width', (options.axis === 'row' ? main : cross) + 'px');
		set(slot, 'height', (options.axis === 'row' ? cross : main) + 'px');
		tracks.push(main + 'px');
	});
	set(host, options.axis === 'row' ? 'grid-template-columns' : 'grid-template-rows', tracks.join(' '));
	set(host, options.axis === 'row' ? 'grid-template-rows' : 'grid-template-columns', cross + 'px');
	set(host, 'justify-content', options.axis === 'row' ? options.alignment : 'start');
	set(host, 'align-content', options.axis === 'column' ? options.alignment : 'start');
	for (const slot of slots) {
		const child = slot.firstElementChild as HTMLElement | null;
		if (child) notify(child);
	}
}

/** 觀察器只屬於此宿主；卸載及 StrictMode 重掛載完整清理。 */
export function observeLayout(host: HTMLElement, measure: () => void): () => void {
	const win = host.ownerDocument.defaultView!;
	let stopped = false;
	let running = false;
	const update = () => {
		if (stopped || running) return;
		running = true;
		try { measure(); } finally { running = false; }
	};
	const Resize = win.ResizeObserver;
	const resize = Resize ? new Resize(update) : undefined;
	resize?.observe(host);
	for (const slot of Array.from(host.children)) {
		resize?.observe(slot);
		if (slot.firstElementChild) resize?.observe(slot.firstElementChild);
	}
	const mutation = new win.MutationObserver(update);
	mutation.observe(host, { subtree: true, childList: true, characterData: true });
	host.addEventListener(sizeEvent, update);
	host.addEventListener('load', update, true);
	if (!resize) win.addEventListener('resize', update);
	const fonts = host.ownerDocument.fonts;
	fonts?.addEventListener('loadingdone', update);
	update();
	return () => {
		stopped = true;
		resize?.disconnect();
		mutation.disconnect();
		host.removeEventListener(sizeEvent, update);
		host.removeEventListener('load', update, true);
		if (!resize) win.removeEventListener('resize', update);
		fonts?.removeEventListener('loadingdone', update);
	};
}
