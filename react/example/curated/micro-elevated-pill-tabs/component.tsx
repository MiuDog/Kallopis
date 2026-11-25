import { useState, type KeyboardEvent } from 'react';
import { KlpBadge, KlpButton, KlpSurface, KlpText } from '@kallopis/react';

export interface MicroElevatedTabItem {
	id: string;
	label: string;
	count?: number;
}

const defaultTabs: readonly MicroElevatedTabItem[] = [
	{ id: 'readme', label: 'README.md', count: 12 },
	{ id: 'tokens', label: 'tokens.css', count: 350 },
	{ id: 'showcase', label: 'showcase.tsx', count: 60 },
];

/** 微立體膠囊分頁列：從 styles/curated/micro-elevated-pill-tabs 自動載入。 */
export default function MicroElevatedPillTabs({ initialTabs = defaultTabs }: { initialTabs?: readonly MicroElevatedTabItem[] }) {
	const [tabs, setTabs] = useState<MicroElevatedTabItem[]>([...initialTabs]);
	const [activeId, setActiveId] = useState(initialTabs[0]?.id ?? 'readme');
	const [nextIndex, setNextIndex] = useState(1);

	const activeTab = tabs.find(item => item.id === activeId) ?? tabs[0];

	function onKeyDown(event: KeyboardEvent<HTMLDivElement>) {
		if (!tabs.length) return;
		const index = tabs.findIndex(item => item.id === activeId);
		if (event.key === 'ArrowRight') {
			event.preventDefault();
			setActiveId(tabs[(index + 1) % tabs.length].id);
		} else if (event.key === 'ArrowLeft') {
			event.preventDefault();
			setActiveId(tabs[(index - 1 + tabs.length) % tabs.length].id);
		}
	}

	function addTab() {
		const id = `draft-${nextIndex}`;
		setNextIndex(value => value + 1);
		setTabs(prev => [...prev, { id, label: `untitled-${nextIndex}.md`, count: 0 }]);
		setActiveId(id);
	}

	function closeTab(id: string) {
		setTabs(prev => {
			if (prev.length <= 1) return prev;
			const next = prev.filter(item => item.id !== id);
			if (activeId === id) setActiveId(next[next.length - 1].id);
			return next;
		});
	}

	return (
		<div className="klp-curated-tabs-wrap">
			<div className="klp-curated-tabstrip" role="tablist" aria-label="微立體工作區分頁" onKeyDown={onKeyDown}>
				{tabs.map(tab => {
					const selected = tab.id === activeId;
					return (
						<div key={tab.id} className="klp-curated-tab-pill" data-active={selected}>
							<KlpButton size="xs" tone="ghost" selected={selected} className="klp-curated-tab-trigger" onClick={() => setActiveId(tab.id)}>
								<span className="klp-curated-tab-dot" aria-hidden="true" />
								<span>{tab.label}</span>
								{typeof tab.count === 'number' && <KlpBadge>{tab.count}</KlpBadge>}
							</KlpButton>
							{tabs.length > 1 && (
								<KlpButton size="xs" tone="ghost" className="klp-curated-tab-close" aria-label={`關閉 ${tab.label}`} onClick={() => closeTab(tab.id)}>×</KlpButton>
							)}
						</div>
					);
				})}
				<KlpButton size="sm" onClick={addTab}>+ 新增分頁</KlpButton>
			</div>
			<KlpSurface tone="stage" className="klp-curated-tab-stage">
				<KlpText role="body-strong">{activeTab?.label}</KlpText>
				<KlpText role="caption" tone="muted">使用左右方向鍵或點擊分頁切換；表面陰影與強調點由目前風格自動解析。</KlpText>
			</KlpSurface>
		</div>
	);
}
