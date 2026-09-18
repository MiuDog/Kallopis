part of 'klp_editing_intent.dart';

/// 更新已存在的組字預覽，不建立第二次文件插入。
final class KlpUpdateCompositionIntent extends KlpEditingIntent {

	final KlpCompositionText provisional;

	const KlpUpdateCompositionIntent(this.provisional);
}
