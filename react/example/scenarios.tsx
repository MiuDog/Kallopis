import { useEffect, useRef, useState } from 'react';
import { KlpButton, KlpCommandKeymap, KlpCommandRegistry, KlpCommandShortcutHost, KlpDockLayout, KlpFileExplorer, KlpFrame, KlpRegisteredCommandMenu, KlpRegisteredCommandPalette, KlpRegisteredCommandToolbar, KlpSurface, KlpText, KlpTextField, KlpThemeProvider, applyKlpDockAction, applyKlpStyleOverrides, createKlpStylePack, encodeKlpDockLayout, restoreKlpDockLayout, type KlpCommandExecutionResult, type KlpCommandReference, type KlpDockLayoutData, type KlpDockPanel, type KlpMode, type KlpShortcutFocus } from '@kallopis/react';
import { reactScenarioRegistry } from './scenario-registry.mjs';

import { IdeWorkbench } from './ide-workbench.js';

type SceneId = keyof typeof reactScenarioRegistry;
interface SceneData {
	/* 標籤／檔案與分區是產品示意資料，不能升格為庫模板。 */
	left: readonly string[];
	right: readonly string[];
	bottom: readonly string[];
	files: readonly string[];
	action: string;
	draft: string;
}
const scenes: Record<Exclude<SceneId, 'ide'>, SceneData> = {
	vscode: { left: ['Explorer', 'Search'], right: ['Outline'], bottom: ['Output', 'Problems'], files: ['main.ts', 'theme.ts', 'README.md'], action: '執行檢查', draft: 'export const greeting = "Kallopis";\n// 正文編輯器核心由產品接入。' },
	blockbench: { left: ['Outliner', 'Tools'], right: ['Properties', 'Textures'], bottom: ['Animations'], files: ['Cube', 'Head', 'Body'], action: '新增方塊', draft: 'untitled_model.bbmodel' },
	blender: { left: ['Tools'], right: ['Outliner', 'Properties'], bottom: ['Timeline'], files: ['Cube', 'Camera', 'Light'], action: '移動物件', draft: 'workspace.blend' },
};
const modes: readonly KlpMode[] = ['light', 'dark', 'ultraDark', 'transparent'];
const commandItems: readonly KlpCommandReference[] = [{ commandId: 'layout.save' }, { commandId: 'layout.restore' }, { commandId: 'layout.reset' }, { commandId: 'scene.run' }, { commandId: 'panel.bottom', kind: 'toggle' }];

function initialLayout(id: Exclude<SceneId, 'ide'>): KlpDockLayoutData {
	const scene = scenes[id];
	return {
		left: { axis: 'vertical', isVisible: true, extent: 180, groups: [{ id: 'navigation', panelIds: [...scene.left], activePanelId: scene.left[0], mainAxisExtent: 320 }] },
		right: { axis: 'vertical', isVisible: true, extent: 190, groups: scene.right.map((panel, index) => ({ id: `properties-${index}`, panelIds: [panel], activePanelId: panel, mainAxisExtent: 210 })) },
		bottom: { axis: 'horizontal', isVisible: true, extent: 120, groups: [{ id: 'messages', panelIds: [...scene.bottom], activePanelId: scene.bottom[0], mainAxisExtent: 320 }] },
	};
}

