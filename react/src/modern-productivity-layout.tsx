import { useLayoutEffect, useRef, type ReactNode } from 'react';
import { KlpButton, KlpFrame, KlpSurface } from './components.js';
import { KlpAppLayout, KlpLayoutRow, KlpLayoutColumn, KlpLayoutPane } from './workbench-layout.js';
import { useKlp } from './theme.js';

/** 單一側欄功能；產品擁有內容資料。 */
export interface KlpModernProductivityPanel {
	/* id：重排及切換的穩定身分；label：按鈕的文字與可存取名稱；content：原生產品內容。 */
	readonly id: string;
	readonly label: string;
	readonly content: ReactNode;
}

/** 現代風生產力模板的受控公開輸入。 */
export interface KlpModernProductivityLayoutProps {
	/* panels：有序功能；selectedId：產品選取；onSelected：切換提案，不自行更新產品。 */
	panels: readonly KlpModernProductivityPanel[];
	selectedId: string;
	onSelected?: ((id: string) => void) | null;
	/* header／stage：右區角色；sidebarWidth：可選期望寬度，省略時使用正式語意。 */
	header: ReactNode;
	stage: ReactNode;
	sidebarWidth?: number;
}

function validate({ panels, selectedId, sidebarWidth }: KlpModernProductivityLayoutProps) {
	if (!panels.length) throw new TypeError('panels must not be empty');
	const ids = new Set<string>();
	for (const panel of panels) {
		if (!panel.id.trim() || ids.has(panel.id)) throw new TypeError('panel id must be unique and nonempty');
		if (!panel.label.trim()) throw new TypeError('panel label must not be empty');
		ids.add(panel.id);
	}
	if (!ids.has(selectedId)) throw new TypeError('selectedId must identify a panel');
	if (sidebarWidth !== undefined && (!Number.isFinite(sidebarWidth) || sidebarWidth <= 0)) throw new TypeError('sidebarWidth must be finite and positive');
}

/** 全高左側欄與右區 Header／Stage；切換時保留各面板身分。 */
export function KlpModernProductivityLayout(props: KlpModernProductivityLayoutProps) {
	const theme = useKlp();
	const panelHost = useRef<HTMLDivElement>(null);
	validate(props);
	const { panels, selectedId, onSelected, header, stage } = props;
	const width = props.sidebarWidth ?? Number(theme.semantic('theme.geometry.layout.primaryPaneWidth'));
	const inset = Number(theme.semantic('theme.spacing.chromePanelInset'));
	const actionGap = Number(theme.semantic('theme.spacing.actionGap'));
	const headerHeight = Number(theme.semantic('theme.spacing.chromeHeader'));
	useLayoutEffect(() => {
		// 程式切換也不能讓焦點留在已隱藏面板；不強制跳到內容。
		const active = panelHost.current?.ownerDocument.activeElement;
		if (active instanceof HTMLElement && active.closest('[data-klp-productivity-panel][hidden]')) active.blur();
	}, [selectedId, panels]);
	return <KlpAppLayout data-klp-template="modern-productivity-layout">
		<KlpLayoutRow>
			<KlpLayoutPane flex={0} bounds={{ preferred: width }}>
				<KlpFrame role="sidebar" data-klp-productivity="sidebar" style={{ width: '100%', height: '100%', minWidth: 0, minHeight: 0, padding: 0, overflow: 'hidden', borderRadius: Number(theme.semantic('theme.shape.panel')) }}>
					<KlpLayoutColumn spacing="none">
						<KlpLayoutPane flex={0} bounds={{ preferred: Number(theme.semantic('theme.geometry.control.buttonHeight')) + inset * 2 }}>
							<div style={{ display: 'flex', gap: actionGap, padding: inset, overflowX: 'auto', height: '100%', boxSizing: 'border-box' }}>
								{panels.map(panel => <KlpButton key={panel.id} selected={panel.id === selectedId} disabled={!onSelected} onClick={() => { if (panel.id !== selectedId) onSelected?.(panel.id); }} style={{ flexShrink: 0 }}>{panel.label}</KlpButton>)}
							</div>
						</KlpLayoutPane>
						<KlpLayoutPane><div ref={panelHost} style={{ height: '100%', overflow: 'hidden' }}>
							{panels.map(panel => <div key={panel.id} data-klp-productivity-panel={panel.id} hidden={panel.id !== selectedId} inert={panel.id !== selectedId} style={{ height: '100%', overflow: 'auto' }}>{panel.content}</div>)}
						</div></KlpLayoutPane>
					</KlpLayoutColumn>
				</KlpFrame>
			</KlpLayoutPane>
			<KlpLayoutPane><KlpSurface tone="stage" data-klp-productivity="stage-region" style={{ height: '100%', overflow: 'hidden', padding: 0, borderRadius: 0 }}>
				<KlpLayoutColumn spacing="none">
					<KlpLayoutPane flex={0} bounds={{ minimum: headerHeight }}><div data-klp-productivity="header" style={{ minHeight: headerHeight }}>{header}</div></KlpLayoutPane>
					<KlpLayoutPane><div data-klp-productivity="stage" style={{ height: '100%', overflow: 'auto' }}>{stage}</div></KlpLayoutPane>
				</KlpLayoutColumn>
			</KlpSurface></KlpLayoutPane>
		</KlpLayoutRow>
	</KlpAppLayout>;
}
