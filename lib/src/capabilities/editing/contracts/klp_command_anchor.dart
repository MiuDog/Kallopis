import 'klp_editing_draw_command.dart';
import 'klp_editing_endpoint.dart';
import 'klp_editing_stamp.dart';

part 'klp_block_command_anchor.dart';
part 'klp_caret_command_anchor.dart';

/// 與 editor drawing 同幀的 typed 命令定位；座標維持 editor-local。
sealed class KlpCommandAnchor {
	final KlpEditingStamp stamp;
	final double viewportWidth;
	final double viewportHeight;
	final KlpEditingRect rect;

	KlpCommandAnchor({required this.stamp, required this.viewportWidth, required this.viewportHeight, required this.rect}) {
		if (![viewportWidth, viewportHeight, rect.x, rect.y, rect.width, rect.height, rect.x + rect.width, rect.y + rect.height].every((value) => value.isFinite)
			|| viewportWidth <= 0 || viewportHeight <= 0 || rect.width < 0 || rect.height < 0) {
			throw ArgumentError('Invalid command anchor geometry');
		}
	}

	bool sameIdentity(KlpCommandAnchor other);
}
