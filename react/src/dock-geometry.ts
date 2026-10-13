import { encodeKlpDockLayout, type KlpDockAreaData, type KlpDockLayoutData } from './dock-layout-state.js';
import { resolveKlpLinearLayout, type KlpLinearItem } from './linear-layout.js';

/** 邏輯限制不擁有品牌預設，正 Infinity 或省略 maximum 表示無邏輯上限。 */
export interface KlpDockAreaConstraints {
	readonly minExtent: number;
	readonly maxExtent?: number;
}
/** 當前宿主與 semantic 尺寸投影，沒有 DOM 或產品內容。 */
export interface KlpDockGeometryArgs {
	readonly width: number;
	readonly height: number;
	readonly layout: KlpDockLayoutData;
	readonly leftConstraints: KlpDockAreaConstraints;
	readonly rightConstraints: KlpDockAreaConstraints;
	readonly bottomConstraints?: KlpDockAreaConstraints;
	readonly handleExtent: number;
	/** 省略沒有 header；0 保留零高 header 槽。 */
	readonly headerExtent?: number;
}
/** 同一座標供呈現、指標命中及 resize 使用。 */
export interface KlpDockRect {
	readonly left: number;
	readonly top: number;
	readonly width: number;
	readonly height: number;
}
export interface KlpDockGeometry {
	readonly stage: KlpDockRect;
	readonly left: KlpDockRect | null;
	readonly right: KlpDockRect | null;
	readonly bottom: KlpDockRect | null;
	readonly header: KlpDockRect | null;
	/** 隱藏區仍保留有限邊緣 reopen handle，不保留正文配額。 */
	readonly leftHandle: KlpDockRect;
	readonly rightHandle: KlpDockRect;
	readonly bottomHandle: KlpDockRect;
	/** 實際 viewport 預算；UI 提交仍須與邏輯 min/max 求交集。 */
	readonly maximumLeft: number;
	readonly maximumRight: number;
	readonly maximumBottom: number;
}

function invalid(field: string): never {
	throw new TypeError('Dock geometry: invalid ' + field);
}
function finite(value: unknown, field: string): number {
	if (typeof value !== 'number' || !Number.isFinite(value) || value < 0) invalid(field);
	return value;
}
function limits(value: KlpDockAreaConstraints, field: string): KlpDockAreaConstraints {
	if (!value || typeof value !== 'object' || Array.isArray(value)) invalid(field);
	const minExtent = finite(value.minExtent, field + '.minExtent');
	const maxExtent = value.maxExtent;
	if (maxExtent !== undefined && maxExtent !== Infinity) {
		if (finite(maxExtent, field + '.maxExtent') < minExtent) invalid(field + '.maxExtent');
	}
	return { minExtent, maxExtent };
}
function item(area: KlpDockAreaData, constraint: KlpDockAreaConstraints): KlpLinearItem {
	return {
		minimum: constraint.minExtent,
		maximum: constraint.maxExtent === Infinity ? undefined : constraint.maxExtent,
		preferred: area.extent,
		flex: 0,
	};
}
function visible(area: KlpDockAreaData): boolean {
	return area.isVisible && area.groups.length > 0;
}
function rect(left: number, top: number, width: number, height: number): KlpDockRect {
	return Object.freeze({ left, top, width, height });
}

/** 保存偏好只讀；root 與把手依同一 linear 配額，合法 style 不回寫布局。 */
export function resolveKlpDockGeometry(args: KlpDockGeometryArgs): KlpDockGeometry {
	if (!args || typeof args !== 'object' || Array.isArray(args)) invalid('args');
	const width = finite(args.width, 'width');
	const height = finite(args.height, 'height');
	const handle = finite(args.handleExtent, 'handleExtent');
	const headerHeight = args.headerExtent === undefined ? 0 : Math.min(height, finite(args.headerExtent, 'headerExtent'));
	// 全部 layout 驗證交給既有 codec，不複製保存 parser。
	encodeKlpDockLayout(args.layout);
	const layout = args.layout;
	const leftLimits = limits(args.leftConstraints, 'leftConstraints');
	const rightLimits = limits(args.rightConstraints, 'rightConstraints');
	const bottomLimits = args.bottomConstraints === undefined ? undefined : limits(args.bottomConstraints, 'bottomConstraints');
	if (!bottomLimits && (layout.bottom.isVisible || layout.bottom.groups.length > 0)) invalid('bottomConstraints');
	const showLeft = visible(layout.left);
	const showRight = visible(layout.right);
	const showBottom = visible(layout.bottom);
	const center: KlpLinearItem = { minimum: 0, preferred: 0, flex: 1 };
	const horizontal = resolveKlpLinearLayout({
		extent: width,
		gutter: handle,
		gutterCount: Number(showLeft) + Number(showRight),
		items: [...(showLeft ? [item(layout.left, leftLimits)] : []), center, ...(showRight ? [item(layout.right, rightLimits)] : [])],
	});
	const leftWidth = showLeft ? horizontal.extents[0] : 0;
	const rightWidth = showRight ? horizontal.extents[horizontal.extents.length - 1] : 0;
	const centerWidth = horizontal.extents[Number(showLeft)];
	const leftGutter = showLeft ? horizontal.gutter : 0;
	const rightGutter = showRight ? horizontal.gutter : 0;
	const centerLeft = leftWidth + leftGutter;
	const rightLeft = width - rightWidth;
	const bodyHeight = height - headerHeight;
	const vertical = resolveKlpLinearLayout({
		extent: bodyHeight,
		gutter: handle,
		gutterCount: Number(showBottom),
		items: [center, ...(showBottom ? [item(layout.bottom, bottomLimits!)] : [])],
	});
	const stageHeight = vertical.extents[0];
	const bottomHeight = showBottom ? vertical.extents[1] : 0;
	const bottomGutter = showBottom ? vertical.gutter : 0;
	const leftHandleWidth = showLeft ? leftGutter : Math.min(handle, width);
	const rightHandleWidth = showRight ? rightGutter : Math.min(handle, width);
	let bottomHandleHeight = 0;
	if (bottomLimits) bottomHandleHeight = showBottom ? bottomGutter : Math.min(handle, bodyHeight);
	return Object.freeze({
		stage: rect(centerLeft, headerHeight, centerWidth, stageHeight),
		left: showLeft ? rect(0, 0, leftWidth, height) : null,
		right: showRight ? rect(rightLeft, headerHeight, rightWidth, bodyHeight) : null,
		bottom: showBottom ? rect(centerLeft, height - bottomHeight, centerWidth, bottomHeight) : null,
		header: args.headerExtent === undefined ? null : rect(centerLeft, 0, width - centerLeft, headerHeight),
		leftHandle: rect(showLeft ? leftWidth : 0, 0, leftHandleWidth, height),
		rightHandle: rect(showRight ? rightLeft - rightGutter : width - rightHandleWidth, headerHeight, rightHandleWidth, bodyHeight),
		bottomHandle: rect(centerLeft, showBottom ? headerHeight + stageHeight : height - bottomHandleHeight, centerWidth, bottomHandleHeight),
		maximumLeft: Math.max(0, width - rightWidth - leftHandleWidth - rightGutter),
		maximumRight: Math.max(0, width - leftWidth - rightHandleWidth - leftGutter),
		maximumBottom: Math.max(0, bodyHeight - bottomHandleHeight),
	});
}
