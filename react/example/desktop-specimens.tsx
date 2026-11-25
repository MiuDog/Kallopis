import { AdvancedSpecimen } from './advanced-specimens.js';
import { advancedComponentNames } from './desktop-catalog-data.mjs';
import { useState } from 'react';
import { KlpTextArea, KlpCheckbox, KlpSwitch, KlpRadioGroup, KlpSelect, KlpComboBox, KlpSlider, KlpList, KlpTabs, KlpTable, KlpAccordion, KlpBreadcrumb, KlpPagination, KlpProgress, KlpAlert, KlpEmptyState, KlpDialog, KlpTooltip, KlpStatusBar, KlpSeparator, KlpLink, KlpAvatar, KlpSkeleton, KlpButton, KlpText, KlpTextField } from '@kallopis/react';

/** 每個公開元件都有真實 specimen；狀態只屬當次展示。 */
export function DesktopSpecimen({ name }: { name: string }) {

	const [text, setText] = useState('研究筆記');
	const [checked, setChecked] = useState(false);
	const [value, setValue] = useState('first');
	const [number, setNumber] = useState(35);
	const [page, setPage] = useState(1);
	const [open, setOpen] = useState(false);
	const [disabled, setDisabled] = useState(false);
	const options = [{ value: 'first', label: '第一項' }, { value: 'second', label: '第二項' }, { value: 'disabled', label: '暫不可用', disabled: true }];
	const input = <KlpTextField label="內容" value={text} onChange={event => setText(event.target.value)} />;
	if (advancedComponentNames.includes(name)) return <AdvancedSpecimen name={name} />;
	let specimen;
	switch (name) {
		case 'KlpTextArea': specimen = <KlpTextArea label="長篇備註" value={text} disabled={disabled} onChange={event => setText(event.target.value)} hint="可換行；內容由 consumer 保存" />; break;
		case 'KlpCheckbox': specimen = <KlpCheckbox label="包含已封存資料" checked={checked} disabled={disabled} onChange={event => setChecked(event.target.checked)} />; break;
		case 'KlpSwitch': specimen = <KlpSwitch label="啟用即時預覽" checked={checked} disabled={disabled} onChange={event => setChecked(event.target.checked)} />; break;
		case 'KlpRadioGroup': specimen = <KlpRadioGroup label="開啟位置" options={options} value={value} disabled={disabled} onValueChange={setValue} />; break;
		case 'KlpSelect': specimen = <KlpSelect label="預設資料夾" options={options} value={value} disabled={disabled} onChange={event => setValue(event.target.value)} />; break;
		case 'KlpComboBox': specimen = <KlpComboBox label="標籤建議" options={['設計', '研究', '工作']} value={text} disabled={disabled} onChange={event => setText(event.target.value)} />; break;
		case 'KlpSlider': specimen = <KlpSlider label="縮放比例" min={0} max={100} value={number} disabled={disabled} onChange={event => setNumber(Number(event.target.value))} />; break;
		case 'KlpList': specimen = <KlpList label="資料清單" items={options.map(option => ({ id: option.value, title: option.label, description: '共用資料列，保留項目間距及選取語意。', meta: '示範資料', disabled: disabled || option.disabled }))} selectedId={value} onSelect={setValue} />; break;
		case 'KlpTabs': specimen = <KlpTabs label="資料檢視" value={value} onValueChange={setValue} tabs={[{ id: 'first', label: '內容', content: input }, { id: 'second', label: '資訊', content: <KlpText>草稿仍保留：{text}</KlpText> }, { id: 'disabled', label: '不可用', disabled: true, content: null }]} />; break;
		case 'KlpTable': specimen = <><KlpButton selected={checked} onClick={() => setChecked(!checked)}>反向排列</KlpButton><KlpTable caption="資料來源" columns={['名稱', '狀態', '類型']} rows={(checked ? [...options].reverse() : options).map(option => ({ id: option.value, cells: [option.label, option.disabled ? '停用' : '可用', '文件'] }))} /></>; break;
		case 'KlpAccordion': specimen = <KlpAccordion title="進階設定">{input}</KlpAccordion>; break;
		case 'KlpBreadcrumb': specimen = <KlpBreadcrumb label="所在位置" items={[{ label: 'Catalog', href: '?catalog=desktop' }, { label: '目前展示', href: '?specimen=KlpBreadcrumb' }]} />; break;
		case 'KlpPagination': specimen = <KlpPagination page={page} pageCount={5} onPageChange={setPage} />; break;
		case 'KlpProgress': specimen = <><KlpSlider label="完成程度" value={number} onChange={event => setNumber(Number(event.target.value))} /><KlpProgress label="匯入進度" value={checked ? undefined : number} /><KlpCheckbox label="不確定進度" checked={checked} onChange={event => setChecked(event.target.checked)} /></>; break;
		case 'KlpAlert': specimen = <><KlpButton selected={checked} onClick={() => setChecked(!checked)}>切換錯誤狀態</KlpButton><KlpAlert title={checked ? '無法完成操作' : '資料已就緒'} tone={checked ? 'danger' : 'success'}>提示內容由產品提供。</KlpAlert></>; break;
		case 'KlpEmptyState': specimen = checked ? <KlpText>已建立示範資料</KlpText> : <KlpEmptyState title="還沒有資料" description="加入第一份資料開始整理。" action={<KlpButton onClick={() => setChecked(true)}>新增資料</KlpButton>} />; break;
		case 'KlpDialog': specimen = <><KlpButton onClick={() => setOpen(true)}>開啟對話框</KlpButton><KlpDialog open={open} title="編輯資料名稱" onClose={() => setOpen(false)}>{input}</KlpDialog></>; break;
		case 'KlpTooltip': specimen = <KlpTooltip text="支援滑鼠懸停與鍵盤焦點；Escape 關閉"><KlpButton onClick={() => setChecked(!checked)}>查看說明</KlpButton></KlpTooltip>; break;
		case 'KlpStatusBar': specimen = <><KlpButton onClick={() => setChecked(!checked)}>切換工作狀態</KlpButton><KlpStatusBar>{checked ? '工作完成' : '等待操作'} · UTF-8</KlpStatusBar></>; break;
		case 'KlpSeparator': specimen = <><KlpText>主要內容</KlpText><KlpSeparator /><KlpText>補充資訊</KlpText></>; break;
		case 'KlpLink': specimen = <KlpLink href="?catalog=desktop">返回桌面 Catalog</KlpLink>; break;
		case 'KlpAvatar': specimen = <>{input}<KlpAvatar label={text || '使用者'} /></>; break;
		case 'KlpSkeleton': specimen = <><KlpButton onClick={() => setChecked(!checked)}>切換載入狀態</KlpButton>{checked ? <KlpText>內容已載入</KlpText> : <KlpSkeleton />}</>; break;
		default: specimen = advancedComponentNames.includes(name) ? <AdvancedSpecimen name={name} /> : <KlpText>未登錄的桌面 specimen：{name}</KlpText>;
	}
	return <div className="demo-stack">{specimen}<KlpCheckbox label="停用控制（適用輸入／選取元件）" checked={disabled} onChange={event => setDisabled(event.target.checked)} /><KlpText role="caption" aria-live="polite">值：{text} · 選項：{value} · 開關：{checked ? '開' : '關'} · 頁碼：{page}</KlpText></div>;
}
