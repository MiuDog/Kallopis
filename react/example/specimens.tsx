import { NativeFieldSpecimen } from './advanced-specimens.js';
import { useState, type ComponentType } from 'react';
import { KlpAppLayout, KlpBadge, KlpButton, KlpCard, KlpFileExplorer, KlpFrame, KlpIconButton, KlpLayoutColumn, KlpLayoutDivider, KlpLayoutPane, KlpLayoutRow, KlpLayoutSpacer, KlpSurface, KlpText, KlpTextField, KlpThemeProvider, KlpWorkspace, applyKlpStyleOverrides, createKlpStylePack, useKlp, type KlpMode } from '@kallopis/react';
import { CommandsDemo } from './commands-demo.js';
import { DockDemo } from './dock-demo.js';
import { reactSpecimenRegistry } from './specimen-registry.mjs';
import { ModernProductivityPreview } from './modern-productivity-preview.js';
import { DesktopSpecimen } from './desktop-specimens.js';
import { desktopComponentNames } from './desktop-catalog-data.mjs';

interface SpecimenProps {
	/* name是公開路由identity，compound fixture據此選當次實際target與參數。 */
	name: string;
}

/* registry資料與實際factory分離；同一份name清單供網站直接讀取。 */
const factories = { basic: BasicSpecimen, layout: LayoutSpecimen, command: CommandSpecimen, dock: DockSpecimen, theme: ThemeSpecimen };
const specimens: Readonly<Record<string, ComponentType<SpecimenProps>>> = Object.fromEntries(Object.entries(reactSpecimenRegistry).map(([name, kind]) => [name, factories[kind]]));
export const reactSpecimenNames = Object.freeze(Object.keys(reactSpecimenRegistry).sort());
const modes: readonly KlpMode[] = ['light', 'dark', 'ultraDark', 'transparent'];

export function SpecimenApp({ name }: SpecimenProps) {
	if (name === 'KlpModernProductivityLayout') return <ModernProductivityPreview id="modern-productivity-layout" />;
	return <StandardSpecimenApp name={name} />;
}

function StandardSpecimenApp({ name }: SpecimenProps) {

	/* mode／alternate／width屬展示環境；epoch只在明確重設時重建fixture，不隨theme切換。 */
	const [mode, setMode] = useState<KlpMode>('light');
	const [alternate, setAlternate] = useState(false);
	const [width, setWidth] = useState(760);
	const [epoch, setEpoch] = useState(0);
	const [base] = useState(createKlpStylePack);
	const [spacious] = useState(() => applyKlpStyleOverrides(base, { /* semantics按正式ID對應四模式值，沒有第二份預設style。 */ semantics: { 'theme.spacing.contentStackGap': { light: 'p(space600)', dark: 'p(space600)', ultraDark: 'p(space600)', transparent: 'p(space600)' }, 'theme.spacing.actionGap': { light: 'p(space300)', dark: 'p(space300)', ultraDark: 'p(space300)', transparent: 'p(space300)' } } }));
	const Fixture = Object.hasOwn(specimens, name) ? specimens[name] : undefined;
	function reset() { setEpoch(value => value + 1); }
	function togglePack() { setAlternate(value => !value); }
	function toggleWidth() { setWidth(value => value === 760 ? 320 : 760); }
	return <KlpThemeProvider mode={mode} stylePack={alternate ? spacious : base} className="demo-app">
		<main className="demo-main">
			<KlpText as="h1" role="h2">{Fixture ? name : '找不到元件展示'}</KlpText>
			{Fixture ? <>
				<KlpText role="code">import {'{ '}{name}{' }'} from '@kallopis/react';</KlpText>
				<div className="demo-row" aria-label="展示環境">
					{modes.map(value => <KlpButton key={value} size="sm" selected={mode === value} onClick={() => setMode(value)}>{value}</KlpButton>)}
					<KlpButton selected={alternate} onClick={togglePack}>風格檔：{alternate ? '寬鬆' : '預設'}</KlpButton>
					<KlpButton onClick={toggleWidth}>展示寬度：{width}</KlpButton>
					<KlpButton onClick={reset}>重設展示</KlpButton>
				</div>
				<div style={{ /* width/maxWidth僅定義產品可用測量空間，視覺全部由公開元件負責。 */ width, maxWidth: '100%', minWidth: 0 }} data-specimen={name}><Fixture key={epoch} name={name} /></div>
				<KlpText as="p" role="caption">參數與回呼狀態由這份展示擁有；元件依共同語意呈現。透明模式顯示宿主底色。</KlpText>
			</> : <KlpText as="p" role="body-strong" aria-live="polite">未註冊的公開名稱：{name || '空值'}。請從下方元件清單選擇。</KlpText>}
			<details><summary>所有 React 元件展示</summary><ul>{reactSpecimenNames.map(value => <li key={value}><a href={`?specimen=${encodeURIComponent(value)}`}>{value}</a></li>)}</ul></details>
		</main>
	</KlpThemeProvider>;
}

