import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/kallopis_editing_provider.dart';
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';
import 'package:kallopis/src/features/editing/adapters/klp_editing_adapter.dart';
import 'package:kallopis/src/features/editing/internal/klp_editing_placement.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:kallopis/src/runtime/contracts/klp_installation_exception.dart';

class _EditingSource implements KlpEditingSource {
	final StreamController<KlpEditingDrawing> _controller;
	KlpEditingDrawing? _drawing;
	List<KlpEditingDrawing> publishOnNextRead = const [];
	final int? failAfterReads;
	int _reads = 0;
	int cancellations = 0;

	_EditingSource(KlpEditingDrawing? drawing, {this.failAfterReads}) : _drawing = drawing, _controller = StreamController<KlpEditingDrawing>.broadcast(sync: false) {
		_controller.onCancel = () => cancellations++;
	}

	@override
	KlpEditingDrawing get drawing {
		if (failAfterReads case final limit? when _reads++ >= limit) throw StateError('Editing source read failed.');
		for (final drawing in publishOnNextRead) {
			publish(drawing);
		}
		publishOnNextRead = const [];
		return _drawing ?? (throw StateError('Editing source has no drawing.'));
	}
	@override
	Stream<KlpEditingDrawing> get drawings => _controller.stream;
	bool get hasListener => _controller.hasListener;

	void publish(KlpEditingDrawing drawing) {
		_drawing = drawing;
		_controller.add(drawing);
	}

	void clear() => _drawing = null;

	Future<void> close() => _controller.close();
}

final class _LayoutSource extends _EditingSource implements KlpEditingLayoutSource {
	KlpEditingStyle? _style;

	_LayoutSource(super.drawing);

	@override
	KlpEditingDrawing layout(KlpEditingLayout layout) {
		layout.validate();
		final before = drawing.projection.stamp;
		_style = layout.style;
		final next = _drawing(
			before.projectionRevision + 1,
			content: before.contentRevision,
			composition: before.compositionRevision,
			layout: before.layoutRevision + 1,
			environment: 'style-${layout.style.hashCode}',
			width: layout.viewport.width,
			height: layout.viewport.height,
		);
		publish(next);
		return next;
	}
}

KlpEditingDrawing _drawing(int projection, {int generation = 0, int content = 0, int composition = 0, int layout = 0, String environment = 'font-style-0', double width = 640, double height = 480}) {
	final stamp = KlpEditingStamp(
		documentId: 'document', pageId: 'page', generation: generation,
		projectionRevision: projection, contentRevision: content,
		compositionRevision: composition, layoutRevision: layout,
		environmentId: environment,
	);
	final endpoint = KlpEditingEndpoint('block', 0, KlpEditingAffinity.downstream);
	return KlpEditingDrawing(
		projection: KlpEditingProjection(stamp: stamp, anchor: endpoint, focus: endpoint, blockSelection: false),
		width: width, height: height, commands: const [],
	);
}

KlpTreeRuntime _install(_EditingSource source, {KlpPrimitiveSet? primitives}) {
	final runtime = KlpTreeRuntime();
	runtime.update(
		root: KlpEditingContent(id: KlpId.parse('stage'), source: source),
		adapters: [KlpEditingAdapter()],
		primitives: primitives ?? KlpWorkspacePreset.light(),
	);
	return runtime;
}

void _updateSingle(KlpTreeRuntime runtime, _EditingSource source) {
	runtime.update(
		root: KlpEditingContent(id: KlpId.parse('editing'), source: source),
		adapters: [KlpEditingAdapter()],
		primitives: KlpWorkspacePreset.light(),
	);
}

KlpTreeRuntime _installSingle(_EditingSource source) {
	final runtime = KlpTreeRuntime();
	_updateSingle(runtime, source);
	return runtime;
}

