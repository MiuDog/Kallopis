import { BlockNoteSchema, defaultBlockSpecs } from '@blocknote/core'
import { createReactBlockSpec } from '@blocknote/react'
import { createContext, useContext } from 'react'
import { rows, samePage } from './flowProtocol'
import type { Message, Page, PageProjection } from './flowProtocol'

export const FlowPresentation = createContext<{ projections: PageProjection[]; open: (request: Message) => void }>({ projections: [], open: () => {} })

function PageButton({ target, hostBlockId, database }: { target: Page; hostBlockId: string; database?: { databaseId: string; viewId: string; referenceId: string } }) {

	const presentation = useContext(FlowPresentation)
	const projection = presentation.projections.find((value) => samePage(value.page, target))
	const available = projection?.availability === 'available'
	return <button type="button" className="kallopis-reference-projection" contentEditable={false} disabled={!available} data-page-project-id={target.projectId} data-page-document-id={target.documentId} data-page-availability={projection?.availability ?? 'unknown'} onClick={() => presentation.open({ page: target, hostBlockId, ...database })}>{projection?.title ?? target.documentId}</button>
}

// custom block 只持有頁面身分；名稱和可用性來自非正文的 React 投影。
const pageLink = createReactBlockSpec({ type: 'krepisPageLink', propSchema: { referenceVersion: { default: 1 }, projectId: { default: '' }, documentId: { default: '' } }, content: 'none' }, {
	render: ({ block }) => <PageButton target={{ projectId: block.props.projectId, documentId: block.props.documentId }} hostBlockId={block.id} />,
})

const database = createReactBlockSpec({ type: 'krepisDatabase', propSchema: { referenceVersion: { default: 1 }, viewId: { default: 'table' }, viewKind: { default: 'table' }, rowsJson: { default: '[]' } }, content: 'none' }, {
	render: ({ block }) => {
		const references = rows(block.props.rowsJson)
		return <div data-krepis-database={block.id} data-view-id={block.props.viewId} contentEditable={false}>
			<table><tbody>
				{references.map((row, index) => <tr key={row.referenceId} data-reference-id={row.referenceId} data-row-index={index}><td><PageButton target={row} hostBlockId={block.id} database={{ databaseId: block.id, viewId: block.props.viewId, referenceId: row.referenceId }} /></td></tr>)}
				{references.length === 0 && <tr data-empty-database="true"><td><br /></td></tr>}
			</tbody></table>
		</div>
	},
})

export const flowSchema = BlockNoteSchema.create({ blockSpecs: { ...defaultBlockSpecs, krepisPageLink: pageLink(), krepisDatabase: database() } })
