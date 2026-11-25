import fs from 'node:fs';
import path from 'node:path';
import { createHash } from 'node:crypto';

const apiStart = '<!-- reference-api:start -->';
const apiEnd = '<!-- reference-api:end -->';
const labels = {
	/* 分類標籤由兩平台共用，能力分類不強迫兩平台交付相同 API。 */
	'components/actions': '操作元件', 'components/inputs': '輸入元件', 'components/navigation': '導覽元件',
	'components/layout': '布局元件', 'components/collections': '資料呈現', 'components/feedback': '狀態回饋',
	'components/content': '內容元件', 'components/workspace': '工作區元件', types: '資料與型別',
	controllers: '控制與生命週期', styling: '語意風格', utilities: '工具函式', platform: '平台整合',
};
const memberHelp = {
	/* 共用參數只解釋角色；元件特有優先序與語意留在專頁正文。 */
	key: '框架識別鍵。', label: '顯示標籤。', child: '產品提供的內容。', children: '產品提供的子內容。',
	tone: '選擇語意呈現。', size: '尺寸選擇。', selected: '由產品持有的選取狀態。',
	onPressed: '啟動時通知產品；nullable 回呼的停用規則依元件契約。', onLongPress: '長按回呼。',
	leading: '前方內容。', trailing: '後方內容。', compact: '緊湊呈現選項。',
	value: '目前值。', onChanged: '將值的變更交回產品。', onChange: '將變更事件交回產品。',
	controller: '借用產品提供的控制器。', registry: '借用共用命令登錄表。', getContext: '取得當次產品執行上下文。',
	id: '穩定識別，用於查詢或回報。', description: '補充描述。', category: '分類資訊。', keywords: '搜尋關鍵字。',
	handler: '由產品提供的執行處理。', icon: '操作或內容圖示。', isVisible: '依目前上下文判定是否可見。',
	isEnabled: '依目前上下文判定是否可啟動。', isChecked: '依目前上下文判定勾選狀態。',
	sections: '產品投影的區段資料。', expandedIds: '目前展開的識別集合。', selectedId: '產品持有的選取識別。',
	onSelect: '將選取意圖交回產品。', onSelected: '將選取意圖交回產品。', onToggle: '將展開或切換意圖交回產品。',
	type: '原生 HTML 元素的 type。', className: '外部宿主 class；不取代內部語意樣式。',
	ref: '存取公開的原生宿主。', mode: '風格模式。', stylePack: '此 scope 使用的合法風格包。',
	items: '由產品提供的項目。', header: '標頭內容。', footer: '頁尾內容。',
	open: '產品持有的開啟狀態。', onDismiss: '向產品提出關閉意圖。', onResult: '接收執行結果。',
	createState: '由 Flutter 建立此元件的 State。', build: '由 Flutter 依目前 context 建構畫面。',
	dispose: '釋放此物件擁有的資源；由建立者管理生命週期。',
};

function slug(value) { return value.replace(/([a-z0-9])([A-Z])/g, '$1-$2').replaceAll('_', '-').toLowerCase(); }
function cell(value) { return String(value ?? '—').replaceAll('|', '\\|').replaceAll('\n', '<br>'); }
function code(value, language) { return `\`\`\`${language}\n${String(value).replace(/^ +/gm, value => '\t'.repeat(Math.ceil(value.length / 2)))}\n\`\`\``; }
function link(from, to) { return path.posix.relative(path.posix.dirname(from), to); }

