import { KlpCommandRegistry, type KlpCommandExecutionResult } from './command-registry.js';

export type KlpShortcutPlatform = 'mac' | 'other';
export type KlpShortcutScope = 'app' | 'page' | 'region' | 'component';
export type KlpShortcutHandlingState = 'ignored' | 'prefix' | 'executed' | 'cancelled' | 'recording';
export type KlpShortcutConflictKind = 'exact' | 'prefix';

export interface KlpShortcutStroke {

	/* key 是 canonical logical key；primary 隨平台投影；其餘 modifier 必須精確匹配。 */
	readonly key: string;
	readonly primary?: boolean;
	readonly ctrl?: boolean;
	readonly alt?: boolean;
	readonly shift?: boolean;
	readonly meta?: boolean;
}

export interface KlpShortcutInput extends KlpShortcutStroke {

	/* stroke 欄位沿公開定義；repeat 控制重複事件，composing 保護輸入法。 */
	readonly repeat?: boolean;
	readonly composing?: boolean;
}

export interface KlpShortcutFocus {

	/* focusId 是原生焦點 owner；三個 scope ID 投影有效鏈；editable 避免接管正文輸入。 */
	readonly focusId: string;
	readonly pageId?: string;
	readonly regionId?: string;
	readonly componentId?: string;
	readonly editable?: boolean;
}

export interface KlpShortcutBinding<C = unknown> {

	/* id 是 binding owner，commandId 引用唯一 registry；sequence 保留產品預設組合。 */
	readonly id: string;
	readonly commandId: string;
	readonly sequence: readonly KlpShortcutStroke[];
	/* scope／scopeId 限定有效焦點；priority 決定同層排序；兩個 allow 明示輸入例外；when 讀產品當次條件。 */
	readonly scope: KlpShortcutScope;
	readonly scopeId?: string;
	readonly priority?: number;
	readonly allowRepeat?: boolean;
	readonly allowInEditable?: boolean;
	readonly when?: (context: C) => boolean;
}

export interface KlpShortcutHandling {

	/* handled 僅在實際消費鍵時成立；state 描述解析結果；兩 ID 與 execution 只在適用狀態存在。 */
	readonly handled: boolean;
	readonly state: KlpShortcutHandlingState;
	readonly bindingId?: string;
	readonly commandId?: string;
	readonly execution?: Promise<KlpCommandExecutionResult>;
}

export interface KlpShortcutConflict {

	/* kind 區分完整及前綴衝突；bindingIds 用 UTF-16 排序；winnerId 由固定順位決定。 */
	readonly kind: KlpShortcutConflictKind;
	readonly bindingIds: readonly string[];
	readonly winnerId: string;
}

export interface KlpShortcutOverrides {

	/* schemaVersion 擁有 wire 版本；bindings 動態 ID 對應覆寫序列，null 為停用，無產品 callback。 */
	readonly schemaVersion: 1;
	readonly bindings: Readonly<Record<string, readonly KlpShortcutStroke[] | null>>;
}

export interface KlpCommandKeymapOptions {

	/* platform 投影 primary；chordTimeoutMs 是每一步的毫秒期限；now 可注入 monotonic clock。 */
	readonly platform?: KlpShortcutPlatform;
	readonly chordTimeoutMs?: number;
	readonly now?: () => number;
}

interface Candidate<C> {

	/* binding 保持註冊 token；sequence 是目前有效覆寫，僅在本次解析使用。 */
	readonly binding: KlpShortcutBinding<C>;
	readonly sequence: readonly KlpShortcutStroke[];
}

const modifiers = ['primary', 'ctrl', 'alt', 'shift', 'meta'] as const;
const scopes: readonly KlpShortcutScope[] = ['app', 'page', 'region', 'component'];
const namedKeys = new Set(['enter', 'escape', 'tab', 'space', 'backspace', 'delete', 'insert', 'home', 'end', 'pageup', 'pagedown', 'arrowup', 'arrowdown', 'arrowleft', 'arrowright']);

export class KlpCommandKeymap<C = unknown> {

