import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'dart:async';

import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_source.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_interaction.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_layout.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_point_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_viewport_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_viewport_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_source.dart';
import 'package:kallopis/src/capabilities/state/klp_mutable_state.dart';
import 'package:kallopis/src/capabilities/state/klp_state.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'klp_editor_mode_capability.dart';

/// 借用提供者來源並保存最後一份已通過版本閘門的繪圖。
final class KlpEditingPlacement implements KlpPlacementResource, KlpBoundEditingActions, KlpBoundBlockActions, KlpBoundAnchoredCommandActions, KlpBoundEditorModeActions, KlpBoundEditingSaveActions {
	final KlpEditingSource _source;
	late final StreamSubscription<KlpEditingDrawing> _subscription;
	late final KlpMutableState<KlpEditingDrawing> _drawing;
	final Map<String, KlpEditingDrawing> _queuedEnvironmentWatermarks = {};
	bool _disposed = false;

	KlpEditingPlacement(this._source, KlpEditingDrawing prepared) {
		if (!_source.drawings.isBroadcast) throw const KlpContractError('invalid_editing_source', 'Editing drawings must use a broadcast stream.');

		// 先訂閱再讀取目前快照；非同步廣播確保初始化完成前不會漏接事件。
		_subscription = _source.drawings.listen(_receive);
		try {
			final current = _source.drawing;
			_validateAdvance(prepared, current, allowSame: true);
			_drawing = KlpMutableState(current);
		} catch (_) {
			unawaited(_subscription.cancel());
			rethrow;
		}
	}

	KlpState<KlpEditingDrawing> get drawing => _drawing.readOnly;
	int get queuedEnvironmentCount => _queuedEnvironmentWatermarks.length;
	bool matches(KlpEditingSource source) => identical(_source, source);

	@override
	int issueCommandSequence() {
		final source = _source;
		if (_disposed || source is! KlpEditableSource && source is! KlpBlockControlSource && source is! KlpAnchoredCommandSource && source is! KlpEditorModeSource && source is! KlpEditingSaveSource) throw StateError('Editing commands are unavailable');
		return switch (source) {
			KlpEditableSource value => value.issueCommandSequence(),
			KlpBlockControlSource value => value.issueCommandSequence(),
			KlpAnchoredCommandSource value => value.issueCommandSequence(),
			KlpEditorModeSource value => value.issueCommandSequence(),
			KlpEditingSaveSource value => value.issueCommandSequence(),
			_ => throw StateError('Editing commands are unavailable'),
		};
	}

	@override
	KlpState<KlpEditingSaveProjection> get saveState {
		final source = _source;
		if (_disposed || source is! KlpEditingSaveSource) throw StateError('Editing save state is unavailable');
		return source.saveState;
	}

	@override
	Future<KlpEditingSaveReply> submitSave(KlpEditingSaveRequest request) {
		final source = _source;
		if (_disposed || source is! KlpEditingSaveSource) throw StateError('Editing save is unavailable');
		return Future.sync(() => source.submitSave(request));
	}

	@override
	Future<KlpEditorModeReply> submitEditorMode(KlpEditorModeRequest request, {required int committedAtMs}) async {
		final source = _source;
		if (_disposed || source is! KlpEditorModeSource) throw StateError('Editor modes are unavailable');
		final reply = await Future.sync(() => source.submitEditorMode(request, committedAtMs: committedAtMs));
		if (!_disposed) _receive(source.drawing);
		return reply;
	}

	@override
	Future<KlpEditorModeReply> submitEditorViewport(KlpEditorViewportRequest request, {required int committedAtMs}) async {
		final source = _source;
		if (_disposed || source is! KlpEditorModeSource) throw StateError('Editor viewport is unavailable');
		final reply = await Future.sync(() => source.submitEditorViewport(request, committedAtMs: committedAtMs));
		if (!_disposed) _receive(source.drawing);
		return reply;
	}

	@override
	Future<KlpCommandReply> submitAnchoredCommand(KlpCommandRequest request, {required int committedAtMs}) async {
		final source = _source;
		if (_disposed || source is! KlpAnchoredCommandSource) throw StateError('Anchored commands are unavailable');
		final reply = await Future.sync(() => source.submitAnchoredCommand(request, committedAtMs: committedAtMs));
		if (_disposed) return reply;
		_receive(source.drawing);
		return reply;
	}

	@override
	KlpEditingDrawing layout(KlpEditingLayout layout) {
		final source = _source;
		if (_disposed || source is! KlpEditingLayoutSource) throw StateError('Editing layout is unavailable');
		layout.validate();
		final prior = _source.drawing;
		if (_validateAdvance(_drawing.value, prior, allowSame: true)) _drawing.value = prior;
		final next = source.layout(layout);
		if (!identical(next, _source.drawing)) throw const KlpContractError('invalid_editing_layout', 'Layout must return the source current drawing.');
		if (next.width != layout.viewport.width || next.height != layout.viewport.height) throw const KlpContractError('invalid_editing_layout', 'Layout returned another viewport.');
		_validateAdvance(_drawing.value, next, allowSame: true, allowEnvironment: true);
		if (prior.projection.stamp.environmentId != next.projection.stamp.environmentId) _queuedEnvironmentWatermarks[prior.projection.stamp.environmentId] = prior;
		if (!identical(_drawing.value, next)) _drawing.value = next;
		return next;
	}

