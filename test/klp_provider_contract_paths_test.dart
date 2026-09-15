import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart' as provider;
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart' as contract0;
import 'package:kallopis/src/capabilities/state/klp_state.dart' as contract1;
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_item.dart' as contract2;
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_projection.dart' as contract3;
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_request.dart' as contract4;
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_viewport_request.dart' as contract5;
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_anchor.dart' as contract6;
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_item.dart' as contract7;
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_projection.dart' as contract8;
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_request.dart' as contract9;
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_reply.dart' as contract10;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_item.dart' as contract11;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_tool_item.dart' as contract12;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_viewport_projection.dart' as contract13;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_projection.dart' as contract14;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_request.dart' as contract15;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_viewport_request.dart' as contract16;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_reply.dart' as contract17;
import 'package:kallopis/src/capabilities/editing/contracts/klp_handwriting_state.dart' as contract18;
import 'package:kallopis/src/capabilities/editing/contracts/klp_handwriting_state_source.dart' as contract19;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_draw_command.dart' as contract20;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart' as contract21;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_interaction.dart' as contract22;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_layout.dart' as contract23;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_point_request.dart' as contract24;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_path.dart' as contract25;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_source.dart' as contract26;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_style.dart' as contract27;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_viewport.dart' as contract28;
import 'package:kallopis/src/capabilities/editing/contracts/klp_composition_attribute.dart' as contract29;
import 'package:kallopis/src/capabilities/editing/contracts/klp_composition_segment.dart' as contract30;
import 'package:kallopis/src/capabilities/editing/contracts/klp_composition_text.dart' as contract31;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_endpoint.dart' as contract32;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart' as contract33;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart' as contract34;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart' as contract35;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_request.dart' as contract36;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_projection.dart' as contract37;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_reply.dart' as contract38;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_request.dart' as contract39;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_source.dart' as contract40;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart' as contract41;
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart' as contract42;
import 'package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart' as contract43;