function BasicSpecimen({ name }: SpecimenProps) {
	return desktopComponentNames.includes(name) ? <DesktopSpecimen name={name} /> : <OriginalBasicSpecimen name={name} />;
}

function OriginalBasicSpecimen({ name }: SpecimenProps) {

	/* text／changed／disabled是當次元件props；count是原callback觀察；selection／expanded屬Explorer資料。 */
	const [text, setText] = useState('展示內容');
	const [changed, setChanged] = useState(false);
	const [disabled, setDisabled] = useState(false);
	const [count, setCount] = useState(0);
	const [selection, setSelection] = useState('first');
	const [expanded, setExpanded] = useState(['files']);
	function click() { setCount(value => value + 1); }
	function toggle() { setChanged(value => !value); }
	function toggleDisabled() { setDisabled(value => !value); }
	function select(id: string) { setSelection(id); click(); }
	function expand(id: string) { setExpanded(values => values.includes(id) ? values.filter(value => value !== id) : [...values, id]); click(); }
	const input = <KlpTextField label="元件內草稿" value={text} onChange={event => setText(event.target.value)} />;
	let preview;
	let parameter;
	let example;
	switch (name) {
		case 'KlpText':
			parameter = '文字角色與弱化'; example = '<KlpText role="h2" tone="muted">文字</KlpText>';
			preview = <KlpText role={changed ? 'h2' : 'body'} tone={changed ? 'muted' : 'primary'}>{text}</KlpText>; break;
		case 'KlpSurface':
			parameter = '表面層級'; example = '<KlpSurface tone="raised">內容</KlpSurface>';
			preview = <KlpSurface tone={changed ? 'raised' : 'inset'} className="demo-surface"><KlpText>{text}</KlpText></KlpSurface>; break;
		case 'KlpBadge':
			parameter = '狀態語意'; example = '<KlpBadge tone="success">完成</KlpBadge>';
			preview = <KlpBadge tone={changed ? 'success' : 'neutral'}>{text}</KlpBadge>; break;
		case 'KlpCard':
			parameter = '表面與頁首／頁尾'; example = '<KlpCard header="標題" footer="狀態">內容</KlpCard>';
			preview = <KlpCard tone={changed ? 'raised' : 'base'} header={changed ? text : undefined} footer={changed ? '頁尾' : undefined}>{input}</KlpCard>; break;
		case 'KlpButton':
			parameter = '尺寸／語意／選取'; example = '<KlpButton selected onClick={handle}>執行</KlpButton>';
			preview = <KlpButton size={changed ? 'lg' : 'sm'} tone={changed ? 'primary' : 'secondary'} selected={changed} disabled={disabled} onClick={click}>{text}</KlpButton>; break;
		case 'KlpIconButton':
			parameter = '尺寸／角色／選取'; example = '<KlpIconButton label="新增" onClick={handle}>+</KlpIconButton>';
			preview = <KlpIconButton label={text} size={changed ? 'lg' : 'sm'} tone={changed ? 'inline' : 'standalone'} selected={changed} disabled={disabled} onClick={click}>+</KlpIconButton>; break;
		case 'KlpTextField':
			parameter = '錯誤與提示'; example = '<KlpTextField label="名稱" value={value} onChange={handle} error={error} />';
			preview = <><NativeFieldSpecimen /><KlpTextField label="元件輸入" value={text} disabled={disabled} error={changed} hint={changed ? '產品提供錯誤說明' : '輸入回呼由產品保存'} onChange={event => { setText(event.target.value); click(); }} /></>; break;
		case 'KlpFileExplorer':
			parameter = '資料標籤'; example = '<KlpFileExplorer sections={sections} expandedIds={expanded} selectedId={selected} onToggle={toggle} onSelect={select} />';
			preview = <KlpFileExplorer label="元件檔案清單" sections={[{ /* id是section stablekey，label是可改的產品資料，items為可選取產品項目。 */ id: 'files', label: changed ? text : '檔案', items: [{ id: 'first', label: 'scene.json' }, { id: 'second', label: 'materials' }] }]} expandedIds={expanded} selectedId={selection} onToggle={expand} onSelect={select} />; break;
		case 'KlpFrame':
			parameter = '區域角色與頁尾'; example = '<KlpFrame role="sidebar" header="工具" footer="狀態">內容</KlpFrame>';
			preview = <KlpFrame role={changed ? 'sidebar' : 'content'} header={text} footer={changed ? '產品頁尾' : undefined}>{input}</KlpFrame>; break;
		case 'KlpWorkspace':
			parameter = '增加輔助 Frame'; example = '<KlpWorkspace><KlpFrame role="sidebar">工具</KlpFrame><KlpFrame>內容</KlpFrame></KlpWorkspace>';
			preview = <KlpWorkspace><KlpFrame role="sidebar" header="工具"><KlpText>{text}</KlpText></KlpFrame><KlpFrame header="內容">{input}</KlpFrame>{changed && <KlpFrame role="auxiliary" header="輔助"><KlpText>產品附加區域</KlpText></KlpFrame>}</KlpWorkspace>; break;
		default: throw new Error(`Invalid basic specimen: ${name}`);
	}
	return <div className="demo-stack">
		<KlpTextField label="內容參數" value={text} onChange={event => setText(event.target.value)} />
		<div className="demo-row"><KlpButton selected={changed} onClick={toggle}>{parameter}：{changed ? '變更' : '預設'}</KlpButton>{['KlpButton', 'KlpIconButton', 'KlpTextField'].includes(name) && <KlpButton selected={disabled} onClick={toggleDisabled}>停用：{disabled ? '開' : '關'}</KlpButton>}</div>
		<KlpCard header={<KlpText role="label">實際 {name}</KlpText>}>{preview}</KlpCard>
		<KlpText role="caption" aria-live="polite">回呼 {count} 次 · 值：{text} · 選取：{selection} · 展開：{expanded.join(', ') || '無'}</KlpText>
		<pre><code>{example}</code></pre>
	</div>;
}

