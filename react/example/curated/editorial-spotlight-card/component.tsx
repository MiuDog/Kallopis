import { useState } from 'react';
import { KlpBadge, KlpButton, KlpText } from '@kallopis/react';

const orbs = [
	{ id: 'mint', label: 'Mint', color: '#A7E5D3' },
	{ id: 'peach', label: 'Peach', color: '#F4C5A8' },
	{ id: 'lavender', label: 'Lavender', color: '#C8B8E0' },
	{ id: 'sky', label: 'Sky', color: '#A8C8E8' },
] as const;

/** 編輯風光暈焦點卡：結合 open-tag 的 1px 細線與柔和光暈點綴。 */
export default function EditorialSpotlightCard({
	title = 'Quietly Editorial Workspace',
	initialOrb = 'peach',
}: {
	title?: string;
	initialOrb?: (typeof orbs)[number]['id'];
}) {
	const [orbId, setOrbId] = useState<(typeof orbs)[number]['id']>(initialOrb);
	const [bookmarked, setBookmarked] = useState(false);
	const activeOrb = orbs.find(item => item.id === orbId) ?? orbs[1];

	return (
		<article className="klp-curated-editorial-card">
			<div className="klp-curated-editorial-orb" style={{ background: `radial-gradient(circle at top right, ${activeOrb.color}55, transparent 68%)` }} aria-hidden="true" />
			<div className="klp-curated-editorial-body">
				<div className="klp-curated-editorial-head">
					<KlpText role="label" tone="muted">EDITORIAL · CALM · EXPERT</KlpText>
					<KlpBadge>{activeOrb.label}</KlpBadge>
				</div>
				<h3 className="klp-curated-editorial-title">{title}</h3>
				<KlpText role="caption" tone="muted">以留白、字重與 1px 細線建立閱讀節奏，僅在角落保留微弱的柔和光暈。</KlpText>
				<div className="klp-curated-editorial-footer">
					<div className="klp-curated-orb-dots" role="group" aria-label="切換光暈色調">
						{orbs.map(item => (
							<button
								key={item.id}
								type="button"
								className="klp-curated-orb-btn"
								aria-label={`光暈 ${item.label}`}
								aria-pressed={orbId === item.id}
								style={{ background: item.color }}
								onClick={() => setOrbId(item.id)}
							/>
						))}
					</div>
					<KlpButton size="sm" tone={bookmarked ? 'primary' : 'secondary'} selected={bookmarked} onClick={() => setBookmarked(value => !value)}>
						{bookmarked ? '已收藏設計案例 ✓' : '收藏設計案例'}
					</KlpButton>
				</div>
			</div>
		</article>
	);
}
