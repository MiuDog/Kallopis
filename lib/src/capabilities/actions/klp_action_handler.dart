import 'dart:async';

import '../../kernel/identity/klp_placement_id.dart';
import 'klp_action.dart';
import 'klp_action_activation.dart';

/// 安裝期注入的操作派送器；feature 只知道此能力，不依賴 application。
abstract interface class KlpActionHandler {

	bool accepts(KlpAction action);
	FutureOr<KlpActionActivation> activate(KlpAction action, KlpPlacementId source);
}

/// 準備期只允許本庫可派送的 action；假實作不能進入已安裝樹。
bool acceptsKlpAction(KlpActionHandler? handler, KlpAction action) => handler?.accepts(action) ?? action is KlpCallbackAction;

/// 唯一 action 派送入口；未綁定的導覽 action 一律拒絕。
FutureOr<KlpActionActivation> dispatchKlpAction(KlpActionHandler? handler, KlpAction action, KlpPlacementId source) {
	if (handler != null) return handler.activate(action, source);
	if (action case KlpCallbackAction(:final callback)) {
		callback();
		return const KlpActionActivation(true);
	}
	return const KlpActionActivation(false);
}