	/* registry 僅借用公開執行權威；platform／timeout 為不可變解析選項；clock／lastTime 驗證單調性。 */
	private readonly registry: KlpCommandRegistry<C>;
	readonly platform: KlpShortcutPlatform;
	readonly chordTimeoutMs: number;
	private readonly clock: () => number;
	private lastTime = 0;
	/* bindings 以物件識別 owner；overrides 只擁有使用者設定；closed 不影響產品 registry。 */
	private readonly bindings = new Map<string, KlpShortcutBinding<C>>();
	private overrides = new Map<string, readonly KlpShortcutStroke[] | null>();
	private closed = false;
	/* pending／pendingFocus／started 擁有一步 chord；recordOwner／recorded 擁有 explicit 錄製 session。 */
	private pending: readonly KlpShortcutStroke[] = Object.freeze([]);
	private pendingFocus?: KlpShortcutFocus;
	private started = 0;
	private recordOwner?: string;
	private recorded: readonly KlpShortcutStroke[] = Object.freeze([]);

	constructor(registry: KlpCommandRegistry<C>, options: KlpCommandKeymapOptions = {}) {
		this.registry = registry;
		this.platform = options.platform ?? 'other';
		this.chordTimeoutMs = options.chordTimeoutMs ?? 1000;
		if (!['mac', 'other'].includes(this.platform)) throw new TypeError('Invalid platform');
		if (!Number.isInteger(this.chordTimeoutMs) || this.chordTimeoutMs < 1 || this.chordTimeoutMs > 600000) throw new TypeError('Invalid chord timeout');
		if (options.now !== undefined && typeof options.now !== 'function') throw new TypeError('Invalid clock');

		// 原生 performance clock 不依 wall clock，測試可注入同單位來源。
		this.clock = options.now ?? (() => performance.now());
	}

	get isDisposed(): boolean { return this.closed; }
	get isRecording(): boolean { return this.recordOwner !== undefined; }
	get pendingSequence(): readonly KlpShortcutStroke[] { return this.pending; }
	get recordedSequence(): readonly KlpShortcutStroke[] { return this.recorded; }

	register(binding: KlpShortcutBinding<C>): () => void {
		this.requireOpen();
		const copy = copyBinding(binding);
		if (this.bindings.has(copy.id)) throw new Error(`Duplicate binding: ${copy.id}`);
		this.bindings.set(copy.id, copy);
		this.cancelChord();
		return () => {
			if (this.bindings.get(copy.id) !== copy) return;

			this.bindings.delete(copy.id);
			this.overrides.delete(copy.id);
			this.cancelChord();
		};
	}

	handle(input: KlpShortcutInput, focus: KlpShortcutFocus, context: C): KlpShortcutHandling {
		if (this.closed) return handling('ignored');

		// 步驟一：先完成輸入及 clock 驗證，非法資料不部分更新 session。
		const key = copyStroke(input, false);
		const chain = copyFocus(focus);
		const repeat = flag(input.repeat, 'repeat');
		const composing = flag(input.composing, 'composing');
		const time = this.readTime();
		this.expireAt(time);
		if (this.pendingFocus && !sameFocus(this.pendingFocus, chain)) this.cancelChord();
		if (this.recordOwner !== undefined && this.recordOwner !== chain.focusId) {
			this.cancelRecording();
			return handling('ignored');
		}
		if (composing) {
			this.cancelChord();
			return handling('ignored');
		}
		if (!canonical(key.key)) return handling('ignored');

		// 步驟二：explicit 錄製不接命令，未完成 chord 可用無 modifier Escape 取消。
		const actual = project(key, this.platform);
		if (this.isRecording) return this.record(actual, repeat);

		if (this.pending.length && plainEscape(actual)) {
			this.cancelChord();
			return handling('cancelled');
		}

		// 步驟三：每次重新讀同 registry 與產品條件；續鍵失配只重新解析一次。
		const candidates = this.active(chain, context, repeat);
		let sequence = [...this.pending, actual];
		let selected = this.select(candidates, sequence);
		if (!selected && this.pending.length) {
			this.cancelChord();
			sequence = [actual];
			selected = this.select(candidates, sequence);
		}
		if (!selected) return handling('ignored');

		const binding = selected.binding;
		if (selected.sequence.length > sequence.length) {
			this.pending = Object.freeze(sequence);
			this.pendingFocus = chain;
			this.started = time;
			return Object.freeze({ /* state／handled：合法前綴；兩 ID：目前最高順位候選。 */ state: 'prefix', handled: true, bindingId: binding.id, commandId: binding.commandId });
		}
		this.cancelChord();
		return Object.freeze({ /* state／handled：dispatch 已開始；兩 ID：實際目標；execution：原 registry typed Promise。 */ state: 'executed', handled: true, bindingId: binding.id, commandId: binding.commandId, execution: this.registry.execute(binding.commandId, context) });
	}

