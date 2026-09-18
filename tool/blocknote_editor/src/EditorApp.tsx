import type { Block } from '@blocknote/core'
import { BlockNoteView } from '@blocknote/mantine'
import type { Theme } from '@blocknote/mantine'
import { useCreateBlockNote, SuggestionMenuController, useExtension, useExtensionState, useBlockNoteEditor } from '@blocknote/react'
import { SuggestionMenu } from '@blocknote/core/extensions'
import type { SuggestionMenuProps, DefaultReactSuggestionItem } from '@blocknote/react'
import { useEffect, useRef, useState } from 'react'
import { renderToStaticMarkup } from 'react-dom/server'
import { insertTemplateBlocks } from './templateInsert'
import { KallopisEditorMenus, invalidateEditorMenus } from './KallopisEditorMenus'
import '@blocknote/core/fonts/inter.css'
import '@blocknote/mantine/style.css'

type Envelope = {
	protocolVersion: number
	type: string
	sessionId: string
	requestId: number
	revision: number
	documentId?: string
	messageIdStart?: number
	document?: { format: string; schemaVersion: number; blockNoteVersion: string; blocks: Block[] }
	appearance?: { background: string; text: string; fontFamily: string; fontSize: number }
	assetId?: string
	name?: string
	mediaType?: string
	blockId?: string
	blocks?: Block[]
	afterBlockId?: string
	query?: string
	replacement?: string
	matchBlockId?: string
	matchStart?: number
	matchLength?: number
	outline?: OutlineItem[]
	references?: ReferenceProjection[]
}

type OutlineItem = { blockId: string; title: string; level: number }
type ReferenceProjection = { referenceId: string; hostBlockId: string; sourceDocumentId: string; sourceBlockId: string; title: string; text: string; available: boolean }

declare global {
	interface Window {
		flutter_inappwebview?: { callHandler: (name: string, message: unknown) => Promise<unknown> }
		kallopisBlockNote?: { receive: (command: Envelope) => Promise<void> }
	}
}

let editorGeneration = 0

