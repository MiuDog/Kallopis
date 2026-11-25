import { useState } from 'react';
import { KlpFrame, KlpText, KlpBadge, KlpTextField, KlpFileExplorer, KlpList, KlpWorkspace } from '@kallopis/react';
import './research.css';

export interface ResearchRecord {
	/* id：穩定識別；title：顯示名稱；category：分類；source：來源；summary：摘要；body：閱讀段落。 */
	id: string;
	title: string;
	category: string;
	source: string;
	summary: string;
	body: readonly string[];
}

export interface ResearchLibraryProps {
	/* records：消費端資料；notes：依識別保存備註；onNoteChange：交還消費端處理修改。 */
	records: readonly ResearchRecord[];
	notes: Readonly<Record<string, string>>;
	onNoteChange: (id: string, value: string) => void;
}

/** 可獨立採用的資料閱讀畫面；外層 consumer 提供正式 theme。 */
export function ResearchLibrary({ records, notes, onNoteChange }: ResearchLibraryProps) {

	const [query, setQuery] = useState('');
	const [category, setCategory] = useState('全部資料');
	const [selectedId, setSelectedId] = useState(records[0]?.id ?? '');
	const [expandedIds, setExpandedIds] = useState(['collection']);
	const categories = ['全部資料', ...new Set(records.map(record => record.category))];
	const visible = records.filter(record => (category === '全部資料' || record.category === category) && `${record.title} ${record.summary}`.toLowerCase().includes(query.toLowerCase()));
	const selected = visible.find(record => record.id === selectedId) ?? visible[0];
	const sections = [{ id: 'collection', label: '研究主題', items: categories.map(label => ({ id: label, label })) }];

	return <div className="research-library">
		<header className="research-heading">
			<div className="research-stack"><KlpText role="caption" tone="muted">個人工作區 / 知識整理</KlpText><KlpText as="h1" role="h2">研究資料庫</KlpText></div>
			<KlpText role="caption" tone="muted">收集線索，形成自己的觀點。</KlpText>
		</header>
		<KlpWorkspace className="research-columns">
			<KlpFrame surface="raised" role="sidebar" className="research-navigation" header={<KlpText role="label">資料收藏</KlpText>} footer={<KlpText role="caption" tone="muted">{records.length} 份資料 · 本地示範</KlpText>}>
				<KlpFileExplorer label="研究分類" sections={sections} selectedId={category} expandedIds={expandedIds} onSelect={setCategory} onToggle={id => setExpandedIds(ids => ids.includes(id) ? [] : [id])} />
			</KlpFrame>
			<KlpFrame surface="raised" className="research-results" header={<KlpText role="body-strong">{category}</KlpText>}>
				<div className="research-pad research-stack">
					<KlpTextField label="搜尋" placeholder="尋找標題或摘要" value={query} onChange={event => setQuery(event.target.value)} />
					<KlpText role="caption" tone="muted" aria-live="polite">{visible.length} 份資料</KlpText>
					<KlpList label="研究資料" items={visible.map(record => ({ id: record.id, title: record.title, description: record.summary, meta: record.category }))} selectedId={selected?.id} onSelect={setSelectedId} empty="沒有符合的資料，請修改搜尋內容或切換分類。" />
				</div>
			</KlpFrame>
			<KlpFrame surface="raised" className="research-reader" header={<div className="research-row"><KlpText role="label">閱讀與思考</KlpText><KlpBadge>研究筆記</KlpBadge></div>}>
				{selected ? <article className="research-article research-stack">
					<KlpText role="caption" tone="muted">{selected.category} / {selected.source}</KlpText>
					<KlpText as="h2" role="h1">{selected.title}</KlpText>
					<KlpText as="p" role="lead" tone="muted">{selected.summary}</KlpText>
					<KlpText as="h3" role="h3">研究摘記</KlpText>
					{selected.body.map(paragraph => <KlpText as="p" key={paragraph}>{paragraph}</KlpText>)}
					<div className="research-note research-stack"><KlpText as="h3" role="h3">我的觀點</KlpText><KlpTextField label="備註" placeholder="記下值得延伸的想法…" value={notes[selected.id] ?? ''} onChange={event => onNoteChange(selected.id, event.target.value)} /><KlpText role="caption" tone="muted">此預覽只暫存於記憶體，重新整理後還原。</KlpText></div>
				</article> : <div className="research-pad"><KlpText tone="muted">選擇資料後，在這裡閱讀內容。</KlpText></div>}
			</KlpFrame>
		</KlpWorkspace>
	</div>;
}
