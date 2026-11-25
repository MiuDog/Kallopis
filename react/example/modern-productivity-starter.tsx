import { useState } from 'react';
import { KlpModernProductivityLayout, KlpText, KlpTextField, useKlp } from '@kallopis/react';

/** 可複製的產品接線：選取與草稿由 consumer 擁有。 */
export function ModernProductivityStarter({ sidebarWidth }: { sidebarWidth?: number }) {
	const theme = useKlp();
	const [selectedId, setSelectedId] = useState('navigation');
	const [navigation, setNavigation] = useState('');
	const [tools, setTools] = useState('');
	const inset = Number(theme.semantic('theme.spacing.contentInset'));
	return <KlpModernProductivityLayout
		sidebarWidth={sidebarWidth}
		selectedId={selectedId}
		onSelected={setSelectedId}
		panels={[
			{ id: 'navigation', label: '導航', content: <div style={{ padding: inset }}><KlpTextField label="導航草稿" value={navigation} onChange={event => setNavigation(event.target.value)} /></div> },
			{ id: 'tools', label: '工具', content: <div style={{ padding: inset }}><KlpTextField label="工具草稿" value={tools} onChange={event => setTools(event.target.value)} /></div> },
		]}
		header={<div style={{ padding: inset }}><KlpText role="body-strong">微立體工作台佈局</KlpText></div>}
		stage={<div style={{ padding: inset }}><KlpText>Stage：替換成你的作品內容。工具功能已整合在左側欄。</KlpText></div>}
	/>;
}
