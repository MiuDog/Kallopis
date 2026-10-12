/** 只描述一個主軸尺寸，不持有內容、panel 或產品狀態。 */
export interface KlpLinearItem {
	readonly minimum?: number;
	readonly maximum?: number;
	readonly preferred?: number;
	readonly flex?: number;
}

export interface KlpLinearLayoutResult {
	readonly extents: readonly number[];
	readonly gutter: number;
	readonly unused: number;
	readonly compressed: boolean;
}

function nonnegative(value: number, path: string): number {
	if (typeof value !== 'number' || !Number.isFinite(value) || value < 0) throw new RangeError(`${path}: expected finite nonnegative number`);
	return value;
}

/** 比例先正規化，避免巨大但有限的權重加總變成 Infinity。 */
function proportional(weights: readonly number[], budget: number): number[] {
	const maximum = weights.reduce((largest, weight) => Math.max(largest, weight), 0);
	if (maximum === 0 || budget === 0) return weights.map(() => 0);
	const normalized = weights.map(weight => weight / maximum);
	const total = normalized.reduce((sum, weight) => sum + weight, 0);
	return normalized.map(weight => (weight / total) * budget);
}

/** 先保留 gutter，再解析 minimum、preferred 與受限 flex。 */
export function resolveKlpLinearLayout(input: {
	readonly extent: number;
	readonly gutter: number;
	readonly gutterCount: number;
	readonly items: readonly KlpLinearItem[];
}): KlpLinearLayoutResult {
	const extent = nonnegative(input.extent, 'extent');
	const gutter = nonnegative(input.gutter, 'gutter');
	const gutterCount = nonnegative(input.gutterCount, 'gutterCount');
	if (!Number.isInteger(gutterCount)) throw new RangeError('gutterCount: expected integer');
	if (!Array.isArray(input.items)) throw new TypeError('items: expected array');
	const items = input.items.map((item, index) => {
		if (!item || typeof item !== 'object') throw new TypeError(`items[${index}]: expected item`);
		const minimum = nonnegative(item.minimum === undefined ? 0 : item.minimum, `items[${index}].minimum`);
		const maximum = item.maximum === undefined ? undefined : nonnegative(item.maximum, `items[${index}].maximum`);
		const preferred = nonnegative(item.preferred === undefined ? 0 : item.preferred, `items[${index}].preferred`);
		const flex = nonnegative(item.flex === undefined ? 1 : item.flex, `items[${index}].flex`);
		if (maximum !== undefined && maximum < minimum) throw new RangeError(`items[${index}].maximum: below minimum`);
		return {minimum, maximum, preferred, flex};
	});
	const actualGutter = gutterCount === 0 ? 0 : Math.min(gutter, extent / gutterCount);
	const budget = Math.max(0, extent - actualGutter * gutterCount);
	const minima = items.map(item => item.minimum);
	const minimumTotal = minima.reduce((sum, value) => sum + value, 0);
	const compressed = (gutterCount > 0 && actualGutter < gutter) || minimumTotal > budget;
	let extents: number[];
	if (minimumTotal > budget) {
		extents = proportional(minima, budget);
	} else {
		extents = items.map(item => Math.max(item.minimum, Math.min(item.preferred, item.maximum ?? Number.POSITIVE_INFINITY)));
		const preferredTotal = extents.reduce((sum, value) => sum + value, 0);
		if (preferredTotal > budget) {
			const extras = proportional(extents.map((value, index) => value - minima[index]), Math.max(0, budget - minimumTotal));
			extents = minima.map((value, index) => value + extras[index]);
		} else {
			let remaining = Math.max(0, budget - preferredTotal);
			// 每輪至少完成分配或移除一個達上限的項目，迭代次數有限。
			for (let round = 0; round <= items.length && remaining > 0; round++) {
				const active = items.map((item, index) => ({item, index})).filter(({item, index}) => item.flex > 0 && (item.maximum === undefined || item.maximum > extents[index]));
				if (active.length === 0) break;
				const shares = proportional(active.map(({item}) => item.flex), remaining);
				let spent = 0, capped = false;
				active.forEach(({item, index}, position) => {
					const capacity = item.maximum === undefined ? remaining : Math.max(0, item.maximum - extents[index]);
					const amount = Math.min(shares[position], capacity);
					extents[index] += amount;
					spent += amount;
					capped ||= capacity <= shares[position];
				});
				remaining = Math.max(0, remaining - spent);
				if (!capped || spent === 0) break;
			}
		}
	}
	const unused = Math.max(0, budget - extents.reduce((sum, value) => sum + value, 0));
	return Object.freeze({extents: Object.freeze(extents), gutter: actualGutter, unused, compressed});
}
