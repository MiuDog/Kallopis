import { applyDatabaseCommand } from './flowDatabaseTransactions'
import { FlowMessageOutbox } from './flowMessageOutbox'
import { FlowFailure, count, equalJson, id, page, rows, samePage, validateDocument } from './flowProtocol'
import type { FlowDocument, FlowEditor, Message, PageProjection } from './flowProtocol'

type HostAccess = {
	editor: () => FlowEditor
	document: () => FlowDocument
	outline: () => unknown[]
	replace: (document: FlowDocument, exact: boolean, validateCommit: () => void) => Promise<void>
	editable: (value: boolean) => void
	projections: (values: PageProjection[]) => void
}

/** 保存宿主協定狀態；即時正文及歷史只由上游 editor 持有。 */
export class FlowOperationHost {
	readonly hostInstanceId = crypto.randomUUID()
	readonly outbox = new FlowMessageOutbox(() => this.block())
	flow = false
	sessionId = ''
	documentId = ''
	epoch = 0
	revision = 0
	eventSeq = 0
	applying = false
	private opened = false
	private messageId = 1000
	private token = 0
	private gated = false
	private composing = false
	private drainingComposition = false
	private compositionDone: (() => void)[] = []
	private lockId: string | null = null
	private lastReload: { id: string; epoch: number; document: FlowDocument; lockId: string } | null = null
	private retired: { command: Message; response: Message | null; retirementId: string; snapshot: Message } | null = null
	private controlResponses = new Map<string, { command: Message; response: Message }>()
	private pendingInteractions = new Map<number, Message>()
	private lastIncomingRequest = 0
	private lastRecoveryRequest = 0
	private legacyDelivery: Promise<unknown> = Promise.resolve()

	constructor(private readonly access: HostAccess) {}

	get writable() { return !this.retired && !this.gated && (!this.flow || this.outbox.capacityAvailable) }
	get transactionAllowed() { return this.applying || this.writable || (this.composing || this.drainingComposition) && this.gated }
	allowsTransaction(compositionId: unknown) {
		return this.applying || this.writable || this.transactionAllowed && typeof compositionId === 'number' && Number.isSafeInteger(compositionId) && compositionId > 0
	}
	get version() { return { epoch: this.epoch, revision: this.revision } }

	beginMutation() {
		if (!this.writable) throw new FlowFailure('blocked')
		return this.token
	}

	checkMutation(token: number) {
		if (token !== this.token || !this.writable) throw new FlowFailure('blocked')
	}

	composition(start: boolean) {
		if (start && !this.writable) return
		this.drainingComposition = !start && this.composing
		this.composing = start
		if (!start) {
			for (const resolve of this.compositionDone.splice(0)) resolve()
		}
	}

	changed() {
		if (this.applying || !this.sessionId) return
		if (this.revision >= Number.MAX_SAFE_INTEGER || this.eventSeq >= Number.MAX_SAFE_INTEGER) { this.block(); return }
		this.revision += 1
		this.eventSeq += 1
		void this.send('changed', this.messageId++, { outline: this.access.outline() })
	}

	private envelope(type: string, requestId: number, fields: Message = {}): Message {
		return {
			protocolVersion: 1, type, sessionId: this.sessionId, documentId: this.documentId,
			requestId, revision: this.revision,
			...(this.flow ? { flowProtocolVersion: 1, hostInstanceId: this.hostInstanceId, epoch: this.epoch, eventSeq: this.eventSeq } : {}),
			...fields,
		}
	}

	send(type: string, requestId: number, fields: Message = {}) {
		const message = this.envelope(type, requestId, fields)
		if (this.flow) return this.outbox.ordinary(message)
		this.legacyDelivery = this.legacyDelivery.then(() => window.flutter_inappwebview?.callHandler('KallopisBlockNote', message))
		return this.legacyDelivery
	}

	private block() {
		this.gated = true
		this.token += 1
		if (!this.composing) this.access.editable(false)
	}

