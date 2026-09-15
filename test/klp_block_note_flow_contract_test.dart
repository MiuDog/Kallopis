import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart' as klp;
import 'package:kallopis/src/features/editing/adapters/klp_block_note_editing_adapter.dart';
import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:krepis_block_note/krepis_block_note.dart' as krepis;

void main() {
	test('optional Flow parameters preserve the existing hosted constructor and defaults', () {
		final controller = _controller(krepis.KlpBlockNoteBridgeChannel());
		final content = klp.KlpBlockNoteEditingContent(id: klp.KlpId.root('flow'), controller: controller);
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final bound = _prepare(runtime, content);
		expect(content.controller, same(controller));
		expect(content.pageProjections, isEmpty);
		expect(content.onOpenPage, isNull);
		expect(content.onDatabaseDrop, isNull);
		expect(bound.controller, same(controller));
		expect(bound.pageProjections, isEmpty);
		expect(bound.onOpenPage, isNull);
		expect(bound.onDatabaseDrop, isNull);
		expect(() => klp.KlpBlockNoteEditingContent(id: content.id, controller: _controller(_UnhostedPort())), throwsArgumentError);
	});

	test('page projections snapshot complete identities and remain immutable through prepare and bound', () {
		final controller = _controller(krepis.KlpBlockNoteBridgeChannel());
		final first = krepis.KrepisPageProjection(page: krepis.KrepisPageReference(projectId: 'A', documentId: 'same'), title: '同名', availability: krepis.KrepisPageAvailability.available);
		final second = krepis.KrepisPageProjection(page: krepis.KrepisPageReference(projectId: 'B', documentId: 'same'), title: '同名', availability: krepis.KrepisPageAvailability.unavailable);
		final projections = [first, second];
		final content = klp.KlpBlockNoteEditingContent(id: klp.KlpId.root('flow'), controller: controller, pageProjections: projections);
		projections.clear();
		expect(content.pageProjections, [first, second]);
		expect(() => content.pageProjections.clear(), throwsUnsupportedError);
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final bound = _prepare(runtime, content);
		expect(bound.pageProjections, [first, second]);
		expect(bound.pageProjections[0].page.projectId, 'A');
		expect(bound.pageProjections[1].page.projectId, 'B');
		expect(() => bound.pageProjections.clear(), throwsUnsupportedError);
		expect(controller.dirty, isFalse);
	});

	test('typed and legacy callbacks preserve identity and return the consumer result unchanged', () async {
		final controller = _controller(krepis.KlpBlockNoteBridgeChannel());
		final opened = <krepis.KrepisPageOpenRequest>[];
		final dropped = <krepis.KrepisDatabaseDropRequest>[];
		final failure = krepis.KrepisBlockNoteFailure(code: krepis.KrepisBlockNoteFailureCode.invalidTarget, operation: 'database.reference.insert', requestId: null);
		final expectedResult = krepis.KrepisBlockNoteEditRejected(failure: failure);
		Future<void> onOpenPage(krepis.KrepisPageOpenRequest request) async { opened.add(request); }
		Future<krepis.KrepisBlockNoteEditResult> onDatabaseDrop(krepis.KrepisDatabaseDropRequest request) async { dropped.add(request); return expectedResult; }
		Future<void> onOpened() async {}
		Future<void> onOpenAsset(String assetId) async {}
		Future<void> onOpenReference(String referenceId, String documentId, String blockId) async {}
		Future<klp.KlpResolvedAsset> resolveAsset(String assetId) async => const klp.KlpResolvedAsset(bytes: [1], mediaType: 'application/octet-stream');
		final content = klp.KlpBlockNoteEditingContent(
			id: klp.KlpId.root('flow'),
			controller: controller,
			onOpenPage: onOpenPage,
			onDatabaseDrop: onDatabaseDrop,
			onOpened: onOpened,
			onOpenAsset: onOpenAsset,
			onOpenReference: onOpenReference,
			resolveAsset: resolveAsset,
		);
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final bound = _prepare(runtime, content);
		expect(bound.onOpenPage, same(onOpenPage));
		expect(bound.onDatabaseDrop, same(onDatabaseDrop));
		expect(bound.onOpened, same(onOpened));
		expect(bound.onOpenAsset, same(onOpenAsset));
		expect(bound.onOpenReference, same(onOpenReference));
		expect(bound.resolveAsset, same(resolveAsset));
		final page = krepis.KrepisPageReference(projectId: 'A', documentId: 'page');
		final view = krepis.KrepisDatabaseViewReference(database: krepis.KrepisDatabaseReference(databaseId: 'database'), viewId: 'table');
		final opening = krepis.KrepisPageOpenRequest(page: page, hostBlockId: 'database', databaseView: view, referenceId: 'row');
		final dropping = krepis.KrepisDatabaseDropRequest(page: page, placement: krepis.KrepisDatabasePlacement(view: view, rowIndex: 2), expectedVersion: krepis.KrepisBlockNoteVersion(epoch: 3, revision: 4));
		await bound.onOpenPage!(opening);
		expect(opened.single, same(opening));
		expect(await bound.onDatabaseDrop!(dropping), same(expectedResult));
		expect(dropped.single, same(dropping));
	});

	test('declaration replacement updates projections and callbacks without owning session lifecycle', () async {
		final channel = krepis.KlpBlockNoteBridgeChannel();
		final commands = <Map<String, Object?>>[];
		await channel.bindPlatformSender((command) async { commands.add(command); });
		final controller = _controller(channel);
		var registryNotices = 0;
		void registryCallback() { registryNotices++; }
		controller.onChanged = registryCallback;
		Future<void> firstCallback(krepis.KrepisPageOpenRequest request) async {}
		Future<void> nextCallback(krepis.KrepisPageOpenRequest request) async {}
		final projection = krepis.KrepisPageProjection(page: krepis.KrepisPageReference(projectId: 'A', documentId: 'page'), title: 'first', availability: krepis.KrepisPageAvailability.available);
		final id = klp.KlpId.root('flow');
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final first = _prepare(runtime, klp.KlpBlockNoteEditingContent(id: id, controller: controller, pageProjections: [projection], onOpenPage: firstCallback));
		final next = _prepare(runtime, klp.KlpBlockNoteEditingContent(id: id, controller: controller, onOpenPage: nextCallback));
		expect(first.pageProjections, [projection]);
		expect(first.onOpenPage, same(firstCallback));
		expect(next.pageProjections, isEmpty);
		expect(next.onOpenPage, same(nextCallback));
		expect(next.controller, same(controller));
		expect(next.controller.bridge, same(channel));
		expect(controller.onChanged, same(registryCallback));
		expect(controller.dirty, isFalse);
		expect(registryNotices, 0);
		expect(commands, isEmpty);
	});
}

KlpBoundBlockNoteEditing _prepare(KlpTreeRuntime runtime, klp.KlpBlockNoteEditingContent content) {
	// 使用正式語意解析與 prepare/materialize 邊界，不以手工 bound 冒充透傳證據。
	runtime.update(root: content, adapters: [KlpBlockNoteEditingAdapter()], primitives: klp.KlpWorkspacePreset.light());
	return (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundBlockNoteEditing;
}

krepis.KlpBlockNoteSessionController _controller(krepis.KlpBlockNoteBridgePort bridge) => krepis.KlpBlockNoteSessionController(documentId: 'document', sessionId: 'session', initialDocument: krepis.KlpBlockNoteDocument(schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: []), bridge: bridge, persist: (_) async {});

final class _UnhostedPort implements krepis.KlpBlockNoteBridgePort {

	@override
	Future<void> send(Map<String, Object?> command) async {}
}