	cancelChord(): boolean {
		const had = this.pending.length > 0;
		this.pending = Object.freeze([]);
		this.pendingFocus = undefined;
		return had;
	}

	expireChord(): boolean {
		if (this.closed || !this.pending.length) return false;

		return this.expireAt(this.readTime());
	}

	conflicts(focus: KlpShortcutFocus, context: C): readonly KlpShortcutConflict[] {
		if (this.closed) return Object.freeze([]);

		const candidates = this.active(copyFocus(focus), context, false);
		const result: KlpShortcutConflict[] = [];
		for (let first = 0; first < candidates.length; first++) {
			for (let second = first + 1; second < candidates.length; second++) {
				const a = candidates[first];
				const b = candidates[second];
				if (a.binding.scope !== b.binding.scope || a.binding.scopeId !== b.binding.scopeId) continue;

				const short = a.sequence.length <= b.sequence.length ? a.sequence : b.sequence;
				const long = a.sequence.length <= b.sequence.length ? b.sequence : a.sequence;
				if (!matches(long, short, this.platform)) continue;

				const kind: KlpShortcutConflictKind = short.length === long.length ? 'exact' : 'prefix';
				const ids = Object.freeze([a.binding.id, b.binding.id].sort(lexical));
				result.push(Object.freeze({ /* kind：匹配關係；bindingIds：穩定診斷對；winnerId：candidates 已固定順位排序。 */ kind, bindingIds: ids, winnerId: a.binding.id }));
			}
		}
		result.sort(compareConflicts);
		return Object.freeze(result);
	}

	setOverride(id: string, sequence: readonly KlpShortcutStroke[] | null): void {
		this.requireBinding(id);
		const copy = sequence === null ? null : copySequence(sequence);
		this.overrides.set(id, copy);
		this.cancelChord();
	}

	restore(id: string): void {
		this.requireBinding(id);
		this.overrides.delete(id);
		this.cancelChord();
	}

	exportOverrides(): KlpShortcutOverrides {
		// fromEntries 產生普通 DTO 並安全保存 __proto__ 等合法 command ID。
		const bindings = Object.fromEntries(this.overrides);
		return Object.freeze({ /* schemaVersion：唯一 wire 版本；bindings：隔離且 frozen 的使用者覆寫。 */ schemaVersion: 1, bindings: Object.freeze(bindings) });
	}

	importOverrides(value: unknown): void {
		this.requireOpen();
		const source = object(value);
		fields(source, ['schemaVersion', 'bindings']);
		if (source.schemaVersion !== 1) throw new TypeError('Invalid override version');
		const bindings = object(source.bindings);
		const replacement = new Map<string, readonly KlpShortcutStroke[] | null>();
		for (const [id, sequence] of Object.entries(bindings)) {
			this.requireBinding(id);
			if (sequence !== null) {
				if (!Array.isArray(sequence)) throw new TypeError('Invalid sequence');
				for (const item of sequence) fields(object(item), ['key', ...modifiers]);
			}
			replacement.set(id, sequence === null ? null : copySequence(sequence as KlpShortcutStroke[]));
		}

		// 所有 nested 欄位有效後才替換，失敗不清除現有 chord 或覆寫。
		this.overrides = replacement;
		this.cancelChord();
	}

	beginRecording(focusId: string): void {
		this.requireOpen();
		text(focusId, 'focusId');
		this.cancelChord();
		this.recordOwner = focusId;
		this.recorded = Object.freeze([]);
	}

	finishRecording(): readonly KlpShortcutStroke[] {
		this.recordOwner = undefined;
		return this.recorded;
	}

	cancelRecording(): void {
		this.recordOwner = undefined;
		this.recorded = Object.freeze([]);
	}

	dispose(): void {
		if (this.closed) return;

		this.closed = true;
		this.bindings.clear();
		this.overrides.clear();
		this.cancelChord();
		this.cancelRecording();
	}

	private requireOpen(): void {
		if (this.closed) throw new Error('Keymap is disposed');
	}

