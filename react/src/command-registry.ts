import type { ReactNode } from 'react';

export interface KlpCommandDefinition<C = unknown> {
	/* id 保留產品識別；label 為呈現名稱；description/category/keywords 供入口搜尋；icon 保持原生呈現引用。 */
	readonly id: string;
	readonly label: string;
	readonly description?: string;
	readonly category?: string;
	readonly keywords?: readonly string[];
	readonly icon?: ReactNode;
	/* handler 擁有業務；三個 predicate 每次讀 caller context，不建立狀態鏡像。 */
	readonly handler: (context: C) => unknown | PromiseLike<unknown>;
	readonly isVisible?: (context: C) => boolean;
	readonly isEnabled?: (context: C) => boolean;
	readonly isChecked?: (context: C) => boolean;
}

export interface KlpCommandConditionError {
	/* error 保留原值，包裝記錄讓 throw undefined 仍可診斷。 */
	readonly error: unknown;
}

export interface KlpCommandState {
	/* metadata 為本次唯讀快照；keywords 複製凍結，icon 不凍結產品物件。 */
	readonly id: string;
	readonly label: string;
	readonly description?: string;
	readonly category?: string;
	readonly keywords: readonly string[];
	readonly icon?: ReactNode;
	/* visible/enabled/checked 是最新條件；running 屬於註冊 token；conditionError 保留失敗。 */
	readonly visible: boolean;
	readonly enabled: boolean;
	readonly checked: boolean;
	readonly running: boolean;
	readonly conditionError: KlpCommandConditionError | null;
}

export type KlpCommandExecutionResult =
	/* commandId 保留執行目標；status 決定 value 或 error/phase 的合法可達性。 */
	| Readonly<{ commandId: string; status: 'executed'; value: unknown }>
	| Readonly<{ commandId: string; status: 'missing' | 'hidden' | 'disabled' | 'busy' | 'disposed' }>
	| Readonly<{ commandId: string; status: 'error'; error: unknown; phase: 'condition' | 'handler' }>;

interface CommandEntry<C> {
	/* definition 是隔離後的自有 metadata 與 callback；running 隨 owner 存活，不依 ID 共用。 */
	readonly definition: KlpCommandDefinition<C> & { readonly keywords: readonly string[] };
	running: boolean;
}

interface Observer {
	/* listener 以獨立記錄識別，即使 callback 相同仍有不同 owner。 */
	readonly listener: () => void;
}

function requireText(value: unknown, name: string): asserts value is string {
	if (typeof value !== 'string' || value.trim().length === 0) throw new TypeError(`${name} must contain non-whitespace text`);
}

function copyDefinition<C>(definition: KlpCommandDefinition<C>): CommandEntry<C>['definition'] {
	if (!definition || typeof definition !== 'object') throw new TypeError('Command definition must be an object');
	requireText(definition.id, 'id');
	requireText(definition.label, 'label');
	for (const name of ['description', 'category'] as const) {
		if (definition[name] !== undefined) requireText(definition[name], name);
	}
	if (typeof definition.handler !== 'function') throw new TypeError('handler must be a function');
	for (const name of ['isVisible', 'isEnabled', 'isChecked'] as const) {
		if (definition[name] !== undefined && typeof definition[name] !== 'function') throw new TypeError(`${name} must be a function`);
	}
	const keywords = definition.keywords === undefined ? [] : definition.keywords;
	if (!Array.isArray(keywords)) throw new TypeError('keywords must be an array');
	for (const keyword of keywords) requireText(keyword, 'keyword');
	const copy: CommandEntry<C>['definition'] = {
		id: definition.id,
		label: definition.label,
		description: definition.description,
		category: definition.category,
		keywords: Object.freeze([...keywords]),
		icon: definition.icon,
		handler: definition.handler,
		isVisible: definition.isVisible,
		isEnabled: definition.isEnabled,
		isChecked: definition.isChecked,
	};
	return Object.freeze(copy);
}

function evaluate<C>(predicate: ((context: C) => boolean) | undefined, context: C, fallback: boolean): boolean {
	const value = predicate ? predicate(context) : fallback;
	if (typeof value !== 'boolean') throw new TypeError('Command predicate must return boolean');
	return value;
}

function snapshot<C>(entry: CommandEntry<C>, context: C): KlpCommandState {
	const definition = entry.definition;
	let visible = false;
	let enabled = false;
	let checked = false;
	let conditionError: KlpCommandConditionError | null = null;
	try {
		visible = evaluate(definition.isVisible, context, true);
		enabled = evaluate(definition.isEnabled, context, true);
		checked = evaluate(definition.isChecked, context, false);
	}
	catch (error) {
		visible = false;
		enabled = false;
		checked = false;
		conditionError = Object.freeze({ error });
	}
	const state: KlpCommandState = {
		id: definition.id,
		label: definition.label,
		description: definition.description,
		category: definition.category,
		keywords: definition.keywords,
		icon: definition.icon,
		visible,
		enabled,
		checked,
		running: entry.running,
		conditionError,
	};
	return Object.freeze(state);
}

