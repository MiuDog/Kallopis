import 'package:kallopis/src/kernel/identity/klp_id.dart';
import '../internal/klp_explorer_controller_binding.dart';

enum KlpExplorerControllerResult { completed, unavailable, targetMissing, superseded }

/// Consumer 可持有的一次性語意命令入口，不讀寫 Explorer 產品狀態。
final class KlpExplorerController {

	Future<KlpExplorerControllerResult> focusItem(KlpId id) => invokeKlpExplorerController(this, id, reveal: false);

	Future<KlpExplorerControllerResult> revealItem(KlpId id) => invokeKlpExplorerController(this, id, reveal: true);

	void dispose() => disposeKlpExplorerController(this);
}