export function EditorApp() {
	const sessionId = useRef('')
	const revision = useRef(0)
	const messageId = useRef(1000)
	const applying = useRef(false)
	const [references, setReferences] = useState<ReferenceProjection[]>([])
	const [theme, setTheme] = useState<Theme>({})
	const editor = useCreateBlockNote({
		uploadFile: async (file) => readAsDataUrl(file),
	})

	function send(type: string, requestId: number, fields: Pick<Envelope, 'document' | 'outline'> = {}) {
		const message: Envelope = {
			protocolVersion: 1,
			type,
			sessionId: sessionId.current,
			requestId,
			revision: revision.current,
			...fields,
		}
		void window.flutter_inappwebview?.callHandler('KallopisBlockNote', message)
	}

	async function receive(command: Envelope) {
		if (command.protocolVersion !== 1) return
		if (command.type === 'configure' && command.appearance) {
			const appearance = command.appearance
			setTheme({ colors: { editor: { background: appearance.background, text: appearance.text } }, fontFamily: appearance.fontFamily })
			document.documentElement.style.setProperty('--kallopis-editor-background', appearance.background)
			document.documentElement.style.setProperty('--kallopis-editor-font-size', `${appearance.fontSize}px`)
			return
		}
		if (command.type === 'open' && command.document) {
			editorGeneration += 1
			invalidateEditorMenus()
			sessionId.current = command.sessionId
			revision.current = command.revision
			if (typeof command.messageIdStart === 'number') messageId.current = command.messageIdStart
			applying.current = true
			const blocks = await hydrateAssets(command.document.blocks)
			editor.replaceBlocks(editor.document, blocks)
			applying.current = false
			send('ready', command.requestId)
			return
		}
		if (command.sessionId !== sessionId.current) return
		if (command.type === 'template.insert') {
			if (!Array.isArray(command.blocks) || command.blocks.length === 0) throw new Error('範本區塊不得為空')

			// 資產先在暫存映射解析；切頁或插入失敗時不發布到目前文件。
			const sources = new Map<string, string>()
			const blocks = await hydrateAssets(command.blocks, sources)
			if (command.sessionId !== sessionId.current) throw new Error('範本插入工作階段已失效')

			insertTemplateBlocks(editor, blocks, command.afterBlockId)
			for (const [id, source] of sources) assetSources.set(id, source)
			return
		}
		if (command.type === 'asset.insert' && command.assetId && command.name) {
			const source = `asset://${command.assetId}`
			if (command.mediaType?.startsWith('image/')) {
				const url = await resolveAsset(command.assetId)
				editor.insertBlocks([{ type: 'image', props: { url, name: command.name, caption: command.name } }], editor.document.at(-1)!, 'after')
				rememberAssetSource(editor.document.at(-1), source)
			}
			else {
				editor.insertBlocks([{ type: 'file', props: { url: source, name: command.name, caption: command.name } }], editor.document.at(-1)!, 'after')
			}
			return
		}
		if ((command.type === 'replace.one' || command.type === 'replace.all') && command.query && command.replacement !== undefined) {
			replaceText(command.query, command.replacement, command.type === 'replace.all', command.matchBlockId)
			return
		}
		if (command.type === 'reference.configure') {
			setReferences(command.references ?? [])
			return
		}
		if (command.type === 'snapshot.request') {
			send('snapshot.response', command.requestId, { document: {
					format: 'kallopis.blocknote',
					schemaVersion: 1,
					blockNoteVersion: '0.54.2',
					blocks: persistedBlocks(editor.document),
				} })
			return
		}
		if (command.type === 'block.focus' && command.blockId && editor.getBlock(command.blockId)) {
			editor.setTextCursorPosition(command.blockId, 'start')
			editor.focus()
			const block = document.querySelector(`[data-id="${CSS.escape(command.blockId)}"]`)
			block?.scrollIntoView({ block: 'center', behavior: 'smooth' })
			highlightMatch(block, command.matchStart, command.matchLength)
			return
		}
	}

	function highlightMatch(block: Element | null, start?: number, length?: number) {
		CSS.highlights?.delete('kallopis-search-hit')
		if (!block || start == null || length == null || length <= 0 || !CSS.highlights) return
		const walker = document.createTreeWalker(block, NodeFilter.SHOW_TEXT)
		let offset = 0
		let startNode: Text | null = null
		let endNode: Text | null = null
		let startOffset = 0
		let endOffset = 0
		while (walker.nextNode()) {
			const node = walker.currentNode as Text
			const next = offset + node.length
			if (!startNode && start >= offset && start < next) {
				startNode = node
				startOffset = start - offset
			}
			if (start + length > offset && start + length <= next) {
				endNode = node
				endOffset = start + length - offset
				break
			}
			offset = next
		}
		if (!startNode || !endNode) return
		const range = new Range()
		range.setStart(startNode, startOffset)
		range.setEnd(endNode, endOffset)
		CSS.highlights.set('kallopis-search-hit', new Highlight(range))
	}

	function replaceText(query: string, replacement: string, replaceAll: boolean, matchBlockId?: string) {
		let replaced = false
		// 讓跨區塊的全部取代成為單一 BlockNote undo 交易。
		editor.transact(() => {
			for (const block of editor.document) {
				if (!replaceAll && matchBlockId && block.id !== matchBlockId) continue
				const result = replaceInlineContent(block.content, query, replacement, replaceAll, replaced)
				if (!result.changed) continue
				editor.updateBlock(block.id, { content: result.content as never })
				replaced = true
				if (!replaceAll) break
			}
		})
	}

	useEffect(() => {
		window.kallopisBlockNote = { receive }
		return () => { delete window.kallopisBlockNote }
	})

	useEffect(() => {
		function openAttachment(event: MouseEvent) {
			const target = event.target instanceof Element ? event.target : null
			const block = target?.closest('[data-content-type="file"]')
			const source = block?.querySelector('[data-url^="asset://"]')?.getAttribute('data-url') ?? block?.getAttribute('data-url')
			if (!source?.startsWith('asset://')) return
			event.preventDefault()
			event.stopPropagation()
			void window.flutter_inappwebview?.callHandler('KallopisBlockNoteOpenAsset', source.slice('asset://'.length))
		}
		document.addEventListener('click', openAttachment, true)
		return () => document.removeEventListener('click', openAttachment, true)
	}, [])

	return (
		<main>
			<BlockNoteView
				editor={editor}
				slashMenu={false}
				formattingToolbar={false}
				linkToolbar={false}
				sideMenu={false}
				filePanel={false}
				tableHandles={false}
				emojiPicker={false}
				comments={false}
				attributionTooltip={false}
				theme={theme}
				onChange={() => {
					if (applying.current || sessionId.current === '') return
					revision.current += 1
					send('changed', messageId.current++, { outline: extractOutline(editor.document) })
				}}
			>
				<KallopisEditorMenus><SuggestionMenuController triggerCharacter="/" suggestionMenuComponent={KallopisSuggestionMenu} /></KallopisEditorMenus>
			</BlockNoteView>
			<section className="kallopis-reference-projections" aria-label="參考區塊">
				{references.map((projection) => (
					<button
						key={projection.referenceId}
						type="button"
						className="kallopis-reference-projection"
						data-reference-id={projection.referenceId}
						data-host-block-id={projection.hostBlockId}
						data-source-document-id={projection.sourceDocumentId}
						data-source-block-id={projection.sourceBlockId}
						contentEditable={false}
						disabled={!projection.available}
						onClick={() => void window.flutter_inappwebview?.callHandler('KallopisBlockNoteOpenReference', {
							referenceId: projection.referenceId,
							sourceDocumentId: projection.sourceDocumentId,
							sourceBlockId: projection.sourceBlockId,
						})}
					>
						{projection.available ? `${projection.title}\n${projection.text}` : '參考來源不可用'}
					</button>
				))}
			</section>
		</main>
	)
}

