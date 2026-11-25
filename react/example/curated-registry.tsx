// 由 styles/scripts/generate-curated.mjs 自動產生，禁止手改。
import type { ComponentType } from 'react';
import EditorialSpotlightCard from './curated/editorial-spotlight-card/component.js';
import './curated/editorial-spotlight-card/styles.css';
import MicroElevatedPillTabs from './curated/micro-elevated-pill-tabs/component.js';
import './curated/micro-elevated-pill-tabs/styles.css';

export interface CuratedComponentEntry {
	readonly id: string;
	readonly meta: {
		readonly schemaVersion: number;
		readonly id: string;
		readonly name: string;
		readonly englishName: string;
		readonly status: string;
		readonly recommendedTheme: string;
		readonly summary: string;
		readonly inspiration: { readonly site: string; readonly url: string; readonly traits: readonly string[] };
		readonly tokensUsed: readonly string[];
		readonly props: readonly { readonly name: string; readonly type: string; readonly required: boolean; readonly defaultValue: string | null; readonly description: string }[];
	};
	readonly Component: ComponentType;
	readonly snippets: { readonly react: string; readonly flutter: string; readonly html: string };
}

export const curatedComponents: readonly CuratedComponentEntry[] = [
	{
		id: "editorial-spotlight-card",
		meta: {"schemaVersion":1,"id":"editorial-spotlight-card","name":"編輯風光暈焦點卡","englishName":"Editorial Spotlight Card","status":"approved","recommendedTheme":"modern-minimal-v1","summary":"取材自 open-tag 的安靜編輯感焦點卡：1px 細線分隔、EB Garamond 襯線標題、柔和光暈點綴色切換與收藏狀態回饋。","inspiration":{"site":"fancyboi999/open-tag","url":"https://github.com/fancyboi999/open-tag","traits":["1px hairline 邊框無重陰影","EB Garamond 編輯標題層次","Mint / Peach / Lavender / Sky 柔和光暈"]},"tokensUsed":["theme.colors.component","theme.colors.surface","theme.colors.border","theme.colors.text","theme.colors.textMuted","theme.colors.brand","theme.shape.card","theme.shape.control"],"props":[{"name":"title","type":"string","required":false,"defaultValue":"\"Quietly Editorial\"","description":"編輯風格標題"},{"name":"initialOrb","type":"\"mint\" | \"peach\" | \"lavender\" | \"sky\"","required":false,"defaultValue":"\"peach\"","description":"預設光暈色調"}]},
		Component: EditorialSpotlightCard,
		snippets: {"react":"import { KlpThemeProvider } from '@kallopis/react';\nimport EditorialSpotlightCard from './component';\nimport '@kallopis/react/styles.css';\nimport './styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"light\">\n\t\t\t<EditorialSpotlightCard title=\"Quietly Editorial Workspace\" initialOrb=\"peach\" />\n\t\t</KlpThemeProvider>\n\t);\n}\n","flutter":"import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 依 modern-minimal-v1（open-tag）語意呈現編輯感細線卡片。\nclass EditorialSpotlightCard extends StatelessWidget {\n\tconst EditorialSpotlightCard({super.key, required this.title, required this.subtitle});\n\tfinal String title;\n\tfinal String subtitle;\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\tfinal klp = context.klp;\n\t\treturn Container(\n\t\t\tpadding: EdgeInsets.all(klp.spacing.comfortable),\n\t\t\tdecoration: BoxDecoration(\n\t\t\t\tcolor: klp.colors.component,\n\t\t\t\tborderRadius: BorderRadius.circular(klp.shape.card),\n\t\t\t\tborder: Border.all(color: klp.colors.border),\n\t\t\t),\n\t\t\tchild: Column(\n\t\t\t\tcrossAxisAlignment: CrossAxisAlignment.start,\n\t\t\t\tchildren: [\n\t\t\t\t\tText(title, style: TextStyle(fontSize: 24, color: klp.colors.text)),\n\t\t\t\t\tSizedBox(height: klp.spacing.tight),\n\t\t\t\t\tText(subtitle, style: TextStyle(color: klp.colors.textMuted)),\n\t\t\t\t],\n\t\t\t),\n\t\t);\n\t}\n}\n","html":"<!-- 直接引用 styles/themes/modern-minimal-v1.css -->\n<link rel=\"stylesheet\" href=\"./styles/themes/modern-minimal-v1.css\">\n\n<article style=\"padding:18px 20px;background:var(--klp-colors-component);border:1px solid var(--klp-colors-border);border-radius:var(--klp-shape-card);color:var(--klp-colors-text)\">\n\t<h3 style=\"margin:0 0 8px;font-family:'EB Garamond',Georgia,serif;font-weight:400;font-size:26px\">Quietly Editorial Workspace</h3>\n\t<p style=\"margin:0;color:var(--klp-colors-textMuted)\">以 1px 細線與留白構成柔和層次。</p>\n</article>\n"},
	},
	{
		id: "micro-elevated-pill-tabs",
		meta: {"schemaVersion":1,"id":"micro-elevated-pill-tabs","name":"微立體膠囊分頁列","englishName":"Micro-Elevated Pill Tabs","status":"approved","recommendedTheme":"micro-elevation-v1","summary":"多層抬升的桌面工作區分頁列，支援鍵盤左右方向鍵切換、新增與關閉分頁、計數徽章與琥珀強調點綴，完全由 --klp-* 語意驅動。","inspiration":{"site":"Obsidian / Unico Workspace","url":"https://github.com/MiuDog/Kallopis","traits":["分層浮起分頁膠囊","鍵盤左右方向鍵焦點移動","可關閉與動態新增分頁"]},"tokensUsed":["theme.colors.surface","theme.colors.component","theme.colors.stageSurface","theme.colors.border","theme.colors.borderStrong","theme.colors.text","theme.colors.textMuted","theme.colors.accent","theme.shape.control","theme.shape.panel"],"props":[{"name":"initialTabs","type":"readonly { id: string; label: string; count?: number }[]","required":false,"defaultValue":"3 tabs","description":"初始分頁集合"}]},
		Component: MicroElevatedPillTabs,
		snippets: {"react":"import { KlpThemeProvider } from '@kallopis/react';\nimport MicroElevatedPillTabs from './component';\nimport '@kallopis/react/styles.css';\nimport './styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode=\"dark\">\n\t\t\t<MicroElevatedPillTabs />\n\t\t</KlpThemeProvider>\n\t);\n}\n","flutter":"import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 依 micro-elevation-v1 語意組合膠囊分頁列（使用 context.klp 解析背景、邊框與強調點）。\nclass MicroElevatedPillTabs extends StatelessWidget {\n\tconst MicroElevatedPillTabs({super.key, required this.labels, required this.activeIndex, required this.onSelect});\n\tfinal List<String> labels;\n\tfinal int activeIndex;\n\tfinal ValueChanged<int> onSelect;\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\tfinal klp = context.klp;\n\t\treturn Container(\n\t\t\tpadding: EdgeInsets.all(klp.spacing.tight),\n\t\t\tdecoration: BoxDecoration(\n\t\t\t\tcolor: klp.colors.surface,\n\t\t\t\tborderRadius: BorderRadius.circular(klp.shape.panel),\n\t\t\t\tborder: Border.all(color: klp.colors.border),\n\t\t\t),\n\t\t\tchild: Wrap(\n\t\t\t\tspacing: 6,\n\t\t\t\tchildren: [\n\t\t\t\t\tfor (var i = 0; i < labels.length; i++)\n\t\t\t\t\t\tGestureDetector(\n\t\t\t\t\t\t\tonTap: () => onSelect(i),\n\t\t\t\t\t\t\tchild: Container(\n\t\t\t\t\t\t\t\tpadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),\n\t\t\t\t\t\t\t\tdecoration: BoxDecoration(\n\t\t\t\t\t\t\t\t\tcolor: i == activeIndex ? klp.colors.component : klp.colors.transparent,\n\t\t\t\t\t\t\t\t\tborderRadius: BorderRadius.circular(klp.shape.control),\n\t\t\t\t\t\t\t\t\tborder: Border.all(color: i == activeIndex ? klp.colors.borderStrong : klp.colors.transparent),\n\t\t\t\t\t\t\t\t),\n\t\t\t\t\t\t\t\tchild: Text(labels[i], style: TextStyle(color: i == activeIndex ? klp.colors.text : klp.colors.textMuted)),\n\t\t\t\t\t\t\t),\n\t\t\t\t\t\t),\n\t\t\t\t],\n\t\t\t),\n\t\t);\n\t}\n}\n","html":"<!-- 直接引用 styles/themes/micro-elevation-v1.css（不需匯入元件庫） -->\n<link rel=\"stylesheet\" href=\"./styles/themes/micro-elevation-v1.css\">\n\n<div style=\"display:flex;gap:6px;padding:6px;background:var(--klp-colors-surface);border:1px solid var(--klp-colors-border);border-radius:var(--klp-shape-panel)\">\n\t<button style=\"padding:5px 10px;border:1px solid var(--klp-colors-borderStrong);border-radius:var(--klp-shape-control);background:var(--klp-colors-component);color:var(--klp-colors-text)\">README.md</button>\n\t<button style=\"padding:5px 10px;border:1px solid transparent;border-radius:var(--klp-shape-control);background:transparent;color:var(--klp-colors-textMuted)\">tokens.css</button>\n</div>\n"},
	}
];
