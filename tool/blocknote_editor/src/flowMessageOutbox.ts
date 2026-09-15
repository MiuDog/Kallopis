import { count } from './flowProtocol'
import type { Message } from './flowProtocol'

type Pending = { message: Message; finish: (received: boolean) => void }
type FrozenDelivery = { message: Message; received: Promise<boolean> }

/** 普通交付串行；恢復回覆不等待普通佇列。 */
export class FlowMessageOutbox {
	private queue: Pending[] = []
	private generation = 0
	private running = false
	private stalled = false
	private sequence = 0
	private controlTail: Promise<unknown> = Promise.resolve()

	constructor(private readonly failClosed: () => void) {}

	get tail() { return this.sequence }
	get capacityAvailable() { return this.queue.length < 126 && !this.stalled }

	ordinary(message: Message): Promise<boolean> {
		return this.freezeOrdinary(message).received
	}

	freezeOrdinary(message: Message): FrozenDelivery {
		if (this.sequence >= Number.MAX_SAFE_INTEGER || this.queue.length >= 128) {
			this.failClosed()
			return { message, received: Promise.resolve(false) }
		}
		const delivery = { ...message, lane: 'ordinary', deliverySeq: ++this.sequence }
		const promise = new Promise<boolean>((finish) => {
			this.queue.push({ message: delivery, finish })
		})
		if (this.queue.length >= 128) this.failClosed()
		void this.drain()
		return { message: delivery, received: promise }
	}

	async replayOrdinary(message: Message): Promise<boolean> {
		if (message.lane !== 'ordinary' || count(message.deliverySeq) < 1) return false
		const received = await this.deliver(message)
		if (!received) this.failClosed()
		return received
	}

	async control(message: Message): Promise<boolean> {
		const delivery = this.controlTail.then(() => this.deliver({ ...message, lane: 'control' }))
		this.controlTail = delivery
		const received = await delivery
		if (!received) this.failClosed()
		return received
	}

	cover(sequence: number) {
		this.generation += 1
		this.running = false
		this.stalled = false
		for (const entry of this.queue.filter((value) => value.message.deliverySeq <= sequence)) entry.finish(false)
		this.queue = this.queue.filter((value) => value.message.deliverySeq > sequence)
		void this.drain()
	}

	private async drain() {
		if (this.running || this.stalled) return
		this.running = true
		const generation = this.generation
		while (this.queue.length && generation === this.generation) {
			const entry = this.queue[0]
			const received = await this.deliver(entry.message)
			if (generation !== this.generation) return
			if (!received) {
				this.stalled = true
				this.running = false
				this.failClosed()
				entry.finish(false)
				return
			}
			this.queue.shift()
			entry.finish(true)
		}
		this.running = false
	}

	private async deliver(message: Message): Promise<boolean> {
		let timer: ReturnType<typeof setTimeout> | undefined
		try {
			const receipt = await Promise.race([
				window.flutter_inappwebview?.callHandler('KallopisBlockNote', message),
				new Promise<undefined>((resolve) => { timer = setTimeout(resolve, 5000) }),
			]) as Message | undefined
			if (!receipt || receipt.received !== true || receipt.lane !== message.lane || receipt.hostInstanceId !== message.hostInstanceId || receipt.messageType !== message.type) return false
			if (message.lane === 'ordinary') return receipt.deliverySeq === message.deliverySeq && receipt.requestId === undefined && receipt.recoveryId === undefined
			return receipt.requestId === message.requestId && receipt.recoveryId === message.recoveryId && receipt.deliverySeq === undefined
		}
		catch { return false }
		finally { if (timer !== undefined) clearTimeout(timer) }
	}
}
