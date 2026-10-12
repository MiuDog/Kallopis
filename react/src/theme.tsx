import { createContext, useContext, useMemo, type CSSProperties, type HTMLAttributes } from 'react';
import { klpThemes, klpRecipes } from './generated.js';

export type KlpMode = keyof typeof klpThemes;
export type KlpSemantic = keyof typeof klpThemes.light;
export type KlpRecipe = keyof typeof klpRecipes;
export type KlpTokenValue = string | number | readonly (string | number)[];
export interface KlpTheme {
	mode: KlpMode;
	tokens: Readonly<Record<KlpSemantic, KlpTokenValue>>;
	semantic: (id: string) => KlpTokenValue;
}

// 明確拒絕未知主題，避免 consumer 拼字錯誤時悄悄回退。
export function createKlpTheme(mode: KlpMode = 'light'): KlpTheme['tokens'] {
	if (!Object.hasOwn(klpThemes, mode)) throw new Error(`Unknown Klp theme mode: ${mode}`);
	return klpThemes[mode];
}
export function getKlpRecipe(id: KlpRecipe) {
	if (!Object.hasOwn(klpRecipes, id)) throw new Error(`Unknown Klp recipe: ${id}`);
	return klpRecipes[id];
}
const ThemeContext = createContext<KlpTheme | null>(null);
export function useKlp(): KlpTheme {
	const theme = useContext(ThemeContext);
	if (!theme) throw new Error('KlpThemeProvider is required');
	return theme;
}
export interface KlpThemeProviderProps extends HTMLAttributes<HTMLDivElement> {
	mode?: KlpMode;
}
export function KlpThemeProvider({ mode = 'light', children, className = '', ...props }: KlpThemeProviderProps) {
	const theme = useMemo<KlpTheme>(() => {
		const tokens = createKlpTheme(mode);
		return { mode, tokens, semantic(id) {
			if (!Object.hasOwn(tokens, id)) throw new Error(`Unknown Klp semantic: ${id}`);
			return tokens[id as KlpSemantic];
		} };
	}, [mode]);
	const brand = String(theme.semantic('theme.colors.brand'));
	// primaryForeground 與 byBrightness 採正式記號中各自指定的亮度算法。
	const rgb = [1, 3, 5].map(index => parseInt(brand.slice(index, index + 2), 16));
	const luma = rgb.reduce((sum, value, index) => sum + value * [0.299, 0.587, 0.114][index], 0);
	const foreground = theme.semantic(luma < 160 ? 'theme.colors.onDarkBackground' : 'theme.colors.onLightBackground');
	const surface = String(theme.semantic('theme.colors.surface'));
	const luminance = [1, 3, 5].map(index => parseInt(surface.slice(index, index + 2), 16) / 255).map(value => value <= 0.04045 ? value / 12.92 : ((value + 0.055) / 1.055) ** 2.4).reduce((sum, value, index) => sum + value * [0.2126, 0.7152, 0.0722][index], 0);
	const style = { '--klp-primary-foreground': foreground, '--klp-icon-wash': theme.semantic(luminance < 0.5 ? 'theme.surface.selectionWashOpacity' : 'theme.surface.focusWashOpacity'), ...props.style } as CSSProperties;
	return <ThemeContext.Provider value={theme}><div {...props} style={style} className={`klp-theme ${className}`} data-klp-mode={mode}>{children}</div></ThemeContext.Provider>;
}
