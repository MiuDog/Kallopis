import { useCallback, useMemo, useRef, useState } from 'react';
import { KlpDockLayout, KlpCard, KlpSurface, KlpText, KlpButton, KlpTextField, encodeKlpDockLayout, restoreKlpDockLayout, applyKlpDockAction, type KlpDockLayoutData, type KlpDockPanel, type KlpDockAction } from '@kallopis/react';

/** 初始布局是此展示產品的選擇，不是庫的預設布局。 */
const initialLayout: KlpDockLayoutData = {
	left: { axis: 'vertical', isVisible: true, extent: 180, groups: [{ id: 'navigation', panelIds: ['explorer', 'search'], activePanelId: 'explorer', mainAxisExtent: 240 }] },
	right: { axis: 'vertical', isVisible: true, extent: 180, groups: [{ id: 'properties', panelIds: ['inspector'], activePanelId: 'inspector', mainAxisExtent: 200 }, { id: 'history-group', panelIds: ['history'], activePanelId: 'history', mainAxisExtent: 160 }] },
	bottom: { axis: 'horizontal', isVisible: true, extent: 120, groups: [{ id: 'messages', panelIds: ['output'], activePanelId: 'output', mainAxisExtent: 240 }] },
};
const areaNames = ['left', 'right', 'bottom'] as const;

