import type { KlpMode, KlpStylePack } from '@kallopis/react';
export interface ThemeMetadataEntry {
	readonly id: string;
	readonly family: string;
	readonly version: string;
	readonly name: string;
	readonly englishName: string;
	readonly defaultMode: KlpMode;
	readonly description: string;
	readonly packPath: string;
	readonly cssPath: string;
	readonly jsPath: string;
	readonly previewImage: string;
	readonly sourceReference: string;
	readonly surfaceStyle: string;
	readonly elevationStyle: string;
	readonly typography: string;
	readonly orbs?: readonly string[];
	readonly palettePreview: Readonly<Record<'light' | 'dark', readonly string[]>>;
}
export declare const themeMetadata: readonly ThemeMetadataEntry[];
export declare const themePacks: Readonly<Record<string, KlpStylePack>>;
