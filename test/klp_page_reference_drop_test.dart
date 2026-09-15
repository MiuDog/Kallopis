import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_block_note_flow_transport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart' show KlpId;
import 'package:kallopis/src/rendering/flutter/internal/klp_page_reference_drag.dart';
import 'package:krepis_block_note/krepis_block_note.dart';

void main() {
	final first = KlpId.root('first');
	final second = KlpId.root('second');
	final pageA = KrepisPageReference(projectId: 'project-A', documentId: 'same');
	final pageB = KrepisPageReference(projectId: 'project-B', documentId: 'same');

	test('one mapped source preserves the complete page identity and immutable original move source', () {
		final source = {first};
		final drag = KlpPageReferenceDrag(sourceIds: source, pageReferences: {first: pageA, second: pageB});
		source.add(second);
		expect(drag.sourceIds, {first});
		expect(() => drag.sourceIds.add(second), throwsUnsupportedError);
		expect(drag.page, pageA);
		expect(drag.page!.projectId, 'project-A');
		expect(drag.page!.documentId, 'same');
	});

	test('empty, unmapped and multiselection carriers never choose a guessed first page', () {
		final mappings = {first: pageA, second: pageB};
		final empty = KlpPageReferenceDrag(sourceIds: {}, pageReferences: mappings);
		final unmapped = KlpPageReferenceDrag(sourceIds: {KlpId.root('category')}, pageReferences: mappings);
		final multiple = KlpPageReferenceDrag(sourceIds: {first, second}, pageReferences: mappings);
		expect(empty.page, isNull);
		expect(unmapped.page, isNull);
		expect(multiple.page, isNull);
		expect(multiple.sourceIds, {first, second}, reason: 'Existing Explorer multi-selection movement keeps the full source set');
	});

	test('active carrier notification only changes drag state without creating a second page registry', () {
		final original = klpActivePageReferenceDrag.value;
		addTearDown(() { klpActivePageReferenceDrag.value = original; });
		final drag = KlpPageReferenceDrag(sourceIds: {second}, pageReferences: {second: pageB});
		final observed = <KlpPageReferenceDrag?>[];
		void listener() { observed.add(klpActivePageReferenceDrag.value); }
		klpActivePageReferenceDrag.addListener(listener);
		addTearDown(() { klpActivePageReferenceDrag.removeListener(listener); });
		klpActivePageReferenceDrag.value = drag;
		expect(klpActivePageReferenceDrag.value, same(drag));
		expect(klpActivePageReferenceDrag.value!.page, pageB);
		klpActivePageReferenceDrag.value = null;
		expect(observed, [drag, null]);
	});
}

final class FlowHostFixture {

	final channel = KlpBlockNoteBridgeChannel();
	final commands = <Map<String, Object?>>[];
	final results = <Map<String, Object?>>[];
	final responses = <Map<String, Object?>>[];
	final failures = <(Object, StackTrace)>[];
	final statusVersions = <int>[];
	final document = KlpBlockNoteDocument(schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: const []);
	late final KlpBlockNoteSessionController session;
	late final KlpBlockNoteFlowTransport transport;
	late KlpBoundBlockNoteEditing content;
	int deliverySeq = 0;
	int interactionId = 5000;
	int registryNotices = 0;
	bool rejectConfiguration = false;
	bool _transportDisposed = false;

	FlowHostFixture({Future<void> Function(KlpBlockNoteDocument)? persist}) {
		session = KlpBlockNoteSessionController(documentId: 'document', sessionId: 'session', initialDocument: document, bridge: channel, persist: persist ?? (_) async {}, operationTimeout: const Duration(seconds: 2));
		session.onChanged = () { registryNotices++; };
		content = bound();
		transport = KlpBlockNoteFlowTransport(
			session: session,
			content: () => content,
			send: (message) async { results.add(Map<String, Object?>.from(message)); },
			onFailure: (error, stack) { failures.add((error, stack)); },
			onStatusChanged: () { statusVersions.add(session.operationStatus.statusVersion); },
		);
	}

	KlpBoundBlockNoteEditing bound({Iterable<KrepisPageProjection> projections = const [], Future<void> Function(KrepisPageOpenRequest)? onOpenPage, Future<KrepisBlockNoteEditResult> Function(KrepisDatabaseDropRequest)? onDatabaseDrop}) => KlpBoundBlockNoteEditing(session, background: '#ffffff', text: '#000000', fontFamily: 'Test', fontSize: 14, pageProjections: projections, onOpenPage: onOpenPage, onDatabaseDrop: onDatabaseDrop);

	Future<void> open() async {
		await channel.bindPlatformSender(_send);
		await session.prepareFlowCapabilities();
		await session.open();
	}

	Map<String, Object?> interaction(String type, Map<String, Object?> fields) => _envelope(type, interactionId++, fields);

	Map<String, Object?> _envelope(String type, int requestId, Map<String, Object?> fields) => {
		'protocolVersion': 1, 'flowProtocolVersion': 1, 'documentId': 'document', 'sessionId': 'session', 'hostInstanceId': 'host-A', 'epoch': 0, 'revision': 0, 'eventSeq': 0, 'requestId': requestId, 'type': type, 'lane': 'ordinary', 'deliverySeq': ++deliverySeq, ...fields,
	};

	void _reply(Map<String, Object?> command, String type, Map<String, Object?> fields) {
		final response = _envelope(type, command['requestId']! as int, fields);
		responses.add(response);
		if (_transportDisposed) session.acceptFlowMessage(response);
		else transport.receive(response);
	}

	Future<void> _send(Map<String, Object?> command) async {
		commands.add(Map<String, Object?>.from(command));
		switch (command['type']) {
			case 'flow.capabilities.request':
				final response = {'protocolVersion': 1, 'flowProtocolVersion': 1, 'documentId': 'document', 'sessionId': 'session', 'hostInstanceId': 'host-A', 'epoch': 0, 'revision': 0, 'eventSeq': 0, 'requestId': command['requestId'], 'type': 'flow.capabilities.response', 'lane': 'control', 'lastDeliverySeq': 0, 'capabilities': {'pageLinksV1': true, 'databaseTableV1': true, 'operationGateV1': true}};
				transport.receive(response);
			case 'open':
				_reply(command, 'ready', {'outline': <Object?>[]});
			case 'snapshot.request':
				_reply(command, 'snapshot.response', {'document': document.toJson(), 'outline': <Object?>[]});
			case 'page.configure':
				_reply(command, 'command.result', {'commandType': 'page.configure', 'status': rejectConfiguration ? 'rejected' : 'unchanged', if (rejectConfiguration) 'failure': {'code': 'invalidArgument'}});
			case 'operation.lock':
				_reply(command, 'operation.locked', {'lockId': command['lockId'], 'barrierEventSeq': 0, 'document': document.toJson(), 'outline': <Object?>[]});
			case 'operation.unlock':
				_reply(command, 'operation.unlocked', {'lockId': command['lockId']});
			default:
				throw StateError('Unexpected fake-host command ${command['type']}');
		}
	}

	void detachTransport() {
		if (_transportDisposed) return;

		_transportDisposed = true;
		transport.dispose();
	}

	void dispose() {
		detachTransport();
		channel.unbindPlatformSender();
	}
}
