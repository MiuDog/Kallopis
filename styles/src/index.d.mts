export type KlpStyleMode = 'light' | 'dark' | 'ultraDark' | 'transparent';
export type KlpStylePrimitive = string | number | (string | number)[];
export type KlpStyleValue = string | number | readonly (string | number)[];
export type KlpStyleDocuments = Record<'primitives' | 'semantics' | 'recipes', string>;

export interface KlpStyleIdentity {

	/** id：風格身份，與元件或產品身份分離。 */
	id: string;
	/** version：風格資料版本，不是交換 schema 版本。 */
	version: string;
}

export interface KlpStyleRecipe {

	/** aliases：雙語查詢名，保持原文。 */
	aliases: string;
	/** inherit：配方繼承記號，不是產品 UI tree。 */
	inherit: string;
	/** parameters：視覺配方原文，不能作為程式執行。 */
	parameters: string;
}

export interface KlpStylePack extends KlpStyleIdentity {

	/** schemaVersion：只接受已支援的交換版本。 */
	schemaVersion: 1;
	/** primitives：值原料，不擁有用途或數值安全界限。 */
	primitives: Record<string, KlpStylePrimitive>;
	/** semantics：用途對應四 mode 的安全表達式。 */
	semantics: Record<string, Record<KlpStyleMode, string>>;
	/** recipes：視覺配方及繼承，不包含事件或行為。 */
	recipes: Record<string, KlpStyleRecipe>;
	/** descriptions：保留文件說明，不複製風格值。 */
	primitiveDescriptions: Record<string, string>;
	semanticDescriptions: Record<string, string>;
}

export interface KlpStyleSnapshot extends Readonly<KlpStyleIdentity> {

	/** mode：解析時選定的主題。 */
	readonly mode: KlpStyleMode;
	/** tokens：深度 frozen 的已驗證資料，由 adapter 處理平台表示法。 */
	readonly tokens: Readonly<Record<string, KlpStyleValue>>;
	/** recipes：深度 frozen 的配方原文，尚不承諾完整 typed 展開。 */
	readonly recipes: Readonly<Record<string, Readonly<KlpStyleRecipe>>>;
}

export interface KlpStyleOverrides {

	/** primitives：只可替換已有原料，所有 mode 都必須重新驗證。 */
	primitives?: Record<string, KlpStylePrimitive>;
	/** semantics：只可覆寫已有用途的部分 mode，不新增身份。 */
	semantics?: Record<string, Partial<Record<KlpStyleMode, string>>>;
}

export function importStyleTables(documents: KlpStyleDocuments, identity: KlpStyleIdentity): KlpStylePack;
export function validateStylePack(pack: unknown): KlpStylePack;
export function exportStyleTables(pack: KlpStylePack): KlpStyleDocuments;
export function resolveStylePack(pack: unknown, mode: KlpStyleMode, catalog: unknown): KlpStyleSnapshot;
export function applyStyleOverrides(pack: unknown, overrides: KlpStyleOverrides, catalog: unknown): KlpStylePack;
