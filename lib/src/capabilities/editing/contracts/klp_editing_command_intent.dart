part of 'klp_editing_intent.dart';

/// 舊正文輸入命令的種類；實際文字變更由來源處理。
enum KlpEditingCommand { paragraphBreak, backspace, indentList, outdentList }

/// 送往舊正文來源的具型別命令；本值不套用交易或保存歷史。
final class KlpEditingCommandIntent extends KlpEditingIntent {
	final KlpEditingCommand command;

	const KlpEditingCommandIntent(this.command);
}
