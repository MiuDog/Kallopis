import 'klp_editing_stamp.dart';
import 'klp_editor_mode_item.dart';
import 'klp_editor_tool_item.dart';
import 'klp_editor_viewport_projection.dart';

/// 編輯模式切換的暫態階段；文件與工具狀態仍以提供者投影為準。
enum KlpEditorModeTransition { ready, switching, suspended }

/// 同一 editor 的模式、工具與 viewport 投影；不保存文件內容副本。
final class KlpEditorModeProjection {
	final KlpEditingStamp stamp;
	final int revision;
	final String activeModeId;
	final String activeToolId;
	final KlpEditorModeTransition transition;
	final List<KlpEditorModeItem> modes;
	final List<KlpEditorToolItem> tools;
	final KlpEditorViewportProjection viewport;

	KlpEditorModeProjection({
		required this.stamp,
		required this.revision,
		required this.activeModeId,
		required this.activeToolId,
		required this.transition,
		required Iterable<KlpEditorModeItem> modes,
		required Iterable<KlpEditorToolItem> tools,
		required this.viewport,
	}) : modes = List.unmodifiable(modes), tools = List.unmodifiable(tools) {
		if (revision < 0 || activeModeId.trim().isEmpty || activeToolId.trim().isEmpty) throw ArgumentError('Invalid editor mode projection identity');
		stamp.requireExact(viewport.stamp);
		final modeIds = <String>{};
		for (final mode in this.modes) {
			if (!modeIds.add(mode.id)) throw ArgumentError('Duplicate editor mode identity');
		}
		final toolIds = <String>{};
		for (final tool in this.tools) {
			if (!toolIds.add(tool.id)) throw ArgumentError('Duplicate editor tool identity');
			if (!modeIds.contains(tool.modeId)) throw ArgumentError('Editor tool references an unknown mode');
			final purpose = this.modes.singleWhere((mode) => mode.id == tool.modeId).purpose;
			final matchesPurpose = switch (purpose) {
				KlpEditorInputPurpose.text => tool.acceptsTextInput,
				KlpEditorInputPurpose.navigation => tool.controlsViewport,
				KlpEditorInputPurpose.handwriting => tool.commitsInk,
			};
			if (!matchesPurpose) throw ArgumentError('Editor tool channel does not match its mode purpose');
			final owner = this.modes.singleWhere((mode) => mode.id == tool.modeId);
			if (tool.enabled && !owner.enabled) throw ArgumentError('Enabled editor tools require an enabled mode');
		}
		for (final mode in this.modes.where((candidate) => candidate.enabled)) {
			if (!this.tools.any((tool) => tool.modeId == mode.id && tool.enabled)) throw ArgumentError('Enabled editor modes require an enabled tool');
		}
		final activeMode = this.modes.where((mode) => mode.id == activeModeId).firstOrNull;
		final activeTool = this.tools.where((tool) => tool.id == activeToolId && tool.modeId == activeModeId).firstOrNull;
		if (activeMode == null || activeTool == null) throw ArgumentError('Active editor mode and tool must be registered and related');
		if (transition == KlpEditorModeTransition.ready && (!activeMode.enabled || !activeTool.enabled)) throw ArgumentError('Ready editor mode and tool must be enabled');
	}

	KlpEditorInputPurpose get activePurpose => modes.singleWhere((mode) => mode.id == activeModeId).purpose;
}
