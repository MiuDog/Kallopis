import { useMemo, useState } from 'react';
import { KlpAppLayout, KlpLayoutRow, KlpLayoutColumn, KlpLayoutPane, KlpLayoutDivider, KlpThemeProvider, KlpCard, KlpSurface, KlpText, KlpButton, KlpTextField, applyKlpStyleOverrides, type KlpMode, type KlpStylePack } from '@kallopis/react';

interface LayoutDemoProps {
	/** 使用宿主目前風格，不在展示建立另一份預設值。 */
	mode: KlpMode;
	stylePack: KlpStylePack;
}

export function LayoutDemo({ mode, stylePack }: LayoutDemoProps) {
	const [width, setWidth] = useState(480);
	const [height, setHeight] = useState(300);
	const [alignment, setAlignment] = useState<'start' | 'end'>('start');
	const [inset, setInset] = useState<'standard' | 'none'>('standard');
	const [gap, setGap] = useState<'current' | '12' | 'large'>('current');
	const [count, setCount] = useState(0);
	const previewPack = useMemo(() => {
		if (gap === 'current') return stylePack;
		const value = gap === 'large' ? 'p(radiusFull)' : 'p(space300)';
		return applyKlpStyleOverrides(stylePack, { semantics: { 'theme.spacing.space2': { light: value, dark: value, ultraDark: value, transparent: value } } });
	}, [stylePack, gap]);
	return <KlpCard header={<KlpText role="body-strong">一般布局互動展示</KlpText>}>
		<div className="demo-stack">
			<KlpText role="caption" tone="muted">每層只扣自己的間距；最小尺寸不足會比例縮小，上限留下的空間依對齊保留。</KlpText>
			<div className="demo-row" aria-label="布局寬度">{[160, 480, 760].map(value => <KlpButton key={value} size="sm" selected={width === value} onClick={() => setWidth(value)}>寬 {value}</KlpButton>)}</div>
			<div className="demo-row" aria-label="布局高度">{[100, 300].map(value => <KlpButton key={value} size="sm" selected={height === value} onClick={() => setHeight(value)}>高 {value}</KlpButton>)}</div>
			<div className="demo-row">
				<KlpButton size="sm" selected={alignment === 'end'} onClick={() => setAlignment(value => value === 'start' ? 'end' : 'start')}>內容靠底</KlpButton>
				<KlpButton size="sm" selected={inset === 'none'} onClick={() => setInset(value => value === 'standard' ? 'none' : 'standard')}>取消外距</KlpButton>
				<KlpButton size="sm" selected={gap === '12'} onClick={() => setGap('12')}>布局間距 12</KlpButton>
				<KlpButton size="sm" selected={gap === 'large'} onClick={() => setGap('large')}>極大布局間距</KlpButton>
				<KlpButton size="sm" onClick={() => setGap('current')}>還原布局間距</KlpButton>
			</div>
			<KlpThemeProvider mode={mode} stylePack={previewPack} className="demo-layout-preview" style={{ width, height }} aria-label="一般布局預覽">
				<KlpAppLayout inset={inset}>
					<KlpLayoutRow>
						<KlpLayoutPane id="layout-sidebar" flex={0} bounds={{ minimum: 80, maximum: 160, preferred: 120 }}>
							<KlpSurface tone="inset" className="demo-layout-content"><KlpText role="label">SIDEBAR</KlpText><KlpText role="caption">preferred 120</KlpText></KlpSurface>
						</KlpLayoutPane>
						<KlpLayoutDivider />
						<KlpLayoutColumn id="layout-main" bounds={{ minimum: 80 }} alignment={alignment}>
							<KlpLayoutPane id="layout-toolbar" flex={0} bounds={{ preferred: 40 }}>
								<KlpSurface tone="raised" className="demo-layout-toolbar"><KlpText role="caption">WORKBENCH</KlpText></KlpSurface>
							</KlpLayoutPane>
							<KlpLayoutDivider />
							<KlpLayoutPane id="layout-body" bounds={{ maximum: 140 }}>
								<KlpSurface className="demo-layout-content">
									<KlpTextField label="保留的產品輸入" defaultValue="切換尺寸仍保留" />
									<KlpButton size="sm" onClick={() => setCount(value => value + 1)}>執行動作</KlpButton>
								</KlpSurface>
							</KlpLayoutPane>
						</KlpLayoutColumn>
					</KlpLayoutRow>
				</KlpAppLayout>
			</KlpThemeProvider>
			<KlpText role="caption" aria-live="polite">容器 {width} × {height} · 已執行 {count} 次</KlpText>
			<KlpText role="caption">自然主軸：量測 70 的內容與 preferred 30，flex 不延伸填滿。</KlpText>
			<div className="demo-layout-natural">
				<KlpLayoutRow sizing="content">
					<KlpLayoutPane flex={0}><div style={{ width: 70 }}><KlpText role="caption">自然 70</KlpText></div></KlpLayoutPane>
					<KlpLayoutPane bounds={{ preferred: 30 }}><KlpText role="caption">30</KlpText></KlpLayoutPane>
				</KlpLayoutRow>
			</div>
		</div>
	</KlpCard>;
}
