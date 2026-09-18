import 'package:kallopis/src/features/workspace/explorer/contracts/klp_explorer_controller.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

typedef KlpExplorerControllerCommand = Future<KlpExplorerControllerResult> Function(KlpId id);

final Expando<_KlpExplorerControllerAttachment> _attachments = Expando();
final Expando<bool> _disposed = Expando();

final class _KlpExplorerControllerAttachment {

	final Object owner;
	final KlpExplorerControllerCommand focus;
	final KlpExplorerControllerCommand reveal;

	const _KlpExplorerControllerAttachment({required this.owner, required this.focus, required this.reveal});
}

void attachKlpExplorerController(Object controller, Object owner, {required KlpExplorerControllerCommand focus, required KlpExplorerControllerCommand reveal}) {
	if (_disposed[controller] ?? false) {
		throw KlpContractError('explorer_controller_disposed', '已釋放的 Explorer controller 不能再次附接。');
	}
	final current = _attachments[controller];
	if (current != null && !identical(current.owner, owner)) {
		throw KlpContractError('explorer_controller_already_attached', 'Explorer controller 同時只能附接一個可用 placement。');
	}
	_attachments[controller] = _KlpExplorerControllerAttachment(owner: owner, focus: focus, reveal: reveal);
}

void detachKlpExplorerController(Object controller, Object owner) {
	final current = _attachments[controller];
	if (current != null && identical(current.owner, owner)) _attachments[controller] = null;
}

Future<KlpExplorerControllerResult> invokeKlpExplorerController(Object controller, KlpId id, {required bool reveal}) async {
	final attachment = _attachments[controller];
	if (attachment == null || (_disposed[controller] ?? false)) return KlpExplorerControllerResult.unavailable;

	final result = await (reveal ? attachment.reveal(id) : attachment.focus(id));
	return identical(_attachments[controller], attachment) ? result : KlpExplorerControllerResult.superseded;
}

void disposeKlpExplorerController(Object controller) {
	_disposed[controller] = true;
	_attachments[controller] = null;
}