function category(declaration) {
	const name = declaration.name;
	const source = declaration.sourceUri ?? declaration.source ?? '';
	if (name === 'KlpThemeProvider') return 'styling';
	if (declaration.renderable) {
		if (/Button|Command|Toolbar|Action|Menu/.test(name)) return 'components/actions';
		if (/Field|Input|Picker|Checkbox|Radio|Switch|Slider|Toggle|Selection|Combo|Select|Form/.test(name)) return 'components/inputs';
		if (/Navigation|Rail|Breadcrumb|Tab|Pagination|Stepper/.test(name)) return 'components/navigation';
		if (/Toast|Notice|Alert|Dialog|Loading|Error|Empty|Progress|Skeleton|Permission|Placeholder/.test(name)) return 'components/feedback';
		if (/Explorer|Workspace|Workbench|Dock|AppLayout|ModernProductivity/.test(name)) return 'components/workspace';
		if (/Layout|Frame|Surface|Pane|Divider|Spacer|Row|Column|Grid|Inset|Wrap|Stack|Scroll|Split|Card/.test(name)) return 'components/layout';
		if (/Table|List|Tree|Accordion|Collection/.test(name)) return 'components/collections';
		return 'components/content';
	}
	if (/Controller|Registry|Keymap$/.test(name) && !/Props|Options|Result|State|Callback/.test(name)) return 'controllers';
	if (/\/styling\/|style-pack|theme\.|generated\./.test(source) || /Theme|StylePack|StyleOverrides|^klp(?:Primitives|Recipes|Themes|Style)|^useKlp$|^getKlpRecipe$/.test(name)) return 'styling';
	if (/\/platform\//.test(source)) return 'platform';
	if (['function', 'extension', 'variable', 'getter'].includes(declaration.kind)) return 'utilities';
	return 'types';
}

function responsibility(declaration) {
	if (declaration.documentation) return declaration.documentation;
	const name = declaration.name;
	if (name.endsWith('Props')) return `定義 ${name.slice(0, -5)} 的產品輸入、子內容與事件介面。`;
	if (declaration.renderable) return `提供 ${name} 的共用呈現與互動。產品透過下列參數提供內容、狀態與事件處理；內部視覺由 Kallopis 語意風格管理。`;
	if (declaration.kind === 'enum') return `定義 ${name} 的合法選項，供引用此型別的公開 API 使用。`;
	if (['interface', 'type', 'typedef'].includes(declaration.kind)) return `定義 ${name} 的資料形狀或合法值，供產品與 Kallopis 公開 API 交換資料。`;
	return `提供 ${name} 的公開契約；可用操作、輸入與回傳型別如下。`;
}

function imports(declaration, framework) {
	if (framework === 'react') {
		const modifier = ['interface', 'type'].includes(declaration.kind) ? 'type ' : '';
		return `import { ${modifier}${declaration.name} } from '@kallopis/react';`;
	}
	return `import 'package:kallopis/kallopis_${declaration.primarySurface ?? 'foundation'}.dart';`;
}

function sample(declaration, framework) {
	if (declaration.example) return declaration.example;
	const name = declaration.name;
	const entry = imports(declaration, framework);
	if (name === 'KlpButton') {
		if (framework === 'flutter') return `${entry}\n\nKlpButton(\n\tlabel: '儲存',\n\tonPressed: () {\n\t\t// 接入產品的儲存流程。\n\t},\n)`;
		return `${entry}\n\nexport function SaveButton() {\n\treturn <KlpButton onClick={() => {\n\t\t// 接入產品的儲存流程。\n\t}}>儲存</KlpButton>;\n}`;
	}
	if (framework === 'react') {
		if (declaration.renderable) return `import type { ComponentProps } from 'react';\n${entry}\n\n// 產品提供下表列出的必要 props；在 KlpThemeProvider 內呈現。\nexport function Example(props: ComponentProps<typeof ${name}>) {\n\treturn <${name} {...props} />;\n}`;
		if (declaration.kind === 'function') return `${entry}\n\n// 產品提供參數；回傳值保留此 API 的原生型別。\nconst invoke = (...args: Parameters<typeof ${name}>) => ${name}(...args);`;
		if (declaration.kind === 'class') return `${entry}\n\nconst create = (...args: ConstructorParameters<typeof ${name}>) => new ${name}(...args);`;
		if (declaration.kind === 'variable') return `${entry}\n\nconst productReference = ${name};`;
		const generic = declaration.signature.match(new RegExp(`${name}<([^>]+)>`));
		const argumentsText = generic ? `<${generic[1].split(',').map(() => 'unknown').join(', ')}>` : '';
		return `${entry}\n\n// 產品資料沿用公開型別，避免維護第二份資料契約。\ntype ProductValue = ${name}${argumentsText};`;
	}
	const enumValue = declaration.members?.find(member => member.kind === 'enumValue');
	if (enumValue) return `${entry}\n\nfinal value = ${name}.${enumValue.name};`;
	const staticValue = declaration.members?.find(member => member.kind === 'field' && member.signature.startsWith('static '));
	if (staticValue && /abstract/.test(declaration.signature)) return `${entry}\n\nfinal value = ${name}.${staticValue.name};`;
	if (declaration.kind === 'extension') {
		const getter = declaration.members?.find(member => member.kind === 'getter');
		if (getter) return `${entry}\n\n// 以公開 extension 讀取接收者的語意能力。\nObject? readExample(${declaration.typeRelationships.extends} value) => ${name}(value).${getter.name};`;
		return `${entry}\n\n// 在符合下方 extends 型別的接收者上使用 ${name} 的公開方法。`;
	}
	if (['function', 'variable', 'getter'].includes(declaration.kind)) return `${entry}\n\nfinal product${name[0].toUpperCase()}${name.slice(1)} = ${name};`;
	const constructor = declaration.members?.find(member => member.kind === 'constructor');
	if (constructor && !/abstract|sealed/.test(`${declaration.kind} ${declaration.signature}`)) {
		const parameters = (constructor.parameters ?? []).filter(parameter => parameter.required);
		const generic = declaration.signature.match(new RegExp(`${name}<([^>]+)>`));
		const typeParams = generic ? `<${generic[1]}>` : '';
		const typeArgs = generic ? `<${generic[1].split(',').map(item => item.trim().split(/\s/)[0]).join(', ')}>` : '';
		const values = parameters.map(parameter => parameter.named ? `${parameter.name}: ${parameter.name}` : parameter.name).join(', ');
		const formal = parameters.map(parameter => `${parameter.type} ${parameter.name}`).join(', ');
		const constructorName = constructor.name === 'new' ? name : constructor.name;
		const suffix = constructorName.startsWith(name) ? constructorName.slice(name.length) : `.${constructorName}`;
		return `${entry}\n\n// 由產品提供必要資料；可選參數沿用下表預設。\n${name}${typeArgs} createExample${typeParams}(${formal}) => ${name}${typeArgs}${suffix}(${values});`;
	}
	return `${entry}\n\n// 在產品介面沿用公開型別；實例由其擁有者提供。\nvoid acceptValue(${name} value) {\n\t// 接入產品的資料處理。\n}`;
}

function sampleImports(example, declaration, declarations) {
	const needed = new Set();
	const tokens = new Set(example.match(/\b[A-Z][A-Za-z0-9_]*\b/g) ?? []);
	for (const { declaration: type, framework } of declarations) {
		if (framework !== 'flutter' || !tokens.has(type.name)) continue;
		const statement = imports(type, framework);
		if (!example.includes(statement)) needed.add(statement);
	}
	const sdk = [
		['dart:async', /\b(?:FutureOr|Stream|StreamSubscription|Completer|Timer)\b/],
		['dart:typed_data', /\b(?:Uint8List|ByteData)\b/],
		['package:flutter/foundation.dart', /\b(?:ValueListenable|ValueNotifier|Listenable)\b/],
		['package:flutter/material.dart', /\b(?:Widget|BuildContext|IconData|TextStyle|EdgeInsets|Axis|Alignment|VoidCallback|Color|Size|Offset|FocusNode|TextEditingController|Key|TextAlign|BoxConstraints|ScrollController|TextInputType|ValueChanged|WidgetBuilder|ShortcutActivator|Rect|FontWeight)\b/],
	];
	for (const [library, pattern] of sdk) {
		const statement = `import '${library}';`;
		if (pattern.test(example) && !example.includes(statement)) needed.add(statement);
	}
	return [...needed, example].join('\n');
}

function parametersTable(parameters, fields = [], framework = 'flutter') {
	if (!parameters?.length) return '';
	const rows = parameters.map(parameter => {
		const field = fields.find(item => item.name === parameter.name);
		const explanation = parameter.documentation || field?.documentation || memberHelp[parameter.name] || '依公開型別提供此輸入。';
		let defaultValue = parameter.defaultValue;
		if (defaultValue == null) {
			defaultValue = framework === 'flutter' ? 'null' : 'undefined';
			if (parameter.required) defaultValue = '—';
		}
		return `| \`${cell(parameter.name)}\` | \`${cell(parameter.type)}\` | ${parameter.required ? '是' : '否'} | ${cell(defaultValue)} | ${cell(explanation)} |`;
	});
	return `| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |\n| --- | --- | --- | --- | --- |\n${rows.join('\n')}\n`;
}

function apiSection(declaration, framework) {
	const language = framework === 'flutter' ? 'dart' : 'tsx';
	const fields = declaration.members?.filter(member => member.kind === 'field') ?? [];
	const sections = [`## 公開簽名\n\n${code(declaration.signature, language)}`];
	if (declaration.parameters?.length) sections.push(`## ${declaration.renderable && framework === 'react' ? 'Props 與事件' : '參數'}\n\n${parametersTable(declaration.parameters, fields, framework)}`);
	const constructors = declaration.members?.filter(member => member.kind === 'constructor') ?? [];
	const merged = new Set(constructors.flatMap(member => (member.parameters ?? []).map(parameter => parameter.name)));
	for (const constructor of constructors) sections.push(`## 建構子 ${constructor.name}\n\n${constructor.documentation || ''}\n\n${code(constructor.signature, language)}\n\n${parametersTable(constructor.parameters, fields, framework)}`);
	const members = declaration.members?.filter(member => member.kind !== 'constructor' && !(member.kind === 'field' && merged.has(member.name))) ?? [];
	if (members.length) {
		sections.push('## 成員與方法');
		for (const member of members) sections.push(`### ${member.name}\n\n${code(member.signature, language)}\n\n${member.documentation || memberHelp[member.name] || ''}${member.parameters?.length ? `\n\n${parametersTable(member.parameters, [], framework)}` : ''}`);
	}
	return `${apiStart}\n\n${sections.join('\n\n')}\n\n${apiEnd}`;
}

/** 純投影介面：測試可使用小清冊，不依賴平台 SDK 或寫入檔案。 */
export function buildReferenceDocuments({ root, flutterManifest, reactDeclarations }) {
	const declarations = [
		...flutterManifest.modules.flatMap(module => module.declarations).map(declaration => ({ declaration, framework: 'flutter' })),
		...reactDeclarations.map(declaration => ({ declaration, framework: 'react' })),
	];
	const ids = new Set();
	const entries = [];
	const documents = [];
	for (const { declaration, framework } of declarations) {
		if (ids.has(declaration.id)) throw new Error(`Duplicate public id: ${declaration.id}`);
		ids.add(declaration.id);
		const group = category(declaration);
		let filename = slug(declaration.name);
		if (declarations.filter(item => item.framework === framework && category(item.declaration) === group && slug(item.declaration.name) === filename).length > 1) filename += `--${createHash('sha256').update(declaration.id).digest('hex').slice(0, 10)}`;
		const source = `docs/reference/${framework}/${group}/${filename}.md`;
		entries.push({ /* id／framework／name：宣告身份；source／href：唯一來源及網站路由；category：共用分類。 */ id: declaration.id, framework, name: declaration.name, source, href: source.replace(/\.md$/, '.html'), category: group });
	}
	for (const [index, { declaration, framework }] of declarations.entries()) {
		const entry = entries[index];
		const stability = framework === 'react' ? '0.1 · 未發布 npm' : declaration.primarySurface === 'experimental' ? 'Experimental' : 'Stable';
		const sourcePath = declaration.sourceUri?.replace('package:kallopis/', 'flutter/lib/') ?? declaration.source;
		const quickstart = link(entry.source, `docs/reference/${framework}/quickstart.md`);
		const relatedNames = new Set((`${declaration.signature} ${JSON.stringify(declaration.members)} ${JSON.stringify(declaration.parameters)}`).match(/\bKlp[A-Za-z0-9_]+\b/g) ?? []);
		const related = entries.filter(other => other.framework === framework && other.id !== entry.id && relatedNames.has(other.name));
		const relationships = declaration.typeRelationships;
		const inherited = relationships ? [relationships.extends, ...(relationships.mixins ?? []), ...(relationships.implements ?? [])].filter(Boolean) : [];
		const inheritance = inherited.map(name => {
			const baseName = name.split('<')[0];
			const local = entries.find(other => other.framework === framework && other.name === baseName);
			if (local) return `- 繼承／實作：[${name}](${link(entry.source, local.source)})。`;
			const libraries = { /* Flutter 官方型別所屬 library。 */ CustomPainter: 'rendering', ThemeExtension: 'material', ChangeNotifier: 'foundation', LocalizationsDelegate: 'widgets', Intent: 'widgets' };
			const library = libraries[baseName] ?? 'widgets';
			if (['Object', 'Enum'].includes(baseName)) return `- 框架繼承成員：[${baseName}](https://api.dart.dev/dart-core/${baseName}-class.html)。`;
			return `- 框架繼承成員：[${name}](https://api.flutter.dev/flutter/${library}/${baseName}-class.html)。`;
		});
		if (framework === 'react' && (declaration.renderable || /HTMLAttributes/.test(declaration.signature))) inheritance.push('- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。');
		const surfaces = framework === 'flutter' ? (declaration.surfaces ?? []).map(surface => `- \`package:kallopis/kallopis_${surface}.dart\``).join('\n') : '- `@kallopis/react`';
		let example = sample(declaration, framework);
		if (framework === 'flutter') example = sampleImports(example, declaration, declarations);
		const content = `# ${declaration.name}\n\n${framework === 'flutter' ? 'Flutter' : 'React'} · ${stability} · ${labels[entry.category]}\n\n## 主要職責\n\n${responsibility(declaration)}\n\n## 公開入口\n\n${surfaces}\n\n## 速成使用\n\n前置：[平台接入](${quickstart})。以下為接入片段；必要資料由產品提供。\n\n${code(example, framework === 'flutter' ? 'dart' : 'tsx')}\n\n${apiSection(declaration, framework)}\n\n## 使用限制與關聯\n\n${inheritance.join('\n')}\n${related.map(other => `- [${other.name}](${link(entry.source, other.source)})`).join('\n')}\n- [語意與 token 規範](${link(entry.source, 'docs/design-tokens/KALLOPIS-DESIGN-MAP.md')})。\n- [宣告來源](${link(entry.source, sourcePath)})；來源位置不作為 consumer import。\n${declaration.sourceUri ? `- 來源識別：\`${declaration.sourceUri}\`。\n` : ''}`;
		documents.push({ /* source：寫入路徑；content：Markdown 唯一正文。 */ source: entry.source, content });
	}
	return { documents, entries };
}

/** 只更新 API 標記區，保留使用者維護的職責、範例及使用限制。 */
export function updateReferenceDocuments(root, result, check = false) {
	const failures = [];
	for (const document of result.documents) {
		const target = path.join(root, document.source);
		let next = document.content;
		if (fs.existsSync(target)) {
			const previous = fs.readFileSync(target, 'utf8');
			if (!previous.includes(apiStart) || !previous.includes(apiEnd)) throw new Error(`Missing API boundaries: ${document.source}`);
			next = previous.slice(0, previous.indexOf(apiStart)) + document.content.slice(document.content.indexOf(apiStart), document.content.indexOf(apiEnd) + apiEnd.length) + previous.slice(previous.indexOf(apiEnd) + apiEnd.length);
			if (next === previous) continue;
		}
		if (check) failures.push(document.source);
		else {
			// 全部 API 解析完成後，逐頁寫入；不刪除不屬於本清冊的檔案。
			fs.mkdirSync(path.dirname(target), { recursive: true });
			fs.writeFileSync(target, next);
		}
	}
	if (failures.length) throw new Error(`Reference missing or stale: ${failures.join(', ')}`);
}

export function referenceIndexes(entries) {
	return ['flutter', 'react'].map(framework => {
		const source = `docs/reference/${framework}/README.md`;
		const selected = entries.filter(entry => entry.framework === framework);
		const groups = [...new Set(selected.map(entry => entry.category))].sort();
		const sections = groups.map(group => `## ${labels[group]}\n\n${selected.filter(entry => entry.category === group).map(entry => `- [${entry.name}](${link(source, entry.source)})`).join('\n')}`);
		return { source, content: `# Kallopis ${framework === 'flutter' ? 'Flutter' : 'React'} Reference\n\n[速成接入](quickstart.md) · [跨平台索引](../README.md) · [畫面範例](../../examples/README.md)\n\n目前公開清冊：${selected.length} 個宣告。按實際公開能力分類；索引由公開來源產生。\n\n${sections.join('\n\n')}\n` };
	});
}
