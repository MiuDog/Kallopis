import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_source.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';

/// 初次安裝與後續發布共用同一能力閘門，避免動態啟用繞過 handler 資格。
void validateKlpEditorModeCapability(KlpEditingSource source, KlpEditingDrawing drawing) {
	if (source is! KlpEditorModeSource) return;
	final modes = drawing.editorModes ?? (throw const KlpContractError('missing_editor_mode_projection', 'Editor mode capability must publish its authority on every drawing.'));
	final tools = modes.tools.where((tool) => tool.enabled);
	if (tools.any((tool) => tool.acceptsTextInput) && source is! KlpEditableSource) {
		throw const KlpContractError('missing_text_mode_capability', 'Enabled text tools require the enclosing editable source capability.');
	}
	if (tools.any((tool) => tool.commitsInk)) {
		throw const KlpContractError('missing_handwriting_capability', 'Handwriting tools remain disabled until the ink input capability is installed.');
	}
}
