export interface CatalogPropEntry {
	readonly name: string;
	readonly type: string;
	readonly required: boolean;
	readonly defaultValue: string | null;
	readonly documentation: string;
}
export interface CatalogTokenBinding {
	readonly id: string;
	readonly css: string;
	readonly flutter: string;
}
export interface CatalogComponentMeta {
	readonly name: string;
	readonly id: string;
	readonly source: string;
	readonly signature: string;
	readonly documentation: string;
	readonly props: readonly CatalogPropEntry[];
	readonly tokens: readonly CatalogTokenBinding[];
}
export declare const catalogProps: Readonly<Record<string, CatalogComponentMeta>>;
