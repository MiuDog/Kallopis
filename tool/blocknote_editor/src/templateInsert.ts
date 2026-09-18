import type { Block, BlockNoteEditor } from '@blocknote/core'
import { closeHistory } from '@tiptap/pm/history'

export function insertTemplateBlocks(editor: BlockNoteEditor, blocks: Block[], afterBlockId?: string) {

	// 步驟 1：提交前核對位置與所有子樹身分，不讓失效命令改動正文。
	if (!Array.isArray(blocks) || blocks.length === 0) throw new Error('範本區塊不得為空')

	let anchor = afterBlockId
	if (anchor == null) {
		try {
			anchor = editor.getTextCursorPosition().block.id
		}
		catch {
			anchor = undefined
		}
		if (!anchor || !editor.getBlock(anchor)) anchor = editor.document.at(-1)?.id
	}
	if (!anchor || !editor.getBlock(anchor)) throw new Error('範本插入位置不存在')

	const ids = new Set<string>()
	function validate(block: Block) {
		if (!block || typeof block.id !== 'string' || !block.id || ids.has(block.id) || editor.getBlock(block.id)) {
			throw new Error('範本區塊身分無效或重複')
		}
		ids.add(block.id)
		block.children?.forEach(validate)
	}
	blocks.forEach(validate)

	// 步驟 2：上游先驗證整批節點，再以單一交易插入，並隔離前後編輯的復原群組。
	editor.transact((transaction) => {
		closeHistory(transaction)
		editor.insertBlocks(blocks, anchor, 'after')
	})
	editor.transact((transaction) => closeHistory(transaction))
}
