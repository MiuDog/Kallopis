import { KlpButton, KlpFrame } from '@kallopis/react';
import './pending-changes.css';

export interface PendingChangesBannerProps {
	/* visible：宿主判定是否有變更；attention：宿主攔截切換時遞增以重播提示；busy：保存期間鎖操作。
	 * error：必要操作回饋；onSave／onDiscard：宿主提供行為，本元件不持有資料、路由或持久層。 */
	visible: boolean;
	attention: number;
	busy: boolean;
	error?: string;
	onSave: () => void;
	onDiscard: () => void;
}
export function PendingChangesBanner({ visible, attention, busy, error, onSave, onDiscard }: PendingChangesBannerProps) {
	if (!visible && !busy) return null;
	return <div className="klp-pending-host" role="status" aria-live="polite"><KlpFrame key={attention} surface="flat" className={`klp-pending-banner ${attention ? 'klp-pending-attention' : ''}`}><span>{error || '有尚未保存的變更'}</span><div className="klp-pending-actions"><KlpButton disabled={busy} onClick={onDiscard}>捨棄變更</KlpButton><KlpButton disabled={busy} onClick={onSave}>{busy ? '保存中…' : '保存變更'}</KlpButton></div></KlpFrame></div>;
}
