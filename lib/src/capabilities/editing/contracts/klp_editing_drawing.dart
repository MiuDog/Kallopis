import 'klp_editing_draw_command.dart';
import '../internal/klp_editing_draw_command_validation.dart';
import 'klp_editing_projection.dart';
import 'klp_block_projection.dart';
import 'klp_command_projection.dart';
import 'klp_editor_mode_projection.dart';

void _validateGeometry(KlpEditingRect rect) {
	if (![rect.x, rect.y, rect.width, rect.height, rect.x + rect.width, rect.y + rect.height].every((value) => value.isFinite) || rect.width < 0 || rect.height < 0) throw ArgumentError('Invalid editing geometry');
}

/// 與輸入投影一起發布的封閉幾何快照；不接受文字重排或繪製回呼。
final class KlpEditingDrawing {

	final KlpEditingProjection projection;
	final double width;
	final double height;
	final KlpEditingRect? caretRect;
	final KlpEditingRect? composingRect;
	final KlpBlockProjection? blocks;
	final KlpCommandProjection? anchoredCommands;
	final KlpEditorModeProjection? editorModes;
	final List<KlpEditingDrawCommand> commands;

	KlpEditingDrawing({required this.projection, required this.width, required this.height, required Iterable<KlpEditingDrawCommand> commands, this.caretRect, this.composingRect, this.blocks, this.anchoredCommands, this.editorModes}) : commands = freezeKlpEditingDrawCommands(commands) {
		if (!width.isFinite || !height.isFinite || width <= 0 || height <= 0) throw ArgumentError('Invalid editing viewport');
		if (caretRect != null) _validateGeometry(caretRect!);
		if (composingRect != null) _validateGeometry(composingRect!);
		if (composingRect != null && projection.window?.composingStartUtf8 == null) throw ArgumentError('Composing geometry requires an active composition');
		if (blocks != null && (blocks!.stamp != projection.stamp || blocks!.width != width || blocks!.height != height)) throw ArgumentError('Block projection must share the drawing stamp and viewport');
		if (anchoredCommands != null && (anchoredCommands!.stamp != projection.stamp || anchoredCommands!.anchor.viewportWidth != width || anchoredCommands!.anchor.viewportHeight != height)) throw ArgumentError('Anchored commands must share the drawing stamp and viewport');
		if (editorModes != null && (editorModes!.stamp != projection.stamp || editorModes!.viewport.width != width || editorModes!.viewport.height != height)) throw ArgumentError('Editor modes must share the drawing stamp and viewport');
	}
}
