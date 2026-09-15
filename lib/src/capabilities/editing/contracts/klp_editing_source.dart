import 'dart:async';

import 'klp_editing_drawing.dart';
import 'klp_editing_interaction.dart';
import 'klp_editing_layout.dart';
import 'klp_editing_point_request.dart';
import 'klp_editing_reply.dart';
import 'klp_editing_request.dart';
import 'klp_block_request.dart';
import 'klp_block_viewport_request.dart';
import 'klp_command_request.dart';
import 'klp_command_reply.dart';
import 'klp_editor_mode_reply.dart';
import 'klp_editor_mode_request.dart';
import 'klp_editor_viewport_request.dart';

/// 提供者擁有的編輯快照來源；安裝端只借用目前值與非同步廣播。
///
/// [drawings] 必須是非同步 broadcast stream。每個事件必須已成為 [drawing]
/// 的目前值，且同一 stamp 重播時必須沿用同一個不可變 [KlpEditingDrawing]。
/// 基礎 provider 快照／廣播合約持續保留；KLP-0020 不將保存或手寫等共用用途整體棄用。
abstract interface class KlpEditingSource {
	KlpEditingDrawing get drawing;
	Stream<KlpEditingDrawing> get drawings;
}

/// 可重排來源由 Kallopis 提供完整 layout/style；唯讀資料也可實作此能力。
/// 此 layout 通道只維護舊正文相容與回退；新 BlockNote 的排版由上游引擎掌管。
abstract interface class KlpEditingLayoutSource implements KlpEditingSource {
	KlpEditingDrawing layout(KlpEditingLayout layout);
}

/// 可編輯來源另外接受 typed 命令並綁定單一平台輸入 host。
/// 文字、IME 與 hit testing 操作限舊正文相容；新 BlockNote 不經此通道建立第二交易或 undo 權威。
abstract interface class KlpEditableSource implements KlpEditingLayoutSource {
	int issueCommandSequence();
	FutureOr<KlpEditingReply> submit(KlpEditingRequest request, {required int committedAtMs});
	FutureOr<KlpEditingReply> selectPoint(KlpEditingPointRequest request);
	KlpEditingInteractionBinding bindInteraction(KlpEditingInteraction interaction);
}

/// 同一編輯來源可選擇提供 K02 區塊控制；命令不得另行注入來源。
/// 區塊、清單與 undo 操作限舊正文相容；不向新 BlockNote 回放本合約的正文操作。
abstract interface class KlpBlockControlSource implements KlpEditingSource {
	int issueCommandSequence();
	FutureOr<KlpEditingReply> submitBlock(KlpBlockRequest request, {required int committedAtMs});
	FutureOr<KlpEditingReply> submitBlockViewport(KlpBlockViewportRequest request, {required int committedAtMs});
}

/// 同一 editor source 可選擇提供 K03 候選與原子確認能力。
/// 保留共用候選命令與定位資料；舊正文 caret／block 操作用途仍受相容界線約束。
abstract interface class KlpAnchoredCommandSource implements KlpEditingSource {
	int issueCommandSequence();
	FutureOr<KlpCommandReply> submitAnchoredCommand(KlpCommandRequest request, {required int committedAtMs});
}

/// 同一 editor source 可選擇提供 K04 模式、工具與 viewport 能力。
/// 保留現有模式與手寫通道合約；不在此決定未定案的手寫正文整合或 Spatial 引擎。
abstract interface class KlpEditorModeSource implements KlpEditingSource {
	int issueCommandSequence();
	FutureOr<KlpEditorModeReply> submitEditorMode(KlpEditorModeRequest request, {required int committedAtMs});
	FutureOr<KlpEditorModeReply> submitEditorViewport(KlpEditorViewportRequest request, {required int committedAtMs});
}