export function DockDemo() {
	const [layout, setLayout] = useState(initialLayout);
	const [width, setWidth] = useState(760);
	const [height, setHeight] = useState(460);
	const [source, setSource] = useState('');
	const [message, setMessage] = useState('拖動分頁到另一分頁列、面板正文或 Stage 邊緣。');
	const [count, setCount] = useState(0);
	const [draft, setDraft] = useState('未命名場景');
	const [closeMode, setCloseMode] = useState<'approve' | 'deny' | 'delay'>('approve');
	/** callback 身分保持固定，批准模式由產品最新值決定。 */
	const closeModeRef = useRef(closeMode);
	closeModeRef.current = closeMode;
	const approveClose = useCallback(() => {
		if (closeModeRef.current === 'delay') return new Promise<boolean>(resolve => window.setTimeout(() => resolve(true), 1200));
		return closeModeRef.current === 'approve';
	}, []);
	const panels = useMemo<readonly KlpDockPanel[]>(() => [
		{ id: 'explorer', label: 'Explorer', isPinned: true, content: <div className="demo-dock-content"><KlpText role="label">檔案</KlpText><KlpText role="caption">scene.json</KlpText><KlpText role="caption">materials / wood</KlpText></div>, onCloseRequested: approveClose },
		{ id: 'search', label: 'Search', content: <div className="demo-dock-content"><KlpTextField label="搜尋面板輸入" defaultValue="material" /></div>, onCloseRequested: approveClose },
		{ id: 'inspector', label: 'Inspector', isDirty: true, content: <div className="demo-dock-content"><KlpTextField label="物件名稱" defaultValue="Cube" /><KlpText role="caption">未儲存標記由產品提供</KlpText></div>, onCloseRequested: approveClose },
		{ id: 'history', label: 'History', content: <div className="demo-dock-content"><KlpText role="caption">建立物件</KlpText><KlpText role="caption">修改材質</KlpText></div>, onCloseRequested: approveClose },
		{ id: 'output', label: 'Output', content: <div className="demo-dock-content"><KlpText as="code" role="code">場景已載入 · 0 errors</KlpText></div>, onCloseRequested: approveClose },
	], [approveClose]);
	/** 保存契約只接受能力清冊，不把內容與 callback 混入資料邊界。 */
	const policies = useMemo(() => panels.map(({ id, allowSide, allowBottom }) => ({ id, allowSide, allowBottom })), [panels]);
	const available = restoreKlpDockLayout(encodeKlpDockLayout(layout), policies).availablePanelIds;
	function commit(next: KlpDockLayoutData) {
		setLayout(next);
		setCount(value => value + 1);
	}
	function action(request: KlpDockAction) {
		const result = applyKlpDockAction(layout, policies, request);
		if (result.changed) commit(result.layout);
	}
	function restore() {
		try {
			const result = restoreKlpDockLayout(source, policies);
			if (encodeKlpDockLayout(result.layout) !== encodeKlpDockLayout(layout)) commit(result.layout);
			setMessage(`還原成功 · 缺少面板：${result.missingPanelIds.join(', ') || '無'} · 可重開：${result.availablePanelIds.join(', ') || '無'}`);
		} catch (error) {
			setMessage(`還原失敗，保留布局：${error instanceof Error ? error.message : String(error)}`);
		}
	}
	function open(panelId: string) {
		const group = layout.left.groups[0];
		if (group) action({ type: 'open', panelId, destination: { kind: 'tab', area: 'left', groupId: group.id, index: group.panelIds.length } });
		else action({ type: 'open', panelId, destination: { kind: 'group', area: 'left', groupId: 'reopened-navigation', index: 0, extent: 240 } });
	}
	function merge() {
		const groups = areaNames.flatMap(area => layout[area].groups);
		if (groups.length < 2) return;
		action({ type: 'merge', sourceGroupId: groups[1].id, targetGroupId: groups[0].id, index: groups[0].panelIds.length });
	}
	return <KlpCard header={<KlpText role="body-strong">停靠 Workbench 互動展示</KlpText>}>
		<div className="demo-stack">
			<KlpText role="caption" tone="muted">將分頁拖到面板正文可分割群組；拖動區域把手或群組分隔線可縮放。保存保留偏好尺寸，窄畫面只壓縮呈現。</KlpText>
			<div className="demo-row" aria-label="停靠寬度">{[320, 760, 1040].map(value => <KlpButton key={value} size="sm" selected={width === value} onClick={() => setWidth(value)}>停靠寬 {value}</KlpButton>)}</div>
			<div className="demo-row">
				{[180, 460].map(value => <KlpButton key={value} size="sm" selected={height === value} onClick={() => setHeight(value)}>停靠高 {value}</KlpButton>)}
				<KlpButton size="sm" onClick={() => { setSource(encodeKlpDockLayout(layout)); setMessage('已保存到下方 JSON，可貼到另一個宿主還原。'); }}>保存布局</KlpButton>
				<KlpButton size="sm" onClick={restore}>還原布局</KlpButton>
				<KlpButton size="sm" onClick={() => { if (encodeKlpDockLayout(layout) !== encodeKlpDockLayout(initialLayout)) commit(initialLayout); setMessage('初始布局已還原。'); }}>重設布局</KlpButton>
				<KlpButton size="sm" disabled={areaNames.flatMap(area => layout[area].groups).length < 2} onClick={merge}>合併前兩群組</KlpButton>
			</div>
			<div className="demo-row" aria-label="關閉批准方式">
				<KlpButton size="sm" selected={closeMode === 'approve'} onClick={() => setCloseMode('approve')}>批准關閉</KlpButton>
				<KlpButton size="sm" selected={closeMode === 'deny'} onClick={() => setCloseMode('deny')}>拒絕關閉</KlpButton>
				<KlpButton size="sm" selected={closeMode === 'delay'} onClick={() => setCloseMode('delay')}>延遲批准關閉</KlpButton>
				{available.map(id => <KlpButton key={id} size="sm" onClick={() => open(id)}>重開 {panels.find(panel => panel.id === id)?.label}</KlpButton>)}
			</div>
			<div className={`demo-dock-preview demo-w-${width} demo-h-${height}`}>
				<KlpDockLayout label="停靠布局預覽" layout={layout} panels={panels} leftConstraints={{ minExtent: 120, maxExtent: 360 }} rightConstraints={{ minExtent: 120, maxExtent: 360 }} bottomConstraints={{ minExtent: 80, maxExtent: 260 }} collapseThresholds={{ left: 48, right: 48, bottom: 32 }} onLayoutChanged={commit} onCloseError={(error, id) => setMessage(`${id} 關閉失敗：${String(error)}`)}
					contentHeader={<KlpSurface tone="raised" className="demo-dock-header"><KlpText role="caption">SCENE · 產品擁有內容與流程</KlpText></KlpSurface>}
					stage={<KlpSurface tone="inset" className="demo-dock-stage"><KlpText role="lead">Stage</KlpText><KlpTextField label="場景名稱" value={draft} onChange={event => setDraft(event.target.value)} /><KlpText role="caption">正文、3D 或終端由產品接入。</KlpText></KlpSurface>} />
			</div>
			<KlpText role="caption" aria-live="polite">已提交 {count} 次布局變更 · 左 {layout.left.extent} / 右 {layout.right.extent} / 下 {layout.bottom.extent} · {message}</KlpText>
			<details><summary>布局 JSON（schema 1）</summary><textarea aria-label="布局 JSON" className="demo-style-json" value={source} onChange={event => setSource(event.target.value)} /></details>
		</div>
	</KlpCard>;
}
