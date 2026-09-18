import 'klp_text_offsets.dart';
import 'klp_composition_text.dart';

part 'klp_replace_text_intent.dart';
part 'klp_select_text_intent.dart';
part 'klp_begin_composition_intent.dart';
part 'klp_update_composition_intent.dart';
part 'klp_commit_composition_intent.dart';
part 'klp_cancel_composition_intent.dart';
part 'klp_editing_command_intent.dart';

/// 封閉的編輯操作資料；不允許字串命令、Widget 或外部執行函式。
sealed class KlpEditingIntent {

	const KlpEditingIntent();
}