function replaceInlineContent(content: unknown, query: string, replacement: string, replaceAll: boolean, alreadyReplaced: boolean): { content: unknown; changed: boolean } {
	if (typeof content === 'string') {
		if (alreadyReplaced && !replaceAll) return { content, changed: false }
		const index = content.indexOf(query)
		if (index < 0) return { content, changed: false }
		const value = replaceAll ? content.split(query).join(replacement) : content.slice(0, index) + replacement + content.slice(index + query.length)
		return { content: value, changed: true }
	}
	if (!Array.isArray(content)) return { content, changed: false }
	let changed = false
	let replaced = alreadyReplaced
	const value = content.map((part) => {
		if (!part || typeof part !== 'object' || replaced && !replaceAll) return part
		const inline = part as { text?: unknown; content?: unknown }
		const target = typeof inline.text === 'string' ? inline.text : inline.content
		const result = replaceInlineContent(target, query, replacement, replaceAll, replaced)
		if (!result.changed) return part
		changed = true
		replaced = true
		return typeof inline.text === 'string' ? { ...inline, text: result.content } : { ...inline, content: result.content }
	})
	return { content: value, changed }
}

function extractOutline(blocks: Block[]): OutlineItem[] {
	const result: OutlineItem[] = []
	function visit(block: Block) {
		if (block.type === 'heading') {
			const value = block as Block & { props: { level?: number }; content?: unknown }
			const title = plainText(value.content).trim()
			const level = Number(value.props.level ?? 1)
			if (title && Number.isInteger(level) && level >= 1 && level <= 6) result.push({ blockId: block.id, title, level })
		}
		block.children?.forEach(visit)
	}
	blocks.forEach(visit)
	return result
}