	private async barrier() {
		this.block()
		const token = this.token
		this.pendingInteractions.clear()
		if (this.composing) await new Promise<void>((resolve) => this.compositionDone.push(resolve))
		// 讓瀏覽器自然提交 compositionend 後的最後一筆上游交易。
		await new Promise<void>((resolve) => requestAnimationFrame(() => requestAnimationFrame(() => resolve())))
		if (token !== this.token) throw new FlowFailure('recoveryRequired', 'superseded')
		this.drainingComposition = false
		this.access.editable(false)
		return token
	}

	private snapshot() { return { document: this.access.document(), outline: this.access.outline() } }

	async receive(command: Message): Promise<boolean> {
		if (!command || command.protocolVersion !== 1 || typeof command.type !== 'string') return true
		if (count(command.requestId) < 1) throw new FlowFailure('protocolMismatch')
		id(command.sessionId)
		if (this.flow || command.flowProtocolVersion === 1) id(command.documentId)
		count(command.revision)
		if (this.flow || command.type === 'flow.capabilities.request') {
			if (command.flowProtocolVersion !== 1) throw new FlowFailure('protocolMismatch')
			count(command.epoch)
		}
		if (command.type === 'operation.reconcile' && command.hostInstanceId !== this.hostInstanceId) {
			if (command.flowProtocolVersion !== 1) throw new FlowFailure('protocolMismatch')
			id(command.hostInstanceId)
			id(command.lockId)
			id(command.recoveryId)
			count(command.epoch)
			await this.outbox.control({
				protocolVersion: 1, flowProtocolVersion: 1, type: 'operation.error', commandType: command.type,
				documentId: command.documentId, sessionId: command.sessionId, requestId: command.requestId,
				hostInstanceId: this.hostInstanceId, epoch: this.epoch, revision: this.revision, eventSeq: this.eventSeq,
				lockId: command.lockId, recoveryId: command.recoveryId, failure: { code: 'recoveryRequired', detail: 'hostReplaced' },
			})
			return true
		}
		if (command.type === 'flow.capabilities.request') {
			if (this.sessionId && (this.sessionId !== command.sessionId || this.documentId !== command.documentId)) throw new FlowFailure('protocolMismatch')
			if (command.hostInstanceId !== undefined && command.hostInstanceId !== this.hostInstanceId) throw new FlowFailure('protocolMismatch')
			const key = `capabilities:${command.requestId}`
			const cached = this.controlResponses.get(key)
			if (cached) {
				if (!equalJson(cached.command, command)) throw new FlowFailure('protocolMismatch')
				await this.outbox.control(cached.response)
				return true
			}
			if (this.controlResponses.size >= 128) throw new FlowFailure('busy')
			const resume = this.writable
			const token = await this.barrier()
			await this.legacyDelivery
			if (token !== this.token) throw new FlowFailure('recoveryRequired', 'superseded')
			this.sessionId = id(command.sessionId)
			this.documentId = id(command.documentId)
			this.flow = true
			const response = this.envelope('flow.capabilities.response', command.requestId, {
				capabilities: { pageLinksV1: true, databaseTableV1: true, operationGateV1: true }, lastDeliverySeq: this.outbox.tail,
			})
			this.controlResponses.set(key, { command: structuredClone(command), response })
			if (await this.outbox.control(response) && resume && !this.retired && token === this.token) {
				this.gated = false
				this.access.editable(true)
			}
			return true
		}
		if (this.flow && command.hostInstanceId !== this.hostInstanceId) {
			if (command.type === 'operation.reconcile') await this.outbox.control(this.envelope('operation.error', command.requestId, {
				commandType: command.type, lockId: command.lockId, recoveryId: command.recoveryId,
				failure: { code: 'recoveryRequired', detail: 'hostReplaced' },
			}))
			return true
		}
		if (this.retired) {
			if (command.type === 'operation.reconcile') {
				await this.operation(command)
				return true
			}
			if (command.type === 'operation.retire') {
				if (equalJson(command, this.retired.command) && this.retired.response) {
					await this.outbox.replayOrdinary(this.retired.response)
				}
				else {
					await this.send('operation.error', command.requestId, {
						commandType: command.type, lockId: command.lockId, retirementId: command.retirementId,
						failure: { code: 'protocolMismatch' },
					})
				}
				return true
			}
			return true
		}
		if (this.flow && command.type !== 'interaction.result' && command.type !== 'operation.reconcile') {
			if (command.requestId <= this.lastIncomingRequest) return true
			this.lastIncomingRequest = command.requestId
		}
		if (command.type === 'open') {
			const token = this.beginMutation()
			if (this.flow && this.opened) throw new FlowFailure('blocked')
			validateDocument(command.document)
			if (this.flow && (command.sessionId !== this.sessionId || command.documentId !== this.documentId)) throw new FlowFailure('protocolMismatch')
			this.sessionId = id(command.sessionId)
			this.documentId = this.flow ? id(command.documentId) : command.documentId ?? ''
			{
				await this.access.replace(command.document, false, () => this.checkMutation(token))
				this.checkMutation(token)
				this.revision = command.revision
				this.epoch = command.epoch ?? 0
				this.eventSeq = 0
				this.messageId = command.messageIdStart ?? 1000
			}
			this.opened = true
			await this.send('ready', command.requestId, { document: structuredClone(command.document), outline: this.access.outline() })
			return true
		}
		if (command.sessionId !== this.sessionId || this.flow && command.documentId !== this.documentId) return true
		if (command.type === 'snapshot.request') {
			await this.send('snapshot.response', command.requestId, this.snapshot())
			return true
		}
		if (command.type === 'interaction.result') {
			const interaction = this.pendingInteractions.get(command.interactionRequestId)
			if (interaction && interaction.type === command.interactionType && interaction.deliverySeq === command.interactionDeliverySeq) this.pendingInteractions.delete(command.interactionRequestId)
			return true
		}
		if (command.type === 'page.configure' || command.type.startsWith('database.')) {
			let fields: Message
			try {
				if (!this.flow) throw new FlowFailure('unsupportedCapability')
				if (command.type === 'page.configure') {
					if (!Array.isArray(command.projections)) throw new FlowFailure('invalidArgument')
					const values: PageProjection[] = []
					for (const value of command.projections) {
						const reference = page(value.page)
						if (typeof value.title !== 'string' || !['available', 'unavailable', 'unknown'].includes(value.availability) || values.some((entry) => samePage(entry.page, reference))) throw new FlowFailure('invalidArgument')
						values.push({ page: reference, title: value.title, availability: value.availability })
					}
					this.access.projections(values)
					fields = { status: 'unchanged' }
				}
				else { this.beginMutation(); fields = applyDatabaseCommand(this.access.editor(), command, this.version) }
				if (fields.status === 'applied') fields.outline = this.access.outline()
			}
			catch (error) {
				if (!(error instanceof FlowFailure)) { this.block(); throw error }
				fields = { status: 'rejected', failure: { code: error.code, ...(error.detail ? { detail: error.detail } : {}) } }
			}
			await this.send('command.result', command.requestId, { commandType: command.type, ...fields })
			return true
		}
		if (command.type.startsWith('operation.')) {
			if (!this.flow) throw new FlowFailure('unsupportedCapability')
			await this.operation(command)
			return true
		}
		return false
	}