	@override
	Future<KlpEditingReply> submit(KlpEditingRequest request, {required int committedAtMs}) {
		final source = _source;
		if (_disposed || source is! KlpEditableSource) throw StateError('Editing submission is unavailable');
		return Future.sync(() => source.submit(request, committedAtMs: committedAtMs));
	}

	@override
	Future<KlpEditingReply> submitBlock(KlpBlockRequest request, {required int committedAtMs}) async {
		final source = _source;
		if (_disposed || source is! KlpBlockControlSource) throw StateError('Block controls are unavailable');
		final reply = await Future.sync(() => source.submitBlock(request, committedAtMs: committedAtMs));
		if (_disposed) return reply;
		_receive(source.drawing);
		return reply;
	}

	@override
	Future<KlpEditingReply> submitBlockViewport(KlpBlockViewportRequest request, {required int committedAtMs}) async {
		final source = _source;
		if (_disposed || source is! KlpBlockControlSource) throw StateError('Block viewport controls are unavailable');
		final reply = await Future.sync(() => source.submitBlockViewport(request, committedAtMs: committedAtMs));
		if (_disposed) return reply;
		_receive(source.drawing);
		return reply;
	}

	@override
	Future<KlpEditingReply> selectPoint(KlpEditingPointRequest request) {
		final source = _source;
		if (_disposed || source is! KlpEditableSource) throw StateError('Point selection is unavailable');
		return Future.sync(() => source.selectPoint(request));
	}

	@override
	KlpEditingInteractionBinding bindInteraction(KlpEditingInteraction interaction) {
		final source = _source;
		if (_disposed || source is! KlpEditableSource) throw StateError('Editing interaction is unavailable');
		return source.bindInteraction(interaction);
	}

	void _receive(KlpEditingDrawing event) {
		if (_disposed) return;
		final current = _source.drawing;
		final displayed = _drawing.value;
		final advanced = _validateAdvance(displayed, current, allowSame: true, allowEnvironment: false);
		if (advanced) _drawing.value = current;

		if (_coveredBy(event, current)) {
			if (event.projection.stamp == current.projection.stamp) {
				_validateAdvance(current, event, allowSame: true);
				_queuedEnvironmentWatermarks.clear();
			}
			return;
		}
		final queued = _queuedEnvironmentWatermarks[event.projection.stamp.environmentId];
		if (queued != null && _coveredBy(event, queued)) {
			if (event.projection.stamp == queued.projection.stamp) _queuedEnvironmentWatermarks.remove(event.projection.stamp.environmentId);
			return;
		}
		throw const KlpContractError('invalid_editing_publication', 'An editing event must already be the source current drawing or an older queued delivery.');
	}

	bool _coveredBy(KlpEditingDrawing drawing, KlpEditingDrawing watermark) {
		final value = drawing.projection.stamp;
		final limit = watermark.projection.stamp;
		if (!limit.sameSession(value) || limit.environmentId != value.environmentId) return false;
		return value.projectionRevision <= limit.projectionRevision
			&& value.contentRevision <= limit.contentRevision
			&& value.compositionRevision <= limit.compositionRevision
			&& value.layoutRevision <= limit.layoutRevision;
	}

	bool _validateAdvance(KlpEditingDrawing previous, KlpEditingDrawing next, {required bool allowSame, bool allowEnvironment = false}) {
		validateKlpEditorModeCapability(_source, next);
		final before = previous.projection.stamp;
		final after = next.projection.stamp;
		if (!before.sameSession(after)) {
			throw const KlpContractError('editing_session_mismatch', 'An installed editing source cannot change document, page, or generation.');
		}
		if (!allowEnvironment && before.environmentId != after.environmentId) {
			throw KlpContractError('editing_environment_mismatch', '${before.environmentId} -> ${after.environmentId}: semantic environment replacement is not installed yet.');
		}
		if (before.projectionRevision == after.projectionRevision) {
			after.requireExact(before);
			if (!allowSame || !identical(previous, next)) {
				throw const KlpContractError('editing_stamp_collision', 'The same editing stamp must identify the same immutable drawing.');
			}
			return false;
		}
		if (_source is KlpEditorModeSource) {
			final priorModes = previous.editorModes ?? (throw const KlpContractError('missing_editor_mode_projection', 'Editor mode capability must publish its authority on every drawing.'));
			final nextModes = next.editorModes ?? (throw const KlpContractError('missing_editor_mode_projection', 'Editor mode capability must publish its authority on every drawing.'));
			if (nextModes.revision <= priorModes.revision) throw const KlpContractError('editor_mode_revision_regression', 'Editor mode revision must advance with its drawing.');
		}
		if (after.projectionRevision < before.projectionRevision || after.contentRevision < before.contentRevision || after.compositionRevision < before.compositionRevision || after.layoutRevision < before.layoutRevision) {
			throw KlpContractError('editing_revision_regression', '${before.projectionRevision} -> ${after.projectionRevision}: editing revisions must be monotonic.');
		}
		return true;
	}

	@override
	void update(KlpValidatedNode node) {}

	@override
	void dispose() {
		if (_disposed) return;
		_disposed = true;
		unawaited(_subscription.cancel());
		_drawing.dispose();
	}
}