function plainText(content: unknown): string {
	if (typeof content === 'string') return content
	if (!Array.isArray(content)) return ''
	return content.map((part) => {
		if (!part || typeof part !== 'object') return ''
		const value = part as { text?: unknown; content?: unknown }
		return typeof value.text === 'string' ? value.text : plainText(value.content)
	}).join('')
}

const assetSources = new Map<string, string>()

async function hydrateAssets(blocks: Block[], sources = assetSources): Promise<Block[]> {
	// 完整子樹都經由宿主解析資產，正文保存時仍保留原本的 asset 身分。
	return Promise.all(structuredClone(blocks).map(async (block) => {
		if (block.children?.length) block.children = await hydrateAssets(block.children, sources)
		if (block.type !== 'image') return block
		const image = block as Block & { props: { url: string } }
		const url = String(image.props.url ?? '')
		if (!url.startsWith('asset://')) return block
		const resolved = await resolveAsset(url.slice('asset://'.length))
		sources.set(block.id, url)
		return { ...block, props: { ...block.props, url: resolved } } as Block
	}))
}

async function resolveAsset(assetId: string): Promise<string> {
	const value = await window.flutter_inappwebview?.callHandler('KallopisBlockNoteAsset', assetId) as { mediaType: string; base64: string } | undefined
	if (!value) throw new Error(`資產無法解析：${assetId}`)
	return `data:${value.mediaType};base64,${value.base64}`
}

function rememberAssetSource(block: Block | undefined, source: string) {
	if (block?.type === 'image') assetSources.set(block.id, source)
}

function persistedBlocks(blocks: Block[]): Block[] {
	// 巢狀範本圖片與根區塊使用相同的持久化資產表示。
	return structuredClone(blocks).map((block) => {
		if (block.children?.length) block.children = persistedBlocks(block.children)
		const source = assetSources.get(block.id)
		if (block.type !== 'image' || !source) return block
		return { ...block, props: { ...block.props, url: source } } as Block
	})
}

function readAsDataUrl(file: File): Promise<string> {
	return new Promise((resolve, reject) => {
		const reader = new FileReader()
		reader.onload = () => resolve(String(reader.result))
		reader.onerror = () => reject(reader.error ?? new Error('圖片讀取失敗'))
		reader.readAsDataURL(file)
	})
}

// 編輯器只傳送命令資料，選單由宿主既有 KlpMenu 呈現。
function KallopisSuggestionMenu(props: SuggestionMenuProps<DefaultReactSuggestionItem>) {
	const suggestion = useExtension(SuggestionMenu)
	const suggestionState = useExtensionState(SuggestionMenu)
	const editor = useBlockNoteEditor()
	const anchor = useRef<HTMLDivElement>(null)
	const opened = useRef(false)
	useEffect(() => {
		if (opened.current || props.loadingState !== 'loaded' || !props.items.length || !anchor.current) return

		opened.current = true
		const bounds = anchor.current.getBoundingClientRect()
		const items = props.items
		const state = editor.prosemirrorState
		const generation = editorGeneration
		const to = state.selection.from
		const query = `/${suggestionState?.query ?? ''}`
		const from = to - query.length
		void window.flutter_inappwebview?.callHandler('KallopisMenu', {
			x: bounds.left,
			y: bounds.top,
			searchable: true,
			items: items.map((item) => ({ title: item.title, shortcut: item.badge, description: item.subtext, group: item.group, iconSvg: item.icon ? renderToStaticMarkup(item.icon) : undefined })),
		}).then((index) => {
			if (generation !== editorGeneration) return

			suggestion.closeMenu()
			// 宿主取得焦點可能已關閉 slash 狀態；僅在正文未變時消除捕捉的查詢。
			if (typeof index === 'number' && items[index] && editor.prosemirrorState.doc.eq(state.doc) && from >= 0 && state.doc.textBetween(from, to) === query) {
				editor.transact((transaction) => {
					transaction.delete(from, to)
					items[index].onItemClick()
				})
			}
			editor.focus()
		})
	}, [props])
	return <div ref={anchor} />
}
