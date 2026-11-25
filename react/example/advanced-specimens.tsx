import { useState } from 'react';
import { KlpTreeGrid, KlpTree, KlpMultiSelect, KlpVirtualList, KlpDataGrid, KlpPopover, KlpDrawer, KlpToastRegion, KlpSpinner, KlpSplitButton, KlpRibbon, KlpContentHost, KlpSystemAction, KlpSelect, KlpButton, KlpText, KlpTextField, KlpCheckbox } from '@kallopis/react';

/** 完整化展示：每個入口呈現真實元件，示範狀態與宿主替身明確留在 example。 */
export function AdvancedSpecimen({ name }: { name: string }) {

	const [open, setOpen] = useState(false);
	const [selected, setSelected] = useState('notes');
	const [expanded, setExpanded] = useState(['root']);
	const [values, setValues] = useState(['notes']);
	const [text, setText] = useState('研究筆記');
	const [count, setCount] = useState(0);
	const [fail, setFail] = useState(false);
	const [loading, setLoading] = useState(false);
	const [tab, setTab] = useState('edit');
	const [toastIds, setToastIds] = useState<number[]>([]);
	const [descending, setDescending] = useState(false);
	const [sortKey, setSortKey] = useState<'name' | 'status'>('name');
	const gridRows = [{ id: 'draft', values: { name: text, status: '草稿' } }, { id: 'locked', values: { name: '鎖定資料', status: '唯讀' }, disabled: true }].sort((left, right) => (descending ? -1 : 1) * left.values[sortKey].localeCompare(right.values[sortKey], 'zh-Hant'));
	const options = [{ value: 'notes', label: '筆記' }, { value: 'files', label: '檔案' }, { value: 'locked', label: '鎖定項目', disabled: true }];
	const input = <KlpTextField label="名稱" value={text} onChange={event => setText(event.target.value)} />;
	let result;
	switch (name) {
		case 'KlpTreeGrid': result = <KlpTreeGrid label="階層資料" columns={['名稱', '類型', '狀態']} rows={[{ id: 'root', label: '工作區', cells: ['資料夾', '開啟'], children: [{ id: 'notes', label: '筆記', cells: ['文件', '草稿'], children: [{ id: 'draft', label: '第一版', cells: ['版本', '可用'] }] }, { id: 'locked', label: '封存資料', cells: ['文件', '唯讀'], disabled: true }] }]} selectedId={selected} expandedIds={expanded} onSelect={setSelected} onToggle={id => setExpanded(ids => ids.includes(id) ? ids.filter(value => value !== id) : [...ids, id])} />; break;
		case 'KlpTree': result = <KlpTree label="資料樹" items={[{ id: 'root', label: '工作區', children: [{ id: 'notes', label: '筆記', children: [{ id: 'draft', label: '草稿' }] }, { id: 'files', label: '檔案' }, { id: 'locked', label: '無權限資料', disabled: true }] }]} selectedId={selected} expandedIds={expanded} onSelect={setSelected} onToggle={id => setExpanded(ids => ids.includes(id) ? ids.filter(value => value !== id) : [...ids, id])} />; break;
		case 'KlpMultiSelect': result = <KlpMultiSelect label="資料來源" options={options} value={values} onValueChange={setValues} />; break;
		case 'KlpVirtualList': result = <KlpVirtualList label="一萬筆資料" items={Array.from({ length: 10000 }, (_, index) => ({ id: String(index), label: `資料 ${index + 1}`, disabled: index === 4 }))} selectedId={selected} onSelect={setSelected} />; break;
		case 'KlpDataGrid': result = <KlpDataGrid label="可編輯資料" columns={[{ key: 'name', label: '名稱', editable: true }, { key: 'status', label: '狀態' }]} rows={gridRows} sort={{ key: sortKey, direction: descending ? 'descending' : 'ascending' }} onSort={key => { if (key !== 'name' && key !== 'status') return; if (key === sortKey) setDescending(!descending); else { setSortKey(key); setDescending(false); } }} onCellChange={(_id, _key, value) => setText(value)} />; break;
		case 'KlpPopover': result = <KlpPopover label="編輯屬性" open={open} onOpenChange={setOpen}>{input}</KlpPopover>; break;
		case 'KlpDrawer': result = <><KlpButton onClick={() => setOpen(true)}>開啟檢查面板</KlpButton><KlpDrawer open={open} title="資料屬性" onClose={() => setOpen(false)}>{input}</KlpDrawer></>; break;
		case 'KlpToastRegion': result = <><KlpButton onClick={() => { setToastIds(ids => [...ids, count + 1]); setCount(count + 1); }}>新增通知</KlpButton><KlpToastRegion items={toastIds.map(id => ({ id: String(id), title: `工作 ${id} 已完成`, message: '通知集合由 consumer 保存，可逐項關閉。', tone: 'success' }))} onDismiss={id => setToastIds(ids => ids.filter(value => String(value) !== id))} /></>; break;
		case 'KlpSpinner': result = <><KlpCheckbox label="工作完成" checked={open} onChange={event => setOpen(event.target.checked)} />{open ? <KlpText>工作完成</KlpText> : <KlpSpinner label="正在準備預覽" />}</>; break;
		case 'KlpSplitButton': result = <KlpSplitButton label="儲存" onAction={() => setSelected('已儲存')} options={[{ id: 'copy', label: '儲存副本', onAction: () => setSelected('已儲存副本') }, { id: 'export', label: '目前不能匯出', disabled: true, onAction: () => setSelected('不可觸發') }]} />; break;
		case 'KlpRibbon': result = <KlpRibbon label="文件工具" value={tab} onValueChange={setTab} tabs={[{ id: 'edit', label: '編輯', content: <div className="demo-row"><KlpButton onClick={() => setCount(count + 1)}>新增段落</KlpButton><KlpButton disabled>復原</KlpButton></div> }, { id: 'view', label: '檢視', content: <KlpCheckbox label="顯示詳細資訊" checked={open} onChange={event => setOpen(event.target.checked)} /> }]} />; break;
		case 'KlpContentHost': result = <><KlpCheckbox label="模擬載入" checked={loading} onChange={event => setLoading(event.target.checked)} /><KlpCheckbox label="模擬引擎失敗" checked={fail} onChange={event => setFail(event.target.checked)} /><KlpContentHost label="產品內容引擎" loading={loading} error={fail ? '示範連線失敗，取消勾選即可重試' : undefined}><KlpText>此處由產品掛載圖表、日曆、時間軸、Krepis／BlockNote 或其他引擎。</KlpText>{input}</KlpContentHost></>; break;
		case 'KlpSystemAction': result = <><KlpCheckbox label="模擬宿主失敗" checked={fail} onChange={event => setFail(event.target.checked)} /><KlpSystemAction label="執行宿主示範" onAction={async () => { await new Promise(resolve => setTimeout(resolve, 500)); if (fail) throw new Error('宿主拒絕本次操作'); setCount(value => value + 1); }} /><KlpSystemAction label="系統托盤" unavailable="瀏覽器未接桌面托盤 API" /><KlpText role="caption">此展示使用本地替身，不呼叫實際系統 API。</KlpText></>; break;
		default: result = <KlpText>未登錄元件：{name}</KlpText>;
	}
	return <div className="demo-stack">{result}<KlpText role="caption" aria-live="polite">選取：{selected} · 多選：{values.join('、')} · 操作次數：{count} · 名稱：{text}</KlpText></div>;
}

/** 同一公開 TextField 的原生變體；檔案只回報名稱，不上傳或讀取。 */
export function NativeFieldSpecimen() {
	const [type, setType] = useState('text');
	const [values, setValues] = useState<Record<string, string>>({ color: '#4488aa', number: '1' });
	const [file, setFile] = useState('');
	const types = ['text', 'search', 'password', 'number', 'date', 'time', 'datetime-local', 'color', 'file'];
	return <div className="demo-stack"><KlpSelect label="輸入類型" value={type} options={types.map(value => ({ value, label: value }))} onChange={event => setType(event.target.value)} /><KlpTextField key={type} label="原生值輸入" type={type} value={type === 'file' ? undefined : values[type] ?? ''} onChange={event => { if (type === 'file') setFile(event.target.files?.[0]?.name ?? ''); else setValues(previous => ({ ...previous, [type]: event.target.value })); }} /><KlpText role="caption">{type === 'file' ? file || '尚未選取檔案' : '選擇器由瀏覽器與 OS 提供，值由 consumer 持有。'}</KlpText></div>;
}
