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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpAccordion } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpAccordion title=\"系統標題\">範例內容</KlpAccordion>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpAccordion\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpAccordion(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpaccordion\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpAccordion 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpAlert } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpAlert title=\"系統標題\" tone=\"primary\">範例內容</KlpAlert>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpSurface（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpSurface(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpalert\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpAlert 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpAppLayout } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpAppLayout />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpAppLayout\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpAppLayout(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpapplayout\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpAppLayout 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpAvatar } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpAvatar label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpAvatar\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpAvatar(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpavatar\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpAvatar 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpBadge } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpBadge tone=\"primary\">範例內容</KlpBadge>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpBadge\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpBadge(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpbadge\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpBadge 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpBreadcrumb } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpBreadcrumb label=\"工作區項目\" items=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpBreadcrumb\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpBreadcrumb(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpbreadcrumb\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpBreadcrumb 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpButton } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpButton tone=\"primary\" size=\"md\" selected={selected}>範例內容</KlpButton>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpButton\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpButton(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpbutton\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpButton 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpCard } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpCard tone=\"primary\">範例內容</KlpCard>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpCard\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpCard(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpcard\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpCard 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpCheckbox } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpCheckbox label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpCheckbox\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpCheckbox(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpcheckbox\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpCheckbox 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpComboBox } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpComboBox label=\"工作區項目\" options=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpTextField（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTextField(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpcombobox\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpComboBox 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpCommandShortcutHost } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpCommandShortcutHost>範例內容</KlpCommandShortcutHost>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpCommandShortcutHost\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpCommandShortcutHost(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpcommandshortcuthost\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpCommandShortcutHost 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpContentHost } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpContentHost label=\"工作區項目\">範例內容</KlpContentHost>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 透過 KlpTheme.of(context) 讀取共用 semantic tokens\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpContentHost(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpcontenthost\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpContentHost 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpDataGrid } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpDataGrid label=\"工作區項目\" columns=\"範例\" rows=\"範例\" onCellChange=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpTree（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTree(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpdatagrid\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpDataGrid 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpDialog } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpDialog open={open} title=\"系統標題\">範例內容</KlpDialog>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpDialog\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpDialog(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpdialog\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpDialog 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpDockLayout } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpDockLayout />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpDockLayout\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpDockLayout(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpdocklayout\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpDockLayout 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpDrawer } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpDrawer open={open} title=\"系統標題\">範例內容</KlpDrawer>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpDrawer\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpDrawer(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpdrawer\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpDrawer 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpEmptyState } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpEmptyState title=\"系統標題\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpEmptyState\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpEmptyState(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpemptystate\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpEmptyState 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpFileExplorer } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpFileExplorer expandedIds=\"範例\" onToggle=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpFileExplorer\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpFileExplorer(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpfileexplorer\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpFileExplorer 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpFrame } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpFrame>範例內容</KlpFrame>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpPanelFrame（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpPanelFrame(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpframe\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpFrame 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpIconButton } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpIconButton label=\"工作區項目\" tone=\"primary\" size=\"md\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpIconButton\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpIconButton(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpiconbutton\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpIconButton 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpLayoutColumn } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpLayoutColumn />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 Column（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn Column(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klplayoutcolumn\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpLayoutColumn 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpLayoutDivider } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpLayoutDivider />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpLayoutDivider\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpLayoutDivider(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klplayoutdivider\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpLayoutDivider 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpLayoutPane } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpLayoutPane />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpLayoutPane\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpLayoutPane(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klplayoutpane\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpLayoutPane 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpLayoutRow } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpLayoutRow />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 Row（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn Row(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klplayoutrow\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpLayoutRow 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpLayoutSpacer } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpLayoutSpacer />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 Spacer（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn Spacer(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klplayoutspacer\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpLayoutSpacer 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpLink } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpLink>範例內容</KlpLink>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpButton（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpButton(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klplink\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpLink 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpList } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpList label=\"工作區項目\" onSelect=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpFileExplorer（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpFileExplorer(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klplist\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpList 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpModernProductivityLayout } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpModernProductivityLayout selectedId=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpModernProductivityLayout\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpModernProductivityLayout(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpmodernproductivitylayout\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-panel);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpModernProductivityLayout 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpMultiSelect } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpMultiSelect label=\"工作區項目\" options=\"範例\" value={value} onValueChange=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpFilterChip（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpFilterChip(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpmultiselect\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpMultiSelect 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpPagination } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpPagination label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpPagination\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpPagination(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klppagination\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpPagination 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpPopover } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpPopover label=\"工作區項目\" open={open}>範例內容</KlpPopover>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpPopover\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpPopover(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klppopover\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpPopover 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpProgress } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpProgress label=\"工作區項目\" value={value} />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpProgress\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpProgress(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpprogress\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpProgress 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpRadioGroup } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpRadioGroup label=\"工作區項目\" value={value} onValueChange=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpRadioGroup\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpRadioGroup(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpradiogroup\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpRadioGroup 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpRegisteredCommandMenu } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpRegisteredCommandMenu emptyLabel=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpRegisteredCommandMenu\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpRegisteredCommandMenu(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpregisteredcommandmenu\" style=\"\n\tbackground: var(--klp-surface-separation);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpRegisteredCommandMenu 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpRegisteredCommandPalette } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpRegisteredCommandPalette open={open} label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpRegisteredCommandPalette\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpRegisteredCommandPalette(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpregisteredcommandpalette\" style=\"\n\tbackground: var(--klp-surface-separation);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpRegisteredCommandPalette 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpRegisteredCommandPopup } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpRegisteredCommandPopup open={open} />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpRegisteredCommandPopup\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpRegisteredCommandPopup(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpregisteredcommandpopup\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpRegisteredCommandPopup 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpRegisteredCommandToolbar } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpRegisteredCommandToolbar label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpRegisteredCommandToolbar\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpRegisteredCommandToolbar(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpregisteredcommandtoolbar\" style=\"\n\tbackground: var(--klp-surface-separation);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpRegisteredCommandToolbar 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpRibbon } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpRibbon label=\"工作區項目\" value={value} onValueChange=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 透過 KlpTheme.of(context) 讀取共用 semantic tokens\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpRibbon(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpribbon\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpRibbon 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpSelect } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpSelect label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpSelect\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpSelect(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpselect\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpSelect 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpSeparator } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpSeparator />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpDivider（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpDivider(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpseparator\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpSeparator 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpSkeleton } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpSkeleton label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpSurface（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpSurface(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpskeleton\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpSkeleton 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpSlider } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpSlider label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpSlider\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpSlider(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpslider\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpSlider 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpSpinner } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpSpinner label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpProgressBar（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpProgressBar(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpspinner\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpSpinner 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpSplitButton } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpSplitButton label=\"工作區項目\" options=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 透過 KlpTheme.of(context) 讀取共用 semantic tokens\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpSplitButton(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpsplitbutton\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpSplitButton 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpStatusBar } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpStatusBar>範例內容</KlpStatusBar>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpStatusBar\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpStatusBar(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpstatusbar\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpStatusBar 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpSurface } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpSurface tone=\"primary\">範例內容</KlpSurface>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpSurface\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpSurface(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpsurface\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpSurface 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpSwitch } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpSwitch label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpCompactSwitch（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpCompactSwitch(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpswitch\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpSwitch 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpSystemAction } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpSystemAction label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 透過 KlpTheme.of(context) 讀取共用 semantic tokens\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpSystemAction(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpsystemaction\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpSystemAction 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpTable } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpTable caption=\"範例\" columns=\"範例\" rows=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpTree（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTree(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klptable\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpTable 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpTabs } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpTabs label=\"工作區項目\" value={value} onValueChange=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpTabs\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTabs(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klptabs\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpTabs 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpText } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpText tone=\"primary\">範例內容</KlpText>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpText\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpText(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klptext\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpText 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpTextArea } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpTextArea label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpTextArea\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTextArea(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klptextarea\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpTextArea 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpTextField } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpTextField label=\"工作區項目\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpTextField\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTextField(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klptextfield\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpTextField 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpThemeProvider } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpThemeProvider>範例內容</KlpThemeProvider>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpTheme（或以 KlpTheme.of(context) 組合）\nKlpTheme(\n\tdata: KlpThemeData.dark(),\n\tchild: Builder(\n\t\tbuilder: (context) {\n\t\t\tfinal klp = context.klp;\n\t\t\treturn ColoredBox(color: klp.colors.app);\n\t\t},\n\t),\n)",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpthemeprovider\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpThemeProvider 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpToastRegion } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpToastRegion label=\"工作區項目\" items=\"範例\" onDismiss=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpSurface（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpSurface(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klptoastregion\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpToastRegion 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpTooltip } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpTooltip text=\"範例\">範例內容</KlpTooltip>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpTooltip\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTooltip(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klptooltip\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpTooltip 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpTree } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpTree label=\"工作區項目\" expandedIds=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpTree\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTree(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klptree\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpTree 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpTreeGrid } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpTreeGrid label=\"工作區項目\" columns=\"範例\" expandedIds=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 透過 KlpTheme.of(context) 讀取共用 semantic tokens\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTreeGrid(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klptreegrid\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpTreeGrid 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpVirtualList } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpVirtualList label=\"工作區項目\" items=\"範例\" onSelect=\"範例\" />\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 使用 Kallopis Flutter 公開元件 KlpVirtualList\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpVirtualList(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpvirtuallist\" style=\"\n\tbackground: var(--klp-colors-component);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpVirtualList 範例內容\n</div>"
		}
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
		],
		"snippets": {
			"react": "import { KlpThemeProvider, KlpWorkspace } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<KlpWorkspace>範例內容</KlpWorkspace>\n\t\t</KlpThemeProvider>\n\t);\n}",
			"flutter": "import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// Flutter 端對應 KlpTwoPaneWorkspace（或以 KlpTheme.of(context) 組合）\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn KlpTwoPaneWorkspace(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}",
			"html": "<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div class=\"my-klpworkspace\" style=\"\n\tbackground: var(--klp-colors-surface);\n\tcolor: var(--klp-colors-text);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-control);\n\tpadding: var(--klp-spacing-contentInset);\n\">\n\tKlpWorkspace 範例內容\n</div>"
		}
	}
});