function reportToHost(error: unknown): void {
	// observer 錯誤只交宿主；宿主通道本身失敗也不能破壞 pending finally。
	try {
		if (typeof globalThis.reportError === 'function') globalThis.reportError(error);
		else console.error(error);
	}
	catch {
		// 宿主錯誤處理器不屬於命令生命週期，避免其錯誤蓋過產品結果。
	}
}

export class KlpCommandRegistry<C = unknown> {
	/* entries 以註冊物件識別 owner；observers 隔離訂閱；revision/closed 提供宿主失效與銷毀狀態。 */
	private readonly entries = new Map<string, CommandEntry<C>>();
	private readonly observers = new Set<Observer>();
	private revision = 0;
	private closed = false;
	/* onObserverError 接 observer 診斷，不接產品 handler 錯誤。 */
	constructor(private readonly onObserverError?: (error: unknown) => void) {}

	get version(): number { return this.revision; }
	get isDisposed(): boolean { return this.closed; }

	register(definition: KlpCommandDefinition<C>): () => void {
		this.requireOpen();
		const copy = copyDefinition(definition);
		if (this.entries.has(copy.id)) throw new TypeError(`Duplicate command: ${copy.id}`);
		const entry: CommandEntry<C> = { definition: copy, running: false };
		this.entries.set(copy.id, entry);
		this.emit();
		return () => {
			if (!this.isCurrent(entry)) return;
			this.entries.delete(copy.id);
			this.emit();
		};
	}

	getState(id: string, context: C): KlpCommandState | null {
		requireText(id, 'id');
		const entry = this.entries.get(id);
		return entry ? snapshot(entry, context) : null;
	}

	list(context: C): readonly KlpCommandState[] {
		const ids = [...this.entries.keys()].sort();
		const states: KlpCommandState[] = [];
		for (const id of ids) {
			const state = this.getState(id, context);
			if (state) states.push(state);
		}
		return Object.freeze(states);
	}

	async execute(id: string, context: C): Promise<KlpCommandExecutionResult> {
		requireText(id, 'id');
		if (this.closed) return Object.freeze({ commandId: id, status: 'disposed' });
		const entry = this.entries.get(id);
		if (!entry) return Object.freeze({ commandId: id, status: 'missing' });
		const state = snapshot(entry, context);
		if (this.closed) return Object.freeze({ commandId: id, status: 'disposed' });
		if (!this.isCurrent(entry)) return Object.freeze({ commandId: id, status: 'missing' });
		if (state.conditionError) return Object.freeze({ commandId: id, status: 'error', phase: 'condition' as const, error: state.conditionError.error });
		if (!state.visible) return Object.freeze({ commandId: id, status: 'hidden' });
		if (!state.enabled) return Object.freeze({ commandId: id, status: 'disabled' });
		if (entry.running) return Object.freeze({ commandId: id, status: 'busy' });
		entry.running = true;
		this.emit();
		if (this.closed) return Object.freeze({ commandId: id, status: 'disposed' });
		if (!this.isCurrent(entry)) return Object.freeze({ commandId: id, status: 'missing' });
		try {
			const value = await entry.definition.handler(context);
			return Object.freeze({ commandId: id, status: 'executed', value });
		}
		catch (error) {
			return Object.freeze({ commandId: id, status: 'error', phase: 'handler' as const, error });
		}
		finally {
			if (this.isCurrent(entry)) {
				entry.running = false;
				this.emit();
			}
		}
	}

	subscribe(listener: () => void): () => void {
		this.requireOpen();
		if (typeof listener !== 'function') throw new TypeError('listener must be a function');
		const observer: Observer = { listener };
		this.observers.add(observer);
		return () => { this.observers.delete(observer); };
	}

	refresh(): void {
		this.requireOpen();
		this.emit();
	}

	dispose(): void {
		if (this.closed) return;
		this.closed = true;
		this.entries.clear();
		this.emit();
		this.observers.clear();
	}

	private requireOpen(): void {
		if (this.closed) throw new Error('Command registry is disposed');
	}

	private isCurrent(entry: CommandEntry<C>): boolean {
		return !this.closed && this.entries.get(entry.definition.id) === entry;
	}

	private emit(): void {
		this.revision++;
		for (const observer of [...this.observers]) {
			if (!this.observers.has(observer)) continue;
			try {
				observer.listener();
			}
			catch (error) {
				if (!this.onObserverError) reportToHost(error);
				else {
					try { this.onObserverError(error); }
					catch (callbackError) { reportToHost(callbackError); }
				}
			}
		}
	}
}
