import 'package:flutter/foundation.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:krepis_block_note/krepis_block_note.dart';

/// 同一拖放保留 Explorer 完整來源集合，只有單頁映射能進入資料庫。
final class KlpPageReferenceDrag {

	final Set<KlpId> sourceIds;
	final KrepisPageReference? page;

	KlpPageReferenceDrag({required Set<KlpId> sourceIds, required Map<KlpId, KrepisPageReference> pageReferences})
		: sourceIds = Set.unmodifiable(sourceIds), page = sourceIds.length == 1 ? pageReferences[sourceIds.single] : null;
}

/// 僅存在於一次拖放期間，不持有頁面 catalog 或編輯器工作階段。
final klpActivePageReferenceDrag = ValueNotifier<KlpPageReferenceDrag?>(null);
