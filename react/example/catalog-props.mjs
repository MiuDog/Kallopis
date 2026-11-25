// 由 react/scripts/generate-catalog-props.mjs 自動產生，禁止手改。
export const catalogProps = Object.freeze({
	"KlpAccordion": {
		"name": "KlpAccordion",
		"id": "@kallopis/react#KlpAccordion",
		"source": "react/src/desktop/views.tsx",
		"signature": "export function KlpAccordion({ title, children, defaultOpen }: KlpAccordionProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "title",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "children",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "defaultOpen",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpAlert": {
		"name": "KlpAlert",
		"id": "@kallopis/react#KlpAlert",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpAlert({ title, children, tone = 'info' }: KlpAlertProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "title",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "children",
				"type": "ReactNode",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "tone",
				"type": "\"danger\" | \"info\" | \"success\" | \"warning\" | undefined",
				"required": false,
				"defaultValue": "'info'",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpAppLayout": {
		"name": "KlpAppLayout",
		"id": "@kallopis/react#KlpAppLayout",
		"source": "react/src/workbench-layout.tsx",
		"signature": "export function KlpAppLayout({ inset = 'standard', children, style, ref, ...props }: KlpAppLayoutProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "inset",
				"type": "\"none\" | \"standard\" | undefined",
				"required": false,
				"defaultValue": "'standard'",
				"documentation": ""
			},
			{
				"name": "ref",
				"type": "Ref<HTMLDivElement> | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.space2",
				"css": "--klp-spacing-space2",
				"flutter": "spacing.space2"
			}
		]
	},
	"KlpAvatar": {
		"name": "KlpAvatar",
		"id": "@kallopis/react#KlpAvatar",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpAvatar({ label, src, fallback }: KlpAvatarProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "src",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "fallback",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpBadge": {
		"name": "KlpBadge",
		"id": "@kallopis/react#KlpBadge",
		"source": "react/src/components.tsx",
		"signature": "export function KlpBadge({ tone = 'neutral', className = '', ...props }: KlpBadgeProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "tone",
				"type": "\"danger\" | \"info\" | \"neutral\" | \"success\" | \"warning\" | undefined",
				"required": false,
				"defaultValue": "'neutral'",
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	},
	"KlpBreadcrumb": {
		"name": "KlpBreadcrumb",
		"id": "@kallopis/react#KlpBreadcrumb",
		"source": "react/src/desktop/views.tsx",
		"signature": "export function KlpBreadcrumb({ label, items }: KlpBreadcrumbProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "items",
				"type": "readonly { label: string; href: string; }[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpButton": {
		"name": "KlpButton",
		"id": "@kallopis/react#KlpButton",
		"source": "react/src/components.tsx",
		"signature": "export function KlpButton({ tone = 'secondary', size = 'md', selected, type = 'button', className = '', ...props }: KlpButtonProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "tone",
				"type": "\"ghost\" | \"primary\" | \"secondary\" | undefined",
				"required": false,
				"defaultValue": "'secondary'",
				"documentation": ""
			},
			{
				"name": "size",
				"type": "\"lg\" | \"md\" | \"sm\" | \"xl\" | \"xs\" | undefined",
				"required": false,
				"defaultValue": "'md'",
				"documentation": ""
			},
			{
				"name": "selected",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			},
			{
				"name": "type",
				"type": "\"button\" | \"reset\" | \"submit\" | undefined",
				"required": false,
				"defaultValue": "'button'",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	},
	"KlpCard": {
		"name": "KlpCard",
		"id": "@kallopis/react#KlpCard",
		"source": "react/src/components.tsx",
		"signature": "export function KlpCard({ header, footer, children, tone = 'component', className = '', ...props }: KlpCardProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "header",
				"type": "ReactNode",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "footer",
				"type": "ReactNode",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			},
			{
				"name": "tone",
				"type": "\"base\" | \"component\" | \"inset\" | \"muted\" | \"raised\" | \"stage\" | undefined",
				"required": false,
				"defaultValue": "'component'",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	},
	"KlpCheckbox": {
		"name": "KlpCheckbox",
		"id": "@kallopis/react#KlpCheckbox",
		"source": "react/src/desktop/controls.tsx",
		"signature": "export function KlpCheckbox({ label, className = '', ...props }: KlpCheckboxProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpComboBox": {
		"name": "KlpComboBox",
		"id": "@kallopis/react#KlpComboBox",
		"source": "react/src/desktop/controls.tsx",
		"signature": "export function KlpComboBox({ label, options, id, className = '', ...props }: KlpComboBoxProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "options",
				"type": "readonly string[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpCommandShortcutHost": {
		"name": "KlpCommandShortcutHost",
		"id": "@kallopis/react#KlpCommandShortcutHost",
		"source": "react/src/command-shortcut-host.tsx",
		"signature": "export function KlpCommandShortcutHost<C>(props: KlpCommandShortcutHostProps<C>): ReactNode",
		"documentation": "",
		"props": [
			{
				"name": "keymap",
				"type": "KlpCommandKeymap<C>",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "getContext",
				"type": "() => C",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "getFocus",
				"type": "(target: EventTarget | null) => KlpShortcutFocus",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onHandling",
				"type": "(handling: KlpShortcutHandling) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onResult",
				"type": "(result: KlpCommandExecutionResult) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "children",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpContentHost": {
		"name": "KlpContentHost",
		"id": "@kallopis/react#KlpContentHost",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpContentHost({ label, children, loading, error }: KlpContentHostProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "children",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "loading",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "error",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpDataGrid": {
		"name": "KlpDataGrid",
		"id": "@kallopis/react#KlpDataGrid",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpDataGrid({ label, columns, rows, onCellChange, sort, onSort }: KlpDataGridProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "columns",
				"type": "readonly { key: string; label: string; editable?: boolean; }[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "rows",
				"type": "readonly { id: string; values: Readonly<Record<string, string>>; disabled?: boolean; }[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onCellChange",
				"type": "(rowId: string, key: string, value: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "sort",
				"type": "{ key: string; direction: 'ascending' | 'descending'; } | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onSort",
				"type": "((key: string) => void) | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpDialog": {
		"name": "KlpDialog",
		"id": "@kallopis/react#KlpDialog",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpDialog({ open, title, onClose, children, actions, placement = 'center' }: KlpDialogProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "placement",
				"type": "\"center\" | \"end\" | undefined",
				"required": false,
				"defaultValue": "'center'",
				"documentation": ""
			},
			{
				"name": "open",
				"type": "boolean",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "title",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onClose",
				"type": "() => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "children",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "actions",
				"type": "ReactNode",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpDockLayout": {
		"name": "KlpDockLayout",
		"id": "@kallopis/react#KlpDockLayout",
		"source": "react/src/workbench-dock.tsx",
		"signature": "export function KlpDockLayout(props: KlpDockLayoutProps): import(\"react\").JSX.Element",
		"documentation": "受控 native DOM；沒有保存鏡像，所有事件都交既有 pure action。",
		"props": [
			{
				"name": "layout",
				"type": "KlpDockLayoutData",
				"required": true,
				"defaultValue": null,
				"documentation": "layout 是唯一保存權威；panels 提供當前清冊；stage／contentHeader 是產品內容槽。"
			},
			{
				"name": "panels",
				"type": "readonly KlpDockPanel[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "stage",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "contentHeader",
				"type": "ReactNode",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "leftConstraints",
				"type": "KlpDockAreaConstraints",
				"required": true,
				"defaultValue": null,
				"documentation": "三區限制屬於產品邏輯；缺省 Bottom 僅允許隱藏且空，實際配額另由有限宿主解算。"
			},
			{
				"name": "rightConstraints",
				"type": "KlpDockAreaConstraints",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "bottomConstraints",
				"type": "KlpDockAreaConstraints | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "collapseThresholds",
				"type": "Partial<Record<KlpDockArea, number>> | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": "collapseThresholds 是產品拖移收合門檻，缺省0；不回寫低於門檻的小尺寸。"
			},
			{
				"name": "onLayoutChanged",
				"type": "(layout: KlpDockLayoutData) => void",
				"required": true,
				"defaultValue": null,
				"documentation": "changed 才通知一次；onCloseError 讓產品呈現批准錯誤，未提供則交宿主。"
			},
			{
				"name": "onCloseError",
				"type": "((error: unknown, panelId: string) => void) | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "label",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": "label／areaLabels 是可及與本地化名称；ref 指向有限布局宿主。"
			},
			{
				"name": "areaLabels",
				"type": "Partial<Record<KlpDockArea, string>> | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "ref",
				"type": "Ref<HTMLDivElement> | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpDrawer": {
		"name": "KlpDrawer",
		"id": "@kallopis/react#KlpDrawer",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpDrawer(props: KlpDrawerProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "open",
				"type": "boolean",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "title",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onClose",
				"type": "() => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "children",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpEmptyState": {
		"name": "KlpEmptyState",
		"id": "@kallopis/react#KlpEmptyState",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpEmptyState({ title, description, action }: KlpEmptyStateProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "title",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "description",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "action",
				"type": "ReactNode",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpFileExplorer": {
		"name": "KlpFileExplorer",
		"id": "@kallopis/react#KlpFileExplorer",
		"source": "react/src/components.tsx",
		"signature": "export function KlpFileExplorer({ sections, expandedIds, selectedId, onToggle, onSelect, label = 'Explorer', className = '', ...props }: KlpFileExplorerProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "sections",
				"type": "readonly KlpExplorerSection[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "expandedIds",
				"type": "readonly string[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "selectedId",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onToggle",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onSelect",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "label",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "'Explorer'",
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	},
	"KlpFrame": {
		"name": "KlpFrame",
		"id": "@kallopis/react#KlpFrame",
		"source": "react/src/components.tsx",
		"signature": "export function KlpFrame({ role = 'content', surface = 'flat', header, footer, children, className = '', ...props }: KlpFrameProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "surface",
				"type": "\"flat\" | \"raised\" | undefined",
				"required": false,
				"defaultValue": "'flat'",
				"documentation": "surface：明確選用正式微立體配方，既有 caller 預設維持平面。"
			},
			{
				"name": "role",
				"type": "\"auxiliary\" | \"content\" | \"sidebar\" | undefined",
				"required": false,
				"defaultValue": "'content'",
				"documentation": ""
			},
			{
				"name": "header",
				"type": "ReactNode",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "footer",
				"type": "ReactNode",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	},
	"KlpIconButton": {
		"name": "KlpIconButton",
		"id": "@kallopis/react#KlpIconButton",
		"source": "react/src/components.tsx",
		"signature": "export function KlpIconButton({ label, tone = 'standalone', className = '', ...props }: KlpIconButtonProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "tone",
				"type": "\"inline\" | \"standalone\" | \"window\" | undefined",
				"required": false,
				"defaultValue": "'standalone'",
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			},
			{
				"name": "size",
				"type": "\"lg\" | \"md\" | \"sm\" | \"xl\" | \"xs\" | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "selected",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	},
	"KlpLayoutColumn": {
		"name": "KlpLayoutColumn",
		"id": "@kallopis/react#KlpLayoutColumn",
		"source": "react/src/workbench-layout.tsx",
		"signature": "export function KlpLayoutColumn(props: KlpLayoutLinearProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "spacing",
				"type": "\"none\" | \"standard\" | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "alignment",
				"type": "\"end\" | \"start\" | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "sizing",
				"type": "\"content\" | \"fill\" | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": "fill 需要 enclosing definite CSS 尺寸；content 明確要求自然主軸。"
			},
			{
				"name": "flex",
				"type": "number | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": "flex 與 bounds 是父 compound 的主軸限制，沒有產品狀態。"
			},
			{
				"name": "bounds",
				"type": "KlpLayoutBounds | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "ref",
				"type": "Ref<HTMLDivElement> | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.space2",
				"css": "--klp-spacing-space2",
				"flutter": "spacing.space2"
			}
		]
	},
	"KlpLayoutDivider": {
		"name": "KlpLayoutDivider",
		"id": "@kallopis/react#KlpLayoutDivider",
		"source": "react/src/workbench-layout.tsx",
		"signature": "export function KlpLayoutDivider({ style, ...props }: KlpLayoutDividerProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "ref",
				"type": "Ref<HTMLDivElement> | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.space2",
				"css": "--klp-spacing-space2",
				"flutter": "spacing.space2"
			}
		]
	},
	"KlpLayoutPane": {
		"name": "KlpLayoutPane",
		"id": "@kallopis/react#KlpLayoutPane",
		"source": "react/src/workbench-layout.tsx",
		"signature": "export function KlpLayoutPane({ flex = 1, bounds = emptyBounds, children, style, ...props }: KlpLayoutPaneProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "flex",
				"type": "number | undefined",
				"required": false,
				"defaultValue": "1",
				"documentation": "flex 與 bounds 是父 compound 的主軸限制，沒有產品狀態。"
			},
			{
				"name": "bounds",
				"type": "KlpLayoutBounds | undefined",
				"required": false,
				"defaultValue": "emptyBounds",
				"documentation": ""
			},
			{
				"name": "ref",
				"type": "Ref<HTMLDivElement> | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.space2",
				"css": "--klp-spacing-space2",
				"flutter": "spacing.space2"
			}
		]
	},
	"KlpLayoutRow": {
		"name": "KlpLayoutRow",
		"id": "@kallopis/react#KlpLayoutRow",
		"source": "react/src/workbench-layout.tsx",
		"signature": "export function KlpLayoutRow(props: KlpLayoutLinearProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "spacing",
				"type": "\"none\" | \"standard\" | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "alignment",
				"type": "\"end\" | \"start\" | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "sizing",
				"type": "\"content\" | \"fill\" | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": "fill 需要 enclosing definite CSS 尺寸；content 明確要求自然主軸。"
			},
			{
				"name": "flex",
				"type": "number | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": "flex 與 bounds 是父 compound 的主軸限制，沒有產品狀態。"
			},
			{
				"name": "bounds",
				"type": "KlpLayoutBounds | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "ref",
				"type": "Ref<HTMLDivElement> | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.space2",
				"css": "--klp-spacing-space2",
				"flutter": "spacing.space2"
			}
		]
	},
	"KlpLayoutSpacer": {
		"name": "KlpLayoutSpacer",
		"id": "@kallopis/react#KlpLayoutSpacer",
		"source": "react/src/workbench-layout.tsx",
		"signature": "export function KlpLayoutSpacer({ flex = 1, bounds = emptyBounds, style, ...props }: KlpLayoutSpacerProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "flex",
				"type": "number | undefined",
				"required": false,
				"defaultValue": "1",
				"documentation": "flex 與 bounds 是父 compound 的主軸限制，沒有產品狀態。"
			},
			{
				"name": "bounds",
				"type": "KlpLayoutBounds | undefined",
				"required": false,
				"defaultValue": "emptyBounds",
				"documentation": ""
			},
			{
				"name": "ref",
				"type": "Ref<HTMLDivElement> | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.space2",
				"css": "--klp-spacing-space2",
				"flutter": "spacing.space2"
			}
		]
	},
	"KlpLink": {
		"name": "KlpLink",
		"id": "@kallopis/react#KlpLink",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpLink({ className = '', ...props }: AnchorHTMLAttributes<HTMLAnchorElement>): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpList": {
		"name": "KlpList",
		"id": "@kallopis/react#KlpList",
		"source": "react/src/desktop/views.tsx",
		"signature": "export function KlpList({ label, items, selectedId, onSelect, empty = '沒有資料' }: KlpListProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "items",
				"type": "readonly KlpListItem[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "selectedId",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onSelect",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "empty",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "'沒有資料'",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpModernProductivityLayout": {
		"name": "KlpModernProductivityLayout",
		"id": "@kallopis/react#KlpModernProductivityLayout",
		"source": "react/src/modern-productivity-layout.tsx",
		"signature": "export function KlpModernProductivityLayout(props: KlpModernProductivityLayoutProps): import(\"react\").JSX.Element",
		"documentation": "全高左側欄與右區 Header／Stage；切換時保留各面板身分。",
		"props": [
			{
				"name": "panels",
				"type": "readonly KlpModernProductivityPanel[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "selectedId",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onSelected",
				"type": "((id: string) => void) | null | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "header",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "stage",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "sidebarWidth",
				"type": "number | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.actionGap",
				"css": "--klp-spacing-actionGap",
				"flutter": "spacing.actionGap"
			},
			{
				"id": "theme.spacing.chromePanelInset",
				"css": "--klp-spacing-chromePanelInset",
				"flutter": "spacing.chromePanelInset"
			},
			{
				"id": "theme.spacing.chromeHeader",
				"css": "--klp-spacing-chromeHeader",
				"flutter": "spacing.chromeHeader"
			},
			{
				"id": "theme.shape.panel",
				"css": "--klp-shape-panel",
				"flutter": "shape.panel"
			},
			{
				"id": "theme.geometry.control.buttonHeight",
				"css": "--klp-geometry-control-buttonHeight",
				"flutter": "geometry.control.buttonHeight"
			},
			{
				"id": "theme.geometry.layout.primaryPaneWidth",
				"css": "--klp-geometry-layout-primaryPaneWidth",
				"flutter": "geometry.layout.primaryPaneWidth"
			}
		]
	},
	"KlpMultiSelect": {
		"name": "KlpMultiSelect",
		"id": "@kallopis/react#KlpMultiSelect",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpMultiSelect({ label, options, value, onValueChange, disabled }: KlpMultiSelectProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "options",
				"type": "readonly { value: string; label: string; disabled?: boolean; }[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "value",
				"type": "readonly string[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onValueChange",
				"type": "(values: string[]) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "disabled",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpPagination": {
		"name": "KlpPagination",
		"id": "@kallopis/react#KlpPagination",
		"source": "react/src/desktop/views.tsx",
		"signature": "export function KlpPagination({ page, pageCount, onPageChange, label = '分頁' }: KlpPaginationProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "page",
				"type": "number",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "pageCount",
				"type": "number",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onPageChange",
				"type": "(page: number) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "label",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "'分頁'",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpPopover": {
		"name": "KlpPopover",
		"id": "@kallopis/react#KlpPopover",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpPopover({ label, open, onOpenChange, children, disabled }: KlpPopoverProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "open",
				"type": "boolean",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onOpenChange",
				"type": "(open: boolean) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "children",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "disabled",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpProgress": {
		"name": "KlpProgress",
		"id": "@kallopis/react#KlpProgress",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpProgress({ label, value, max = 100 }: KlpProgressProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "value",
				"type": "number | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "max",
				"type": "number | undefined",
				"required": false,
				"defaultValue": "100",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpRadioGroup": {
		"name": "KlpRadioGroup",
		"id": "@kallopis/react#KlpRadioGroup",
		"source": "react/src/desktop/controls.tsx",
		"signature": "export function KlpRadioGroup({ label, options, value, onValueChange, disabled }: KlpRadioGroupProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "options",
				"type": "readonly KlpOption[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "value",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onValueChange",
				"type": "(value: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "disabled",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpRegisteredCommandMenu": {
		"name": "KlpRegisteredCommandMenu",
		"id": "@kallopis/react#KlpRegisteredCommandMenu",
		"source": "react/src/command-entries.tsx",
		"signature": "export function KlpRegisteredCommandMenu<C = unknown>(props: KlpRegisteredCommandMenuProps<C>): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "emptyLabel",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "autoFocus",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onDismiss",
				"type": "(() => void) | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "registry",
				"type": "KlpCommandRegistry<C>",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "getContext",
				"type": "() => C",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "items",
				"type": "readonly KlpCommandReference[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onResult",
				"type": "(result: KlpCommandExecutionResult) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "id",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "style",
				"type": "CSSProperties | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.tight",
				"css": "--klp-spacing-tight",
				"flutter": "spacing.tight"
			},
			{
				"id": "theme.spacing.controlContentGap",
				"css": "--klp-spacing-controlContentGap",
				"flutter": "spacing.controlContentGap"
			},
			{
				"id": "theme.spacing.overlayItemGap",
				"css": "--klp-spacing-overlayItemGap",
				"flutter": "spacing.overlayItemGap"
			},
			{
				"id": "theme.spacing.iconSmall",
				"css": "--klp-spacing-iconSmall",
				"flutter": "spacing.iconSmall"
			},
			{
				"id": "theme.spacing.icon",
				"css": "--klp-spacing-icon",
				"flutter": "spacing.icon"
			},
			{
				"id": "theme.surface.separation",
				"css": "--klp-surface-separation",
				"flutter": "surface.separation"
			},
			{
				"id": "theme.components.buttonPaddingX",
				"css": "--klp-components-buttonPaddingX",
				"flutter": "components.buttonPaddingX"
			},
			{
				"id": "theme.components.buttonBorderWidth",
				"css": "--klp-components-buttonBorderWidth",
				"flutter": "components.buttonBorderWidth"
			},
			{
				"id": "theme.components.menuPadding",
				"css": "--klp-components-menuPadding",
				"flutter": "components.menuPadding"
			},
			{
				"id": "theme.geometry.layout.commandMenuWidth",
				"css": "--klp-geometry-layout-commandMenuWidth",
				"flutter": "geometry.layout.commandMenuWidth"
			}
		]
	},
	"KlpRegisteredCommandPalette": {
		"name": "KlpRegisteredCommandPalette",
		"id": "@kallopis/react#KlpRegisteredCommandPalette",
		"source": "react/src/command-palette.tsx",
		"signature": "export function KlpRegisteredCommandPalette<C = unknown>(props: KlpRegisteredCommandPaletteProps<C>): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "registry",
				"type": "KlpCommandRegistry<C>",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "getContext",
				"type": "() => C",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "open",
				"type": "boolean",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "searchLabel",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "emptyLabel",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onResult",
				"type": "(result: KlpCommandExecutionResult) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onDismiss",
				"type": "(reason: KlpCommandDismissReason) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "id",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.tight",
				"css": "--klp-spacing-tight",
				"flutter": "spacing.tight"
			},
			{
				"id": "theme.spacing.overlayItemGap",
				"css": "--klp-spacing-overlayItemGap",
				"flutter": "spacing.overlayItemGap"
			},
			{
				"id": "theme.spacing.iconSmall",
				"css": "--klp-spacing-iconSmall",
				"flutter": "spacing.iconSmall"
			},
			{
				"id": "theme.spacing.icon",
				"css": "--klp-spacing-icon",
				"flutter": "spacing.icon"
			},
			{
				"id": "theme.surface.separation",
				"css": "--klp-surface-separation",
				"flutter": "surface.separation"
			},
			{
				"id": "theme.components.menuPadding",
				"css": "--klp-components-menuPadding",
				"flutter": "components.menuPadding"
			},
			{
				"id": "theme.geometry.layout.overlayViewportInset",
				"css": "--klp-geometry-layout-overlayViewportInset",
				"flutter": "geometry.layout.overlayViewportInset"
			},
			{
				"id": "theme.geometry.layout.dialogMaximumWidth",
				"css": "--klp-geometry-layout-dialogMaximumWidth",
				"flutter": "geometry.layout.dialogMaximumWidth"
			}
		]
	},
	"KlpRegisteredCommandPopup": {
		"name": "KlpRegisteredCommandPopup",
		"id": "@kallopis/react#KlpRegisteredCommandPopup",
		"source": "react/src/command-popup.tsx",
		"signature": "export function KlpRegisteredCommandPopup<C = unknown>(props: KlpRegisteredCommandPopupProps<C>): import(\"react\").JSX.Element | null",
		"documentation": "",
		"props": [
			{
				"name": "open",
				"type": "boolean",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "anchor",
				"type": "KlpCommandPopupAnchor",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onDismiss",
				"type": "(reason: KlpCommandPopupDismissReason) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "registry",
				"type": "KlpCommandRegistry<C>",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "getContext",
				"type": "() => C",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "items",
				"type": "readonly KlpCommandReference[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onResult",
				"type": "(result: KlpCommandExecutionResult) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "id",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "emptyLabel",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.geometry.layout.overlayViewportInset",
				"css": "--klp-geometry-layout-overlayViewportInset",
				"flutter": "geometry.layout.overlayViewportInset"
			},
			{
				"id": "theme.geometry.layout.commandMenuWidth",
				"css": "--klp-geometry-layout-commandMenuWidth",
				"flutter": "geometry.layout.commandMenuWidth"
			}
		]
	},
	"KlpRegisteredCommandToolbar": {
		"name": "KlpRegisteredCommandToolbar",
		"id": "@kallopis/react#KlpRegisteredCommandToolbar",
		"source": "react/src/command-entries.tsx",
		"signature": "export function KlpRegisteredCommandToolbar<C = unknown>(props: KlpRegisteredCommandToolbarProps<C>): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "registry",
				"type": "KlpCommandRegistry<C>",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "getContext",
				"type": "() => C",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "items",
				"type": "readonly KlpCommandReference[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onResult",
				"type": "(result: KlpCommandExecutionResult) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "id",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "style",
				"type": "CSSProperties | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.tight",
				"css": "--klp-spacing-tight",
				"flutter": "spacing.tight"
			},
			{
				"id": "theme.spacing.controlContentGap",
				"css": "--klp-spacing-controlContentGap",
				"flutter": "spacing.controlContentGap"
			},
			{
				"id": "theme.spacing.overlayItemGap",
				"css": "--klp-spacing-overlayItemGap",
				"flutter": "spacing.overlayItemGap"
			},
			{
				"id": "theme.spacing.iconSmall",
				"css": "--klp-spacing-iconSmall",
				"flutter": "spacing.iconSmall"
			},
			{
				"id": "theme.spacing.icon",
				"css": "--klp-spacing-icon",
				"flutter": "spacing.icon"
			},
			{
				"id": "theme.surface.separation",
				"css": "--klp-surface-separation",
				"flutter": "surface.separation"
			},
			{
				"id": "theme.components.buttonPaddingX",
				"css": "--klp-components-buttonPaddingX",
				"flutter": "components.buttonPaddingX"
			},
			{
				"id": "theme.components.buttonBorderWidth",
				"css": "--klp-components-buttonBorderWidth",
				"flutter": "components.buttonBorderWidth"
			},
			{
				"id": "theme.components.menuPadding",
				"css": "--klp-components-menuPadding",
				"flutter": "components.menuPadding"
			},
			{
				"id": "theme.geometry.layout.commandMenuWidth",
				"css": "--klp-geometry-layout-commandMenuWidth",
				"flutter": "geometry.layout.commandMenuWidth"
			}
		]
	},
	"KlpRibbon": {
		"name": "KlpRibbon",
		"id": "@kallopis/react#KlpRibbon",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpRibbon(props: KlpRibbonProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "tabs",
				"type": "readonly KlpTab[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "value",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onValueChange",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpSelect": {
		"name": "KlpSelect",
		"id": "@kallopis/react#KlpSelect",
		"source": "react/src/desktop/controls.tsx",
		"signature": "export function KlpSelect({ label, options, hint, error, id, className = '', ...props }: KlpSelectProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "options",
				"type": "readonly KlpOption[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "hint",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "error",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpSeparator": {
		"name": "KlpSeparator",
		"id": "@kallopis/react#KlpSeparator",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpSeparator(): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpSkeleton": {
		"name": "KlpSkeleton",
		"id": "@kallopis/react#KlpSkeleton",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpSkeleton({ label = '載入中' }: { label?: string }): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "'載入中'",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpSlider": {
		"name": "KlpSlider",
		"id": "@kallopis/react#KlpSlider",
		"source": "react/src/desktop/controls.tsx",
		"signature": "export function KlpSlider({ label, id, className = '', ...props }: KlpSliderProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpSpinner": {
		"name": "KlpSpinner",
		"id": "@kallopis/react#KlpSpinner",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpSpinner({ label = '處理中' }: { label?: string }): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "'處理中'",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpSplitButton": {
		"name": "KlpSplitButton",
		"id": "@kallopis/react#KlpSplitButton",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpSplitButton({ label, onAction, options, disabled }: KlpSplitButtonProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onAction",
				"type": "() => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "options",
				"type": "readonly { id: string; label: string; onAction: () => void; disabled?: boolean; }[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "disabled",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpStatusBar": {
		"name": "KlpStatusBar",
		"id": "@kallopis/react#KlpStatusBar",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpStatusBar({ children, className = '', ...props }: HTMLAttributes<HTMLDivElement>): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpSurface": {
		"name": "KlpSurface",
		"id": "@kallopis/react#KlpSurface",
		"source": "react/src/components.tsx",
		"signature": "export function KlpSurface({ tone = 'base', className = '', ...props }: KlpSurfaceProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "tone",
				"type": "\"base\" | \"component\" | \"inset\" | \"muted\" | \"raised\" | \"stage\" | undefined",
				"required": false,
				"defaultValue": "'base'",
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	},
	"KlpSwitch": {
		"name": "KlpSwitch",
		"id": "@kallopis/react#KlpSwitch",
		"source": "react/src/desktop/controls.tsx",
		"signature": "export function KlpSwitch({ label, className = '', ...props }: KlpCheckboxProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpSystemAction": {
		"name": "KlpSystemAction",
		"id": "@kallopis/react#KlpSystemAction",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpSystemAction({ label, onAction, disabled, unavailable = '此環境未提供此功能' }: KlpSystemActionProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onAction",
				"type": "(() => void | Promise<void>) | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "disabled",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "unavailable",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "'此環境未提供此功能'",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpTable": {
		"name": "KlpTable",
		"id": "@kallopis/react#KlpTable",
		"source": "react/src/desktop/views.tsx",
		"signature": "export function KlpTable({ caption, columns, rows }: KlpTableProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "caption",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "columns",
				"type": "readonly string[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "rows",
				"type": "readonly { id: string; cells: readonly ReactNode[]; }[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpTabs": {
		"name": "KlpTabs",
		"id": "@kallopis/react#KlpTabs",
		"source": "react/src/desktop/views.tsx",
		"signature": "export function KlpTabs({ label, tabs, value, onValueChange }: KlpTabsProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "tabs",
				"type": "readonly KlpTab[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "value",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onValueChange",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpText": {
		"name": "KlpText",
		"id": "@kallopis/react#KlpText",
		"source": "react/src/components.tsx",
		"signature": "export function KlpText({ as: Tag = 'span', role = 'body', tone = 'primary', className = '', ...props }: KlpTextProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "as",
				"type": "\"code\" | \"h1\" | \"h2\" | \"h3\" | \"h4\" | \"p\" | \"span\" | undefined",
				"required": false,
				"defaultValue": "'span'",
				"documentation": ""
			},
			{
				"name": "role",
				"type": "KlpTextRole | undefined",
				"required": false,
				"defaultValue": "'body'",
				"documentation": ""
			},
			{
				"name": "tone",
				"type": "\"faint\" | \"muted\" | \"primary\" | undefined",
				"required": false,
				"defaultValue": "'primary'",
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	},
	"KlpTextArea": {
		"name": "KlpTextArea",
		"id": "@kallopis/react#KlpTextArea",
		"source": "react/src/desktop/controls.tsx",
		"signature": "export function KlpTextArea({ label, hint, error, id, className = '', ...props }: KlpTextAreaProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "hint",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "error",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpTextField": {
		"name": "KlpTextField",
		"id": "@kallopis/react#KlpTextField",
		"source": "react/src/components.tsx",
		"signature": "export function KlpTextField({ label, error = false, hint, id, className = '', ...props }: KlpTextFieldProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "error",
				"type": "boolean | undefined",
				"required": false,
				"defaultValue": "false",
				"documentation": ""
			},
			{
				"name": "hint",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	},
	"KlpThemeProvider": {
		"name": "KlpThemeProvider",
		"id": "@kallopis/react#KlpThemeProvider",
		"source": "react/src/theme.tsx",
		"signature": "export function KlpThemeProvider({ mode = 'light', stylePack, children, className = '', ...props }: KlpThemeProviderProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "mode",
				"type": "\"dark\" | \"light\" | \"transparent\" | \"ultraDark\" | undefined",
				"required": false,
				"defaultValue": "'light'",
				"documentation": ""
			},
			{
				"name": "stylePack",
				"type": "KlpStylePack | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": "stylePack：此 scope 的完整風格；缺省沿用正式預設。"
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.colors.onLightBackground",
				"css": "--klp-colors-onLightBackground",
				"flutter": "colors.onLightBackground"
			},
			{
				"id": "theme.colors.onDarkBackground",
				"css": "--klp-colors-onDarkBackground",
				"flutter": "colors.onDarkBackground"
			},
			{
				"id": "theme.surface.selectionWashOpacity",
				"css": "--klp-surface-selectionWashOpacity",
				"flutter": "surface.selectionWashOpacity"
			},
			{
				"id": "theme.surface.focusWashOpacity",
				"css": "--klp-surface-focusWashOpacity",
				"flutter": "surface.focusWashOpacity"
			}
		]
	},
	"KlpToastRegion": {
		"name": "KlpToastRegion",
		"id": "@kallopis/react#KlpToastRegion",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpToastRegion({ label = '通知', items, onDismiss }: KlpToastRegionProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "'通知'",
				"documentation": ""
			},
			{
				"name": "items",
				"type": "readonly { id: string; title: string; message?: string; tone?: 'info' | 'success' | 'warning' | 'danger'; }[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onDismiss",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpTooltip": {
		"name": "KlpTooltip",
		"id": "@kallopis/react#KlpTooltip",
		"source": "react/src/desktop/feedback.tsx",
		"signature": "export function KlpTooltip({ text, children }: KlpTooltipProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "text",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "children",
				"type": "ReactElement<HTMLAttributes<HTMLElement>, string | import(\"react\").JSXElementConstructor<any>>",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.app",
				"css": "--klp-colors-app",
				"flutter": "colors.app"
			},
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.component",
				"css": "--klp-colors-component",
				"flutter": "colors.component"
			},
			{
				"id": "theme.colors.text",
				"css": "--klp-colors-text",
				"flutter": "colors.text"
			},
			{
				"id": "theme.colors.border",
				"css": "--klp-colors-border",
				"flutter": "colors.border"
			},
			{
				"id": "theme.colors.brand",
				"css": "--klp-colors-brand",
				"flutter": "colors.brand"
			},
			{
				"id": "theme.shape.control",
				"css": "--klp-shape-control",
				"flutter": "shape.control"
			},
			{
				"id": "theme.shape.card",
				"css": "--klp-shape-card",
				"flutter": "shape.card"
			}
		]
	},
	"KlpTree": {
		"name": "KlpTree",
		"id": "@kallopis/react#KlpTree",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpTree({ label, items, expandedIds, selectedId, onSelect, onToggle }: KlpTreeProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "items",
				"type": "readonly KlpTreeItem[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "expandedIds",
				"type": "readonly string[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "selectedId",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onSelect",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onToggle",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpTreeGrid": {
		"name": "KlpTreeGrid",
		"id": "@kallopis/react#KlpTreeGrid",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpTreeGrid({ label, columns, rows, expandedIds, selectedId, onSelect, onToggle }: KlpTreeGridProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "columns",
				"type": "readonly string[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "rows",
				"type": "readonly KlpTreeGridRow[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "expandedIds",
				"type": "readonly string[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "selectedId",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onSelect",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onToggle",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpVirtualList": {
		"name": "KlpVirtualList",
		"id": "@kallopis/react#KlpVirtualList",
		"source": "react/src/desktop/advanced.tsx",
		"signature": "export function KlpVirtualList({ label, items, selectedId, onSelect, height = 240, rowHeight = 40 }: KlpVirtualListProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "label",
				"type": "string",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "items",
				"type": "readonly { id: string; label: string; disabled?: boolean; }[]",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "selectedId",
				"type": "string | undefined",
				"required": false,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "onSelect",
				"type": "(id: string) => void",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "height",
				"type": "number | undefined",
				"required": false,
				"defaultValue": "240",
				"documentation": ""
			},
			{
				"name": "rowHeight",
				"type": "number | undefined",
				"required": false,
				"defaultValue": "40",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.spacing.contentInset",
				"css": "--klp-spacing-contentInset",
				"flutter": "spacing.contentInset"
			},
			{
				"id": "theme.spacing.comfortable",
				"css": "--klp-spacing-comfortable",
				"flutter": "spacing.comfortable"
			}
		]
	},
	"KlpWorkspace": {
		"name": "KlpWorkspace",
		"id": "@kallopis/react#KlpWorkspace",
		"source": "react/src/components.tsx",
		"signature": "export function KlpWorkspace({ children, className = '', ...props }: KlpWorkspaceProps): import(\"react\").JSX.Element",
		"documentation": "",
		"props": [
			{
				"name": "children",
				"type": "ReactNode",
				"required": true,
				"defaultValue": null,
				"documentation": ""
			},
			{
				"name": "className",
				"type": "string | undefined",
				"required": false,
				"defaultValue": "''",
				"documentation": ""
			}
		],
		"tokens": [
			{
				"id": "theme.colors.surface",
				"css": "--klp-colors-surface",
				"flutter": "colors.surface"
			},
			{
				"id": "theme.colors.surfaceInset",
				"css": "--klp-colors-surfaceInset",
				"flutter": "colors.surfaceInset"
			}
		]
	}
});
