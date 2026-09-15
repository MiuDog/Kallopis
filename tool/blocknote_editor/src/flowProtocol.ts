import type { Block, BlockNoteEditor } from '@blocknote/core'

export type FlowBlock = Block<any, any, any>
export type FlowEditor = BlockNoteEditor<any, any, any>
export type Page = { projectId: string; documentId: string }
export type Version = { epoch: number; revision: number }
export type PageProjection = { page: Page; title: string; availability: 'available' | 'unavailable' | 'unknown' }
export type DatabaseRow = Page & { referenceId: string }
export type FlowDocument = { format: string; schemaVersion: number; blockNoteVersion: string; blocks: FlowBlock[] }
export type Message = Record<string, any>

export class FlowFailure extends Error {

	constructor(readonly code: string, readonly detail?: string) {
		super(detail ?? code)
	}
}

export function id(value: unknown): string {
	if (typeof value !== 'string' || !value.trim()) throw new FlowFailure('invalidArgument', 'invalidIdentity')

	return value
}

export function count(value: unknown): number {
	if (typeof value !== 'number' || !Number.isSafeInteger(value) || value < 0) throw new FlowFailure('invalidArgument', 'invalidCount')

	return value
}

export function page(value: unknown): Page {
	if (!value || typeof value !== 'object') throw new FlowFailure('invalidArgument', 'invalidPage')

	const source = value as Record<string, unknown>
	return { projectId: id(source.projectId), documentId: id(source.documentId) }
}

export function samePage(first: Page, second: Page): boolean {
	return first.projectId === second.projectId && first.documentId === second.documentId
}

export function rows(payload: unknown): DatabaseRow[] {
	// 只解析唯一持久 schema；損壞資料必須拒絕，不能當成空表。
	if (typeof payload !== 'string') throw new FlowFailure('invalidArgument', 'invalidRows')
	let decoded: unknown
	try {
		decoded = JSON.parse(payload)
	}
	catch {
		throw new FlowFailure('invalidArgument', 'invalidRows')
	}
	if (!Array.isArray(decoded)) throw new FlowFailure('invalidArgument', 'invalidRows')

	const ids = new Set<string>()
	return decoded.map((value) => {
		if (!value || typeof value !== 'object') throw new FlowFailure('invalidArgument', 'invalidRow')

		const referenceId = id(value.referenceId)
		if (ids.has(referenceId)) throw new FlowFailure('invalidArgument', 'duplicateReference')

		ids.add(referenceId)
		return { referenceId, ...page(value) }
	})
}

export function validateBlocks(blocks: unknown): asserts blocks is FlowBlock[] {
	// 同一份文件所有層級共用 block ID 集合，props 內的 id 不佔身分。
	if (!Array.isArray(blocks)) throw new FlowFailure('invalidArgument', 'invalidBlocks')
	const ids = new Set<string>()
	function visit(values: any[]) {
		for (const block of values) {
			if (!block || typeof block !== 'object') throw new FlowFailure('invalidArgument', 'invalidBlock')
			if (block.id !== undefined) {
				const blockId = id(block.id)
				if (ids.has(blockId)) throw new FlowFailure('invalidArgument', 'duplicateBlock')

				ids.add(blockId)
			}
			if (block.type === 'krepisPageLink' || block.type === 'krepisDatabase') {
				id(block.id)
				if (!block.props || block.props.referenceVersion !== 1) throw new FlowFailure('invalidArgument', 'unsupportedReferenceVersion')
				if (!Array.isArray(block.children) || block.children.length) throw new FlowFailure('invalidArgument', 'referenceChildren')
				if (block.content != null && !(Array.isArray(block.content) && !block.content.length)) throw new FlowFailure('invalidArgument', 'referenceContent')

				if (block.type === 'krepisPageLink') page(block.props)
				else {
					id(block.props.viewId)
					if (block.props.viewKind !== 'table') throw new FlowFailure('invalidArgument', 'unsupportedView')

					rows(block.props.rowsJson)
				}
			}
			if (Array.isArray(block.children)) visit(block.children)
		}
	}
	visit(blocks)
}

export function validateDocument(value: unknown): asserts value is FlowDocument {
	if (!value || typeof value !== 'object') throw new FlowFailure('invalidArgument', 'invalidDocument')

	const document = value as FlowDocument
	if (document.format !== 'kallopis.blocknote' || document.schemaVersion !== 1 || document.blockNoteVersion !== '0.54.2') throw new FlowFailure('unsupportedCapability', 'unsupportedDocument')

	validateBlocks(document.blocks)
}

export function equalJson(first: unknown, second: unknown): boolean {
	if (first === second) return true
	if (Array.isArray(first) && Array.isArray(second)) return first.length === second.length && first.every((value, index) => equalJson(value, second[index]))
	if (!first || !second || typeof first !== 'object' || typeof second !== 'object' || Array.isArray(first) || Array.isArray(second)) return false

	const left = first as Record<string, unknown>
	const right = second as Record<string, unknown>
	const keys = Object.keys(left)
	return keys.length === Object.keys(right).length && keys.every((key) => Object.hasOwn(right, key) && equalJson(left[key], right[key]))
}
