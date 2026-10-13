import type { KlpTheme } from './theme.js';
import type { KlpDockLayoutProps } from './workbench-dock.js';
import type { KlpDockArea } from './dock-layout-operations.js';
import type { KlpDockGroupData, KlpDockLayoutData } from './dock-layout-state.js';
import { resolveKlpDockGeometry, type KlpDockGeometry, type KlpDockRect } from './dock-geometry.js';
import { resolveKlpLinearLayout } from './linear-layout.js';

export const dockAreas: readonly KlpDockArea[] = ['left', 'right', 'bottom'];
export interface DockGroupView {
	/** area／data 指向 caller 身分；矩形全以 root 座標表示，供 render/hit/resize 共用。 */
	area: KlpDockArea;
	data: KlpDockGroupData;
	outer: KlpDockRect;
	inner: KlpDockRect;
	headerHeight: number;
	clipRadius: number;
	gutterAfter?: KlpDockRect;
}
export interface DockView {
	/** layout 是當前只讀 presentation 投影，geometry／groups 是同一份有限配額。 */
	layout: KlpDockLayoutData;
	geometry: KlpDockGeometry;
	groups: readonly DockGroupView[];
	/** 四個數值讀 scoped semantic；没有第二份品牌預設。 */
	handle: number;
	rail: number;
	stroke: number;
	icon: number;
}
export function dockNumber(theme: KlpTheme, id: string): number {
	const value = Number(theme.semantic(id));
	if (!Number.isFinite(value) || value < 0) throw new TypeError('Dock: invalid semantic ' + id);
	return value;
}
export function dockMinimum(axis: 'horizontal' | 'vertical'): number { return axis === 'vertical' ? 32 : 120; }

/** shallow presentation 保留 caller groups；hover 值只用於這次幾何，不能交給保存。 */
export function resolveDockView(props: KlpDockLayoutProps, size: { width: number; height: number }, theme: KlpTheme, preview: ReadonlySet<KlpDockArea>): DockView {
	const handle = dockNumber(theme, 'theme.geometry.layout.resizeHandleExtent');
	const chrome = dockNumber(theme, 'theme.spacing.chromeTab');
	const margin = dockNumber(theme, 'theme.spacing.dockMargin');
	const stroke = dockNumber(theme, 'theme.shape.stroke');
	const radius = Math.max(0, dockNumber(theme, 'theme.shape.card') - stroke);
	const layout = { ...props.layout };
	for (const area of preview) {
		const constraint = area === 'bottom' ? props.bottomConstraints : props[area + 'Constraints' as 'leftConstraints' | 'rightConstraints'];
		if (constraint) layout[area] = { ...layout[area], isVisible: true, extent: constraint.minExtent };
	}
	const geometry = resolveKlpDockGeometry({
		...size, layout,
		leftConstraints: props.leftConstraints, rightConstraints: props.rightConstraints, bottomConstraints: props.bottomConstraints,
		handleExtent: handle,
		headerExtent: props.contentHeader === undefined || props.contentHeader === null ? undefined : dockNumber(theme, 'theme.spacing.chromeHeader'),
	});
	const groups: DockGroupView[] = [];
	for (const area of dockAreas) {
		const rect = geometry[area] ?? { left: 0, top: 0, width: 0, height: 0 };
		const data = layout[area];
		const vertical = data.axis === 'vertical';
		const minimum = dockMinimum(data.axis);
		const allocation = resolveKlpLinearLayout({
			extent: vertical ? rect.height : rect.width, gutter: handle, gutterCount: Math.max(0, data.groups.length - 1),
			items: data.groups.map((group, index) => ({ minimum, preferred: index === data.groups.length - 1 ? minimum : group.mainAxisExtent, flex: index === data.groups.length - 1 ? 1 : 0 })),
		});
		let offset = 0;
		data.groups.forEach((group, index) => {
			const extent = allocation.extents[index];
			const outer = { left: rect.left + (vertical ? 0 : offset), top: rect.top + (vertical ? offset : 0), width: vertical ? rect.width : extent, height: vertical ? extent : rect.height };
			const x = Math.min(margin, outer.width / 2);
			const y = Math.min(margin, outer.height / 2);
			const inner = { left: outer.left + x, top: outer.top + y, width: Math.max(0, outer.width - x * 2), height: Math.max(0, outer.height - y * 2) };
			const gutterAfter = index === data.groups.length - 1 ? undefined : { left: outer.left + (vertical ? 0 : extent), top: outer.top + (vertical ? extent : 0), width: vertical ? rect.width : allocation.gutter, height: vertical ? allocation.gutter : rect.height };
			groups.push({ area, data: group, outer, inner, headerHeight: Math.min(chrome, inner.height), clipRadius: Math.min(radius, inner.width / 2, inner.height / 2), gutterAfter });
			offset += extent + allocation.gutter;
		});
	}
	return { layout, geometry, groups, handle, rail: dockNumber(theme, 'theme.geometry.layout.railDropTargetExtent'), stroke, icon: dockNumber(theme, 'theme.spacing.iconButton') };
}