	private async operation(command: Message) {
		try {
			id(command.lockId)
			if (command.type === 'operation.reconcile') {
				id(command.recoveryId)
				if (command.retirementId !== null) id(command.retirementId)
				if ((command.reloadId === null) !== (command.nextEpoch === null)) throw new FlowFailure('protocolMismatch')
				if (command.reloadId !== null) { id(command.reloadId); count(command.nextEpoch) }
				const key = `${command.requestId}:${command.recoveryId}`
				const cached = this.controlResponses.get(key)
				if (cached && !equalJson(cached.command, command)) throw new FlowFailure('protocolMismatch')
				let response = cached?.response
				if (!response) {
					if (this.controlResponses.size >= 128) throw new FlowFailure('busy')
					if (command.requestId <= this.lastRecoveryRequest) throw new FlowFailure('recoveryRequired')
					this.lastRecoveryRequest = command.requestId
					if (this.retired) {
						if (command.lockId !== this.lockId || command.retirementId !== this.retired.retirementId) throw new FlowFailure('recoveryRequired', 'invalidRetirement')
					}
					else {
						await this.barrier()
						if (command.retirementId !== null) throw new FlowFailure('recoveryRequired', 'invalidRetirement')
						if (this.lockId && this.lockId !== command.lockId) throw new FlowFailure('recoveryRequired', 'invalidLock')
						this.lockId = command.lockId
					}
					response = this.envelope('operation.reconciled', command.requestId, {
						lockId: this.lockId, recoveryId: command.recoveryId, coveredDeliverySeq: this.outbox.tail,
						...(this.retired?.snapshot ?? this.snapshot()), lastAppliedReloadId: this.lastReload?.id ?? null, lastReloadEpoch: this.lastReload?.epoch ?? null,
						hostLifecycle: this.retired ? 'retired' : 'active', retirementId: this.retired?.retirementId ?? null,
					})
					this.controlResponses.set(key, { command: structuredClone(command), response })
				}
				if (await this.outbox.control(response) && command.requestId === this.lastRecoveryRequest) this.outbox.cover(response.coveredDeliverySeq)
				return
			}
			if (command.type === 'operation.lock') {
				if (command.epoch !== this.epoch || this.lockId && this.lockId !== command.lockId) throw new FlowFailure('recoveryRequired', 'invalidLock')
				this.lockId = command.lockId
				await this.barrier()
				await this.send('operation.locked', command.requestId, { lockId: this.lockId, barrierEventSeq: this.eventSeq, ...this.snapshot() })
				return
			}
			if (!this.gated || this.lockId !== command.lockId) throw new FlowFailure('recoveryRequired', 'invalidLock')
			if (command.type === 'operation.retire') {
				const retirementId = id(command.retirementId)
				if (!command.savedVersion || typeof command.savedVersion !== 'object') throw new FlowFailure('protocolMismatch')
				const savedEpoch = count(command.savedVersion.epoch)
				const savedRevision = count(command.savedVersion.revision)
				if (command.epoch !== this.epoch || command.revision !== this.revision || savedEpoch !== this.epoch || savedRevision !== this.revision) throw new FlowFailure('staleVersion')
				const snapshot = structuredClone(this.snapshot())
				this.retired = { command: structuredClone(command), response: null, retirementId, snapshot }
				this.pendingInteractions.clear()
				this.access.editable(false)
				const delivery = this.outbox.freezeOrdinary(this.envelope('operation.retired', command.requestId, { lockId: this.lockId, retirementId, ...snapshot }))
				this.retired.response = structuredClone(delivery.message)
				await delivery.received
				return
			}
			if (command.type === 'operation.reload') {
				id(command.reloadId)
				validateDocument(command.document)
				if (this.lastReload && this.lastReload.id === command.reloadId) {
					if (this.lastReload.lockId !== command.lockId || this.lastReload.epoch !== command.nextEpoch || !equalJson(this.lastReload.document, command.document)) throw new FlowFailure('protocolMismatch')
				}
				else {
					if (command.epoch !== this.epoch || command.oldEpoch !== this.epoch || command.nextEpoch !== this.epoch + 1) throw new FlowFailure('staleVersion')
					const token = await this.barrier()
					await this.access.replace(command.document, true, () => {
						if (token !== this.token || this.lockId !== command.lockId) throw new FlowFailure('recoveryRequired', 'superseded')
					})
					this.epoch = command.nextEpoch
					this.revision = 0
					this.eventSeq = 0
					this.lastReload = { id: command.reloadId, epoch: this.epoch, document: structuredClone(command.document), lockId: command.lockId }
				}
				await this.send('operation.reloaded', command.requestId, { lockId: this.lockId, reloadId: command.reloadId, ...this.snapshot() })
				return
			}
			if (command.type === 'operation.unlock') {
				if (command.epoch !== this.epoch) throw new FlowFailure('staleVersion')
				const token = this.token
				if (await this.send('operation.unlocked', command.requestId, { lockId: this.lockId }) && token === this.token) {
					this.lockId = null
					this.gated = false
					this.access.editable(true)
				}
				return
			}
			throw new FlowFailure('protocolMismatch')
		}
		catch (error) {
			if (!(error instanceof FlowFailure && error.detail === 'superseded')) this.block()
			const fields = { commandType: command.type, lockId: command.lockId, ...(command.reloadId ? { reloadId: command.reloadId } : {}), ...(command.recoveryId ? { recoveryId: command.recoveryId } : {}), ...(command.type === 'operation.retire' || command.type === 'operation.reconcile' ? { retirementId: command.retirementId ?? null } : {}), failure: { code: error instanceof FlowFailure ? error.code : 'transportFailure' } }
			if (command.type === 'operation.reconcile') await this.outbox.control(this.envelope('operation.error', command.requestId, fields))
			else await this.send('operation.error', command.requestId, fields)
		}
	}

