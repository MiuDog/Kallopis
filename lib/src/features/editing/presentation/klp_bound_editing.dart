part of 'klp_editing_presentation.dart';

/// 已核對版本的編輯幾何與本庫風格；平台資源仍由 Flutter host 擁有。
final class KlpBoundEditing extends KlpBoundTemplate {

	final KlpState<KlpEditingDrawing> drawing;
	final KlpBoundEditingStyle style;
	final KlpBoundEditingLayout? layout;
	final KlpBoundEditingActions? actions;
	final KlpBoundBlockControls? blockControls;
	final KlpBoundAnchoredCommands? anchoredCommands;
	final KlpBoundModeToolbar? modeToolbar;
	final KlpBoundEditingSaveActions? saveActions;

	const KlpBoundEditing(this.drawing, this.style, this.layout, this.actions, this.blockControls, this.anchoredCommands, this.modeToolbar, this.saveActions);
}
