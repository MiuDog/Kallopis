import type { Block, PartialBlock } from '@blocknote/core'
import { BlockNoteView } from '@blocknote/mantine'
import { useCreateBlockNote } from '@blocknote/react'
import { useState } from 'react'
import '@blocknote/core/fonts/inter.css'
import '@blocknote/mantine/style.css'
import './App.css'

const storageKey = 'kallopis-editor-comparison-blocknote'

const sampleDocument: PartialBlock[] = [
	{
		type: 'paragraph',
		content: [
			{ type: 'text', text: '這是中文段落，用於比較編輯、選取與字型呈現。', styles: {} },
			{ type: 'text', text: '粗體', styles: { bold: true } },
			{ type: 'text', text: '、', styles: {} },
			{ type: 'text', text: '斜體', styles: { italic: true } },
			{ type: 'text', text: '與', styles: {} },
			{ type: 'text', text: '標記', styles: { backgroundColor: 'yellow' } },
			{ type: 'text', text: '文字也在同一段。', styles: {} },
		],
	},
	{
		type: 'bulletListItem',
		content: '第一層清單',
		children: [
			{ type: 'bulletListItem', content: '第二層清單 A' },
			{ type: 'bulletListItem', content: '第二層清單 B' },
		],
	},
	{
		type: 'table',
		content: {
			type: 'tableContent',
			headerRows: 1,
			rows: [
				{ cells: ['欄位', '說明'] },
				{ cells: ['中文', '表格內容'] },
				{ cells: ['保存', '手動儲存後可重開'] },
			],
		},
	},
	{
		type: 'image',
		props: { url: '/sample-image.png', caption: '本地範例圖片' },
	},
]

function createLongDocument(): PartialBlock[] {
	return Array.from({ length: 400 }, (_, index) => ({
		type: 'paragraph',
		content: `長文段落 ${index + 1}：這是用於手動觀察捲動、輸入延遲與選取表現的中文內容。`,
	}))
}

function readSavedDocument(): Block[] | undefined {
	const saved = localStorage.getItem(storageKey)
	if (!saved) return undefined

	try {
		return JSON.parse(saved) as Block[]
	}
	catch {
		return undefined
	}
}

function App() {
	const editor = useCreateBlockNote({ initialContent: readSavedDocument() })
	const [status, setStatus] = useState('已載入本機存檔（若存在）')

	function replaceDocument(blocks: PartialBlock[], message: string) {
		editor.replaceBlocks(editor.document, blocks)
		setStatus(message)
	}

	function saveDocument() {
		// 明確按下儲存才寫入瀏覽器本機儲存。
		localStorage.setItem(storageKey, JSON.stringify(editor.document))
		setStatus('已儲存')
	}

	function reopenDocument() {
		const saved = readSavedDocument()
		if (!saved) {
			setStatus('尚無存檔')
			return
		}

		replaceDocument(saved, '已從上次存檔重開')
	}

	return (
		<main>
			<header>
				<div>
					<h1>BlockNote 原型</h1>
					<p>{status}</p>
				</div>
				<nav aria-label="文件操作">
					<button onClick={() => replaceDocument(sampleDocument, '已載入共同範例')}>載入範例</button>
					<button onClick={() => replaceDocument(createLongDocument(), '已載入 400 段長文')}>載入長文</button>
					<button onClick={saveDocument}>儲存</button>
					<button onClick={reopenDocument}>重開</button>
				</nav>
			</header>
			<section className="editor-shell">
				<BlockNoteView editor={editor} theme="light" />
			</section>
		</main>
	)
}

export default App