	private requireBinding(id: string): void {
		this.requireOpen();
		if (!this.bindings.has(id)) throw new TypeError(`Unknown binding: ${id}`);
	}

	private readTime(): number {
		const value = this.clock();
		if (!Number.isFinite(value) || value < this.lastTime || value < 0) throw new TypeError('Clock must be finite nonnegative and monotonic');
		this.lastTime = value;
		return value;
	}

	private expireAt(time: number): boolean {
		if (this.pending.length && time - this.started >= this.chordTimeoutMs) return this.cancelChord();

		return false;
	}

	private record(stroke: KlpShortcutStroke, repeat: boolean): KlpShortcutHandling {
		if (plainEscape(stroke)) {
			this.cancelRecording();
			return handling('cancelled');
		}
		if (repeat || this.recorded.length === 4) return handling('ignored');

		this.recorded = Object.freeze([...this.recorded, stroke]);
		return handling('recording');
	}

	private active(focus: KlpShortcutFocus, context: C, repeat: boolean): Candidate<C>[] {
		if (this.registry.isDisposed) return [];

		const result: Candidate<C>[] = [];
		for (const binding of this.bindings.values()) {
			if (!scopeActive(binding, focus)) continue;
			if (focus.editable && !binding.allowInEditable || repeat && !binding.allowRepeat) continue;

			const sequence = this.overrides.has(binding.id) ? this.overrides.get(binding.id) : binding.sequence;
			if (!sequence) continue;

			try {
				if (binding.when && !binding.when(context)) continue;
			}
			catch {
				continue;
			}
			const state = this.registry.getState(binding.commandId, context);
			if (!state || !state.visible || !state.enabled || state.running) continue;

			result.push({ /* binding：原 owner；sequence：有效覆寫或預設，不建立第二命令權威。 */ binding, sequence });
		}
		result.sort(compareCandidates);
		return result;
	}

	private select(candidates: Candidate<C>[], prefix: readonly KlpShortcutStroke[]): Candidate<C> | undefined {
		return candidates.find((candidate) => matches(candidate.sequence, prefix, this.platform));
	}
}

function text(value: unknown, name: string): asserts value is string {
	if (typeof value !== 'string' || !value.trim()) throw new TypeError(`Invalid ${name}`);
}

function flag(value: unknown, name: string): boolean {
	if (value === undefined) return false;

	if (typeof value !== 'boolean') throw new TypeError(`Invalid ${name}`);
	return value;
}

function object(value: unknown): Record<string, unknown> {
	if (!value || typeof value !== 'object' || Array.isArray(value)) throw new TypeError('Expected object');
	return value as Record<string, unknown>;
}

function fields(value: Record<string, unknown>, allowed: readonly string[]): void {
	if (Object.keys(value).some((key) => !allowed.includes(key))) throw new TypeError('Unknown override field');
}

function canonical(key: string): boolean {
	if (namedKeys.has(key) || /^f([1-9]|1[0-9]|2[0-4])$/.test(key)) return true;

	const scalars = [...key];
	if (scalars.length !== 1 || key.trim() === '' || key !== key.toLowerCase()) return false;
	const scalar = key.codePointAt(0)!;
	return scalar < 0xd800 || scalar > 0xdfff;
}

function copyStroke(value: KlpShortcutStroke, strict: boolean): KlpShortcutStroke {
	object(value);
	if (typeof value.key !== 'string' || strict && !canonical(value.key)) throw new TypeError('Invalid logical key');
	return Object.freeze({
		/* key：保留 canonical 值；所有 modifier 正規化 bool，隔離 mutable caller。 */
		key: value.key,
		primary: flag(value.primary, 'primary'),
		ctrl: flag(value.ctrl, 'ctrl'),
		alt: flag(value.alt, 'alt'),
		shift: flag(value.shift, 'shift'),
		meta: flag(value.meta, 'meta'),
	});
}

function copySequence(value: readonly KlpShortcutStroke[]): readonly KlpShortcutStroke[] {
	if (!Array.isArray(value) || value.length < 1 || value.length > 4) throw new TypeError('Sequence must contain one to four strokes');
	return Object.freeze(value.map((stroke) => copyStroke(stroke, true)));
}

