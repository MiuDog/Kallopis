import type { KlpTheme } from './theme.js';

/** 正式微立體配方：供 Frame 與強調表面共用，避免各元件各自定義陰影。 */
export function resolveRelief(theme: KlpTheme, surface = 'theme.colors.surface') {
	const color = String(theme.semantic(surface));
	const dark = [1, 3, 5].every(index => parseInt(color.slice(index, index + 2), 16) < 100);
	const scale = Number(theme.semantic('theme.spacing.space1')) / 4;
	const shadow = String(theme.semantic('theme.surface.overlayShadowColor')).slice(0, 7);
	return `${2 * scale}px ${3 * scale}px ${5 * scale}px ${-scale}px ${shadow}${dark ? '7A' : '2E'}, ${-scale}px ${-scale}px 0 #FFFFFF${dark ? '12' : 'D9'}`;
}
