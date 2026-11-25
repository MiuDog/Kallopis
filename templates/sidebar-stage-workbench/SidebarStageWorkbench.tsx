import { Children, useId, useState, type ReactNode } from 'react';
import { KlpFrame, KlpIconButton, KlpThemeProvider, KlpWorkspace } from '@kallopis/react';
import '@kallopis/react/styles.css';
import './layout.css';
import '../desktop-workbench/desktop-workbench.css';

export interface SidebarStageWorkbenchProps {
	/* sidebar：由產品提供導覽內容，模板不固定業務入口。
	 * stage：目前工作內容，由產品持有資料及切換狀態。
	 * header：可選的 Stage header 內容；每個直接子項各包一個微立體 Panel。 */
	sidebar: ReactNode;
	stage: ReactNode;
	header?: ReactNode;
	/* sidebarHeader／sidebarFooter：產品導覽與底部slot；windowControls：宿主安全控制；edgeToEdge：畫布幾何。 */
	sidebarHeader?: ReactNode;
	sidebarFooter?: ReactNode;
	windowControls?: ReactNode;
	edgeToEdge?: boolean;
}

export function SidebarStageWorkbench({ sidebar, stage, header, sidebarHeader, sidebarFooter, windowControls, edgeToEdge = false }: SidebarStageWorkbenchProps) {

	// React 只持有視覺收合狀態；產品的 Stage 與資料不因收合卸載。
	const [collapsed, setCollapsed] = useState(false);
	const navigationId = useId();
	return <KlpThemeProvider className="workbench-theme">
		<KlpWorkspace className="workbench-shell">
			<KlpFrame role="sidebar" surface="raised" className="workbench-sidebar" hidden={collapsed} footer={sidebarFooter} header={<div className="workbench-sidebar-header">
				{sidebarHeader}<KlpIconButton className="workbench-collapse" tone="inline" size="sm" label={collapsed ? '展開左側欄' : '收合左側欄'} aria-expanded={!collapsed} aria-controls={navigationId} onClick={() => setCollapsed(value => !value)}><span aria-hidden="true">{collapsed ? '›' : '‹'}</span></KlpIconButton>
				<div className="workbench-header-divider" role="separator" aria-orientation="horizontal" />
			</div>}>
				<div id={navigationId} className="workbench-navigation-host" hidden={collapsed}>{sidebar}</div>
			</KlpFrame>
			<div className="workbench-stage-region">
				<header className="workbench-stage-header klp-window-header" aria-label="Stage header">
					{collapsed && <KlpFrame surface="raised" className="workbench-stage-expand"><KlpIconButton tone="inline" label="展開左側欄" aria-expanded={false} aria-controls={navigationId} onClick={() => setCollapsed(false)}><span aria-hidden="true">›</span></KlpIconButton></KlpFrame>}
					{/* 直接子項各自套用 Kallopis 公開微立體配方，不讓產品複製陰影數值。 */}
					{Children.map(header, item => <KlpFrame surface="raised" className="workbench-header-height-sample">{item}</KlpFrame>)}
				{windowControls}</header>
				<KlpFrame surface="raised" className="workbench-stage">
					<main aria-label="Stage" className={`workbench-stage-content ${edgeToEdge ? 'workbench-stage-edge' : ''}`}>{stage}</main>
				</KlpFrame>
			</div>
		</KlpWorkspace>
	</KlpThemeProvider>;
}