export function ScenarioApp({ id }: { id: string }) {
	if (id === 'ide') return <IdeWorkbench />;
	/* 環境改變保持同產品owner；epoch只代表明確重設。 */
	const [mode, setMode] = useState<KlpMode>('light');
	const [alternate, setAlternate] = useState(false);
	const [epoch, setEpoch] = useState(0);
	const [base] = useState(createKlpStylePack);
	const [spacious] = useState(() => applyKlpStyleOverrides(base, { semantics: { 'theme.spacing.contentStackGap': { light: 'p(space600)', dark: 'p(space600)', ultraDark: 'p(space600)', transparent: 'p(space600)' }, 'theme.spacing.actionGap': { light: 'p(space300)', dark: 'p(space300)', ultraDark: 'p(space300)', transparent: 'p(space300)' } } }));
	if (!Object.hasOwn(reactScenarioRegistry, id)) return <main><h1>找不到 GUI 場景</h1><p>未註冊的場景：{id}</p><a href="?scenario=vscode">返回場景入口</a></main>;
	const sceneId = id as Exclude<SceneId, 'ide'>;
	return <KlpThemeProvider mode={mode} stylePack={alternate ? spacious : base}><main className="scenario-app demo-stack">
		<KlpText as="h1" role={window.parent === window ? "h1" : "h2"}>{reactScenarioRegistry[sceneId].title}</KlpText>
		<nav className="demo-row" aria-label="GUI 場景">{Object.entries(reactScenarioRegistry).map(([name, scene]) => <a key={name} href={`?scenario=${name}`}>{scene.title}</a>)}</nav>
		<div className="demo-row" aria-label="展示環境">{modes.map(value => <KlpButton key={value} selected={mode === value} onClick={() => setMode(value)}>{value}</KlpButton>)}<KlpButton selected={alternate} onClick={() => setAlternate(value => !value)}>風格：{alternate ? '寬鬆' : '預設'}</KlpButton><KlpButton onClick={() => setEpoch(value => value + 1)}>重設場景</KlpButton></div>
		<ScenarioWorkbench key={`${id}-${epoch}`} id={sceneId} />
		<KlpText role="caption">復刻資訊區塊與工作台操作；3D、正文編輯器及終端是示意，核心由產品接入。</KlpText>
		<a href={reactScenarioRegistry[sceneId].reference} target="_blank" rel="noopener">官方布局參考 ↗</a>
		<details><summary>公開元件組裝</summary><KlpText as="code" role="code">KlpThemeProvider → KlpCommandShortcutHost → KlpRegisteredCommandToolbar／Menu／Palette ＋ KlpDockLayout → KlpFileExplorer／KlpFrame／KlpSurface／KlpTextField</KlpText></details>
	</main></KlpThemeProvider>;
}

interface SceneContext {
	/* 命令只讀當前產品context；函式與可用性由同一owner投影。 */
	save: () => string;
	restore: () => string;
	reset: () => string;
	run: () => string;
	toggle: () => string;
	search: () => void;
	hasSaved: boolean;
	bottomVisible: boolean;
}

function approveClose() { return true; }

