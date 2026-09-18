import { createContext, useContext, useMemo, useRef } from 'react'
import type { ReactNode } from 'react'
import { BlockNoteDefaultUI, ComponentsContext, useComponentsContext, useBlockNoteEditor } from '@blocknote/react'
import type { ComponentProps } from '@blocknote/react'

type MenuProps = ComponentProps['Generic']['Menu']
const MenuContext = createContext<{ open: (anchor: DOMRect) => Promise<void>; sub: boolean; anchor: () => DOMRect | null } | null>(null)
const callbacks = new WeakMap<HTMLElement, () => void>()
let menuEpoch = 0
export function invalidateEditorMenus() { menuEpoch += 1 }

// 所有編輯器命令下拉都只傳資料，選單表面沿用 Flutter 宿主 KlpMenu。
async function pick(anchor: DOMRect, items: { title: string; enabled?: boolean; selected?: boolean }[]) {
	return await window.flutter_inappwebview?.callHandler('KallopisMenu', { x: anchor.left, y: anchor.bottom, items })
}

function MenuRoot(props: MenuProps['Root']) {
	const root = useRef<HTMLDivElement>(null)
	const busy = useRef(false)
	const editor = useBlockNoteEditor()
	const parent = useContext(MenuContext)
	const menuAnchor = useRef<DOMRect | null>(null)
	async function open(anchor: DOMRect) {
		if (busy.current || !root.current) return

		busy.current = true
		menuAnchor.current = props.sub ? parent?.anchor() ?? anchor : anchor
		props.onOpenChange?.(true)
		const host = root.current
		const nodes = Array.from(host.querySelectorAll<HTMLElement>('[data-klp-menu-item]')).filter(node => {
			const owner = node.closest('[data-klp-menu-root]')
			const dropdownOwner = node.closest('[data-klp-menu-dropdown]')?.closest('[data-klp-menu-root]')
			return dropdownOwner === host && (owner === host || node.dataset.klpMenuTrigger === 'true')
		})
		const actions = nodes.map(node => callbacks.get(node))
		const document = editor.prosemirrorState.doc
		const epoch = menuEpoch
		try {
			const index = await pick(menuAnchor.current, nodes.map(node => {
				const owner = node.closest('[data-klp-menu-root]')!
				const labels = Array.from(owner.querySelectorAll('[data-klp-menu-label]')).filter(label => label.closest('[data-klp-menu-root]') === owner && !!(label.compareDocumentPosition(node) & Node.DOCUMENT_POSITION_FOLLOWING))
				const group = labels.at(-1)?.textContent?.trim()
				const title = node.textContent?.trim() || node.getAttribute('aria-label') || ''
				return { title: group ? `${group} · ${title}` : title, enabled: !node.hasAttribute('disabled'), selected: node.dataset.checked === 'true' }
			}))
			if (epoch === menuEpoch && typeof index === 'number' && editor.prosemirrorState.doc.eq(document)) await actions[index]?.()
		}
		finally { props.onOpenChange?.(false); busy.current = false }
	}
	return <MenuContext.Provider value={{open, sub: props.sub === true, anchor: () => menuAnchor.current}}><div ref={root} data-klp-menu-root style={{display: 'contents'}}>{props.children}</div></MenuContext.Provider>
}

function MenuTrigger(props: MenuProps['Trigger']) {
	const menu = useContext(MenuContext)!
	return <span data-klp-menu-item={menu.sub ? '' : undefined} data-klp-menu-trigger="true" ref={node => {
		if (node) callbacks.set(node, () => menu.open(node.getBoundingClientRect()))
	}} onClick={event => { event.stopPropagation(); menu.open(event.currentTarget.getBoundingClientRect()) }}>{props.children}</span>
}

function MenuItem(props: MenuProps['Item']) {
	return <button type="button" data-klp-menu-item data-checked={props.checked} ref={node => {
		if (node && props.onClick) callbacks.set(node, props.onClick)
	}}>{props.children}</button>
}

function NativeSelect(props: ComponentProps['Generic']['Toolbar']['Select']) {
	const editor = useBlockNoteEditor()
	const components = useComponentsContext()!
	const Button = components.Generic.Toolbar.Button
	const selected = props.items.find(item => item.isSelected)
	return <Button className={props.className} mainTooltip={selected?.text ?? ''} isDisabled={props.isDisabled} onClick={async event => {
		const items = props.items
		const epoch = menuEpoch
		const document = editor.prosemirrorState.doc
		const index = await pick(event.currentTarget.getBoundingClientRect(), items.map(item => ({title: item.text, enabled: !item.isDisabled, selected: item.isSelected})))
		if (epoch === menuEpoch && editor.prosemirrorState.doc.eq(document) && typeof index === 'number' && !items[index]?.isDisabled) items[index]?.onClick()
	}}>{selected?.icon}{selected?.text}</Button>
}

export function KallopisEditorMenus({children}: {children: ReactNode}) {
	const base = useComponentsContext()!
	const components = useMemo(() => ({
		...base,
		FormattingToolbar: {...base.FormattingToolbar, Select: NativeSelect},
		Generic: {...base.Generic,
			Toolbar: {...base.Generic.Toolbar, Select: NativeSelect},
			Menu: {...base.Generic.Menu, Root: MenuRoot, Trigger: MenuTrigger, Item: MenuItem,
				Dropdown: (props: MenuProps['Dropdown']) => <div hidden data-klp-menu-dropdown>{props.children}</div>,
				Divider: () => null,
				Label: (props: MenuProps['Label']) => <div data-klp-menu-label>{props.children}</div>,
			},
		},
	}), [base])
	return <ComponentsContext.Provider value={components}><BlockNoteDefaultUI slashMenu={false} />{children}</ComponentsContext.Provider>
}
