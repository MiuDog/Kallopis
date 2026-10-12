import { useEffect, useRef, useState, type MouseEvent } from 'react';
import { KlpButton, KlpCard, KlpCommandRegistry, KlpRegisteredCommandMenu, KlpRegisteredCommandPalette, KlpRegisteredCommandPopup, KlpRegisteredCommandToolbar, KlpText, KlpTextField, type KlpCommandDismissReason, type KlpCommandExecutionResult, type KlpCommandReference, type KlpCommandPopupAnchor, type KlpCommandPopupDismissReason } from '@kallopis/react';

interface DemoContext {
	/* 產品條件由展示頁擁有，入口每次透過 getContext 讀取。 */
	canSave: boolean;
	grid: boolean;
	showFailure: boolean;
}

const toolbarItems: readonly KlpCommandReference[] = [{ commandId: 'document.save' }, { commandId: 'view.grid', kind: 'toggle' }];
const menuItems: readonly KlpCommandReference[] = [...toolbarItems, { commandId: 'document.fail' }];

export function CommandsDemo() {
	/* registry 每次 effect setup 建立；StrictMode cleanup 後不能再用 disposed owner。 */
	const [registry, setRegistry] = useState<KlpCommandRegistry<DemoContext> | null>(null);
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
		setRegistry(owner);
		function disposeCommands() { owner.dispose(); }
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

	return <KlpCard header={<KlpText role="body-strong">命令與入口</KlpText>}>
		<div className="demo-stack">
			<KlpText as="p" tone="muted">同一份命令註冊同時供工具列、選單與命令面板使用；產品持有可用條件、結果及開關。</KlpText>
			<KlpTextField label="命令展示草稿" value={draft} onChange={event => setDraft(event.target.value)} hint="開關面板及切換風格後保留輸入內容" />
			<div className="demo-row">
				<KlpButton selected={canSave} onClick={toggleSave}>允許儲存：{canSave ? '開' : '關'}</KlpButton>
				<KlpButton selected={showFailure} onClick={toggleFailure}>顯示失敗命令：{showFailure ? '開' : '關'}</KlpButton>
				<KlpButton tone="primary" disabled={!registry} onClick={openPalette}>開啟命令面板</KlpButton>
				<KlpButton disabled={!registry} onClick={openButtonPopup}>開啟錨定選單</KlpButton>
			</div>
			<KlpCard onContextMenu={openPointPopup}><KlpText>在此按右鍵開啟命令選單</KlpText></KlpCard>
			{registry && <>
				<KlpRegisteredCommandToolbar registry={registry} getContext={getContext} items={toolbarItems} label="展示命令工具列" onResult={onResult} />
				<KlpRegisteredCommandMenu registry={registry} getContext={getContext} items={menuItems} label="展示命令選單" emptyLabel="目前沒有命令" onResult={onResult} />
				<KlpRegisteredCommandPalette registry={registry} getContext={getContext} open={open} label="命令面板" searchLabel="搜尋命令" emptyLabel="沒有符合的命令" onResult={onResult} onDismiss={onDismiss} />
				<KlpRegisteredCommandPopup registry={registry} getContext={getContext} items={menuItems} open={popupOpen} anchor={popupAnchor} label="快顯命令選單" emptyLabel="目前沒有命令" onResult={onResult} onDismiss={dismissPopup} />
			</>}
			<KlpText role="caption" aria-live="polite">結果 {resultCount} 次：{message} · 格線：{grid ? '開' : '關'} · 最近關閉：{dismissReason ?? '尚未關閉'} · 快顯關閉：{popupReason ?? '尚未關閉'}</KlpText>
		</div>
	</KlpCard>;
}
