import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_explorer_drop_request.dart';

/// Explorer 對 consumer 的唯一語意事件出口。
sealed class KlpExplorerIntent {

	const KlpExplorerIntent();
}

final class KlpExplorerSelectionRequested extends KlpExplorerIntent {

	final KlpId scopeId;
	final Set<KlpId> selectedIds;
	final KlpId? anchorId;

	KlpExplorerSelectionRequested({required this.scopeId, required Set<KlpId> selectedIds, required this.anchorId}) : selectedIds = Set.unmodifiable(selectedIds);
}

final class KlpExplorerActivationRequested extends KlpExplorerIntent {

	final KlpId itemId;

	const KlpExplorerActivationRequested(this.itemId);
}

final class KlpExplorerExpansionRequested extends KlpExplorerIntent {

	final KlpId itemId;
	final bool expanded;
	final Set<KlpId> expandedIds;

	KlpExplorerExpansionRequested({required this.itemId, required this.expanded, required Set<KlpId> expandedIds}) : expandedIds = Set.unmodifiable(expandedIds);
}

final class KlpExplorerDropRequested extends KlpExplorerIntent {

	final Set<KlpId> sourceIds;
	final KlpId targetId;
	final KlpExplorerDropPlacement position;

	KlpExplorerDropRequested({required Set<KlpId> sourceIds, required this.targetId, required this.position}) : sourceIds = Set.unmodifiable(sourceIds);
}

final class KlpExplorerCommandRequested extends KlpExplorerIntent {

	final KlpId itemId;
	final KlpId commandId;
	final String? input;

	const KlpExplorerCommandRequested({required this.itemId, required this.commandId, this.input});
}