function copyBinding<C>(value: KlpShortcutBinding<C>): KlpShortcutBinding<C> {
	object(value);
	text(value.id, 'id');
	text(value.commandId, 'commandId');
	if (!scopes.includes(value.scope)) throw new TypeError('Invalid scope');
	if (value.scope === 'app') {
		if (value.scopeId !== undefined && value.scopeId !== '') throw new TypeError('App scope cannot have scopeId');
	}
	else text(value.scopeId, 'scopeId');
	if (!Number.isInteger(value.priority ?? 0)) throw new TypeError('Invalid priority');
	if (value.when !== undefined && typeof value.when !== 'function') throw new TypeError('Invalid when');
	return Object.freeze({
		/* id／commandId／sequence：隔離預設資料；scope／scopeId：保留焦點限制；priority：固定順位。
		 * allowRepeat／allowInEditable：明示輸入例外；when：保留產品函式，不 clone context。
		 */
		id: value.id,
		commandId: value.commandId,
		sequence: copySequence(value.sequence),
		scope: value.scope,
		scopeId: value.scopeId || undefined,
		priority: value.priority ?? 0,
		allowRepeat: flag(value.allowRepeat, 'allowRepeat'),
		allowInEditable: flag(value.allowInEditable, 'allowInEditable'),
		when: value.when,
	});
}

function copyFocus(value: KlpShortcutFocus): KlpShortcutFocus {
	object(value);
	text(value.focusId, 'focusId');
	for (const name of ['pageId', 'regionId', 'componentId'] as const) {
		if (value[name] !== undefined) text(value[name], name);
	}
	return Object.freeze({ /* focusId／三 scope ID：隔離焦點鏈；editable：文字輸入門檻。 */ focusId: value.focusId, pageId: value.pageId, regionId: value.regionId, componentId: value.componentId, editable: flag(value.editable, 'editable') });
}

function project(stroke: KlpShortcutStroke, platform: KlpShortcutPlatform): KlpShortcutStroke {
	return Object.freeze({ /* key／alt／shift：同原值；primary 消解為 ctrl 或 meta，以實際 modifier 比對及錄製。 */ key: stroke.key, primary: false, ctrl: !!stroke.ctrl || !!stroke.primary && platform === 'other', alt: !!stroke.alt, shift: !!stroke.shift, meta: !!stroke.meta || !!stroke.primary && platform === 'mac' });
}

function sameStroke(a: KlpShortcutStroke, b: KlpShortcutStroke): boolean {
	return a.key === b.key && modifiers.every((name) => !!a[name] === !!b[name]);
}

function matches(sequence: readonly KlpShortcutStroke[], prefix: readonly KlpShortcutStroke[], platform: KlpShortcutPlatform): boolean {
	return sequence.length >= prefix.length && prefix.every((stroke, index) => sameStroke(project(sequence[index], platform), project(stroke, platform)));
}

function sameFocus(a: KlpShortcutFocus, b: KlpShortcutFocus): boolean {
	return a.focusId === b.focusId && a.pageId === b.pageId && a.regionId === b.regionId && a.componentId === b.componentId && a.editable === b.editable;
}

function scopeActive<C>(binding: KlpShortcutBinding<C>, focus: KlpShortcutFocus): boolean {
	if (binding.scope === 'app') return true;
	if (binding.scope === 'page') return binding.scopeId === focus.pageId;
	if (binding.scope === 'region') return binding.scopeId === focus.regionId;
	return binding.scopeId === focus.componentId;
}

function lexical(a: string, b: string): number { return a < b ? -1 : Number(a > b); }

function compareCandidates<C>(a: Candidate<C>, b: Candidate<C>): number {
	return scopes.indexOf(b.binding.scope) - scopes.indexOf(a.binding.scope) || (b.binding.priority ?? 0) - (a.binding.priority ?? 0) || lexical(a.binding.id, b.binding.id);
}

function compareConflicts(a: KlpShortcutConflict, b: KlpShortcutConflict): number {
	return lexical(a.bindingIds[0], b.bindingIds[0]) || lexical(a.bindingIds[1], b.bindingIds[1]);
}

function plainEscape(stroke: KlpShortcutStroke): boolean {
	return stroke.key === 'escape' && !modifiers.some((name) => stroke[name]);
}

function handling(state: KlpShortcutHandlingState): KlpShortcutHandling {
	return Object.freeze({ /* state：非 dispatch 結果；handled：ignored 不攔截原生事件。 */ state, handled: state !== 'ignored' });
}