KlpBoundEditing _single(KlpTreeRuntime runtime) => (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundEditing;

KlpBoundEditing _stage(KlpTreeRuntime runtime) {
	final root = runtime.frame!.content as KlpBoundPlacement;
	return root.content as KlpBoundEditing;
}

Future<void> _flushEvents() => Future<void>.delayed(Duration.zero);

KlpEditingStyle _withCaret(KlpEditingStyle style, int caret) => KlpEditingStyle(
	fontFamily: style.fontFamily,
	fontFallbacks: style.fontFallbacks,
	fontWeight: style.fontWeight,
	fontSize: style.fontSize,
	lineHeight: style.lineHeight,
	letterSpacing: style.letterSpacing,
	horizontalPadding: style.horizontalPadding,
	verticalPadding: style.verticalPadding,
	blockSpacing: style.blockSpacing,
	overscan: style.overscan,
	textRgba: style.textRgba,
	inkRgba: style.inkRgba,
	caretRgba: caret,
	listIndent: style.listIndent,
	markerGap: style.markerGap,
	minimumBodyEm: style.minimumBodyEm,
	markerRgba: style.markerRgba,
	markerFormat: style.markerFormat,
);

void main() {
	test('editing content installs through workspace and resolves role colors', () async {
		final initial = _drawing(0);
		final source = _EditingSource(initial);
		final primitives = KlpWorkspacePreset.light();
		final runtime = _install(source, primitives: primitives);
		final editing = _stage(runtime);

		expect(editing.drawing.value, same(initial));
		expect(editing.style.text, same(primitives.colors[1]));
		expect(editing.style.ink, same(primitives.colors[1]));
		expect(editing.style.caret, same(primitives.colors[7]));
		expect(editing.style.selection, same(primitives.colors[7]));
		expect(editing.style.horizontalPadding.value, 30);
		expect(editing.style.verticalPadding.value, 28);
		expect(editing.style.blockSpacing.value, 8);
		expect(editing.style.overscan.value, 48);

		final next = _drawing(1, content: 1, layout: 1);
		source.publish(next);
		await _flushEvents();
		expect(editing.drawing.value, same(next));

		runtime.dispose();
		await _flushEvents();
		expect(source.hasListener, isFalse);
		expect(source.cancellations, 1);
		await source.close();
	});

	test('readonly layout source receives semantic style and exact viewport', () async {
		final source = _LayoutSource(_drawing(0));
		final runtime = _installSingle(source);
		final editing = _single(runtime);
		final style = editing.style.core;
		expect(editing.layout, isNotNull);
		expect(editing.actions, isNull);
		expect((style.fontFamily, style.fontWeight, style.fontSize, style.lineHeight, style.letterSpacing), ('packages/kallopis/Noto Sans TC', 400, 16, 24, 0));

		final next = editing.layout!.layout(KlpEditingLayout(viewport: const KlpEditingViewport(width: 500, height: 300), style: style));
		expect((next.width, next.height), (500, 300));
		expect(editing.drawing.value, same(next));
		expect(source._style, same(style));
		await _flushEvents();

		runtime.dispose();
		await source.close();
	});

	test('authorized environment layouts drain bounded stale event watermarks', () async {
		final errors = <Object>[];
		late _LayoutSource source;
		late KlpEditingPlacement placement;
		await runZonedGuarded(() async {
			source = _LayoutSource(_drawing(0));
			final styled = _installSingle(source);
			final style = _single(styled).style.core;
			styled.dispose();
			await _flushEvents();
			placement = KlpEditingPlacement(source, source.drawing);
			source.publish(_drawing(1, content: 1, layout: 1));
			for (var index = 0; index < 5; index++) {
				placement.layout(KlpEditingLayout(viewport: KlpEditingViewport(width: 500 + index.toDouble(), height: 300), style: _withCaret(style, style.caretRgba + index + 1)));
			}
			await _flushEvents();
			expect(placement.queuedEnvironmentCount, 0);
			placement.dispose();
			await source.close();
		}, (error, stack) => errors.add(error));

		expect(errors, isEmpty);
	});

	test('invalid source update is observable and preserves last drawing', () async {
		final errors = <Object>[];
		late _EditingSource source;
		late KlpTreeRuntime runtime;
		late KlpBoundEditing editing;
		await runZonedGuarded(() async {
			final initial = _drawing(2, content: 2, composition: 2, layout: 2);
			source = _EditingSource(initial);
			runtime = _install(source);
			editing = _stage(runtime);

			source.publish(_drawing(3, generation: 1, content: 3, composition: 3, layout: 3));
			await _flushEvents();
			expect(editing.drawing.value, same(initial));

			runtime.dispose();
			await source.close();
		}, (error, stackTrace) => errors.add(error));

		expect(errors, hasLength(1));
		for (final error in errors) {
			expect(error, isA<KlpContractError>());
			expect((error as KlpContractError).code, 'editing_session_mismatch');
		}
	});

	test('same stamp collision and true source regression stay observable', () async {
		final errors = <Object>[];
		late _EditingSource source;
		late KlpEditingPlacement placement;
		await runZonedGuarded(() async {
			final initial = _drawing(2, content: 2, composition: 2, layout: 2);
			source = _EditingSource(initial);
			placement = KlpEditingPlacement(source, initial);

			source.publish(_drawing(2, content: 2, composition: 2, layout: 2));
			await _flushEvents();
			source.publish(_drawing(1, content: 1, composition: 1, layout: 1));
			await _flushEvents();
			expect(placement.drawing.value, same(initial));

			placement.dispose();
			await source.close();
		}, (error, stackTrace) => errors.add(error));

		expect(errors, hasLength(2));
		expect((errors[0] as KlpContractError).code, 'editing_stamp_collision');
		expect((errors[1] as KlpContractError).code, 'editing_revision_regression');
	});

	test('placement reads the latest source snapshot after subscribing', () async {
		final prepared = _drawing(0);
		final latest = _drawing(1, content: 1, layout: 1);
		final source = _EditingSource(prepared);
		source.publish(latest);

		final placement = KlpEditingPlacement(source, prepared);
		expect(placement.drawing.value, same(latest));

		placement.dispose();
		await source.close();
	});

	test('queued catch-up events do not regress the getter watermark', () async {
		final errors = <Object>[];
		late _EditingSource source;
		late KlpEditingPlacement placement;
		await runZonedGuarded(() async {
			final prepared = _drawing(0);
			final first = _drawing(1, content: 1, layout: 1);
			final latest = _drawing(2, content: 2, layout: 2);
			source = _EditingSource(prepared)..publishOnNextRead = [first, latest];
			placement = KlpEditingPlacement(source, prepared);
			await _flushEvents();
			expect(placement.drawing.value, same(latest));

			source.publish(first);
			await _flushEvents();
			expect(placement.drawing.value, same(latest));

			placement.dispose();
			await source.close();
		}, (error, stackTrace) => errors.add(error));

		expect(errors, hasLength(1));
		expect((errors.single as KlpContractError).code, 'editing_revision_regression');
	});

	test('same placement replaces a changed source and ignores the old source', () async {
		final sourceA = _EditingSource(_drawing(0));
		final sourceBInitial = _drawing(0, generation: 1);
		final sourceB = _EditingSource(sourceBInitial);
		final runtime = _installSingle(sourceA);
		final old = _single(runtime);

		_updateSingle(runtime, sourceB);
		final current = _single(runtime);
		expect(current.drawing, isNot(same(old.drawing)));
		expect(current.drawing.value, same(sourceBInitial));
		await _flushEvents();
		expect(sourceA.hasListener, isFalse);

		sourceA.publish(_drawing(1, content: 1, layout: 1));
		final sourceBNext = _drawing(1, generation: 1, content: 1, layout: 1);
		sourceB.publish(sourceBNext);
		await _flushEvents();
		expect(current.drawing.value, same(sourceBNext));

		runtime.dispose();
		await sourceA.close();
		await sourceB.close();
	});

	test('failed replacement keeps the old source and committed frame', () async {
		final sourceAInitial = _drawing(0);
		final sourceA = _EditingSource(sourceAInitial);
		final sourceB = _EditingSource(_drawing(0, generation: 1), failAfterReads: 1);
		final runtime = _installSingle(sourceA);
		final frame = runtime.frame;

		expect(
			() => _updateSingle(runtime, sourceB),
			throwsA(isA<KlpInstallationException>().having((error) => error.committed, 'committed', isFalse)),
		);
		expect(runtime.frame, same(frame));
		expect(_single(runtime).drawing.value, same(sourceAInitial));
		await _flushEvents();
		expect(sourceA.hasListener, isTrue);
		expect(sourceB.hasListener, isFalse);

		runtime.dispose();
		await sourceA.close();
		await sourceB.close();
	});

	test('same source cannot reset generation during a runtime refresh', () async {
		final errors = <Object>[];
		late _EditingSource source;
		late KlpTreeRuntime runtime;
		late KlpEditingDrawing initial;
		await runZonedGuarded(() async {
			initial = _drawing(2, content: 2, composition: 2, layout: 2);
			source = _EditingSource(initial);
			runtime = _installSingle(source);

			source.publish(_drawing(0, generation: 1));
			_updateSingle(runtime, source);
			expect(_single(runtime).drawing.value, same(initial));
			await _flushEvents();
			expect(_single(runtime).drawing.value, same(initial));

			runtime.dispose();
			await source.close();
		}, (error, stackTrace) => errors.add(error));

		expect(errors, hasLength(1));
		expect((errors.single as KlpContractError).code, 'editing_session_mismatch');
	});

	test('initial source failure cancels pending subscriptions without replacing a generation', () async {
		final prepared = _drawing(0);
		final source = _EditingSource(prepared);
		source.clear();
		expect(() => KlpEditingPlacement(source, prepared), throwsStateError);
		await _flushEvents();
		expect(source.cancellations, 1);
		expect(source.hasListener, isFalse);
		await source.close();
	});

	test('closed application catalog includes editing screen body', () {
		final source = _EditingSource(_drawing(0));
		final definitions = klpApplicationAdapters().map((adapter) => adapter.contract.id);
		expect(definitions, contains(KlpEditingContent.typeId));
		unawaited(source.close());
	});
}