function LayoutSpecimen({ name }: SpecimenProps) {

	/* changed調整當次target的公開限制或對齊；text是保持於布局內的產品輸入。 */
	const [changed, setChanged] = useState(false);
	const [text, setText] = useState('布局內草稿');
	function toggle() { setChanged(value => !value); }
	const linearChanged = changed && ['KlpLayoutRow', 'KlpLayoutColumn'].includes(name);
	const pane = <KlpLayoutPane flex={name === 'KlpLayoutPane' ? 0 : 1} bounds={{ /* preferred是產品主軸偏好，minimum／maximum限制合法範圍；只有Pane展示改偏好。 */ preferred: changed && name === 'KlpLayoutPane' ? 150 : 90, minimum: 10, maximum: 180 }}><KlpCard><KlpTextField label="布局內草稿" value={text} onChange={event => setText(event.target.value)} /></KlpCard></KlpLayoutPane>;
	const spacer = <KlpLayoutSpacer flex={changed ? 3 : 1} />;
	const divider = <KlpLayoutDivider hidden={name === 'KlpLayoutDivider' && changed} />;
	const children = <>{pane}{name === 'KlpLayoutSpacer' ? spacer : divider}<KlpLayoutPane flex={1}><KlpSurface className="demo-surface"><KlpText>另一個 Pane</KlpText></KlpSurface></KlpLayoutPane></>;
	const linear = name === 'KlpLayoutColumn' ? <KlpLayoutColumn alignment={linearChanged ? 'end' : 'start'} spacing={linearChanged ? 'none' : 'standard'}>{children}</KlpLayoutColumn> : <KlpLayoutRow alignment={linearChanged ? 'end' : 'start'} spacing={linearChanged ? 'none' : 'standard'}>{children}</KlpLayoutRow>;
	let parameter;
	let example;
	switch (name) {
		case 'KlpAppLayout': parameter = changed ? 'inset: none' : 'inset: standard'; example = '<KlpAppLayout inset={inset}><KlpLayoutRow><KlpLayoutPane flex={1}>內容</KlpLayoutPane></KlpLayoutRow></KlpAppLayout>'; break;
		case 'KlpLayoutPane': parameter = changed ? 'preferred: 150' : 'preferred: 90'; example = '<KlpAppLayout><KlpLayoutRow><KlpLayoutPane flex={0} bounds={bounds}>內容</KlpLayoutPane><KlpLayoutPane flex={1}>另一區域</KlpLayoutPane></KlpLayoutRow></KlpAppLayout>'; break;
		case 'KlpLayoutSpacer': parameter = changed ? 'flex: 3' : 'flex: 1'; example = '<KlpAppLayout><KlpLayoutRow><KlpLayoutPane flex={1}>內容</KlpLayoutPane><KlpLayoutSpacer flex={flex} /><KlpLayoutPane flex={1}>另一區域</KlpLayoutPane></KlpLayoutRow></KlpAppLayout>'; break;
		case 'KlpLayoutDivider': parameter = changed ? 'hidden: true' : 'hidden: false'; example = '<KlpAppLayout><KlpLayoutRow><KlpLayoutPane flex={1}>內容</KlpLayoutPane><KlpLayoutDivider hidden={hidden} /><KlpLayoutPane flex={1}>另一區域</KlpLayoutPane></KlpLayoutRow></KlpAppLayout>'; break;
		default: parameter = linearChanged ? 'alignment: end / spacing: none' : 'alignment: start / spacing: standard'; example = `<KlpAppLayout><${name} alignment={alignment} spacing={spacing}><KlpLayoutPane flex={1}>內容</KlpLayoutPane><KlpLayoutPane flex={1}>另一區域</KlpLayoutPane></${name}></KlpAppLayout>`;
	}
	return <div className="demo-stack">
		<KlpButton selected={changed} onClick={toggle}>變更 {name} 參數：{changed ? '開' : '關'}</KlpButton>
		<div style={{ /* 有限height是產品提供的布局測量空間，寬度沿當前展示宿主。 */ height: 280, width: '100%', minWidth: 0 }}><KlpAppLayout inset={changed && name === 'KlpAppLayout' ? 'none' : 'standard'}>{linear}</KlpAppLayout></div>
		<KlpText role="caption">當次參數：{parameter} · 草稿：{text}</KlpText>
		<pre><code>{example}</code></pre>
	</div>;
}

