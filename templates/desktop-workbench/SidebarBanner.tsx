import { KlpFrame } from '@kallopis/react';
import type { ReactNode } from 'react';
import './desktop-workbench.css';
export function SidebarBanner({ leading, actions }: { /* leading：左半內容slot；actions：右側按鈕slot。資料與操作由consumer擁有。 */ leading: ReactNode; actions: ReactNode }) {
	return <KlpFrame surface="flat" className="klp-sidebar-banner"><div className="klp-sidebar-banner-leading">{leading}</div><div className="klp-sidebar-banner-actions">{actions}</div></KlpFrame>;
}
