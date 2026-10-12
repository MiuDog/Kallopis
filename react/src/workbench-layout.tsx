import { Children, Fragment, isValidElement, useImperativeHandle, useLayoutEffect, useRef, type CSSProperties, type HTMLAttributes, type ReactElement, type ReactNode, type Ref } from 'react';
import { useKlp } from './theme.js';
import { layoutLinear, layoutRoot, observeLayout, validateLayoutItem, type KlpLayoutBounds, type LinearSlotSpec } from './workbench-layout-dom.js';

export type { KlpLayoutBounds } from './workbench-layout-dom.js';

export interface KlpLayoutPaneProps extends HTMLAttributes<HTMLDivElement> {
	/** flex 與 bounds 是父 compound 的主軸限制，沒有產品狀態。 */
	flex?: number;
	bounds?: KlpLayoutBounds;
	ref?: Ref<HTMLDivElement>;
}
export interface KlpLayoutLinearProps extends KlpLayoutPaneProps {
	spacing?: 'standard' | 'none';
	alignment?: 'start' | 'end';
	/** fill 需要 enclosing definite CSS 尺寸；content 明確要求自然主軸。 */
	sizing?: 'fill' | 'content';
}
export interface KlpAppLayoutProps extends HTMLAttributes<HTMLDivElement> {
	inset?: 'standard' | 'none';
	ref?: Ref<HTMLDivElement>;
}
export type KlpLayoutDividerProps = Omit<HTMLAttributes<HTMLDivElement>, 'children'> & { ref?: Ref<HTMLDivElement> };
export type KlpLayoutSpacerProps = Omit<KlpLayoutPaneProps, 'children'>;

const emptyBounds: KlpLayoutBounds = Object.freeze({});
const base: CSSProperties = { boxSizing: 'border-box', minWidth: 0, minHeight: 0, overflow: 'hidden', width: '100%', height: '100%' };
const slotStyle: CSSProperties = { boxSizing: 'border-box', minWidth: 0, minHeight: 0, overflow: 'hidden' };

function elements(children: ReactNode): ReactElement<KlpLayoutPaneProps>[] {
	const result: ReactElement<KlpLayoutPaneProps>[] = [];
	Children.toArray(children).forEach(child => {
		if (!isValidElement<KlpLayoutPaneProps>(child)) throw new TypeError('Layout child must be a layout component');
		if (child.type === Fragment) result.push(...elements(child.props.children));
		else result.push(child);
	});
	return result;
}
function allowed(child: ReactElement): boolean {
	return [KlpLayoutRow, KlpLayoutColumn, KlpLayoutPane, KlpLayoutSpacer, KlpLayoutDivider].includes(child.type as typeof KlpLayoutRow);
}
function choice(value: string, choices: readonly string[], field: string): void {
	if (!choices.includes(value)) throw new TypeError(field + ': unsupported value');
}

function Linear({ axis, flex = 1, bounds = emptyBounds, spacing = 'standard', alignment = 'start', sizing = 'fill', children, style, ref, ...props }: KlpLayoutLinearProps & { axis: 'row' | 'column' }) {
	const theme = useKlp();
	const gap = Number(theme.semantic('theme.spacing.space2'));
	validateLayoutItem(bounds, flex);
	choice(spacing, ['standard', 'none'], 'spacing');
	choice(alignment, ['start', 'end'], 'alignment');
	choice(sizing, ['fill', 'content'], 'sizing');
	const nodes = elements(children);
	if (!nodes.length) throw new TypeError('Layout requires at least one child');
	const specs: LinearSlotSpec[] = [];
	const slots: ReactNode[] = [];
	let previousGutter = false;
	nodes.forEach((node, index) => {
		if (!allowed(node)) throw new TypeError('Direct layout child must be Row, Column, Pane, Spacer or Divider');
		const gutter = node.type === KlpLayoutDivider;
		const itemFlex = node.props.flex ?? 1;
		const itemBounds = node.props.bounds ?? emptyBounds;
		if (!gutter) validateLayoutItem(itemBounds, itemFlex, node.type === KlpLayoutSpacer);
		if (spacing === 'standard' && index > 0 && !previousGutter && !gutter) {
			slots.push(<div key={'gap:' + node.key} data-klp-layout-slot="gutter" aria-hidden="true" style={slotStyle} />);
			specs.push({ gutter: true, bounds: emptyBounds, flex: 0 });
		}
		slots.push(<div key={node.key ?? index} data-klp-layout-slot={gutter ? 'gutter' : 'content'} style={slotStyle}>{node}</div>);
		specs.push({ gutter, bounds: itemBounds, flex: itemFlex });
		previousGutter = gutter;
	});
	const host = useRef<HTMLDivElement>(null);
	useImperativeHandle(ref, () => host.current!, []);
	useLayoutEffect(() => observeLayout(host.current!, () => layoutLinear(host.current!, specs, { axis, gap, alignment, sizing })));
	const geometry: CSSProperties = {
		...style,
		...base,
		display: 'grid',
		position: 'relative',
		gap: 0,
		padding: 0,
		gridTemplateColumns: axis === 'row' ? 'repeat(' + slots.length + ', minmax(0, 1fr))' : 'minmax(0, 1fr)',
		gridTemplateRows: axis === 'column' ? 'repeat(' + slots.length + ', minmax(0, 1fr))' : 'minmax(0, 1fr)',
	};
	if (sizing === 'content') geometry[axis === 'row' ? 'width' : 'height'] = 'max-content';
	return <div {...props} ref={host} data-klp-layout={axis} style={geometry}>{slots}</div>;
}

export function KlpLayoutRow(props: KlpLayoutLinearProps) { return <Linear {...props} axis="row" />; }
export function KlpLayoutColumn(props: KlpLayoutLinearProps) { return <Linear {...props} axis="column" />; }

export function KlpLayoutPane({ flex = 1, bounds = emptyBounds, children, style, ...props }: KlpLayoutPaneProps) {
	useKlp();
	validateLayoutItem(bounds, flex);
	return <div {...props} data-klp-layout="pane" style={{ ...style, ...base }}>{children}</div>;
}
export function KlpLayoutSpacer({ flex = 1, bounds = emptyBounds, style, ...props }: KlpLayoutSpacerProps) {
	useKlp();
	validateLayoutItem(bounds, flex, true);
	return <div {...props} data-klp-layout="spacer" style={{ ...style, ...base }} />;
}
export function KlpLayoutDivider({ style, ...props }: KlpLayoutDividerProps) {
	useKlp();
	return <div {...props} data-klp-layout="divider" style={{ ...style, ...base }} />;
}

export function KlpAppLayout({ inset = 'standard', children, style, ref, ...props }: KlpAppLayoutProps) {
	const theme = useKlp();
	const gap = Number(theme.semantic('theme.spacing.space2'));
	choice(inset, ['standard', 'none'], 'inset');
	const nodes = elements(children);
	if (nodes.length !== 1 || ![KlpLayoutRow, KlpLayoutColumn, KlpLayoutPane].includes(nodes[0].type as typeof KlpLayoutRow)) throw new TypeError('App layout requires a single Row, Column or Pane child');
	const host = useRef<HTMLDivElement>(null);
	useImperativeHandle(ref, () => host.current!, []);
	useLayoutEffect(() => observeLayout(host.current!, () => layoutRoot(host.current!, gap, inset)));
	return <div {...props} ref={host} data-klp-layout="root" style={{ ...base, ...style, boxSizing: 'border-box', minWidth: 0, minHeight: 0, overflow: 'hidden', padding: 0 }}>{nodes[0]}</div>;
}
