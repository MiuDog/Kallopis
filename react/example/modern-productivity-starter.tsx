import { useState } from 'react';
import { KlpModernProductivityLayout, KlpText, KlpTextField } from '@kallopis/react';

/** 可複製的產品接線：選取與草稿由 consumer 擁有。 */
export function ModernProductivityStarter({ sidebarWidth }: { sidebarWidth?: number }) {
	const [selectedId, setSelectedId] = useState('navigation');
	const [navigation, setNavigation] = useState('');
	const [tools, setTools] = useState('');
	return <KlpModernProductivityLayout
		sidebarWidth={sidebarWidth}
		selectedId={selectedId}
		onSelected={setSelectedId}
		panels={[
			{ id: 'navigation', label: '導航', content: <div className="demo-inset-pad"><KlpTextField label="導航草稿" value={navigation} onChange={event => setNavigation(event.target.value)} /></div> },
			{ id: 'tools', label: '工具', content: <div className="demo-inset-pad"><KlpTextField label="工具草稿" value={tools} onChange={event => setTools(event.target.value)} /></div> },
		]}
		header={<div className="demo-inset-pad"><KlpText role="body-strong">微立體工作台佈局</KlpText></div>}
		stage={<div className="demo-inset-pad"><KlpText>Stage：替換成你的作品內容。工具功能已整合在左側欄。</KlpText></div>}
	/>;
}
