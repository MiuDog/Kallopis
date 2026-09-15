import { closeHistory } from '@tiptap/pm/history'
import { count, FlowFailure, id, page, rows, validateBlocks } from './flowProtocol'
import type { FlowEditor, Message, Version } from './flowProtocol'

export function applyDatabaseCommand(editor: FlowEditor, command: Message, version: Version): Message {
	// 步驟 1：驗證版本與完整目標，所有拒絕均發生在正文交易之前。
	const expected = command.expectedVersion
	if (!expected || count(expected.epoch) !== version.epoch || count(expected.revision) !== version.revision || command.epoch !== expected.epoch || command.revision !== expected.revision) throw new FlowFailure('staleVersion')

	validateBlocks(editor.document)
	if (command.type === 'database.insert') {
		const anchor = command.afterBlockId === undefined ? editor.document.at(-1)?.id : id(command.afterBlockId)
		if (!anchor || !editor.getBlock(anchor)) throw new FlowFailure('invalidTarget')

		let index = 1
		while (editor.getBlock(`krepis-database-${index}`)) index++
		const databaseId = `krepis-database-${index}`
		transaction(editor, () => editor.insertBlocks([{ id: databaseId, type: 'krepisDatabase', props: { referenceVersion: 1, viewId: 'table', viewKind: 'table', rowsJson: '[]' }, children: [] }], anchor, 'after'))
		return { status: 'applied', databaseId, viewId: 'table' }
	}
	const databaseId = id(command.databaseId)
	const block = editor.getBlock(databaseId)
	if (!block || block.type !== 'krepisDatabase') throw new FlowFailure('invalidTarget')

	if (command.type === 'database.remove') {
		transaction(editor, () => editor.removeBlocks([block]))
		return { status: 'applied', databaseId }
	}
	const viewId = id(command.viewId)
	if (block.props.viewId !== viewId) throw new FlowFailure('invalidTarget')

	const references = rows(block.props.rowsJson)
	let referenceId: string
	let rowIndex: number | undefined
	if (command.type === 'database.reference.insert') {
		rowIndex = count(command.rowIndex)
		if (rowIndex > references.length) throw new FlowFailure('invalidPosition')

		const targetPage = page(command.page)
		let index = 1
		while (references.some((row) => row.referenceId === `krepis-reference-${index}`)) index++
		referenceId = `krepis-reference-${index}`
		references.splice(rowIndex, 0, { referenceId, ...targetPage })
	}
	else {
		referenceId = id(command.referenceId)
		const previous = references.findIndex((row) => row.referenceId === referenceId)
		if (previous < 0) throw new FlowFailure('invalidTarget')

		if (command.type === 'database.reference.move') {
			rowIndex = count(command.rowIndex)
			if (rowIndex >= references.length) throw new FlowFailure('invalidPosition')
			if (rowIndex === previous) return { status: 'unchanged', databaseId, viewId, referenceId, rowIndex }

			const [row] = references.splice(previous, 1)
			references.splice(rowIndex, 0, row)
		}
		else if (command.type === 'database.reference.remove') references.splice(previous, 1)
		else throw new FlowFailure('invalidArgument', 'unknownDatabaseCommand')
	}

	// 步驟 2：唯一列排序演算法產生候選 payload，上游以單一步驟提交及復原。
	transaction(editor, () => editor.updateBlock(block, { props: { rowsJson: JSON.stringify(references) } }))
	return { status: 'applied', databaseId, viewId, referenceId, ...(rowIndex === undefined ? {} : { rowIndex }) }
}

function transaction(editor: FlowEditor, apply: () => unknown) {
	// 沿用正式範本命令的 history 分組，隔離前後使用者輸入。
	editor.transact((transaction) => {
		closeHistory(transaction)
		apply()
	})
	editor.transact((transaction) => closeHistory(transaction))
}
