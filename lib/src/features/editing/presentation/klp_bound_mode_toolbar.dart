part of 'klp_editing_presentation.dart';

/// 已從 enclosing editor 繫結的模式與 viewport 能力。
final class KlpBoundModeToolbar {
	final String id;
	final KlpBoundEditorModeActions actions;

	const KlpBoundModeToolbar(this.id, this.actions);
}
