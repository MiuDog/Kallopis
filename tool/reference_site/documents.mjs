import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '../..');

// 依來源目錄登錄新 Reference／範例／流程，維持 Markdown 單一正文。
function discoverDocuments(directory, category) {
	const absolute = path.join(root, directory);
	if (!fs.existsSync(absolute)) return [];
	return fs.readdirSync(absolute, { withFileTypes: true }).sort((left, right) => left.name.localeCompare(right.name, 'en')).flatMap(entry => {
		const source = `${directory}/${entry.name}`;
		if (entry.isDirectory()) return discoverDocuments(source, category);
		if (!entry.name.endsWith('.md') || entry.name === 'architecture.md') return [];

		const title = fs.readFileSync(path.join(root, source), 'utf8').match(/^# (.+)/m)?.[1] ?? entry.name;
		const href = source.replace(/README\.md$/, 'index.html').replace(/\.md$/, '.html');
		return [[source, href, title, entry.name === 'README.md' || entry.name === 'quickstart.md' ? 'Index' : category]];
	});
}

// source 為唯一 Markdown 來源，href 為產物路由，title／category 用於導覽與搜尋；不保存正文副本。
export const documents = [
	['docs/README.md', 'docs/overview.html', '文件閱讀入口', 'Index'],
	['docs/ai/README.md', 'docs/ai/index.html', 'AI 閱讀路徑', 'Index'],
	...discoverDocuments('docs/reference', 'Reference'),
	...discoverDocuments('docs/examples', 'Example'),
	...discoverDocuments('docs/guides/flutter', 'Guide'),
	...discoverDocuments('docs/guides/react', 'Guide'),
	['docs/templates/modern-productivity-layout.md', 'docs/guides/modern-productivity-layout.html', '現代風生產力佈局模板', 'Guide'],
	['docs/architecture/workbench-shortcut-host-contract.md', 'docs/guides/workbench-shortcut-host-contract.html', 'Registered 快捷鍵原生宿主契約', 'Guide'],
	['docs/architecture/workbench-shortcut-core-contract.md', 'docs/guides/workbench-shortcut-core-contract.html', 'Registered 快捷鍵核心契約', 'Guide'],
	['docs/architecture/workbench-command-popup-contract.md', 'docs/guides/workbench-command-popup-contract.html', '錨定與右鍵命令選單契約', 'Guide'],
	['docs/architecture/workbench-command-palette-contract.md', 'docs/guides/workbench-command-palette-contract.html', '命令面板契約', 'Guide'],
	['docs/architecture/workbench-command-entry-contract.md', 'docs/guides/workbench-command-entry-contract.html', '命令工具列與選單契約', 'Guide'],
	['docs/architecture/workbench-command-entry-geometry-contract.md', 'docs/guides/workbench-command-entry-geometry-contract.html', 'Registered 命令入口有限幾何', 'Guide'],
	['README.md', 'docs/guides/README.html', 'Project overview', 'Guide'],
	['docs/ai/react-usage.md', 'docs/guides/react-usage.html', 'React 產品使用', 'Guide'],
	['docs/ai/style-designer-workflow.md', 'docs/guides/style-designer-workflow.html', '風格設計師 Agent 工作流程', 'Guide'],
	['spec/workbench-v1.md', 'docs/guides/workbench-v1.html', 'Workbench v1 規範', 'Guide'],
	['spec/style-pack-v1.md', 'docs/guides/style-pack-v1.html', '可替換風格檔', 'Design'],
	['spec/interactive-docs-v1.md', 'docs/guides/interactive-docs-v1.html', '互動文件與 GUI 範例', 'Guide'],
	['docs/research/workbench-reference-survey.md', 'docs/guides/workbench-reference-survey.html', 'Workbench 官方參考', 'Guide'],
	['docs/architecture/workbench-stage-v1.md', 'docs/guides/workbench-stage-v1.html', 'Workbench 本階段計畫', 'Guide'],
	['docs/architecture/workbench-linear-contract.md', 'docs/guides/workbench-linear-contract.html', 'Workbench 線性尺寸規則', 'Guide'],
	['docs/architecture/workbench-dock-contract.md', 'docs/guides/workbench-dock-contract.html', 'Workbench Dock 保存規則', 'Guide'],
	['docs/architecture/workbench-command-contract.md', 'docs/guides/workbench-command-contract.html', 'Workbench 命令生命週期', 'Guide'],
	['docs/ai/product-usage.md', 'docs/guides/docs-ai-product-usage.html', 'Flutter 產品使用', 'Guide'],
	['docs/architecture/multi-framework-verification.md', 'docs/guides/multi-framework-verification.html', '跨框架整合驗證', 'Guide'],
	['docs/architecture/README.md', 'docs/guides/docs-architecture-README.html', 'Architecture', 'Guide'],
	['docs/architecture/frontend-boundaries.md', 'docs/guides/docs-architecture-frontend-boundaries.html', 'Frontend boundaries', 'Guide'],
	['docs/architecture/thin-design-system/architecture.md', 'docs/guides/docs-architecture-thin-design-system-architecture.html', 'Single Architecture', 'Guide'],
	['docs/architecture/thin-design-system/verification.md', 'docs/guides/docs-architecture-thin-design-system-verification.html', 'Verification', 'Guide'],
	['spec/decisions/KLP-0022-thin-design-system-boundary.md', 'docs/guides/spec-decisions-KLP-0022-thin-design-system-boundary.html', 'KLP-0022', 'Guide'],
	['spec/style-v1.md', 'docs/guides/spec-style-v1.html', 'Style specification', 'Guide'],
	['docs/design-tokens/KALLOPIS-DESIGN-MAP.md', 'docs/design-system/index.html', '通用視覺規範', 'Design'],
	['docs/design-tokens/maintenance.md', 'docs/design-system/maintenance.html', '維護與修訂', 'Design'],
	...['notation', 'primitives', 'semantics', 'recipes', 'examples', 'platform-notes'].map((name, index) => [`docs/design-tokens/${name}.md`, `docs/design-system/${name}.html`, ['記號與解析基準', 'Primitive', 'Semantic', '元件與狀態配方', '查表例子', '現行差異與平台邊界'][index], 'Design']),
	['docs/design-tokens/README.md', 'docs/design-system/export-snapshot.html', '2026-10-05 匯出快照', 'Snapshot'],
	['spec/multi-framework-design-system.md', 'docs/guides/spec-multi-framework-design-system.html', '跨框架核心目標', 'Guide'],
].map(([source, href, title, category]) => ({
	/* source／href：跨來源與產物的唯一對照；title／category：區分正式規範、操作指南及快照。 */
	source, href, title, category,
}));

export const documentRoutes = new Map(documents.map(({source, href}) => [source, href]));
documentRoutes.set('docs/reference/manifest.json', 'docs/reference/manifest.json');