function ThemeSpecimen() {
	const theme = useKlp();
	return <KlpCard header={<KlpText role="label">Provider 的實際解析值</KlpText>}><div className="demo-stack"><KlpText>目前模式：{theme.mode} · contentStackGap：{String(theme.semantic('theme.spacing.contentStackGap'))}</KlpText><KlpButton>同一 Provider 的按鈕</KlpButton><KlpTextField label="Provider 內草稿" defaultValue="切換風格仍保留" /><pre><code>{'<KlpThemeProvider mode={mode} stylePack={pack}><Product /></KlpThemeProvider>'}</code></pre></div></KlpCard>;
}
function CommandSpecimen({ name }: SpecimenProps) {
	let example;
	switch (name) {
		case 'KlpCommandShortcutHost': example = '<KlpCommandShortcutHost keymap={keymap} getContext={getContext} getFocus={getFocus} onHandling={onHandling} onResult={onResult}><Product /></KlpCommandShortcutHost>'; break;
		case 'KlpRegisteredCommandPalette': example = '<KlpRegisteredCommandPalette registry={registry} getContext={getContext} open={open} label="命令面板" searchLabel="搜尋命令" emptyLabel="沒有符合的命令" onResult={onResult} onDismiss={onDismiss} />'; break;
		case 'KlpRegisteredCommandPopup': example = '<KlpRegisteredCommandPopup registry={registry} getContext={getContext} items={items} open={open} anchor={anchor} label="快顯命令" emptyLabel="目前沒有命令" onResult={onResult} onDismiss={onDismiss} />'; break;
		case 'KlpRegisteredCommandMenu': example = '<KlpRegisteredCommandMenu registry={registry} getContext={getContext} items={items} label="命令選單" emptyLabel="目前沒有命令" onResult={onResult} />'; break;
		default: example = '<KlpRegisteredCommandToolbar registry={registry} getContext={getContext} items={items} label="命令工具列" onResult={onResult} />';
	}
	return <div className="demo-stack"><CommandsDemo specimen={name} /><KlpText role="caption">公開入口以同一份 registry、產品 context 與結果回呼組裝；此 route 只顯示當次入口。快捷鍵：Primary+S 儲存。</KlpText><pre><code>{example}</code></pre></div>;
}
function DockSpecimen() { return <div className="demo-stack"><DockDemo /><pre><code>{'<KlpDockLayout layout={layout} panels={panels} stage={stage} leftConstraints={left} rightConstraints={right} onLayoutChanged={setLayout} />'}</code></pre></div>; }

/** Catalog 直接呈現既有真實 fixture，不複製元件實作。 */
export function CatalogSpecimen({ name }: SpecimenProps) {
	const Fixture = specimens[name];
	return Fixture ? <Fixture name={name} /> : <KlpText>未登錄元件：{name}</KlpText>;
}
