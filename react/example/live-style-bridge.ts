import { useEffect, useMemo, useState, type CSSProperties } from 'react';
import type { KlpMode } from '@kallopis/react';
import { themePacks } from './theme-presets.mjs';

const modes: readonly KlpMode[] = ['light', 'dark', 'ultraDark', 'transparent'];

// 從即時編輯的 CSS 文字解析出適用於目前 mode 的 --klp-* 覆寫變數，確保可直接蓋過 KlpThemeProvider 的 inline style。
function parseLiveCssVariables(cssText: string, mode: KlpMode): CSSProperties {
	if (!cssText.trim()) return {};
	const vars: Record<string, string> = {};
	const cleaned = cssText.replace(/\/\*[\s\S]*?\*\//g, '');
	const blockPattern = /([^{}]+)\{([^{}]*)\}/g;
	let match: RegExpExecArray | null;
	while ((match = blockPattern.exec(cleaned)) !== null) {
		const selector = match[1].trim();
		const body = match[2];
		const matchesRoot = /(?:^|,)\s*:root(?:\s|,|$)/.test(selector);
		const matchesMode = selector.includes(`[data-klp-mode="${mode}"]`) || selector.includes(`[data-klp-mode='${mode}']`);
		if (!matchesRoot && !matchesMode) continue;
		const declPattern = /(--klp-[a-zA-Z0-9_-]+)\s*:\s*([^;]+);/g;
		let decl: RegExpExecArray | null;
		while ((decl = declPattern.exec(body)) !== null) {
			vars[decl[1]] = decl[2].trim();
		}
	}
	return vars as CSSProperties;
}

/** 同步外層風格示範／元件表的獨立風格、模式與即時 CSS 覆寫，絕不互相綁定狀態。 */
export function useLiveStyleBridge(initialThemeId = 'micro-elevation-v1', initialMode: KlpMode = 'light') {
	const [themeId, setThemeIdState] = useState(() => {
		if (typeof window === 'undefined') return initialThemeId;
		const requested = new URLSearchParams(window.location.search).get('theme');
		return requested && themePacks[requested] ? requested : initialThemeId;
	});
	const [mode, setModeState] = useState<KlpMode>(() => {
		if (typeof window === 'undefined') return initialMode;
		const requested = new URLSearchParams(window.location.search).get('mode');
		return requested && modes.includes(requested as KlpMode) ? (requested as KlpMode) : initialMode;
	});
	const [customCss, setCustomCss] = useState('');

	useEffect(() => {
		const id = 'klp-live-css-override';
		let styleEl = document.getElementById(id) as HTMLStyleElement | null;
		if (!styleEl) {
			styleEl = document.createElement('style');
			styleEl.id = id;
			document.head.append(styleEl);
		}
		styleEl.textContent = customCss;
	}, [customCss]);

	useEffect(() => {
		function onMessage(event: MessageEvent) {
			const data = event.data;
			if (!data || typeof data !== 'object') return;
			if (data.type === 'klp-style-change') {
				if (typeof data.themeId === 'string' && themePacks[data.themeId]) setThemeIdState(data.themeId);
				if (typeof data.mode === 'string' && modes.includes(data.mode as KlpMode)) setModeState(data.mode as KlpMode);
			} else if (data.type === 'klp-custom-css' && typeof data.css === 'string') {
				setCustomCss(data.css);
			}
		}
		window.addEventListener('message', onMessage);
		return () => window.removeEventListener('message', onMessage);
	}, []);

	function setThemeId(nextThemeId: string) {
		if (!themePacks[nextThemeId]) return;
		setThemeIdState(nextThemeId);
		if (window.parent !== window) {
			window.parent.postMessage({ type: 'klp-style-change', themeId: nextThemeId }, '*');
		}
	}

	function setMode(nextMode: KlpMode) {
		if (!modes.includes(nextMode)) return;
		setModeState(nextMode);
		if (window.parent !== window) {
			window.parent.postMessage({ type: 'klp-style-change', mode: nextMode }, '*');
		}
	}

	const customVars = useMemo(() => parseLiveCssVariables(customCss, mode), [customCss, mode]);
	return { themeId, mode, customCss, customVars, setThemeId, setMode };
}
