import 'klp_editing_draw_command.dart';
import '../internal/klp_editing_draw_command_validation.dart';
import 'klp_editing_drawing.dart';

/// 來源回報的筆跡擷取階段；未知結果不代表已提交或可安全重試。
enum KlpHandwritingPhase { capturing, overloaded, committed, canceled, unknown }

/// capture ID 為來源核發的不透明值；generation 來自共用命令序號或同等單調權威。
final class KlpHandwritingCaptureIdentity {
	final int generation;
	final String id;

	KlpHandwritingCaptureIdentity({required this.generation, required this.id}) {
		if (generation <= 0 || id.trim().isEmpty) throw ArgumentError('Invalid handwriting capture identity');
	}

	@override
	bool operator ==(Object other) => other is KlpHandwritingCaptureIdentity && other.generation == generation && other.id == id;

	@override
	int get hashCode => Object.hash(generation, id);
}

/// 核心暫態筆跡的不可變快照；不包含平台樣本、筆刷或 placement 決策。
final class KlpHandwritingState {
	final KlpEditingDrawing drawing;
	final KlpHandwritingCaptureIdentity capture;
	final KlpHandwritingPhase phase;
	final int acceptedBatchSequence;
	final int previewRevision;
	final int sampleCapacity;
	final int bufferedSampleCount;
	final int? remainingSampleCapacity;
	final List<KlpEditingDrawCommand> previewCommands;

	KlpHandwritingState({
		required this.drawing,
		required this.capture,
		required this.phase,
		required this.acceptedBatchSequence,
		required this.previewRevision,
		required this.sampleCapacity,
		required this.bufferedSampleCount,
		required this.remainingSampleCapacity,
		required Iterable<KlpEditingDrawCommand> previewCommands,
	}) : previewCommands = freezeKlpEditingDrawCommands(previewCommands) {
		if (acceptedBatchSequence < 0 || previewRevision < 0 || sampleCapacity <= 0 || bufferedSampleCount < 0 || bufferedSampleCount > sampleCapacity) throw ArgumentError('Invalid handwriting capacity or revision');
		if (remainingSampleCapacity case final remaining?) {
			if (remaining < 0 || bufferedSampleCount + remaining != sampleCapacity) throw ArgumentError('Invalid handwriting remaining capacity');
		}
		if (this.previewCommands.isNotEmpty && previewRevision == 0) throw ArgumentError('Handwriting preview requires a revision');
		for (final command in this.previewCommands) {
			if (command case KlpEditingDrawPath(:final role) || KlpEditingDrawRect(:final role)) {
				if (role != KlpEditingPaintRole.ink) throw ArgumentError('Handwriting preview accepts only ink geometry');
			}
		}
		if (terminal && (bufferedSampleCount != 0 || remainingSampleCapacity != null || this.previewCommands.isNotEmpty)) throw ArgumentError('Terminal handwriting state must clear transient data');
	}

	bool get terminal => phase == KlpHandwritingPhase.committed || phase == KlpHandwritingPhase.canceled;
}
