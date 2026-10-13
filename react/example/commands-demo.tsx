import { useEffect, useRef, useState, type MouseEvent } from 'react';
import { KlpButton, KlpCard, KlpCommandKeymap, KlpCommandRegistry, KlpCommandShortcutHost, KlpRegisteredCommandMenu, KlpRegisteredCommandPalette, KlpRegisteredCommandPopup, KlpRegisteredCommandToolbar, KlpText, KlpTextField, type KlpCommandDismissReason, type KlpCommandExecutionResult, type KlpCommandReference, type KlpCommandPopupAnchor, type KlpCommandPopupDismissReason, type KlpShortcutFocus, type KlpShortcutHandling, type KlpShortcutStroke } from '@kallopis/react';

interface DemoContext {
	/* 產品條件由展示頁擁有，入口每次透過 getContext 讀取。 */
	canSave: boolean;
	grid: boolean;
	showFailure: boolean;
}

const toolbarItems: readonly KlpCommandReference[] = [{ commandId: 'document.save' }, { commandId: 'view.grid', kind: 'toggle' }];
const menuItems: readonly KlpCommandReference[] = [...toolbarItems, { commandId: 'document.fail' }];

export function CommandsDemo({ specimen }: { /* specimen可選公開呈現名稱；有值時只顯示當次compound入口與控制。 */ specimen?: string } = {}) {
	/* registry 每次 effect setup 建立；StrictMode cleanup 後不能再用 disposed owner。 */
	const [registry, setRegistry] = useState<KlpCommandRegistry<DemoContext> | null>(null);
	/* keymap 隨同一份 registry 建立與釋放；錄製與覆寫權威留在公開核心。 */
	const [keymap, setKeymap] = useState<KlpCommandKeymap<DemoContext> | null>(null);
	const [handling, setHandling] = useState<KlpShortcutHandling | null>(null);
	const [, setRevision] = useState(0);
	const [settings, setSettings] = useState('');
	const [settingsMessage, setSettingsMessage] = useState('尚未匯入設定');
	/* recorder 是明確的原生焦點目標；弱映射保留每個 Element 的穩定識別，不保留已移除節點。 */
	const recorder = useRef<HTMLDivElement>(null);
	const focusIds = useRef(new WeakMap<Element, string>());
	const focusCounter = useRef(0);
	/* 以下為產品狀態，不由命令入口複製或代管業務條件。 */
	const [canSave, setCanSave] = useState(true);
	const [grid, setGrid] = useState(false);
	const [showFailure, setShowFailure] = useState(false);
	const [open, setOpen] = useState(false);
	const [draft, setDraft] = useState('保留這份草稿與游標');
	const [message, setMessage] = useState('尚未執行命令');
	const [resultCount, setResultCount] = useState(0);
	const [dismissReason, setDismissReason] = useState<KlpCommandDismissReason | null>(null);
	/* popupOpen 為產品受控開關；popupAnchor 保存同 viewport 原生bounds或point；popupReason 為產品回饋。 */
	const [popupOpen, setPopupOpen] = useState(false);
	const [popupAnchor, setPopupAnchor] = useState<KlpCommandPopupAnchor>({ x: 0, y: 0, width: 0, height: 0 });
	const [popupReason, setPopupReason] = useState<KlpCommandPopupDismissReason | null>(null);
	/* ref 提供最新 context，註冊 handler 不捕捉過期 render 的條件。 */
	const contextRef = useRef<DemoContext>({ canSave, grid, showFailure });
	contextRef.current = { canSave, grid, showFailure };

	function getContext() { return contextRef.current; }
	function getFocus(target: EventTarget | null): KlpShortcutFocus {
		const element = target instanceof Element ? target : document.documentElement;
		let focusId = focusIds.current.get(element);
		if (!focusId) {
			focusId = `commands-focus-${++focusCounter.current}`;
			focusIds.current.set(element, focusId);
		}

		const componentId = element.closest('[data-command-draft]') ? 'draft' : undefined;
		return {
			/* focusId 對應原生節點；pageId／regionId 對應此展示；componentId 僅由產品草稿標記投影。
			 * editable 投影產品已知的草稿／設定欄位；宿主另合併原生輸入判定。 */
			focusId, pageId: 'commands', regionId: 'commands', componentId, editable: componentId === 'draft' || !!element.closest('[data-command-settings]')
		};
	}
	function createCommands() {
		const owner = new KlpCommandRegistry<DemoContext>();
		async function save() {
			function wait(resolve: () => void) { window.setTimeout(resolve, 800); }
			await new Promise<void>(wait);
			return '文件已儲存';
		}
		function toggleGrid() { setGrid(value => !value); }
		function fail() { throw new Error('展示儲存失敗'); }
		owner.register({ id: 'document.save', label: '儲存文件', description: '儲存目前文件', category: '文件', keywords: ['save', 'document'], isEnabled: context => context.canSave, handler: save });
		owner.register({ id: 'view.grid', label: '顯示格線', description: '切換畫布格線', category: '視圖', keywords: ['grid', 'canvas'], isChecked: context => context.grid, handler: toggleGrid });
		owner.register({ id: 'document.fail', label: '模擬失敗', description: '觀察原始錯誤與面板保留', category: '文件', keywords: ['error', 'failure'], isVisible: context => context.showFailure, handler: fail });

		// 平台只決定 primary 對應；所有快捷鍵仍呼叫同一份命令處理。
		const platform = /Mac|iPhone|iPad/.test(navigator.platform) ? 'mac' : 'other';
		const shortcuts = new KlpCommandKeymap(owner, { /* platform 採產品所在環境；不另外擁有計時器。 */ platform });
		/* 各 binding 的 id 為覆寫鍵、commandId 指向原命令、sequence 為預設按鍵、scope／scopeId 限定作用域。
		 * allowInEditable 容許草稿儲存／局部格線；priority 提供可觀察的同作用域衝突勝出順序。 */
		shortcuts.register({ id: 'document.save.primary', commandId: 'document.save', sequence: [{ key: 's', primary: true }], scope: 'app', allowInEditable: true });
		shortcuts.register({ id: 'document.save.chord', commandId: 'document.save', sequence: [{ key: 'k', primary: true }, { key: 's' }], scope: 'app', allowInEditable: true });
		shortcuts.register({ id: 'view.grid.primary', commandId: 'view.grid', sequence: [{ key: 'g', primary: true }], scope: 'page', scopeId: 'commands' });
		shortcuts.register({ id: 'view.grid.duplicate', commandId: 'view.grid', sequence: [{ key: 'g', primary: true }], scope: 'page', scopeId: 'commands', priority: -1 });
		shortcuts.register({ id: 'view.grid.editor', commandId: 'view.grid', sequence: [{ key: 'g', primary: true }], scope: 'component', scopeId: 'draft', allowInEditable: true });
		shortcuts.register({ id: 'document.fail.region', commandId: 'document.fail', sequence: [{ key: 'f', alt: true, shift: true }], scope: 'region', scopeId: 'commands' });
		setRegistry(owner);
		setKeymap(shortcuts);
		function disposeCommands() {
			shortcuts.dispose();
			owner.dispose();
		}
		return disposeCommands;
	}
	useEffect(createCommands, []);
	function refreshContext() {
		if (registry && !registry.isDisposed) registry.refresh();
	}
	useEffect(refreshContext, [registry, canSave, grid, showFailure]);

	function onResult(result: KlpCommandExecutionResult) {
		setResultCount(value => value + 1);
		if (result.status === 'executed') {
			setMessage(result.commandId === 'document.save' ? String(result.value) : '已切換格線');
		}
		else if (result.status === 'error') {
			setMessage(result.error instanceof Error ? result.error.message : String(result.error));
		}
		else setMessage(`命令未執行：${result.status}`);
	}
	function onDismiss(reason: KlpCommandDismissReason) {
		setDismissReason(reason);
		setOpen(false);
	}
	function openPalette() { setOpen(true); }
	function toggleSave() { setCanSave(value => !value); }
	function toggleFailure() { setShowFailure(value => !value); }
	function showPopup(anchor: KlpCommandPopupAnchor) {
		setOpen(false);
		setPopupAnchor(anchor);
		setPopupOpen(true);
	}
	function openButtonPopup(event: MouseEvent<HTMLButtonElement>) {

		// 產品提供觸發按鈕的實際 viewport bounds，library 不掃描產品 DOM。
		const rect = event.currentTarget.getBoundingClientRect();
		showPopup({ x: rect.x, y: rect.y, width: rect.width, height: rect.height });
	}
	function openPointPopup(event: MouseEvent<HTMLElement>) {
		event.preventDefault();
		showPopup({ x: event.clientX, y: event.clientY, width: 0, height: 0 });
	}
	function dismissPopup(reason: KlpCommandPopupDismissReason) {
		setPopupReason(reason);
		setPopupOpen(false);
	}
	function refreshShortcuts() { setRevision(value => value + 1); }
	function onHandling(value: KlpShortcutHandling) {
		setHandling(value);
		refreshShortcuts();
	}
	function beginRecording() {
		if (!keymap || !recorder.current) return;

		// 先移入實際錄製區，再使用當下原生焦點識別；按鈕的焦點不是錄製擁有者。
		recorder.current.focus();
		keymap.beginRecording(getFocus(document.activeElement).focusId);
		refreshShortcuts();
	}
	function applyRecording() {
		if (!keymap) return;

		const sequence = keymap.finishRecording();
		if (sequence.length) keymap.setOverride('document.save.primary', sequence);
		setSettingsMessage(sequence.length ? '已套用儲存快捷鍵' : '沒有錄製按鍵；保留原設定');
		refreshShortcuts();
	}
	function cancelRecording() {
		keymap?.cancelRecording();
		refreshShortcuts();
	}
	function restoreShortcut() {
		keymap?.restore('document.save.primary');
		setSettingsMessage('已還原儲存快捷鍵');
		refreshShortcuts();
	}
	function exportSettings() {
		if (!keymap) return;

		// 僅序列化公開覆寫 DTO，不帶入命令 handler 或產品 context。
		setSettings(JSON.stringify(keymap.exportOverrides()));
		setSettingsMessage('已匯出覆寫設定');
	}
	function importSettings() {
		if (!keymap) return;

		try {
			// JSON 語法與核心原子驗證共用同一失敗回饋；不建立第二套設定驗證。
			keymap.importOverrides(JSON.parse(settings));
			setSettingsMessage('已匯入覆寫設定');
		}
		catch (error) {
			setSettingsMessage(`匯入失敗：${error instanceof Error ? error.message : String(error)}`);
		}
		refreshShortcuts();
	}
	function describeStroke(stroke: KlpShortcutStroke) {
		const parts = [];
		if (stroke.primary) parts.push(keymap?.platform === 'mac' ? '⌘' : 'Ctrl');
		if (stroke.ctrl) parts.push('Ctrl');
		if (stroke.alt) parts.push('Alt');
		if (stroke.shift) parts.push('Shift');
		if (stroke.meta) parts.push('Meta');
		parts.push(stroke.key);
		return parts.join('+');
	}
	const focus = getFocus(document.activeElement);
	const conflicts = keymap?.conflicts(focus, getContext()) ?? [];
	const shortcutContent = <div className="demo-stack" onBlur={refreshShortcuts} onFocus={refreshShortcuts}>
		<KlpText role="body-strong">快捷鍵與設定</KlpText>
		<KlpText as="p" tone="muted">Primary+S 儲存；Primary+K → S 連續按鍵；Primary+G 切換格線。草稿中的格線由 component 作用域接管；啟用失敗命令後可用 Alt+Shift+F。Primary 在此平台為 {keymap?.platform === 'mac' ? '⌘' : 'Ctrl'}。</KlpText>
		<div ref={recorder} tabIndex={0} aria-label="快捷鍵錄製區">
			<KlpCard><KlpText>錄製區：{keymap?.isRecording ? '正在錄製；最多四組按鍵，Escape 取消' : '按下開始錄製後，在此輸入新快捷鍵'}</KlpText></KlpCard>
		</div>
		<div className="demo-row">
			<KlpButton disabled={!keymap} onClick={beginRecording}>開始錄製</KlpButton>
			<KlpButton disabled={!keymap || !keymap.recordedSequence.length} onClick={applyRecording}>套用錄製為儲存快捷鍵</KlpButton>
			<KlpButton disabled={!keymap} onClick={cancelRecording}>取消錄製</KlpButton>
			<KlpButton disabled={!keymap} onClick={restoreShortcut}>還原儲存快捷鍵</KlpButton>
		</div>
		<KlpText role="caption" aria-live="polite">最近處理：{handling?.state ?? '尚未按鍵'} · 綁定：{handling?.bindingId ?? '無'} · 目前連續按鍵：{keymap?.pendingSequence.map(describeStroke).join(' → ') || '無'} · 已錄製：{keymap?.recordedSequence.map(describeStroke).join(' → ') || '無'}</KlpText>
		<KlpText role="caption">作用域：{focus.componentId ?? focus.pageId} · 衝突：{conflicts.map(conflict => `${conflict.kind} ${conflict.bindingIds.join(' / ')} → ${conflict.winnerId}`).join('；') || '無'}</KlpText>
		<div data-command-settings><KlpTextField label="快捷鍵設定 JSON" value={settings} onChange={event => setSettings(event.target.value)} hint="匯入錯誤會保留既有設定" /></div>
		<div className="demo-row"><KlpButton disabled={!keymap} onClick={exportSettings}>匯出設定</KlpButton><KlpButton disabled={!keymap} onClick={importSettings}>匯入設定</KlpButton></div>
		<KlpText role="caption" aria-live="polite">{settingsMessage}</KlpText>
	</div>;

	const showPalette = !specimen || specimen === 'KlpRegisteredCommandPalette';
	const showPopupEntry = !specimen || specimen === 'KlpRegisteredCommandPopup';
	const content = <KlpCard header={<KlpText role="body-strong">{specimen ?? '命令與入口'}</KlpText>}>
		<div className="demo-stack">
			<KlpText as="p" tone="muted">公開命令入口共用命令註冊；產品持有可用條件、結果及開關。</KlpText>
			<div data-command-draft><KlpTextField label="命令展示草稿" value={draft} onChange={event => setDraft(event.target.value)} hint="開關面板及切換風格後保留輸入內容" /></div>
			<div className="demo-row">
				<KlpButton selected={canSave} onClick={toggleSave}>允許儲存：{canSave ? '開' : '關'}</KlpButton>
				<KlpButton selected={showFailure} onClick={toggleFailure}>顯示失敗命令：{showFailure ? '開' : '關'}</KlpButton>
				{showPalette && <KlpButton tone="primary" disabled={!registry} onClick={openPalette}>開啟命令面板</KlpButton>}
				{showPopupEntry && <KlpButton disabled={!registry} onClick={openButtonPopup}>開啟錨定選單</KlpButton>}
			</div>
			{showPopupEntry && <KlpCard onContextMenu={openPointPopup}><KlpText>在此按右鍵開啟命令選單</KlpText></KlpCard>}
			{registry && <>
				{(!specimen || specimen === 'KlpRegisteredCommandToolbar') && <KlpRegisteredCommandToolbar registry={registry} getContext={getContext} items={toolbarItems} label="展示命令工具列" onResult={onResult} />}
				{(!specimen || specimen === 'KlpRegisteredCommandMenu') && <KlpRegisteredCommandMenu registry={registry} getContext={getContext} items={menuItems} label="展示命令選單" emptyLabel="目前沒有命令" onResult={onResult} />}
				{showPalette && <KlpRegisteredCommandPalette registry={registry} getContext={getContext} open={open} label="命令面板" searchLabel="搜尋命令" emptyLabel="沒有符合的命令" onResult={onResult} onDismiss={onDismiss} />}
				{showPopupEntry && <KlpRegisteredCommandPopup registry={registry} getContext={getContext} items={menuItems} open={popupOpen} anchor={popupAnchor} label="快顯命令選單" emptyLabel="目前沒有命令" onResult={onResult} onDismiss={dismissPopup} />}
			</>}
			<KlpText role="caption" aria-live="polite">結果 {resultCount} 次：{message} · 格線：{grid ? '開' : '關'} · 最近關閉：{dismissReason ?? '尚未關閉'} · 快顯關閉：{popupReason ?? '尚未關閉'}</KlpText>
			{(!specimen || specimen === 'KlpCommandShortcutHost') && shortcutContent}
		</div>
	</KlpCard>;
	if (!keymap) return content;

	return <KlpCommandShortcutHost keymap={keymap} getContext={getContext} getFocus={getFocus} onHandling={onHandling} onResult={onResult}>{content}</KlpCommandShortcutHost>;
}
