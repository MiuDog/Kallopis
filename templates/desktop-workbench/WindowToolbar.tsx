import { KlpFrame, KlpIconButton } from '@kallopis/react';
import type { ReactNode } from 'react';
import './desktop-workbench.css';
export interface WindowToolbarProps {
	/* icons為宿主已授權圖示；三個callback僅呈現視窗操作，不包含IPC或Electron。 */
	icons: { /* minimize／maximize／close：各控制的可替換圖示slot。 */ minimize: ReactNode; maximize: ReactNode; close: ReactNode };
	onMinimize: () => void;
	onMaximize: () => void;
	onClose: () => void;
}
export function WindowToolbar({ icons, onMinimize, onMaximize, onClose }: WindowToolbarProps) {
	return <KlpFrame surface="raised" className="klp-window-toolbar"><div role="toolbar" aria-label="視窗控制"><KlpIconButton tone="window" label="最小化視窗" onClick={onMinimize}>{icons.minimize}</KlpIconButton><KlpIconButton tone="window" label="最大化或還原視窗" onClick={onMaximize}>{icons.maximize}</KlpIconButton><KlpIconButton tone="window" label="關閉視窗" onClick={onClose}>{icons.close}</KlpIconButton></div></KlpFrame>;
}