void main() {

	test('public constructors preserve borrowed stamp and intent identity', () {
		final stamp = contract41.KlpEditingStamp(
			documentId: 'document',
			pageId: 'page',
			generation: 2,
			projectionRevision: 7,
			contentRevision: 3,
			compositionRevision: 1,
			layoutRevision: 4,
			environmentId: 'environment',
		);
		final intent = contract33.KlpSelectTextIntent(8, 2);
		final request = provider.KlpEditingRequest(sequence: 5, expected: stamp, blockId: 'block', intent: intent);
		expect(request, isA<contract36.KlpEditingRequest>());
		expect(request.expected, same(stamp));
		expect(request.intent, same(intent));
		expect((intent.anchorUtf8, intent.focusUtf8), (8, 2));
		expect(request.expected.contentRevision, 3);
		expect(provider.KlpEditingRequest.new, same(contract36.KlpEditingRequest.new));
		expect(provider.KlpSelectTextIntent.new, same(contract33.KlpSelectTextIntent.new));
		expect(() => provider.KlpEditingRequest(sequence: 0, expected: stamp, blockId: 'block', intent: intent), throwsArgumentError);
	});
	test('save request retains owner revisions retry identity and default fields', () {
		final stamp = provider.KlpEditingStamp(
			documentId: 'document',
			pageId: 'page',
			generation: 2,
			projectionRevision: 7,
			contentRevision: 3,
			compositionRevision: 1,
			layoutRevision: 4,
			environmentId: 'environment',
		);
		final save = contract39.KlpEditingSaveRequest(sequence: 6, expected: stamp, intent: provider.KlpEditingSaveIntent.save);
		expect(save, isA<provider.KlpEditingSaveRequest>());
		expect(save.expected, same(stamp));
		expect((save.expectedStateRevision, save.failedJobId), (null, null));
		final retry = provider.KlpEditingSaveRequest(
			sequence: 7,
			expected: stamp,
			intent: contract39.KlpEditingSaveIntent.retry,
			expectedStateRevision: 9,
			failedJobId: 4,
		);
		expect(retry.expected, same(stamp));
		expect((retry.expectedStateRevision, retry.failedJobId), (9, 4));
		expect(provider.KlpEditingSaveRequest.new, same(contract39.KlpEditingSaveRequest.new));
		expect(() => provider.KlpEditingSaveRequest(sequence: 8, expected: stamp, intent: provider.KlpEditingSaveIntent.retry), throwsArgumentError);
	});
	test('all original provider types share the named contract identity', () {
		// 固定舊版 44 個 export 與其 part 的 90 個型別，直接觀察同一 Dart library 身分。
		final identities = <(String, Type, Type)>[
			('KlpContractError', provider.KlpContractError, contract0.KlpContractError),
			('KlpState', provider.KlpState, contract1.KlpState),
			('KlpBlockKind', provider.KlpBlockKind, contract2.KlpBlockKind),
			('KlpBlockItem', provider.KlpBlockItem, contract2.KlpBlockItem),
			('KlpBlockProjection', provider.KlpBlockProjection, contract3.KlpBlockProjection),
			('KlpBlockIntent', provider.KlpBlockIntent, contract4.KlpBlockIntent),
			('KlpBlockTextKind', provider.KlpBlockTextKind, contract4.KlpBlockTextKind),
			('KlpBlockRequest', provider.KlpBlockRequest, contract4.KlpBlockRequest),
			('KlpBlockViewportRequest', provider.KlpBlockViewportRequest, contract5.KlpBlockViewportRequest),
			('KlpCommandAnchor', provider.KlpCommandAnchor, contract6.KlpCommandAnchor),
			('KlpBlockCommandAnchor', provider.KlpBlockCommandAnchor, contract6.KlpBlockCommandAnchor),
			('KlpCaretCommandAnchor', provider.KlpCaretCommandAnchor, contract6.KlpCaretCommandAnchor),
			('KlpCommandAvailability', provider.KlpCommandAvailability, contract7.KlpCommandAvailability),
			('KlpCommandTone', provider.KlpCommandTone, contract7.KlpCommandTone),
			('KlpCommandItem', provider.KlpCommandItem, contract7.KlpCommandItem),
			('KlpCommandProjection', provider.KlpCommandProjection, contract8.KlpCommandProjection),
			('KlpCommandRequest', provider.KlpCommandRequest, contract9.KlpCommandRequest),
			('KlpCommandReply', provider.KlpCommandReply, contract10.KlpCommandReply),
			('KlpEditorInputPurpose', provider.KlpEditorInputPurpose, contract11.KlpEditorInputPurpose),
			('KlpEditorModeAvailability', provider.KlpEditorModeAvailability, contract11.KlpEditorModeAvailability),
			('KlpEditorModeItem', provider.KlpEditorModeItem, contract11.KlpEditorModeItem),
			('KlpEditorPointerKind', provider.KlpEditorPointerKind, contract12.KlpEditorPointerKind),
			('KlpEditorToolItem', provider.KlpEditorToolItem, contract12.KlpEditorToolItem),
			('KlpEditorViewportProjection', provider.KlpEditorViewportProjection, contract13.KlpEditorViewportProjection),
			('KlpEditorModeTransition', provider.KlpEditorModeTransition, contract14.KlpEditorModeTransition),
			('KlpEditorModeProjection', provider.KlpEditorModeProjection, contract14.KlpEditorModeProjection),
			('KlpEditorModeRequest', provider.KlpEditorModeRequest, contract15.KlpEditorModeRequest),
			('KlpEditorViewportRequest', provider.KlpEditorViewportRequest, contract16.KlpEditorViewportRequest),
			('KlpEditorModeReply', provider.KlpEditorModeReply, contract17.KlpEditorModeReply),
			('KlpHandwritingPhase', provider.KlpHandwritingPhase, contract18.KlpHandwritingPhase),
			('KlpHandwritingCaptureIdentity', provider.KlpHandwritingCaptureIdentity, contract18.KlpHandwritingCaptureIdentity),
			('KlpHandwritingState', provider.KlpHandwritingState, contract18.KlpHandwritingState),
			('KlpHandwritingStateSource', provider.KlpHandwritingStateSource, contract19.KlpHandwritingStateSource),
			('KlpHandwritingStatePublisher', provider.KlpHandwritingStatePublisher, contract19.KlpHandwritingStatePublisher),
			('KlpEditingPaintRole', provider.KlpEditingPaintRole, contract20.KlpEditingPaintRole),
			('KlpEditingRect', provider.KlpEditingRect, contract20.KlpEditingRect),
			('KlpEditingDrawCommand', provider.KlpEditingDrawCommand, contract20.KlpEditingDrawCommand),
			('KlpEditingDrawRect', provider.KlpEditingDrawRect, contract20.KlpEditingDrawRect),
			('KlpEditingDrawPath', provider.KlpEditingDrawPath, contract20.KlpEditingDrawPath),
			('KlpEditingPushClip', provider.KlpEditingPushClip, contract20.KlpEditingPushClip),
			('KlpEditingPopClip', provider.KlpEditingPopClip, contract20.KlpEditingPopClip),
			('KlpEditingPushTransform', provider.KlpEditingPushTransform, contract20.KlpEditingPushTransform),
			('KlpEditingPopTransform', provider.KlpEditingPopTransform, contract20.KlpEditingPopTransform),
			('KlpEditingDrawing', provider.KlpEditingDrawing, contract21.KlpEditingDrawing),
			('KlpEditingInteraction', provider.KlpEditingInteraction, contract22.KlpEditingInteraction),
			('KlpEditingInteractionBinding', provider.KlpEditingInteractionBinding, contract22.KlpEditingInteractionBinding),
			('KlpEditingLayout', provider.KlpEditingLayout, contract23.KlpEditingLayout),
			('KlpEditingPointRequest', provider.KlpEditingPointRequest, contract24.KlpEditingPointRequest),
			('KlpEditingPathOperation', provider.KlpEditingPathOperation, contract25.KlpEditingPathOperation),
			('KlpEditingPathCommand', provider.KlpEditingPathCommand, contract25.KlpEditingPathCommand),
			('KlpEditingPath', provider.KlpEditingPath, contract25.KlpEditingPath),
			('KlpEditingSource', provider.KlpEditingSource, contract26.KlpEditingSource),
			('KlpEditingLayoutSource', provider.KlpEditingLayoutSource, contract26.KlpEditingLayoutSource),
			('KlpEditableSource', provider.KlpEditableSource, contract26.KlpEditableSource),
			('KlpBlockControlSource', provider.KlpBlockControlSource, contract26.KlpBlockControlSource),
			('KlpAnchoredCommandSource', provider.KlpAnchoredCommandSource, contract26.KlpAnchoredCommandSource),
			('KlpEditorModeSource', provider.KlpEditorModeSource, contract26.KlpEditorModeSource),
			('KlpEditingMarkerFormat', provider.KlpEditingMarkerFormat, contract27.KlpEditingMarkerFormat),
			('KlpEditingStyle', provider.KlpEditingStyle, contract27.KlpEditingStyle),
			('KlpEditingViewport', provider.KlpEditingViewport, contract28.KlpEditingViewport),
			('KlpCompositionAttribute', provider.KlpCompositionAttribute, contract29.KlpCompositionAttribute),
			('KlpCompositionSegment', provider.KlpCompositionSegment, contract30.KlpCompositionSegment),
			('KlpCompositionText', provider.KlpCompositionText, contract31.KlpCompositionText),
			('KlpEditingAffinity', provider.KlpEditingAffinity, contract32.KlpEditingAffinity),
			('KlpEditingEndpoint', provider.KlpEditingEndpoint, contract32.KlpEditingEndpoint),
			('KlpEditingIntent', provider.KlpEditingIntent, contract33.KlpEditingIntent),
			('KlpReplaceTextIntent', provider.KlpReplaceTextIntent, contract33.KlpReplaceTextIntent),
			('KlpSelectTextIntent', provider.KlpSelectTextIntent, contract33.KlpSelectTextIntent),
			('KlpBeginCompositionIntent', provider.KlpBeginCompositionIntent, contract33.KlpBeginCompositionIntent),
			('KlpUpdateCompositionIntent', provider.KlpUpdateCompositionIntent, contract33.KlpUpdateCompositionIntent),
			('KlpCommitCompositionIntent', provider.KlpCommitCompositionIntent, contract33.KlpCommitCompositionIntent),
			('KlpCancelCompositionIntent', provider.KlpCancelCompositionIntent, contract33.KlpCancelCompositionIntent),
			('KlpEditingCommand', provider.KlpEditingCommand, contract33.KlpEditingCommand),
			('KlpEditingCommandIntent', provider.KlpEditingCommandIntent, contract33.KlpEditingCommandIntent),
			('KlpEditingProjection', provider.KlpEditingProjection, contract34.KlpEditingProjection),
			('KlpEditingDecision', provider.KlpEditingDecision, contract35.KlpEditingDecision),
			('KlpEditingReply', provider.KlpEditingReply, contract35.KlpEditingReply),
			('KlpEditingRequest', provider.KlpEditingRequest, contract36.KlpEditingRequest),
			('KlpEditingSavePhase', provider.KlpEditingSavePhase, contract37.KlpEditingSavePhase),
			('KlpEditingSaveError', provider.KlpEditingSaveError, contract37.KlpEditingSaveError),
			('KlpEditingSaveProjection', provider.KlpEditingSaveProjection, contract37.KlpEditingSaveProjection),
			('KlpEditingSaveDecision', provider.KlpEditingSaveDecision, contract38.KlpEditingSaveDecision),
			('KlpEditingSaveReply', provider.KlpEditingSaveReply, contract38.KlpEditingSaveReply),
			('KlpEditingSaveIntent', provider.KlpEditingSaveIntent, contract39.KlpEditingSaveIntent),
			('KlpEditingSaveRequest', provider.KlpEditingSaveRequest, contract39.KlpEditingSaveRequest),
			('KlpEditingSaveSource', provider.KlpEditingSaveSource, contract40.KlpEditingSaveSource),
			('KlpEditingSaveStatePublisher', provider.KlpEditingSaveStatePublisher, contract40.KlpEditingSaveStatePublisher),
			('KlpEditingStamp', provider.KlpEditingStamp, contract41.KlpEditingStamp),
			('KlpEditingTextWindow', provider.KlpEditingTextWindow, contract42.KlpEditingTextWindow),
			('KlpTextOffsets', provider.KlpTextOffsets, contract43.KlpTextOffsets),
		];
		for (final (name, publicType, contractType) in identities) {
			expect(publicType, same(contractType), reason: name);
		}
	});
}