	private interaction(type: string, fields: Message) {
		if (!this.flow || !this.writable) return false
		const requestId = this.messageId++
		const deliverySeq = this.outbox.tail + 1
		this.pendingInteractions.set(requestId, { type, deliverySeq, token: this.token })
		void this.send(type, requestId, fields)
		return true
	}

	openPage(request: Message) {
		if (!this.writable) return
		const block = this.access.editor().getBlock(request.hostBlockId)
		if (!block) return
		const target = page(request.page)
		if (block.type === 'krepisPageLink') {
			if (!samePage(page(block.props), target)) return
		}
		else if (block.type === 'krepisDatabase') {
			if (request.databaseId !== block.id || request.viewId !== block.props.viewId || !rows(block.props.rowsJson).some((row) => row.referenceId === request.referenceId && samePage(row, target))) return
		}
		else return
		this.interaction('page.open', request)
	}

	probeDatabaseDrop(point: Message, source?: Message, commit = false): Message | null {
		if (!this.flow || !this.writable) return null
		if (![point.x, point.y, point.width, point.height].every((value) => typeof value === 'number' && Number.isFinite(value)) || point.width <= 0 || point.height <= 0) return null
		if (point.x < 0 || point.y < 0 || point.x >= point.width || point.y >= point.height) return null
		const x = point.x * window.innerWidth / point.width
		const y = point.y * window.innerHeight / point.height
		const surface = document.elementFromPoint(x, y)?.closest<HTMLElement>('[data-krepis-database]')
		if (!surface) return null
		const databaseId = surface.dataset.krepisDatabase!
		const block = this.access.editor().getBlock(databaseId)
		if (!block || block.type !== 'krepisDatabase') return null
		const references = rows(block.props.rowsJson)
		const displayedRows = [...surface.querySelectorAll<HTMLElement>('tr[data-row-index]')]
		if (displayedRows.length !== references.length) return null
		let rowIndex = references.length
		for (const [index, row] of displayedRows.entries()) {
			if (row.dataset.referenceId !== references[index].referenceId) return null
			const bounds = row.getBoundingClientRect()
			if (y < bounds.top + bounds.height / 2) { rowIndex = index; break }
		}
		const placement = { hostInstanceId: this.hostInstanceId, databaseId, viewId: block.props.viewId, rowIndex, expectedVersion: this.version }
		if (commit) {
			const target = page(source)
			if (!this.interaction('database.drop', { page: target, databaseId, viewId: block.props.viewId, rowIndex, expectedVersion: this.version })) return null
		}
		return placement
	}
}