function ScenarioWorkbench({ id }: { id: Exclude<SceneId, 'ide'> }) {
	const scene = scenes[id];
	const [layout, setLayout] = useState(() => initialLayout(id));
	const [draft, setDraft] = useState(scene.draft);
	const [saved, setSaved] = useState('');
	const [selected, setSelected] = useState(scene.files[0]);
	const [expanded, setExpanded] = useState(['project']);
	const [workspace, setWorkspace] = useState('Layout');
	const [frame, setFrame] = useState('1');
	const [rotation, setRotation] = useState(0);
	const [operations, setOperations] = useState(0);
	const [layoutCount, setLayoutCount] = useState(0);
	const [explorerCount, setExplorerCount] = useState(0);
	const [commandCount, setCommandCount] = useState(0);
	const [message, setMessage] = useState('拖動面板分頁、分隔線或使用命令。');
	const [paletteOpen, setPaletteOpen] = useState(false);
	const [menuOpen, setMenuOpen] = useState(false);
	const [shortcut, setShortcut] = useState('尚未按鍵');
	const [owners, setOwners] = useState<{ registry: KlpCommandRegistry<SceneContext>; keymap: KlpCommandKeymap<SceneContext> } | null>(null);
	const contextRef = useRef<SceneContext>(null!);
	/* 原生焦點在草稿／其他區域間切換時具有穩定identity，不鏡像editor模型。 */
	const focusIds = useRef(new WeakMap<EventTarget, string>());
	const focusCounter = useRef(0);
	const panels: readonly KlpDockPanel[] = [...scene.left, ...scene.right, ...scene.bottom].map(label => ({ id: label, label, content: panel(label), onCloseRequested: approveClose }));
	const policies = panels.map(({ id: panelId, allowSide, allowBottom }) => ({ id: panelId, allowSide, allowBottom }));
	const available = restoreKlpDockLayout(encodeKlpDockLayout(layout), policies).availablePanelIds;

	function commit(value: KlpDockLayoutData) { setLayout(value); setLayoutCount(count => count + 1); }
	function save() { setSaved(encodeKlpDockLayout(layout)); return '布局已保存到展示 JSON'; }
	function restore() {
		const result = restoreKlpDockLayout(saved, policies);
		if (encodeKlpDockLayout(result.layout) !== encodeKlpDockLayout(layout)) commit(result.layout);
		return '布局已還原，正文與選取保持';
	}
	function reset() { if (encodeKlpDockLayout(layout) !== encodeKlpDockLayout(initialLayout(id))) commit(initialLayout(id)); return '布局已重設，草稿保持'; }
	function run() { setOperations(count => count + 1); setRotation(value => value + 15); return `${scene.action}：${selected}（示意）`; }
	function toggle() {
		const result = applyKlpDockAction(layout, policies, { type: 'visibility', area: 'bottom', isVisible: !layout.bottom.isVisible });
		if (result.changed) commit(result.layout);
		return '底部區域已切換';
	}
	function getContext() { return contextRef.current; }
	contextRef.current = { save, restore, reset, run, toggle, search: () => setPaletteOpen(true), hasSaved: !!saved, bottomVisible: layout.bottom.isVisible };
	useEffect(() => {
		const registry = new KlpCommandRegistry<SceneContext>();
		registry.register({ id: 'layout.save', label: '保存布局', category: '工作區', handler: context => context.save() });
		registry.register({ id: 'layout.restore', label: '還原布局', category: '工作區', isEnabled: context => context.hasSaved, handler: context => context.restore() });
		registry.register({ id: 'layout.reset', label: '重設布局', category: '工作區', handler: context => context.reset() });
		registry.register({ id: 'scene.run', label: scene.action, category: '場景', handler: context => context.run() });
		registry.register({ id: 'panel.bottom', label: '底部面板', category: '視圖', isChecked: context => context.bottomVisible, handler: context => context.toggle() });
		registry.register({ id: 'command.search', label: '搜尋命令', category: '工作區', handler: context => context.search() });
		const platform = navigator.platform.toLowerCase().includes('mac') ? 'mac' : 'other';
		const keymap = new KlpCommandKeymap(registry, { platform });
		keymap.register({ id: 'save.primary', commandId: 'layout.save', sequence: [{ key: 's', primary: true }], scope: 'app', allowInEditable: true });
		keymap.register({ id: 'save.chord', commandId: 'layout.save', sequence: [{ key: 'k', primary: true }, { key: 's' }], scope: 'app', allowInEditable: true });
		keymap.register({ id: 'search.primary', commandId: 'command.search', sequence: [{ key: 'p', primary: true, shift: true }], scope: 'app', allowInEditable: true });
		setOwners({ registry, keymap });
		return () => { keymap.dispose(); registry.dispose(); };
	}, [id, scene.action]);
	useEffect(() => { owners?.registry.refresh(); }, [owners, saved, layout.bottom.isVisible]);

	function getFocus(target: EventTarget | null): KlpShortcutFocus {
		if (target && !focusIds.current.has(target)) focusIds.current.set(target, `scene-focus-${++focusCounter.current}`);
		const element = target instanceof Element ? target : null;
		return { focusId: target ? focusIds.current.get(target)! : 'scene-root', pageId: id, editable: !!element?.closest('input,textarea,[contenteditable="true"]') };
	}
	function result(value: KlpCommandExecutionResult) {
		setCommandCount(count => count + 1);
		if (value.status === 'executed') setMessage(String(value.value ?? '命令完成'));
		else if (value.status === 'error') setMessage(`命令失敗，布局保留：${String(value.error)}`);
		else setMessage(`命令狀態：${value.status}`);
	}
	function select(value: string) { setSelected(value); setExplorerCount(count => count + 1); }
	function toggleExplorer(value: string) { setExpanded(values => values.includes(value) ? values.filter(item => item !== value) : [...values, value]); setExplorerCount(count => count + 1); }
	function open(panelId: string) {
		const group = layout.left.groups[0];
		const destination = group ? { kind: 'tab' as const, area: 'left' as const, groupId: group.id, index: group.panelIds.length } : { kind: 'group' as const, area: 'left' as const, groupId: 'reopened', index: 0, extent: 280 };
		const result = applyKlpDockAction(layout, policies, { type: 'open', panelId, destination });
		if (result.changed) commit(result.layout);
	}
	function switchWorkspace(value: string) {
		setWorkspace(value);
		const result = applyKlpDockAction(layout, policies, { type: 'resizeArea', area: 'bottom', extent: value === 'Animation' ? 180 : 120 });
		if (result.changed) commit(result.layout);
	}
	function explorer(label: string) {
		return <KlpFileExplorer label={label} sections={[{ id: 'project', label: id === 'vscode' ? 'KALLOPIS' : 'Scene Collection', items: scene.files.map(file => ({ id: file, label: file })) }]} expandedIds={expanded} selectedId={selected} onSelect={select} onToggle={toggleExplorer} />;
	}
	function panel(label: string) {
		if (['Explorer', 'Outliner'].includes(label)) return explorer(label);
		if (label === 'Search') return <div className="demo-dock-content"><KlpTextField label="搜尋檔案" defaultValue="theme" /><KlpText role="caption">theme.ts · 2 results（示意）</KlpText></div>;
		if (label === 'Tools') return <div className="demo-dock-content">{['Select', 'Move', 'Rotate', 'Scale'].map(tool => <KlpButton key={tool} onClick={() => setMessage(`工具：${tool}（示意）`)}>{tool}</KlpButton>)}</div>;
		if (label === 'Properties') return <div className="demo-dock-content"><KlpText role="label">{selected}</KlpText><KlpTextField label="物件名稱" value={selected} onChange={event => setSelected(event.target.value)} />{['X', 'Y', 'Z'].map(axis => <KlpTextField key={axis} label={`Position ${axis}`} defaultValue="0" />)}</div>;
		if (label === 'Textures') return <div className="demo-dock-content"><KlpButton onClick={() => setMessage('已選取 wood.png（示意）')}>wood.png</KlpButton><KlpText role="caption">16 × 16 · 材質示意</KlpText></div>;
		if (['Timeline', 'Animations'].includes(label)) return <div className="demo-dock-content"><div className="demo-row"><KlpButton onClick={run}>播放（示意）</KlpButton><KlpTextField label="目前影格" value={frame} onChange={event => setFrame(event.target.value)} /></div><KlpText as="code" role="code">1 ────── 20 ────── 40 ────── 60</KlpText></div>;
		if (label === 'Outline') return <div className="demo-dock-content"><KlpText role="caption">greeting · exported constant</KlpText><KlpText role="caption">Main · function（示意）</KlpText></div>;
		return <div className="demo-dock-content"><KlpText as="code" role="code">{label === 'Problems' ? '0 errors · 0 warnings（示意）' : `Kallopis · 操作 ${operations} 次 · ${message}`}</KlpText></div>;
	}
	function stage() {
		if (id === 'vscode') return <KlpFrame role="content" className="scenario-editor" header={<div className="demo-row">{scene.files.map(file => <KlpButton key={file} size="sm" selected={selected === file} onClick={() => select(file)}>{file}</KlpButton>)}</div>}><KlpSurface tone="inset" className="demo-dock-stage"><KlpText role="caption">{selected} · 正文編輯示意</KlpText><textarea aria-label="正文草稿" className="demo-style-json" value={draft} onChange={event => setDraft(event.target.value)} /></KlpSurface></KlpFrame>;
		return <KlpSurface tone="inset" className="demo-dock-stage"><KlpText role="label">{workspace} · 3D Viewport（示意）</KlpText><KlpTextField label="場景草稿" value={draft} onChange={event => setDraft(event.target.value)} /><svg className="scenario-canvas" viewBox="0 0 300 220" role="img" aria-label={`${selected} 立方體示意`}><g className="scenario-grid">{[20, 60, 100, 140, 180, 220, 260].map(value => <path key={value} d={`M${value} 0V220 M0 ${value}H300`} />)}</g><g transform={`rotate(${rotation},150,110)`} className="scenario-object"><path d="M90 75L150 40L210 75L210 145L150 180L90 145Z M90 75L150 110L210 75 M150 110V180" /></g></svg><KlpText role="caption">選取：{selected} · 操作：{operations} · 影格：{frame}</KlpText></KlpSurface>;
	}
	if (!owners) return <KlpText>命令入口載入中…</KlpText>;
	return <KlpCommandShortcutHost keymap={owners.keymap} getContext={getContext} getFocus={getFocus} onHandling={value => setShortcut(`${value.state} · ${value.bindingId ?? '無'}`)} onResult={result}>
		<div className="demo-stack"><div className="demo-row"><KlpButton selected={menuOpen} onClick={() => setMenuOpen(value => !value)}>工作區選單</KlpButton><KlpButton onClick={() => setPaletteOpen(true)}>命令面板</KlpButton>{id === 'blender' && ['Layout', 'Modeling', 'Animation'].map(value => <KlpButton key={value} selected={workspace === value} onClick={() => switchWorkspace(value)}>{value}</KlpButton>)}</div>
			{menuOpen && <KlpRegisteredCommandMenu registry={owners.registry} getContext={getContext} items={commandItems} label="工作區選單命令" emptyLabel="沒有可用命令" onResult={result} />}
			<KlpRegisteredCommandToolbar registry={owners.registry} getContext={getContext} items={commandItems} label="場景命令工具列" onResult={result} />
			<div className="scenario-dock"><KlpDockLayout label={`${id} 工作區`} layout={layout} panels={panels} leftConstraints={{ minExtent: 100, maxExtent: 320 }} rightConstraints={{ minExtent: 120, maxExtent: 320 }} bottomConstraints={{ minExtent: 70, maxExtent: 240 }} onLayoutChanged={commit} onCloseError={error => setMessage(`關閉失敗：${String(error)}`)} contentHeader={<KlpSurface tone="raised" className="demo-dock-header"><KlpText role="caption">{id === 'vscode' ? 'Editor Group' : 'Scene'} · {selected}</KlpText></KlpSurface>} stage={stage()} /></div>
			<KlpText role="caption" aria-live="polite">布局 {layoutCount} 次 · Explorer {explorerCount} 次 · 命令 {commandCount} 次 · {message} · 快捷鍵：{shortcut}</KlpText>
			<div className="demo-row">{available.map(panelId => <KlpButton key={panelId} onClick={() => open(panelId)}>重開 {panelId}</KlpButton>)}</div>
			<details><summary>保存的布局 JSON</summary><textarea aria-label="保存布局 JSON" className="demo-style-json" value={saved} onChange={event => setSaved(event.target.value)} /></details>
		</div>
		<KlpRegisteredCommandPalette registry={owners.registry} getContext={getContext} open={paletteOpen} label="場景命令面板" searchLabel="搜尋場景命令" emptyLabel="沒有符合的命令" onResult={result} onDismiss={() => setPaletteOpen(false)} />
	</KlpCommandShortcutHost>;
}
