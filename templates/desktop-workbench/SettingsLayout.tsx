import { KlpFrame } from '@kallopis/react';
import type { ReactNode } from 'react';
import './desktop-workbench.css';
export function SettingsLayout({ navigation, content, header, notice }: { /* navigation／content為雙區slot，header為視窗操作，notice由consumer提供待決提示。 */ navigation: ReactNode; content: ReactNode; header: ReactNode; notice?: ReactNode }) {
	return <div className="klp-settings-layout"><header className="klp-settings-header klp-window-header">{header}</header><div className="klp-settings-body"><KlpFrame surface="flat" className="klp-settings-navigation">{navigation}</KlpFrame><KlpFrame surface="flat" className="klp-settings-content"><main aria-label="設定內容" className="klp-form-fields">{content}</main>{notice}</KlpFrame></div></div>;
}
